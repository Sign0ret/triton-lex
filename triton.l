%{
/*
 * ═══════════════════════════════════════════════════════════════════════════
 * TRITON LEXER - LEXICAL ANALYZER FOR TRITON DSL
 *
 * Descripción:
 *   Analizador léxico robusto para un lenguaje similar a Python con soporte
 *   para características especiales de Triton (lenguaje para kernels GPU).
 *
 * Arquitectura:
 *   - Manejo de indentación significativa (style Python)
 *   - Generación automática de INDENT/DEDENT tokens
 *   - Tabla de símbolos (hash map) para identificadores y literales
 *   - Output en lista doblemente enlazada para consumo por parser
 *
 * Compilación:
 *   $ flex triton.l
 *   $ gcc -o triton_lexer lex.yy.c -lfl -Wall -Werror
 *
 * Ejecución:
 *   $ ./triton_lexer codigo.py
 *
 * Autor: Generado + Mejorado
 * Fecha: 2026-04-27
 * ═══════════════════════════════════════════════════════════════════════════
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// ═══════════════════════════════════════════════════════════════════════════
// CONFIGURACIÓN DEL LEXER
// ═══════════════════════════════════════════════════════════════════════════

#define HASH_SIZE 256
#define MAX_DEPTH 100
#define STRING_BUFFER_SIZE 1024

// ═══════════════════════════════════════════════════════════════════════════
// ESTADÍSTICAS DEL ANÁLISIS LÉXICO
// ═══════════════════════════════════════════════════════════════════════════

typedef struct {
    int total_tokens;
    int total_lines;
    int total_identifiers;
    int total_numeric_literals;
    int total_string_literals;
    int error_count;
} LexerStats;

LexerStats stats = {0};

// ═══════════════════════════════════════════════════════════════════════════
// ESTRUCTURA 1: HASH MAPS (Tabla de Símbolos y Literales)
// ═══════════════════════════════════════════════════════════════════════════

typedef struct HashNode {
    char* value;
    struct HashNode* next;
} HashNode;

HashNode* idTable[HASH_SIZE] = {NULL};
HashNode* literalTable[HASH_SIZE] = {NULL};

unsigned int hash(const char* str) {
    unsigned long hash_val = 5381;
    int c;
    while ((c = *str++)) {
        hash_val = ((hash_val << 5) + hash_val) + c;
    }
    return hash_val % HASH_SIZE;
}

void insert_into_table(HashNode** table, const char* value) {
    unsigned int index = hash(value);
    HashNode* curr = table[index];

    while(curr != NULL) {
        if(strcmp(curr->value, value) == 0) return;
        curr = curr->next;
    }

    HashNode* new_node = (HashNode*)malloc(sizeof(HashNode));
    if (!new_node) {
        fprintf(stderr, "[ERROR] No hay memoria para HashNode. Abortando.\n");
        exit(EXIT_FAILURE);
    }

    new_node->value = strdup(value);
    if (!new_node->value) {
        fprintf(stderr, "[ERROR] No hay memoria para strdup('%s'). Abortando.\n", value);
        free(new_node);
        exit(EXIT_FAILURE);
    }

    new_node->next = table[index];
    table[index] = new_node;
}

void print_table(HashNode** table, const char* title) {
    printf("\n--- %s ---\n", title);
    int empty = 1;

    for(int i = 0; i < HASH_SIZE; i++) {
        HashNode* curr = table[i];
        while(curr != NULL) {
            empty = 0;
            printf("%s\n", curr->value);
            curr = curr->next;
        }
    }

    if (empty) {
        printf("La tabla está vacía.\n");
    }
}

void free_hash_table(HashNode** table) {
    for (int i = 0; i < HASH_SIZE; i++) {
        HashNode* curr = table[i];
        while (curr != NULL) {
            HashNode* next = curr->next;
            free(curr->value);
            free(curr);
            curr = next;
        }
        table[i] = NULL;
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// ESTRUCTURA 2: PILA DE INDENTACIÓN
// ═══════════════════════════════════════════════════════════════════════════

int indent_stack[MAX_DEPTH] = {0};
int top = 0;

// ═══════════════════════════════════════════════════════════════════════════
// ESTRUCTURA 3: SCANNER OUTPUT (Double Linked List)
// ═══════════════════════════════════════════════════════════════════════════

typedef struct TokenNode {
    char* token_name;
    char* lexeme;
    size_t lexeme_len;
    int line_num;
    struct TokenNode* prev;
    struct TokenNode* next;
} TokenNode;

TokenNode* scanner_head = NULL;
TokenNode* scanner_tail = NULL;

void add_token(const char* token_name, const char* lexeme) {
    TokenNode* new_node = (TokenNode*)malloc(sizeof(TokenNode));
    if (!new_node) {
        fprintf(stderr, "[ERROR] No hay memoria para TokenNode. Abortando.\n");
        exit(EXIT_FAILURE);
    }

    new_node->token_name = strdup(token_name);
    if (!new_node->token_name) {
        fprintf(stderr, "[ERROR] No hay memoria para token_name. Abortando.\n");
        free(new_node);
        exit(EXIT_FAILURE);
    }

    new_node->lexeme = strdup(lexeme);
    if (!new_node->lexeme) {
        fprintf(stderr, "[ERROR] No hay memoria para lexeme. Abortando.\n");
        free(new_node->token_name);
        free(new_node);
        exit(EXIT_FAILURE);
    }

    new_node->lexeme_len = strlen(lexeme);
    new_node->line_num = yylineno;
    new_node->prev = scanner_tail;
    new_node->next = NULL;

    if (scanner_tail != NULL) {
        scanner_tail->next = new_node;
    } else {
        scanner_head = new_node;
    }
    scanner_tail = new_node;

    stats.total_tokens++;
    if (strcmp(token_name, "IDENTIFIER") == 0) stats.total_identifiers++;
    if (strcmp(token_name, "INT_LITERAL") == 0 ||
        strcmp(token_name, "FLOAT_LITERAL") == 0) stats.total_numeric_literals++;
    if (strcmp(token_name, "STRING_LITERAL") == 0) stats.total_string_literals++;
}

void print_scanner_output() {
    TokenNode* curr = scanner_head;
    while (curr != NULL) {
        if (curr->lexeme_len > 0) {
            printf("<%s,%s>\n", curr->token_name, curr->lexeme);
        } else {
            printf("<%s>\n", curr->token_name);
        }
        curr = curr->next;
    }
}

void free_scanner_output() {
    TokenNode* curr = scanner_head;
    while (curr != NULL) {
        TokenNode* next = curr->next;
        free(curr->token_name);
        free(curr->lexeme);
        free(curr);
        curr = next;
    }
    scanner_head = NULL;
    scanner_tail = NULL;
}

void print_statistics() {
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

    /* ===================================================================
       1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN
       =================================================================== */

[ \t]+          { /* Ignorar espacios en medio de la línea */ }

\n[ \t]*|\r\n[ \t]* {
    add_token("NEWLINE", "");

    int current_indent = 0;
    for(int i = 0; yytext[i] != '\0'; i++) {
        if(yytext[i] == ' ') {
            current_indent++;
        } else if(yytext[i] == '\t') {
            current_indent = (current_indent + 8) & ~7;
        }
    }

    if (current_indent > indent_stack[top]) {
        if (top < MAX_DEPTH - 1) {
            indent_stack[++top] = current_indent;
            add_token("INDENT", "");
        } else {
            fprintf(stderr,
                "[ERROR LEXICO FATAL] Nivel de indentación máximo superado\n"
                "  Máximo permitido: %d niveles\n"
                "  Línea: %d\n",
                MAX_DEPTH, yylineno);
            exit(EXIT_FAILURE);
        }
    } else if (current_indent < indent_stack[top]) {
        while (top > 0 && indent_stack[top] > current_indent) {
            top--;
            add_token("DEDENT", "");
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
}

    /* ===================================================================
       2) COMENTARIOS
       =================================================================== */

#.*             { add_token("COMMENT", yytext); }

    /* ===================================================================
       3) PALABRAS RESERVADAS
       =================================================================== */

"def"           { add_token("KW_DEF", yytext); }
"if"            { add_token("KW_IF", yytext); }
"elif"          { add_token("KW_ELIF", yytext); }
"else"          { add_token("KW_ELSE", yytext); }
"for"           { add_token("KW_FOR", yytext); }
"while"         { add_token("KW_WHILE", yytext); }
"in"            { add_token("KW_IN", yytext); }
"break"         { add_token("KW_BREAK", yytext); }
"continue"      { add_token("KW_CONTINUE", yytext); }
"return"        { add_token("KW_RETURN", yytext); }
"pass"          { add_token("KW_PASS", yytext); }
"and"           { add_token("KW_AND", yytext); }
"or"            { add_token("KW_OR", yytext); }
"not"           { add_token("KW_NOT", yytext); }
"is"            { add_token("KW_IS", yytext); }
"True"          { add_token("KW_TRUE", yytext); }
"False"         { add_token("KW_FALSE", yytext); }
"None"          { add_token("KW_NONE", yytext); }

    /* ===================================================================
       4) TOKENS TRITON ESPECÍFICOS
       =================================================================== */

tl\.{LETTER}({LETTER}|{DIGIT})* { add_token("TL_IDENTIFIER", yytext); }

    /* ===================================================================
       5) IDENTIFICADORES
       =================================================================== */

{LETTER}({LETTER}|{DIGIT})* {
    add_token("IDENTIFIER", yytext);
    insert_into_table(idTable, yytext);
}

    /* ===================================================================
       6) TOKENS INVÁLIDOS: dígito seguido de letra (ej: 1a, 3xyz)
       Debe ir ANTES de INT_LITERAL e IDENTIFIER para que el maximal
       munch capture el token completo como error y no lo divida.
       =================================================================== */

{DIGIT}+{LETTER}({LETTER}|{DIGIT})* {
    fprintf(stderr,
        "[ERROR LEXICO] Token inválido '%s' - los identificadores no pueden comenzar con dígito\n"
        "  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
}

    /* ===================================================================
       7) LITERALES NUMÉRICOS

       ORDEN IMPORTANTE:
         1. Prefijos inválidos (0x, 0b, 0o sin dígitos)  → error
         2. Exponente incompleto (1e, 1e+)               → error
         3. Enteros y floats válidos
       =================================================================== */

    /* Prefijos numéricos sin dígitos después: usa trailing context (/) para
       no consumir el carácter siguiente y que sea analizado normalmente */
0[xX]/[^0-9a-fA-F] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo hexadecimal sin valor '%s' - falta al menos un dígito hex\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 0xFF, 0x1A3\n",
        yytext, yylineno);
    stats.error_count++;
}

0[bB]/[^01] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo binario sin valor '%s' - falta al menos un dígito binario\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 0b1010, 0b11001\n",
        yytext, yylineno);
    stats.error_count++;
}

0[oO]/[^0-7] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo octal sin valor '%s' - falta al menos un dígito octal\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 0o755, 0o17\n",
        yytext, yylineno);
    stats.error_count++;
}

    /* Exponente de float incompleto: 1e, 1e+, 1.5e- sin dígitos después */
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.?)[eE][+-]?/[^0-9] {
    fprintf(stderr,
        "[ERROR LEXICO] Exponente de float incompleto '%s' - falta el valor del exponente\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 1e10, 1.5e-3, 2.0E+8\n",
        yytext, yylineno);
    stats.error_count++;
}

    /* Enteros válidos: hex, binario, octal, decimal */
0[xX]{HEX}+|0[bB]{BINARY}+|0[oO]{OCTAL}+|0|[1-9]{DIGIT}* {
    add_token("INT_LITERAL", yytext);
    insert_into_table(literalTable, yytext);
}

    /* Floats válidos */
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+ {
    add_token("FLOAT_LITERAL", yytext);
    insert_into_table(literalTable, yytext);
}

    /* ===================================================================
       8) LITERALES DE TEXTO (Strings)

       ORDEN IMPORTANTE:
         1. Triple-quoted (antes que simples, son más largas)
         2. f-strings (antes que simples)
         3. Strings simples válidas
         4. Strings sin cerrar → error
       =================================================================== */

    /* Triple-quoted: """..."""  y  '''...'''  (pueden ser multilinea) */
\"\"\"([^"\\]|\\.|\"[^"]|\"\"[^"])*\"\"\" { add_token("STRING_LITERAL", yytext); }
\'\'\'([^'\\]|\\.|\\'[^']|\'\'[^'])*\'\'\' { add_token("STRING_LITERAL", yytext); }

    /* f-strings: f"..."  y  f'...' */
[fF]\"([^"\\\n]|\\.)*\" { add_token("STRING_LITERAL", yytext); }
[fF]\'([^'\\\n]|\\.)*\' { add_token("STRING_LITERAL", yytext); }

    /* Strings simples válidas */
\"([^"\\\n]|\\.)*\" { add_token("STRING_LITERAL", yytext); }
\'([^'\\\n]|\\.)*\' { add_token("STRING_LITERAL", yytext); }

    /* Strings sin cerrar: llegan al fin de línea sin comilla de cierre */
\"([^"\\\n]|\\.)*\n {
    fprintf(stderr,
        "[ERROR LEXICO] String sin cerrar (comilla doble)\n"
        "  Línea: %d\n"
        "  Sugerencia: agrega '\"' al final de la cadena\n",
        yylineno - 1);
    stats.error_count++;
}
\'([^'\\\n]|\\.)*\n {
    fprintf(stderr,
        "[ERROR LEXICO] String sin cerrar (comilla simple)\n"
        "  Línea: %d\n"
        "  Sugerencia: agrega \"'\" al final de la cadena\n",
        yylineno - 1);
    stats.error_count++;
}

    /* ===================================================================
       9) OPERADORES COMPUESTOS (deben ir ANTES que los simples)
       =================================================================== */

"+="            { add_token("OP_PLUS_ASSIGN", yytext); }
"-="            { add_token("OP_MINUS_ASSIGN", yytext); }
"*="            { add_token("OP_STAR_ASSIGN", yytext); }
"/="            { add_token("OP_SLASH_ASSIGN", yytext); }
"//="           { add_token("OP_DOUBLE_SLASH_ASSIGN", yytext); }
"%="            { add_token("OP_MOD_ASSIGN", yytext); }
"&="            { add_token("OP_BIT_AND_ASSIGN", yytext); }
"|="            { add_token("OP_BIT_OR_ASSIGN", yytext); }
"^="            { add_token("OP_BIT_XOR_ASSIGN", yytext); }
"<<="           { add_token("OP_LSHIFT_ASSIGN", yytext); }
">>="           { add_token("OP_RSHIFT_ASSIGN", yytext); }

    /* ===================================================================
       10) OPERADOR DE ASIGNACIÓN SIMPLE
       =================================================================== */

"="             { add_token("OP_ASSIGN", yytext); }

    /* ===================================================================
       10) OPERADORES ARITMÉTICOS
       =================================================================== */

"//"            { add_token("OP_DOUBLE_SLASH", yytext); }
"+"             { add_token("OP_PLUS", yytext); }
"-"             { add_token("OP_MINUS", yytext); }
"*"             { add_token("OP_STAR", yytext); }
"/"             { add_token("OP_SLASH", yytext); }
"%"             { add_token("OP_MOD", yytext); }

    /* ===================================================================
       11) OPERADORES RELACIONALES
       =================================================================== */

"<="            { add_token("OP_LE", yytext); }
">="            { add_token("OP_GE", yytext); }
"=="            { add_token("OP_EQ", yytext); }
"!="            { add_token("OP_NEQ", yytext); }
"<"             { add_token("OP_LT", yytext); }
">"             { add_token("OP_GT", yytext); }

    /* ===================================================================
       12) OPERADORES BIT A BIT
       =================================================================== */

"<<"            { add_token("OP_LSHIFT", yytext); }
">>"            { add_token("OP_RSHIFT", yytext); }
"&"             { add_token("OP_BIT_AND", yytext); }
"|"             { add_token("OP_BIT_OR", yytext); }
"^"             { add_token("OP_BIT_XOR", yytext); }
"~"             { add_token("OP_BIT_NOT", yytext); }

    /* ===================================================================
       13) DELIMITADORES Y PUNTUACIÓN
       =================================================================== */

"->"            { add_token("ARROW", yytext); }
"("             { add_token("LPAREN", yytext); }
")"             { add_token("RPAREN", yytext); }
"["             { add_token("LBRACKET", yytext); }
"]"             { add_token("RBRACKET", yytext); }
"{"             { add_token("LBRACE", yytext); }
"}"             { add_token("RBRACE", yytext); }
","             { add_token("COMMA", yytext); }
":"             { add_token("COLON", yytext); }
"."             { add_token("DOT", yytext); }
";"             { add_token("SEMICOLON", yytext); }
"@"             { add_token("AT", yytext); }

    /* ===================================================================
       14) FIN DE ARCHIVO
       =================================================================== */

<<EOF>>         {
                    while(top > 0) {
                        add_token("DEDENT", "");
                        top--;
                    }

                    print_scanner_output();
                    print_table(idTable, "TABLA DE IDENTIFICADORES");
                    print_table(literalTable, "TABLA DE LITERALES NUMERICOS");
                    print_statistics();

                    return 0;
                }

    /* ===================================================================
       ERROR LÉXICO
       =================================================================== */

.               {
    fprintf(stderr,
        "[ERROR LEXICO] Carácter inesperado '%s'\n"
        "  Línea: %d\n"
        "  Carácter ASCII: %d (0x%X)\n",
        yytext, yylineno, (unsigned char)yytext[0], (unsigned char)yytext[0]);
    stats.error_count++;
}

%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo_de_entrada.py>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *archivo = fopen(argv[1], "r");
    if (!archivo) {
        fprintf(stderr, "Error: No se pudo abrir el archivo '%s'\n", argv[1]);
        perror("fopen");
        return EXIT_FAILURE;
    }

    yyin = archivo;
    int result = yylex();

    fclose(archivo);
    free_scanner_output();
    free_hash_table(idTable);
    free_hash_table(literalTable);

    return result;
}