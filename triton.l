%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_DEPTH 100 // Identación máxima

// ESTADÍSTICAS DEL ANÁLISIS LÉXICO

typedef struct {
    int total_tokens;
    int total_lines;
    int total_identifiers;
    int total_numeric_literals;
    int total_string_literals;
    int error_count;
} LexerStats;

LexerStats stats = {0};

// SYMBOL TABLES (Linked Lists)

typedef struct IDNode {
    int entry;
    char* lexeme;
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

// Returns entry number (existing or new)
int insert_id(const char* lexeme) {
    IDNode* curr = id_head;
    while (curr != NULL) {
        if (strcmp(curr->lexeme, lexeme) == 0){ 
            return curr->entry;
        } 
        curr = curr->next;
    }

    IDNode* node = (IDNode*)malloc(sizeof(IDNode));
    if (!node){
        fprintf(stderr, "[ERROR] No hay memoria para IDNode.\n");
        exit(EXIT_FAILURE);
    }

    stats.total_identifiers++;

    node->entry  = id_counter++;
    node->lexeme = strdup(lexeme);
    node->next   = id_head;
    id_head      = node;
    return node->entry;
}

// Returns entry number (existing or new)
int insert_num(const char* lexeme, const char* type) {
    NumNode* curr = num_head;
    while (curr != NULL) {
        if (strcmp(curr->lexeme, lexeme) == 0){
            return curr->entry;
        } 
        curr = curr->next;
    }

    NumNode* node = (NumNode*)malloc(sizeof(NumNode));
    if (!node){
        fprintf(stderr, "[ERROR] No hay memoria para NumNode.\n"); 
        exit(EXIT_FAILURE); 
    }

    stats.total_numeric_literals++;

    node->entry  = num_counter++;
    node->lexeme = strdup(lexeme);
    node->type   = strdup(type);
    node->next   = num_head;
    num_head     = node;
    return node->entry;
}

// Returns entry number (existing or new)
int insert_str(const char* lexeme) {
    StrNode* curr = str_head;
    while (curr != NULL) {
        if (strcmp(curr->lexeme, lexeme) == 0){
            return curr->entry;
        } 
        curr = curr->next;
    }

    StrNode* node = (StrNode*)malloc(sizeof(StrNode));
    if (!node){
        fprintf(stderr, "[ERROR] No hay memoria para StrNode.\n");
        exit(EXIT_FAILURE);
    }

    stats.total_string_literals++;

    node->entry  = str_counter++;
    node->lexeme = strdup(lexeme);
    node->next   = str_head;
    str_head     = node;
    return node->entry;
}

void print_id_table() {
    printf("\n--- Symbol Table: Identifiers ---\n");
    printf("%-8s %-20s\n", "Entry #", "Lexeme");

    if(!id_head){
        printf("La tabla está vacía.\n");
        return;
    }
    // Collect into array for ordered printing
    IDNode* arr[id_counter];
    IDNode* curr = id_head;
    while(curr){
        arr[curr->entry] = curr;
        curr = curr->next; 
    }

    for(int i = 0; i < id_counter; i++){
        printf("%-8d %-20s\n", arr[i]->entry, arr[i]->lexeme);
    }
}

void print_num_table() {
    printf("\n--- Symbol Table: Numbers ---\n");
    printf("%-8s %-20s %-10s\n", "Entry #", "Lexeme", "Type");

    if (!num_head){
        printf("La tabla está vacía.\n");
        return;
    }

    NumNode* arr[num_counter];
    NumNode* curr = num_head;

    while(curr){
        arr[curr->entry] = curr;
        curr = curr->next;
    }

    for(int i = 0; i < num_counter; i++){
        printf("%-8d %-20s %-10s\n", arr[i]->entry, arr[i]->lexeme, arr[i]->type);
    }
}

void print_str_table() {
    printf("\n--- Symbol Table: Strings ---\n");
    printf("%-8s %-20s\n", "Entry #", "Lexeme");

    if(!str_head){ 
        printf("La tabla está vacía.\n");
        return; 
    }

    StrNode* arr[str_counter];
    StrNode* curr = str_head;

    while(curr){
        arr[curr->entry] = curr;
        curr = curr->next;
    }

    for (int i = 0; i < str_counter; i++){
        printf("%-8d %-20s\n", arr[i]->entry, arr[i]->lexeme);
    }
}

void free_symbol_tables() {
    IDNode* ic = id_head;
    while(ic){
        IDNode* n = ic->next; free(ic->lexeme); free(ic); ic = n; 
    }

    NumNode* nc = num_head;
    while(nc){
        NumNode* n = nc->next; free(nc->lexeme); free(nc->type); free(nc); nc = n;
    }

    StrNode* sc = str_head;
    while(sc){
        StrNode* n = sc->next; free(sc->lexeme); free(sc); sc = n;
    }
}

// ESTRUCTURA 2: PILA DE INDENTACIÓN

int indent_stack[MAX_DEPTH] = {0};
int top = 0;

// Profundidad de paréntesis/corchetes/llaves abiertos.

int paren_depth = 0;

// ESTRUCTURA 3: SCANNER OUTPUT (Linked List)

typedef struct TokenNode {
    char* token_name;
    int   entry;       // -1 if not referencing a symbol table like keywords
    int   line_num;
    struct TokenNode* next;
} TokenNode;

TokenNode* scanner_head = NULL;
TokenNode* scanner_tail = NULL;

void add_token(const char* token_name, int entry) {
    TokenNode* node = (TokenNode*)malloc(sizeof(TokenNode));
    if(!node){
        fprintf(stderr, "[ERROR] No hay memoria para TokenNode.\n"); exit(EXIT_FAILURE); 
    }

    node->token_name = strdup(token_name);
    node->entry      = entry;
    node->line_num   = yylineno;
    node->next       = NULL;

    if (scanner_tail){
        scanner_tail->next = node;
    }else{
        scanner_head = node;
    }              
    scanner_tail = node;

    stats.total_tokens++;
}

void print_scanner_output() {
    TokenNode* curr = scanner_head;
    while(curr){
        if (curr->entry >= 0){
            printf("<%s,%d>\n", curr->token_name, curr->entry);
        }
        else{
            printf("<%s>\n", curr->token_name);
        }
        curr = curr->next;
    }
}

void free_scanner_output() {
    TokenNode* curr = scanner_head;
    while(curr){
        TokenNode* next = curr->next;
        free(curr->token_name);
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

    /* 
       1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN
    */

[ \t]+          { /* Ignorar espacios en medio de la línea */ }

\n[ \t]*|\r\n[ \t]* {
    // Continuación implícita: dentro de (), [] o {} los saltos de línea
    // se ignoran completamente, no generan NEWLINE ni INDENT/DEDENT.
    // Esto permite llamadas multilínea como:
    //   tl.load(ptr + offsets,
    //           mask=mask)
    if (paren_depth > 0) {
        /* ignorar newline dentro de paréntesis/corchetes/llaves */
    } else {
        add_token("NEWLINE", -1);

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
                add_token("INDENT", -1);
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
                add_token("DEDENT", -1);
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
}

    /* 
       2) COMENTARIOS
    */

#.*             { add_token("COMMENT", -1); }

    /* 
       3) PALABRAS RESERVADAS
    */

"import"        { add_token("KW_IMPORT", -1); }
"as"            { add_token("KW_AS", -1); }
"def"           { add_token("KW_DEF", -1); }
"if"            { add_token("KW_IF", -1); }
"elif"          { add_token("KW_ELIF", -1); }
"else"          { add_token("KW_ELSE", -1); }
"for"           { add_token("KW_FOR", -1); }
"while"         { add_token("KW_WHILE", -1); }
"in"            { add_token("KW_IN", -1); }
"break"         { add_token("KW_BREAK", -1); }
"continue"      { add_token("KW_CONTINUE", -1); }
"return"        { add_token("KW_RETURN", -1); }
"pass"          { add_token("KW_PASS", -1); }
"and"           { add_token("KW_AND", -1); }
"or"            { add_token("KW_OR", -1); }
"not"           { add_token("KW_NOT", -1); }
"is"            { add_token("KW_IS", -1); }
"True"          { add_token("KW_TRUE", -1); }
"False"         { add_token("KW_FALSE", -1); }
"None"          { add_token("KW_NONE", -1); }

    /* 
       4) IDENTIFICADORES
    */

{LETTER}({LETTER}|{DIGIT})* {
    add_token("IDENTIFIER", insert_id(yytext));
}

    /* 
       7) LITERALES NUMÉRICOS

       ORDEN IMPORTANTE:
         1. Prefijos inválidos (0x, 0b, 0o sin dígitos)  → error
         2. Exponente incompleto (1e, 1e+)               → error
         3. Enteros y floats válidos
        */

    /* Prefijos numéricos sin dígitos después: usa trailing context (/) para
       no consumir el carácter siguiente y que sea analizado normalmente */
0[xX]/[^0-9a-fA-F] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo hexadecimal sin valor '%s' - falta al menos un dígito hex\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 0xFF, 0x1A3\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

0[bB]/[^01] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo binario sin valor '%s' - falta al menos un dígito binario\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 0b1010, 0b11001\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

0[oO]/[^0-7] {
    fprintf(stderr,
        "[ERROR LEXICO] Prefijo octal sin valor '%s' - falta al menos un dígito octal\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 0o755, 0o17\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

    /* Exponente de float incompleto: 1e, 1e+, 1.5e- sin dígitos después */
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.?)[eE][+-]?/[^0-9] {
    fprintf(stderr,
        "[ERROR LEXICO] Exponente de float incompleto '%s' - falta el valor del exponente\n"
        "  Línea: %d\n"
        "  Ejemplo válido: 1e10, 1.5e-3, 2.0E+8\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

    /* Enteros válidos: hex, binario, octal, decimal */
0[xX]{HEX}+|0[bB]{BINARY}+|0[oO]{OCTAL}+|0|[1-9]{DIGIT}* {
    add_token("INT_LITERAL", insert_num(yytext, "int"));
}

    /* Floats válidos */
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+ {
    add_token("FLOAT_LITERAL", insert_num(yytext, "float"));
}

    /* 
       6) TOKENS INVÁLIDOS: dígito seguido de letra (ej: 1a, 3xyz)
    */

{DIGIT}+{LETTER}({LETTER}|{DIGIT})* {
    fprintf(stderr,
        "[ERROR LEXICO] Token inválido '%s' - los identificadores no pueden comenzar con dígito\n"
        "  Línea: %d\n",
        yytext, yylineno);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

    /* 
       8) LITERALES DE TEXTO (Strings)
    */

    /*
    Triple-quoted: """..."""  y  '''...'''  (pueden ser multilinea) 
    */

\"\"\"([^"\\]|\\.|\"[^"]|\"\"[^"])*\"\"\" {
    add_token("STRING_LITERAL", insert_str(yytext));
}

\'\'\'([^'\\]|\\.|\\'[^']|\'\'[^'])*\'\'\' {
    add_token("STRING_LITERAL", insert_str(yytext));
}

    /* Strings simples válidas */
\"([^"\\\n]|\\.)*\" {
    add_token("STRING_LITERAL", insert_str(yytext));
}
\'([^'\\\n]|\\.)*\' {
    add_token("STRING_LITERAL", insert_str(yytext));
}

    /* Strings sin cerrar: llegan al fin de línea sin comilla de cierre */
\"([^"\\\n]|\\.)*\n {
    fprintf(stderr,
        "[ERROR LEXICO] String sin cerrar (comilla doble)\n"
        "  Línea: %d\n"
        "  Sugerencia: agrega '\"' al final de la cadena\n",
        yylineno - 1);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}
\'([^'\\\n]|\\.)*\n {
    fprintf(stderr,
        "[ERROR LEXICO] String sin cerrar (comilla simple)\n"
        "  Línea: %d\n"
        "  Sugerencia: agrega \"'\" al final de la cadena\n",
        yylineno - 1);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

    /* 
       9) OPERADORES COMPUESTOS (deben ir ANTES que los simples)
    */

"+="            { add_token("OP_PLUS_ASSIGN", -1); }
"-="            { add_token("OP_MINUS_ASSIGN", -1); }
"*="            { add_token("OP_STAR_ASSIGN", -1); }
"/="            { add_token("OP_SLASH_ASSIGN", -1); }

    /* 
       10) OPERADOR DE ASIGNACIÓN SIMPLE
    */

"="             { add_token("OP_ASSIGN", -1); }

    /* 
       10) OPERADORES ARITMÉTICOS
    */

"//"            { add_token("OP_DOUBLE_SLASH", -1); }
"+"             { add_token("OP_PLUS", -1); }
"-"             { add_token("OP_MINUS", -1); }
"*"             { add_token("OP_STAR", -1); }
"/"             { add_token("OP_SLASH", -1); }
"%"             { add_token("OP_MOD", -1); }

    /* 
       11) OPERADORES RELACIONALES
        */

"<="            { add_token("OP_LE", -1); }
">="            { add_token("OP_GE", -1); }
"=="            { add_token("OP_EQ", -1); }
"!="            { add_token("OP_NEQ", -1); }
"<"             { add_token("OP_LT", -1); }
">"             { add_token("OP_GT", -1); }

    /* 
       12) OPERADORES BIT A BIT
        */

"<<"            { add_token("OP_LSHIFT", -1); }
">>"            { add_token("OP_RSHIFT", -1); }
"&"             { add_token("OP_BIT_AND", -1); }
"|"             { add_token("OP_BIT_OR", -1); }
"^"             { add_token("OP_BIT_XOR", -1); }
"~"             { add_token("OP_BIT_NOT", -1); }

    /* 
       13) DELIMITADORES Y PUNTUACIÓN
        */

"->"            { add_token("ARROW", -1); }
"("             { paren_depth++; add_token("LPAREN", -1); }
")"             { paren_depth--; add_token("RPAREN", -1); }
"["             { paren_depth++; add_token("LBRACKET", -1); }
"]"             { paren_depth--; add_token("RBRACKET", -1); }
"{"             { paren_depth++; add_token("LBRACE", -1); }
"}"             { paren_depth--; add_token("RBRACE", -1); }
","             { add_token("COMMA", -1); }
":"             { add_token("COLON", -1); }
"."             { add_token("DOT", -1); }
";"             { add_token("SEMICOLON", -1); }
"@"             { add_token("AT", -1); }

    /* 
       14) FIN DE ARCHIVO
    */

<<EOF>>         {
                    while(top > 0) {
                        add_token("DEDENT", -1);
                        top--;
                    }

                    print_scanner_output();
                    print_id_table();
                    print_num_table();
                    print_str_table();
                    print_statistics();

                    return 0;
                }

    /* 
       ERROR LÉXICO
    */

.               {
    fprintf(stderr,
        "[ERROR LEXICO] Carácter inesperado '%s'\n"
        "  Línea: %d\n"
        "  Carácter ASCII: %d (0x%X)\n",
        yytext, yylineno, (unsigned char)yytext[0], (unsigned char)yytext[0]);
    stats.error_count++;
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();
    exit(EXIT_FAILURE);
}

%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    if(argc < 2){
        fprintf(stderr, "Uso: %s <archivo_de_entrada.py>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *archivo = fopen(argv[1], "r");
    if(!archivo){
        fprintf(stderr, "Error: No se pudo abrir el archivo '%s'\n", argv[1]);
        perror("fopen");
        return EXIT_FAILURE;
    }

    yyin = archivo;
    int result = yylex();

    fclose(archivo);
    free_scanner_output();
    free_symbol_tables();

    return result;
}