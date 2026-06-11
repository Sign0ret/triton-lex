%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * triton.tab.h es generado por Bison y contiene:
 *   - Los códigos enteros de cada token (IDENTIFIER, KW_IF, …)
 *   - La definición de YYSTYPE (union yylval)
 * Debe incluirse ANTES de cualquier uso de esos nombres.
 */
#include "triton.tab.h"

/* ════════════════════════════════════════════════════════════════
   COLA DE TOKENS
   Permite que una sola regla de Flex emita varios tokens
   (NEWLINE + INDENT/DEDENT) sin modificar la interfaz yylex().
   ════════════════════════════════════════════════════════════════ */

#define TOK_QUEUE_SIZE 210   /* MAX_DEPTH(100) DEDENTs + margen */

static int tok_queue[TOK_QUEUE_SIZE];
static int tok_q_head = 0;
static int tok_q_tail = 0;

static void tok_enqueue(int t) {
    if (tok_q_tail < TOK_QUEUE_SIZE)
        tok_queue[tok_q_tail++] = t;
}
static int tok_dequeue(void) {
    return tok_queue[tok_q_head++];
}
static int tok_queue_empty(void) {
    return tok_q_head >= tok_q_tail;
}

/* ════════════════════════════════════════════════════════════════
   SEGUIMIENTO DE COLUMNA
   yycolumn  → columna actual del scanner (1-based).
   yytok_col → columna donde empezó el token que se acaba de
               reconocer (usada por yyerror en el parser).
   YY_USER_ACTION corre automáticamente ANTES de cada acción
   de regla, por lo que captura el inicio antes de avanzar.
   ════════════════════════════════════════════════════════════════ */

int yycolumn  = 1;
int yytok_col = 1;

#define YY_USER_ACTION  yytok_col = yycolumn; yycolumn += yyleng;

/* ════════════════════════════════════════════════════════════════
   YY_DECL — renombra la función generada por Flex a flex_lex().
   yylex() (definida abajo) es la que Bison llama; primero drena
   la cola y sólo cuando está vacía invoca flex_lex().
   ════════════════════════════════════════════════════════════════ */

#define YY_DECL static int flex_lex(void)
YY_DECL;  /* prototipo: permite que yylex() llame a flex_lex()
             antes de que aparezca su definición en lex.yy.c  */

/*
 * yylex() — punto de entrada para Bison.
 * Exportada (sin static) para que sea visible al linker.
 * Resetea la cola cuando está vacía para evitar desbordamiento.
 */
int yylex(void) {
    if (!tok_queue_empty()) return tok_dequeue();
    tok_q_head = tok_q_tail = 0;   /* reset: evita desbordamiento */
    return flex_lex();
}

/* ════════════════════════════════════════════════════════════════
   ESTADÍSTICAS DEL ANÁLISIS LÉXICO
   ════════════════════════════════════════════════════════════════ */

typedef struct {
    int total_tokens;
    int total_lines;
    int total_identifiers;
    int total_numeric_literals;
    int total_string_literals;
    int error_count;
} LexerStats;

LexerStats stats = {0};

/* ════════════════════════════════════════════════════════════════
   TABLAS DE SÍMBOLOS (Listas Enlazadas)
   ════════════════════════════════════════════════════════════════ */

typedef struct IDNode {
    int entry;
    char* lexeme;
    /*
     * role — rol semántico asignado por el PARSER durante el análisis
     * sintáctico. El lexer lo inicializa como "identificador"; el parser
     * lo actualiza vía update_id_role() al reconocer construcciones
     * específicas de la gramática:
     *   "funcion"        → def <nombre>(...)
     *   "parametro"      → parámetro formal de una función
     *   "variable"       → lado izquierdo de una asignación (= += -= *= /=)
     *   "variable_ciclo" → variable de iteración en for <var> in ...
     *   "alias_modulo"   → import <módulo> as <alias>
     *   "modulo"         → nombre de módulo en import <módulo>
     *   "identificador"  → (default) aparece en el código sin rol conocido
     */
    char* role;
    struct IDNode* next;
} IDNode;

typedef struct NumNode {
    int entry;
    char* lexeme;
    char* type;
    struct NumNode* next;
} NumNode;

typedef struct StrNode {
    int entry;
    char* lexeme;
    struct StrNode* next;
} StrNode;

IDNode*  id_head  = NULL;
NumNode* num_head = NULL;
StrNode* str_head = NULL;

int id_counter  = 0;
int num_counter = 0;
int str_counter = 0;

int insert_id(const char* lexeme) {
    IDNode* curr = id_head;
    while (curr) {
        if (strcmp(curr->lexeme, lexeme) == 0) return curr->entry;
        curr = curr->next;
    }
    IDNode* node = (IDNode*)malloc(sizeof(IDNode));
    if (!node) { fprintf(stderr, "[ERROR] No hay memoria para IDNode.\n"); exit(EXIT_FAILURE); }
    stats.total_identifiers++;
    node->entry  = id_counter++;
    node->lexeme = strdup(lexeme);
    node->role   = strdup("identificador");  /* rol por defecto; el parser lo actualiza */
    node->next   = id_head;
    id_head      = node;
    return node->entry;
}

/*
 * update_id_role — llamada por el PARSER para actualizar el rol semántico
 * de un identificador ya registrado en la tabla.
 *
 * Parámetros:
 *   entry → índice devuelto por insert_id() (el yylval.entry del token)
 *   role  → cadena que describe el rol: "funcion", "parametro", etc.
 *
 * Si el entry no existe (p.ej. -1 para primarios complejos) la función
 * retorna sin hacer nada, lo que es seguro por diseño.
 */
void update_id_role(int entry, const char* role) {
    IDNode* curr = id_head;
    while (curr) {
        if (curr->entry == entry) {
            free(curr->role);
            curr->role = strdup(role);
            return;
        }
        curr = curr->next;
    }
}

int insert_num(const char* lexeme, const char* type) {
    NumNode* curr = num_head;
    while (curr) {
        if (strcmp(curr->lexeme, lexeme) == 0) return curr->entry;
        curr = curr->next;
    }
    NumNode* node = (NumNode*)malloc(sizeof(NumNode));
    if (!node) { fprintf(stderr, "[ERROR] No hay memoria para NumNode.\n"); exit(EXIT_FAILURE); }
    stats.total_numeric_literals++;
    node->entry  = num_counter++;
    node->lexeme = strdup(lexeme);
    node->type   = strdup(type);
    node->next   = num_head;
    num_head     = node;
    return node->entry;
}

int insert_str(const char* lexeme) {
    StrNode* curr = str_head;
    while (curr) {
        if (strcmp(curr->lexeme, lexeme) == 0) return curr->entry;
        curr = curr->next;
    }
    StrNode* node = (StrNode*)malloc(sizeof(StrNode));
    if (!node) { fprintf(stderr, "[ERROR] No hay memoria para StrNode.\n"); exit(EXIT_FAILURE); }
    stats.total_string_literals++;
    node->entry  = str_counter++;
    node->lexeme = strdup(lexeme);
    node->next   = str_head;
    str_head     = node;
    return node->entry;
}

void print_id_table(void) {
    printf("\n--- Symbol Table: Identifiers ---\n");
    printf("%-8s %-25s %-16s\n", "Entry #", "Lexeme", "Rol Semantico");
    printf("%-8s %-25s %-16s\n", "-------", "------", "-------------");
    if (!id_head) { printf("La tabla está vacía.\n"); return; }
    IDNode* arr[id_counter];
    IDNode* curr = id_head;
    while (curr) { arr[curr->entry] = curr; curr = curr->next; }
    for (int i = 0; i < id_counter; i++)
        printf("%-8d %-25s %-16s\n", arr[i]->entry, arr[i]->lexeme, arr[i]->role);
}

void print_num_table(void) {
    printf("\n--- Symbol Table: Numbers ---\n");
    printf("%-8s %-20s %-10s\n", "Entry #", "Lexeme", "Type");
    if (!num_head) { printf("La tabla está vacía.\n"); return; }
    NumNode* arr[num_counter];
    NumNode* curr = num_head;
    while (curr) { arr[curr->entry] = curr; curr = curr->next; }
    for (int i = 0; i < num_counter; i++)
        printf("%-8d %-20s %-10s\n", arr[i]->entry, arr[i]->lexeme, arr[i]->type);
}

void print_str_table(void) {
    printf("\n--- Symbol Table: Strings ---\n");
    printf("%-8s %-20s\n", "Entry #", "Lexeme");
    if (!str_head) { printf("La tabla está vacía.\n"); return; }
    StrNode* arr[str_counter];
    StrNode* curr = str_head;
    while (curr) { arr[curr->entry] = curr; curr = curr->next; }
    for (int i = 0; i < str_counter; i++)
        printf("%-8d %-20s\n", arr[i]->entry, arr[i]->lexeme);
}

void free_symbol_tables(void) {
    IDNode* ic = id_head;
    while (ic) { IDNode* n = ic->next; free(ic->lexeme); free(ic->role); free(ic); ic = n; }
    NumNode* nc = num_head;
    while (nc) { NumNode* n = nc->next; free(nc->lexeme); free(nc->type); free(nc); nc = n; }
    StrNode* sc = str_head;
    while (sc) { StrNode* n = sc->next; free(sc->lexeme); free(sc); sc = n; }
}

/* ════════════════════════════════════════════════════════════════
   PILA DE INDENTACIÓN
   ════════════════════════════════════════════════════════════════ */

#define MAX_DEPTH 100

int indent_stack[MAX_DEPTH] = {0};
int top = 0;

int paren_depth = 0;   /* profundidad de (), [] o {} abiertos */

/* ════════════════════════════════════════════════════════════════
   SCANNER OUTPUT (Lista Enlazada Simple)
   ════════════════════════════════════════════════════════════════ */

typedef struct TokenNode {
    char* token_name;
    int   entry;
    int   line_num;
    struct TokenNode* next;
} TokenNode;

TokenNode* scanner_head = NULL;
TokenNode* scanner_tail = NULL;

void add_token(const char* token_name, int entry) {
    TokenNode* node = (TokenNode*)malloc(sizeof(TokenNode));
    if (!node) { fprintf(stderr, "[ERROR] No hay memoria para TokenNode.\n"); exit(EXIT_FAILURE); }
    node->token_name = strdup(token_name);
    node->entry      = entry;
    node->line_num   = yylineno;
    node->next       = NULL;
    if (scanner_tail) scanner_tail->next = node;
    else              scanner_head       = node;
    scanner_tail = node;
    stats.total_tokens++;
}

void print_scanner_output(void) {
    TokenNode* curr = scanner_head;
    while (curr) {
        if (curr->entry >= 0) printf("<%s,%d>\n", curr->token_name, curr->entry);
        else                  printf("<%s>\n",    curr->token_name);
        curr = curr->next;
    }
}

void free_scanner_output(void) {
    TokenNode* curr = scanner_head;
    while (curr) {
        TokenNode* next = curr->next;
        free(curr->token_name);
        free(curr);
        curr = next;
    }
    scanner_head = scanner_tail = NULL;
}

void print_statistics(void) {
    printf("\n════════════════════════════════════════════════════════════\n");
    printf("ESTADÍSTICAS DEL LEXER\n");
    printf("════════════════════════════════════════════════════════════\n");
    printf("Total de tokens:              %d\n", stats.total_tokens);
    printf("Identificadores únicos:       %d\n", stats.total_identifiers);
    printf("Literales numéricos únicos:   %d\n", stats.total_numeric_literals);
    printf("Literales de texto únicos:    %d\n", stats.total_string_literals);
    printf("Errores léxicos:              %d\n", stats.error_count);
    printf("════════════════════════════════════════════════════════════\n\n");
}

%}

%option yylineno noinput nounput

DIGIT           [0-9]
LETTER          [a-zA-Z_]
HEX             [0-9a-fA-F]
BINARY          [01]
OCTAL           [0-7]

%%

    /* ────────────────────────────────────────────────────────────
       1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN
       ──────────────────────────────────────────────────────────── */

[ \t]+          { /* Ignorar espacios en medio de la línea */ }

\n[ \t]*|\r\n[ \t]* {
    /*
     * Continuación implícita: dentro de (), [] o {} los saltos de
     * línea se ignoran completamente (no generan NEWLINE/INDENT/DEDENT).
     */
    if (paren_depth > 0) {
        /* ignorar newline dentro de paréntesis/corchetes/llaves */
    } else {
        /* Calcular la indentación de la nueva línea */
        int current_indent = 0;
        for (int i = 0; yytext[i] != '\0'; i++) {
            if      (yytext[i] == ' ')  current_indent++;
            else if (yytext[i] == '\t') current_indent = (current_indent + 8) & ~7;
        }

        /* Encolar NEWLINE primero */
        add_token("NEWLINE", -1);
        tok_enqueue(NEWLINE);

        if (current_indent > indent_stack[top]) {
            if (top < MAX_DEPTH - 1) {
                indent_stack[++top] = current_indent;
                add_token("INDENT", -1);
                tok_enqueue(INDENT);
            } else {
                fprintf(stderr,
                    "[ERROR LEXICO FATAL] Nivel de indentación máximo superado\n"
                    "  Máximo permitido: %d niveles\n  Línea: %d\n",
                    MAX_DEPTH, yylineno);
                exit(EXIT_FAILURE);
            }
        } else if (current_indent < indent_stack[top]) {
            while (top > 0 && indent_stack[top] > current_indent) {
                top--;
                add_token("DEDENT", -1);
                tok_enqueue(DEDENT);
            }
            if (indent_stack[top] != current_indent) {
                fprintf(stderr,
                    "\n[ERROR LEXICO FATAL] Indentación inconsistente\n"
                    "  Línea: %d\n"
                    "  Indentación esperada: %d espacios\n"
                    "  Indentación encontrada: %d espacios\n",
                    yylineno, indent_stack[top], current_indent);
                exit(EXIT_FAILURE);
            }
        }

        /* El siguiente token en la nueva línea empieza en columna
           current_indent+1 (después de los espacios de indentación). */
        yycolumn = current_indent + 1;

        return tok_dequeue();
    }
}

    /* ────────────────────────────────────────────────────────────
       2) COMENTARIOS — se registran pero NO se devuelven al parser
       ──────────────────────────────────────────────────────────── */

#.*             { add_token("COMMENT", -1); /* skip */ }

    /* ────────────────────────────────────────────────────────────
       3) PALABRAS RESERVADAS
       ──────────────────────────────────────────────────────────── */

"import"        { add_token("KW_IMPORT",   -1); return KW_IMPORT;   }
"as"            { add_token("KW_AS",       -1); return KW_AS;       }
"def"           { add_token("KW_DEF",      -1); return KW_DEF;      }
"if"            { add_token("KW_IF",       -1); return KW_IF;       }
"elif"          { add_token("KW_ELIF",     -1); return KW_ELIF;     }
"else"          { add_token("KW_ELSE",     -1); return KW_ELSE;     }
"for"           { add_token("KW_FOR",      -1); return KW_FOR;      }
"while"         { add_token("KW_WHILE",    -1); return KW_WHILE;    }
"in"            { add_token("KW_IN",       -1); return KW_IN;       }
"break"         { add_token("KW_BREAK",    -1); return KW_BREAK;    }
"continue"      { add_token("KW_CONTINUE", -1); return KW_CONTINUE; }
"return"        { add_token("KW_RETURN",   -1); return KW_RETURN;   }
"pass"          { add_token("KW_PASS",     -1); return KW_PASS;     }
"and"           { add_token("KW_AND",      -1); return KW_AND;      }
"or"            { add_token("KW_OR",       -1); return KW_OR;       }
"not"           { add_token("KW_NOT",      -1); return KW_NOT;      }
"is"            { add_token("KW_IS",       -1); return KW_IS;       }
"True"          { add_token("KW_TRUE",     -1); return KW_TRUE;     }
"False"         { add_token("KW_FALSE",    -1); return KW_FALSE;    }
"None"          { add_token("KW_NONE",     -1); return KW_NONE;     }

    /* ────────────────────────────────────────────────────────────
       4) IDENTIFICADORES
       ──────────────────────────────────────────────────────────── */

{LETTER}({LETTER}|{DIGIT})* {
    yylval.entry = insert_id(yytext);
    add_token("IDENTIFIER", yylval.entry);
    return IDENTIFIER;
}

    /* ────────────────────────────────────────────────────────────
       5) LITERALES NUMÉRICOS
       ──────────────────────────────────────────────────────────── */

    /* Prefijos numéricos inválidos (sin dígitos siguientes) */
0[xX]/[^0-9a-fA-F] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo hexadecimal sin valor '%s'\n  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}
0[bB]/[^01] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo binario sin valor '%s'\n  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}
0[oO]/[^0-7] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo octal sin valor '%s'\n  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}

    /* Exponente de float incompleto */
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.?)[eE][+-]?/[^0-9] {
    fprintf(stderr,
        "[ERROR LEXICO] Exponente de float incompleto '%s'\n  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}

    /* Enteros válidos: hex, binario, octal, decimal */
0[xX]{HEX}+|0[bB]{BINARY}+|0[oO]{OCTAL}+|0|[1-9]{DIGIT}* {
    yylval.entry = insert_num(yytext, "int");
    add_token("INT_LITERAL", yylval.entry);
    return INT_LITERAL;
}

    /* Floats válidos */
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+ {
    yylval.entry = insert_num(yytext, "float");
    add_token("FLOAT_LITERAL", yylval.entry);
    return FLOAT_LITERAL;
}

    /* Token inválido: dígito seguido de letra */
{DIGIT}+{LETTER}({LETTER}|{DIGIT})* {
    fprintf(stderr,
        "[ERROR LEXICO] Token inválido '%s'\n  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}

    /* ────────────────────────────────────────────────────────────
       6) LITERALES DE TEXTO (Strings)
       ──────────────────────────────────────────────────────────── */

    /* Triple-quoted */
\"\"\"([^"\\]|\\.|\"[^"]|\"\"[^"])*\"\"\" {
    yylval.entry = insert_str(yytext);
    add_token("STRING_LITERAL", yylval.entry);
    return STRING_LITERAL;
}
\'\'\'([^'\\]|\\.|\\'[^']|\'\'[^'])*\'\'\' {
    yylval.entry = insert_str(yytext);
    add_token("STRING_LITERAL", yylval.entry);
    return STRING_LITERAL;
}

    /* Strings simples válidas */
\"([^"\\\n]|\\.)*\" {
    yylval.entry = insert_str(yytext);
    add_token("STRING_LITERAL", yylval.entry);
    return STRING_LITERAL;
}
\'([^'\\\n]|\\.)*\' {
    yylval.entry = insert_str(yytext);
    add_token("STRING_LITERAL", yylval.entry);
    return STRING_LITERAL;
}

    /* Strings sin cerrar */
\"([^"\\\n]|\\.)*\n {
    fprintf(stderr,
        "[ERROR LEXICO] String sin cerrar (comilla doble)\n  Línea: %d\n",
        yylineno - 1);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}
\'([^'\\\n]|\\.)*\n {
    fprintf(stderr,
        "[ERROR LEXICO] String sin cerrar (comilla simple)\n  Línea: %d\n",
        yylineno - 1);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}

    /* ────────────────────────────────────────────────────────────
       7) OPERADORES COMPUESTOS DE ASIGNACIÓN
       ──────────────────────────────────────────────────────────── */

"+="    { add_token("OP_PLUS_ASSIGN",  -1); return OP_PLUS_ASSIGN;  }
"-="    { add_token("OP_MINUS_ASSIGN", -1); return OP_MINUS_ASSIGN; }
"*="    { add_token("OP_STAR_ASSIGN",  -1); return OP_STAR_ASSIGN;  }
"/="    { add_token("OP_SLASH_ASSIGN", -1); return OP_SLASH_ASSIGN; }

    /* ────────────────────────────────────────────────────────────
       8) OPERADOR DE ASIGNACIÓN SIMPLE
       ──────────────────────────────────────────────────────────── */

"="     { add_token("OP_ASSIGN", -1); return OP_ASSIGN; }

    /* ────────────────────────────────────────────────────────────
       9) OPERADORES ARITMÉTICOS
       ──────────────────────────────────────────────────────────── */

"//"    { add_token("OP_DOUBLE_SLASH", -1); return OP_DOUBLE_SLASH; }
"+"     { add_token("OP_PLUS",  -1); return OP_PLUS;  }
"-"     { add_token("OP_MINUS", -1); return OP_MINUS; }
"*"     { add_token("OP_STAR",  -1); return OP_STAR;  }
"/"     { add_token("OP_SLASH", -1); return OP_SLASH; }
"%"     { add_token("OP_MOD",   -1); return OP_MOD;   }

    /* ────────────────────────────────────────────────────────────
       10) OPERADORES RELACIONALES
       ──────────────────────────────────────────────────────────── */

"<="    { add_token("OP_LE",  -1); return OP_LE;  }
">="    { add_token("OP_GE",  -1); return OP_GE;  }
"=="    { add_token("OP_EQ",  -1); return OP_EQ;  }
"!="    { add_token("OP_NEQ", -1); return OP_NEQ; }
"<"     { add_token("OP_LT",  -1); return OP_LT;  }
">"     { add_token("OP_GT",  -1); return OP_GT;  }

    /* ────────────────────────────────────────────────────────────
       11) OPERADORES BIT A BIT
       ──────────────────────────────────────────────────────────── */

"<<"    { add_token("OP_LSHIFT",  -1); return OP_LSHIFT;  }
">>"    { add_token("OP_RSHIFT",  -1); return OP_RSHIFT;  }
"&"     { add_token("OP_BIT_AND", -1); return OP_BIT_AND; }
"|"     { add_token("OP_BIT_OR",  -1); return OP_BIT_OR;  }
"^"     { add_token("OP_BIT_XOR", -1); return OP_BIT_XOR; }
"~"     { add_token("OP_BIT_NOT", -1); return OP_BIT_NOT; }

    /* ────────────────────────────────────────────────────────────
       12) DELIMITADORES Y PUNTUACIÓN
       ──────────────────────────────────────────────────────────── */

"->"    { add_token("ARROW",    -1); return ARROW;    }
"("     { paren_depth++; add_token("LPAREN",   -1); return LPAREN;   }
")"     { paren_depth--; add_token("RPAREN",   -1); return RPAREN;   }
"["     { paren_depth++; add_token("LBRACKET", -1); return LBRACKET; }
"]"     { paren_depth--; add_token("RBRACKET", -1); return RBRACKET; }
"{"     { paren_depth++; add_token("LBRACE",   -1); return LBRACE;   }
"}"     { paren_depth--; add_token("RBRACE",   -1); return RBRACE;   }
","     { add_token("COMMA",     -1); return COMMA;     }
":"     { add_token("COLON",     -1); return COLON;     }
"."     { add_token("DOT",       -1); return DOT;       }
";"     {
    fprintf(stderr,
        "[ERROR LEXICO] Carácter inesperado ';'\n"
        "  Línea: %d\n"
        "  Sugerencia : Triton-DSL no admite ';' para separar sentencias.\n"
        "               Pon cada sentencia en su propia línea.\n",
        yylineno);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}
    /*
     * Decoradores Triton válidos — reconocidos como token único.
     * Flex usa longest-match, así que estas reglas tienen precedencia
     * sobre la regla genérica "@" que queda solo para error recovery.
     */
"@triton.jit"   { add_token("TRITON_JIT", -1); return TRITON_JIT; }
"@"     { add_token("AT",        -1); return AT;        }

    /* ────────────────────────────────────────────────────────────
       13) FIN DE ARCHIVO
       Emitir DEDENTs pendientes uno por llamada; cuando top == 0,
       señalar EOF al parser con return 0.
       ──────────────────────────────────────────────────────────── */

<<EOF>> {
    if (top > 0) {
        top--;
        add_token("DEDENT", -1);
        return DEDENT;
    }
    return 0;
}

    /* ────────────────────────────────────────────────────────────
       ERROR LÉXICO
       ──────────────────────────────────────────────────────────── */

. {
    fprintf(stderr,
        "[ERROR LEXICO] Carácter inesperado '%s'\n"
        "  Línea: %d\n  Carácter ASCII: %d (0x%X)\n",
        yytext, yylineno,
        (unsigned char)yytext[0], (unsigned char)yytext[0]);
    stats.error_count++;
    print_scanner_output(); print_id_table(); print_num_table();
    print_str_table(); print_statistics();
    exit(EXIT_FAILURE);
}

%%

int yywrap(void) { return 1; }
