/*
 * triton.y — Analizador Sintáctico para Triton-DSL
 *
 * Parser LALR(1) generado con Bison. Implementa la CFG especificada
 * en cfg_triton_dsl.md.  Recibe tokens de yylex() (definido en triton.l
 * a través del wrapper que drena la cola de NEWLINE/INDENT/DEDENT).
 *
 * Estructura del archivo:
 *   §1  Sección de declaraciones C
 *   §2  Declaraciones Bison (tokens, precedencia, tipos)
 *   §3  Producciones (gramática)
 *   §4  Código C de apoyo (yyerror, main)
 */

/* ════════════════════════════════════════════════════════════════
   §1  DECLARACIONES C
   ════════════════════════════════════════════════════════════════ */
%{
#include <stdio.h>
#include <stdlib.h>
#include "triton.h"    /* print_* / free_* de lex.yy.c */

extern int   yylineno;  /* número de línea actual (Flex)          */
extern FILE *yyin;      /* archivo fuente (Flex)                    */
extern char  yytext[];  /* texto del último token reconocido        */
extern int   yytok_col; /* columna donde empezó ese token (Flex)    */

void yyerror(const char *msg);
int  yylex(void);   /* prototipo explícito: evita warning de declaración implícita */
%}

/* ════════════════════════════════════════════════════════════════
   §2  DECLARACIONES BISON
   ════════════════════════════════════════════════════════════════ */

/* ── Tipo semántico ─────────────────────────────────────────── */
%union {
    int entry;   /* índice en la tabla de símbolos correspondiente */
}

/* ── Tokens con valor semántico ─────────────────────────────── */
%token <entry> IDENTIFIER
%token <entry> INT_LITERAL
%token <entry> FLOAT_LITERAL
%token <entry> STRING_LITERAL

/*
 * ── Tipos de no-terminales que propagan el entry ────────────
 *
 * primary y atom propagan el entry del identificador raíz cuando
 * el primario es simple (p.ej. "x"), o -1 cuando es compuesto
 * (p.ej. "x.attr", "a[i]", "f(...)").
 * Esto permite que las reglas de asignación llamen a update_id_role()
 * solo cuando el lado izquierdo es un identificador simple.
 *
 * dotted_name propaga el entry del último componente del nombre
 * (p.ej. en "import triton.language as tl", propaga el entry de "language").
 */
%type <entry> primary atom dotted_name

/* ── Tokens de estructura ───────────────────────────────────── */
%token NEWLINE INDENT DEDENT

/* ── Palabras reservadas ────────────────────────────────────── */
%token KW_IMPORT KW_AS KW_DEF
%token TRITON_JIT   /* token único: "@triton.jit" o "@tl.jit" */
%token KW_IF KW_ELIF KW_ELSE
%token KW_FOR KW_WHILE KW_IN
%token KW_BREAK KW_CONTINUE KW_RETURN KW_PASS
%token KW_AND KW_OR KW_NOT KW_IS
%token KW_TRUE KW_FALSE KW_NONE

/* ── Operadores de asignación ───────────────────────────────── */
%token OP_ASSIGN
%token OP_PLUS_ASSIGN OP_MINUS_ASSIGN OP_STAR_ASSIGN OP_SLASH_ASSIGN

/* ── Operadores aritméticos ─────────────────────────────────── */
%token OP_PLUS OP_MINUS OP_STAR OP_SLASH OP_DOUBLE_SLASH OP_MOD

/* ── Operadores relacionales ────────────────────────────────── */
%token OP_EQ OP_NEQ OP_LT OP_LE OP_GT OP_GE

/* ── Operadores bit a bit ───────────────────────────────────── */
%token OP_LSHIFT OP_RSHIFT OP_BIT_AND OP_BIT_OR OP_BIT_XOR OP_BIT_NOT

/* ── Delimitadores ──────────────────────────────────────────── */
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token COMMA COLON DOT SEMICOLON AT ARROW

/*
 * ── Precedencia de operadores (menor → mayor) ───────────────
 *
 * Estas declaraciones resuelven los conflictos shift/reduce que
 * surgen de la gramática ambigua de expresiones.  Corresponden
 * a la cascada de precedencia de la especificación formal:
 *
 *   Nivel 1  (más bajo)  →  or
 *   Nivel 2              →  and
 *   Nivel 3              →  not  (unario, derecho)
 *   Nivel 4              →  comparaciones
 *   Nivel 5              →  |
 *   Nivel 6              →  ^
 *   Nivel 7              →  &
 *   Nivel 8              →  << >>
 *   Nivel 9              →  + -
 *   Nivel 10             →  * / // %
 *   Nivel 11 (más alto)  →  unario - ~
 */
%left  KW_OR
%left  KW_AND
%right KW_NOT
%left  OP_EQ OP_NEQ OP_LT OP_LE OP_GT OP_GE KW_IS KW_IN
%left  OP_BIT_OR
%left  OP_BIT_XOR
%left  OP_BIT_AND
%left  OP_LSHIFT OP_RSHIFT
%left  OP_PLUS OP_MINUS
%left  OP_STAR OP_SLASH OP_DOUBLE_SLASH OP_MOD
%right UMINUS OP_BIT_NOT   /* pseudo-token para unario */

/*
 * parse.error verbose → Bison genera mensajes detallados:
 *   "syntax error, unexpected X, expecting Y or Z"
 * en lugar del genérico "syntax error".
 */
%define parse.error verbose

/* Símbolo inicial */
%start program

%%

/* ════════════════════════════════════════════════════════════════
   §3  PRODUCCIONES
   ════════════════════════════════════════════════════════════════ */

/* ── Programa ────────────────────────────────────────────────── */

program
    : stmt_list
    ;

/*
 * stmt_list distingue sentencias simples (requieren NEWLINE al final)
 * de sentencias compuestas (terminan con DEDENT, sin NEWLINE propia).
 * También acepta líneas en blanco (NEWLINE sola).
 */
stmt_list
    : /* vacío */
    | stmt_list simple_stmt NEWLINE
    | stmt_list compound_stmt
    | stmt_list NEWLINE          /* líneas en blanco */
    ;

/* ── Sentencias simples (una línea) ──────────────────────────── */

simple_stmt
    : import_stmt
    | return_stmt
    | KW_BREAK
    | KW_CONTINUE
    | KW_PASS
    | primary OP_ASSIGN       expr
      /*
       * Acción semántica: asignación simple  x = expr
       * Si $1 >= 0, el lado izquierdo es un identificador simple;
       * se actualiza su rol a "variable".  Si $1 == -1, el LHS es un
       * primario compuesto (x.attr, a[i], etc.) y no hay entrada directa
       * en la tabla de identificadores para actualizar.
       */
      { if ($1 >= 0) update_id_role($1, "variable"); }
    | primary OP_PLUS_ASSIGN  expr
      /* Acción semántica: asignación aumentada  x += expr */
      { if ($1 >= 0) update_id_role($1, "variable"); }
    | primary OP_MINUS_ASSIGN expr
      /* Acción semántica: asignación aumentada  x -= expr */
      { if ($1 >= 0) update_id_role($1, "variable"); }
    | primary OP_STAR_ASSIGN  expr
      /* Acción semántica: asignación aumentada  x *= expr */
      { if ($1 >= 0) update_id_role($1, "variable"); }
    | primary OP_SLASH_ASSIGN expr
      /* Acción semántica: asignación aumentada  x /= expr */
      { if ($1 >= 0) update_id_role($1, "variable"); }
    | expr                           /* expresión sola (p.ej. llamada) */
    ;
/*
 * Nota: se usa primary como LHS de asignación (no target ni expr).
 *   - Más restrictivo que expr: impide  1+2 = x  (no es primary).
 *   - Más permisivo que un target rígido: evita el conflicto
 *     reduce/reduce que surgía cuando IDENTIFIER DOT IDENTIFIER
 *     competía entre target y primary con lookahead '('.
 * En la práctica cubre todos los destinos válidos de Triton-DSL:
 *   x = …   x.attr = …   x[i] = …   x.attr[i] = …
 * Con shift/reduce resuelto por defecto (shift), funciona correctamente.
 */

/* ── Sentencias compuestas (bloque con INDENT/DEDENT) ─────────── */

compound_stmt
    : decorated_def
    | func_def
    | if_stmt
    | for_stmt
    | while_stmt
    ;

/* ── Importaciones ───────────────────────────────────────────── */

import_stmt
    : KW_IMPORT dotted_name
      /* Acción semántica: el módulo ya fue marcado como "modulo"
         dentro de dotted_name; no se requiere acción adicional. */
    | KW_IMPORT dotted_name KW_AS IDENTIFIER
      /*
       * Acción semántica: el identificador $4 es el alias local con el
       * que se usará el módulo dentro del programa (p.ej. "tl" en
       * "import triton.language as tl").  Se marca como "alias_modulo".
       */
      { update_id_role($4, "alias_modulo"); }
    | KW_IMPORT error
      { fprintf(stderr,
            "  Regla rota : import_stmt → import <módulo>\n"
            "                           | import <módulo> as <alias>\n"
            "  Sugerencia : ¿El nombre del módulo es un identificador válido?\n");
        YYABORT; }
    ;

dotted_name
    : IDENTIFIER
      /*
       * Acción semántica: primer componente de un nombre de módulo.
       * Se marca como "modulo" y se propaga su entry para que las
       * reglas superiores puedan seguir la cadena.
       */
      { update_id_role($1, "modulo"); $$ = $1; }
    | dotted_name DOT IDENTIFIER
      /*
       * Acción semántica: componente adicional de un nombre calificado
       * (p.ej. "language" en "triton.language").
       * Se marca como "modulo" y se propaga el entry del último componente.
       */
      { update_id_role($3, "modulo"); $$ = $3; }
    ;

/* ── Decoradores y definiciones de función ───────────────────── */

decorated_def
    : decorator func_def
    ;

/*
 * decorator — el lexer ya garantiza que solo llega TRITON_JIT
 * ("@triton.jit" o "@tl.jit") como token único.
 * El AT genérico solo puede llegar si el input tiene un decorador
 * no válido, disparando inmediatamente la rama de error.
 */
decorator
    : TRITON_JIT NEWLINE
    | TRITON_JIT LPAREN arg_list RPAREN NEWLINE
    | AT error
      { fprintf(stderr,
            "  Regla rota : decorator → @triton.jit\n"
            "                         | @triton.jit(<args>)\n"
            "  Sugerencia : Solo se permiten @triton.jit o @tl.jit.\n"
            "               Si la función no es un kernel, escríbela sin decorador.\n");
        YYABORT; }
    ;

func_def
    : KW_DEF IDENTIFIER LPAREN param_list RPAREN COLON suite
      /*
       * Acción semántica: definición de función sin anotación de retorno.
       * $2 es el entry del identificador que da nombre a la función.
       * Se actualiza su rol a "funcion" en la tabla de identificadores.
       */
      { update_id_role($2, "funcion"); }
    | KW_DEF IDENTIFIER LPAREN param_list RPAREN ARROW expr COLON suite
      /*
       * Acción semántica: definición de función CON anotación de retorno
       * (p.ej.  def foo(x) -> int: ...).
       * $2 es el entry del nombre de la función.
       */
      { update_id_role($2, "funcion"); }
    | KW_DEF IDENTIFIER LPAREN param_list RPAREN error
      { fprintf(stderr,
            "  Regla rota : func_def → def <nombre>(<params>) : <bloque>\n"
            "                        | def <nombre>(<params>) -> <tipo> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' (o '->') al final del encabezado de la función?\n");
        YYABORT; }
    | KW_DEF IDENTIFIER error
      { fprintf(stderr,
            "  Regla rota : func_def → def <nombre>(<params>) : <bloque>\n"
            "  Sugerencia : ¿Faltan los paréntesis '(' ')' de los parámetros?\n");
        YYABORT; }
    | KW_DEF error
      { fprintf(stderr,
            "  Regla rota : func_def → def <nombre>(<params>) : <bloque>\n"
            "  Sugerencia : 'def' debe ir seguido de un nombre de función válido.\n");
        YYABORT; }
    ;

param_list
    : /* vacío */
    | params
    ;

params
    : param
    | params COMMA param
    ;

/*
 * Un parámetro puede ser:
 *   x                  →  posicional simple
 *   x : tipo           →  anotación de tipo
 *   x = default        →  valor por defecto
 *   x : tipo = default →  anotación + default
 */
param
    : IDENTIFIER
      /*
       * Acción semántica: parámetro posicional simple  def f(x)
       * $1 es el entry del identificador del parámetro.
       */
      { update_id_role($1, "parametro"); }
    | IDENTIFIER COLON expr
      /*
       * Acción semántica: parámetro con anotación de tipo  def f(x: int)
       */
      { update_id_role($1, "parametro"); }
    | IDENTIFIER OP_ASSIGN expr
      /*
       * Acción semántica: parámetro con valor por defecto  def f(x=0)
       */
      { update_id_role($1, "parametro"); }
    | IDENTIFIER COLON expr OP_ASSIGN expr
      /*
       * Acción semántica: parámetro con anotación y default  def f(x: int = 0)
       */
      { update_id_role($1, "parametro"); }
    ;

/* ── Bloque (suite) ──────────────────────────────────────────── */

/*
 * Un bloque siempre tiene la forma:
 *   NEWLINE INDENT <sentencias> DEDENT
 * El NEWLINE pertenece a la línea del encabezado (if/def/for/…).
 */
suite
    : NEWLINE INDENT stmt_list DEDENT
    | NEWLINE error
      { fprintf(stderr,
            "  Regla rota : suite → NEWLINE INDENT <sentencias> DEDENT\n"
            "  Sugerencia : El bloque de código debe estar indentado.\n"
            "               Agrega espacios o un tab al inicio de cada sentencia del bloque.\n");
        YYABORT; }
    ;

/* ── Sentencia if / elif / else ──────────────────────────────── */

/*
 * elif_chain → ε  resuelve el "dangling-else": Bison usa la regla
 * shift-por-defecto y asocia el else con el if más cercano.
 */
if_stmt
    : KW_IF expr COLON suite elif_chain
    | KW_IF expr error
      { fprintf(stderr,
            "  Regla rota : if_stmt → if <condición> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' al final de la condición del 'if'?\n");
        YYABORT; }
    | KW_IF error
      { fprintf(stderr,
            "  Regla rota : if_stmt → if <condición> : <bloque>\n"
            "  Sugerencia : 'if' debe ir seguido de una expresión booleana válida.\n");
        YYABORT; }
    ;

elif_chain
    : /* vacío */
    | KW_ELIF expr COLON suite elif_chain
    | KW_ELSE COLON suite
    ;

/* ── Bucles ──────────────────────────────────────────────────── */

for_stmt
    : KW_FOR IDENTIFIER KW_IN expr COLON suite
      /*
       * Acción semántica: bucle for  for i in expr:
       * $2 es el entry del identificador de la variable de iteración.
       * Se marca como "variable_ciclo" para distinguirla de variables
       * de asignación ordinaria.
       */
      { update_id_role($2, "variable_ciclo"); }
    | KW_FOR IDENTIFIER KW_IN expr error
      { fprintf(stderr,
            "  Regla rota : for_stmt → for <var> in <expr> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' al final del encabezado del 'for'?\n");
        YYABORT; }
    | KW_FOR IDENTIFIER error
      { fprintf(stderr,
            "  Regla rota : for_stmt → for <var> in <expr> : <bloque>\n"
            "  Sugerencia : Después de la variable del 'for' se espera la palabra 'in'.\n"
            "               Ejemplo: for i in range(10):\n");
        YYABORT; }
    | KW_FOR error
      { fprintf(stderr,
            "  Regla rota : for_stmt → for <var> in <expr> : <bloque>\n"
            "  Sugerencia : 'for' debe ir seguido de un identificador (variable de iteración).\n");
        YYABORT; }
    ;

while_stmt
    : KW_WHILE expr COLON suite
    | KW_WHILE expr error
      { fprintf(stderr,
            "  Regla rota : while_stmt → while <condición> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' al final de la condición del 'while'?\n");
        YYABORT; }
    | KW_WHILE error
      { fprintf(stderr,
            "  Regla rota : while_stmt → while <condición> : <bloque>\n"
            "  Sugerencia : 'while' debe ir seguido de una expresión booleana válida.\n");
        YYABORT; }
    ;

/* ── return ──────────────────────────────────────────────────── */

/*
 * Conflicto shift/reduce esperado: después de KW_RETURN, Bison
 * elige shift si el siguiente token puede iniciar una expresión.
 * Eso es el comportamiento correcto (return con valor).
 */
return_stmt
    : KW_RETURN
    | KW_RETURN expr
    ;

/* ════════════════════════════════════════════════════════════════
   EXPRESIONES
   (con precedencia resuelta por las declaraciones %left/%right)
   ════════════════════════════════════════════════════════════════ */

expr
    /* Operadores lógicos */
    : expr KW_OR    expr
    | expr KW_AND   expr
    | KW_NOT expr
    /* Comparaciones */
    | expr OP_EQ    expr
    | expr OP_NEQ   expr
    | expr OP_LT    expr
    | expr OP_LE    expr
    | expr OP_GT    expr
    | expr OP_GE    expr
    | expr KW_IS    expr
    | expr KW_IN    expr
    | expr KW_NOT KW_IN expr   /* operador "not in": x not in y  ≡  not (x in y)
                                 * Bison resuelve el shift/reduce a favor de shift
                                 * (comportamiento por defecto), lo que es correcto:
                                 * cuando el stack tiene "expr KW_NOT" y el lookahead
                                 * es KW_IN, se shifta KW_IN para completar esta regla.
                                 * La precedencia se toma de KW_IN (comparación). */
    /* Bit a bit */
    | expr OP_BIT_OR  expr
    | expr OP_BIT_XOR expr
    | expr OP_BIT_AND expr
    | expr OP_LSHIFT  expr
    | expr OP_RSHIFT  expr
    /* Aritméticos */
    | expr OP_PLUS         expr
    | expr OP_MINUS        expr
    | expr OP_STAR         expr
    | expr OP_SLASH        expr
    | expr OP_DOUBLE_SLASH expr
    | expr OP_MOD          expr
    /* Unarios */
    | OP_MINUS expr  %prec UMINUS
    | OP_BIT_NOT expr
    /* Primario */
    | primary
    ;

/* ── Primarios: acceso a atributo, subscript, llamada ───────── */

/*
 * primary propaga el entry del identificador raíz cuando el primario
 * es un átomo simple (atom → IDENTIFIER).  Para primarios compuestos
 * (acceso a atributo, subscript o llamada) se propaga -1 como centinela,
 * indicando que no hay un único identificador raíz actualizable.
 *
 * Este valor es consumido por simple_stmt en las reglas de asignación.
 */
primary
    : primary DOT IDENTIFIER      { $$ = -1; }  /* x.attr  → sin entrada raíz directa */
    | primary LBRACKET subscript RBRACKET { $$ = -1; }  /* a[i]    → sin entrada raíz directa */
    | primary LPAREN arg_list RPAREN      { $$ = -1; }  /* f(...)  → sin entrada raíz directa */
    | atom                                { $$ = $1; }  /* propaga el entry del átomo        */
    ;

/*
 * subscript cubre índice simple y slices:
 *   expr          →  a[i]
 *   expr : expr   →  a[i:j]
 *   expr :        →  a[i:]
 *   : expr        →  a[:j]
 *   :             →  a[:]
 */
subscript
    : expr
    | expr COLON expr
    | expr COLON
    | COLON expr
    | COLON
    ;

/* ── Átomos ───────────────────────────────────────────────────── */

/*
 * atom propaga el entry del token cuando es un IDENTIFIER, para que
 * primary pueda pasarlo a las reglas de asignación en simple_stmt.
 * Para todos los demás átomos se propaga -1 (no aplica).
 */
atom
    : IDENTIFIER               { $$ = $1; }   /* propaga el entry del identificador */
    | INT_LITERAL              { $$ = -1; }
    | FLOAT_LITERAL            { $$ = -1; }
    | STRING_LITERAL           { $$ = -1; }
    | KW_TRUE                  { $$ = -1; }
    | KW_FALSE                 { $$ = -1; }
    | KW_NONE                  { $$ = -1; }
    | LPAREN expr RPAREN       { $$ = -1; }
    | LBRACKET list_items RBRACKET { $$ = -1; }
    | LBRACE   dict_items RBRACE   { $$ = -1; }
    ;

/* ── Diccionarios ─────────────────────────────────────────────── */

dict_items
    : /* vacío */
    | dict_pairs
    ;

dict_pairs
    : expr COLON expr
    | dict_pairs COMMA expr COLON expr
    ;

/* ── Listas ───────────────────────────────────────────────────── */

list_items
    : /* vacío */
    | expr_list
    ;

expr_list
    : expr
    | expr_list COMMA expr
    ;

/* ── Argumentos de llamada ────────────────────────────────────── */

arg_list
    : /* vacío */
    | arguments
    ;

arguments
    : argument
    | arguments COMMA argument
    ;

/*
 * Conflicto shift/reduce esperado en:
 *   argument → IDENTIFIER . OP_ASSIGN expr  vs.
 *   argument → expr (donde expr → IDENTIFIER)
 * Bison elige shift (kwarg), que es el comportamiento correcto.
 */
argument
    : expr
    | IDENTIFIER OP_ASSIGN expr   /* argumento con nombre: f(x=1) */
    ;

%%

/* ════════════════════════════════════════════════════════════════
   §4  CÓDIGO C DE APOYO
   ════════════════════════════════════════════════════════════════ */

/*
 * yyerror — llamada automáticamente por Bison al detectar un error.
 *
 * Con %define parse.error verbose, Bison genera msg con el formato:
 *   "syntax error, unexpected <TOKEN>, expecting <X> or <Y>"
 * lo que ya indica qué se encontró y qué se esperaba.
 * Esta función añade localización (línea + columna) y el lexema exacto.
 *
 * Las reglas de error de cada producción imprimirán después la regla
 * gramatical violada y una sugerencia de corrección.
 */
void yyerror(const char *msg) {
    fprintf(stderr,
        "\n╔══════════════════════════════════════════════════════════╗\n"
        "║  ERROR SINTÁCTICO                                        ║\n"
        "╠══════════════════════════════════════════════════════════╣\n"
        "  Ubicación : línea %d, columna %d\n"
        "  Token     : \"%s\"\n"
        "  Problema  : %s\n",
        yylineno, yytok_col, yytext, msg);
    fprintf(stderr,
        "╚══════════════════════════════════════════════════════════╝\n");
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo.py>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror("fopen");
        return EXIT_FAILURE;
    }
    yyin = f;

    /* ── Análisis léxico + sintáctico ── */
    int parse_result = yyparse();
    fclose(yyin);

    /* ── Imprimir output del scanner y tablas ── */
    printf("\n════════════════════════════════════════════════════════════\n");
    printf("SCANNER OUTPUT\n");
    printf("════════════════════════════════════════════════════════════\n");
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();

    /* ── Resultado del análisis sintáctico ── */
    printf("════════════════════════════════════════════════════════════\n");
    if (parse_result == 0) {
        printf("ANÁLISIS SINTÁCTICO: [OK] — El programa es sintácticamente correcto.\n");
    } else {
        printf("ANÁLISIS SINTÁCTICO: [ERROR] — Se encontraron errores sintácticos.\n");
    }
    printf("════════════════════════════════════════════════════════════\n\n");

    /* ── Liberar memoria ── */
    free_scanner_output();
    free_symbol_tables();

    return parse_result;
}
