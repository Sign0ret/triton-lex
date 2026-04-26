%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASH_SIZE 256

/* =========================================================================
   1. ESTRUCTURAS DE DATOS: HASH MAPS (Tabla de Símbolos y Literales)
   ========================================================================= */
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

void insert_into_table(HashNode** table, const char* value, const char* table_name) {
    unsigned int index = hash(value);
    HashNode* curr = table[index];
    
    while(curr != NULL) {
        if(strcmp(curr->value, value) == 0) return; 
        curr = curr->next;
    }
    
    HashNode* new_node = (HashNode*)malloc(sizeof(HashNode));
    new_node->value = strdup(value);
    new_node->next = table[index];
    table[index] = new_node;
    
    printf(" [Registrado en %s: %s] ", table_name, value);
}

void print_table(HashNode** table, const char* title) {
    printf("\n--- %s ---\n", title);
    int empty = 1;
    for(int i = 0; i < HASH_SIZE; i++) {
        if(table[i] != NULL) {
            empty = 0;
            printf("Bucket %03d: ", i);
            HashNode* curr = table[i];
            while(curr != NULL) {
                printf("[%s] -> ", curr->value);
                curr = curr->next;
            }
            printf("NULL\n");
        }
    }
    if (empty) printf("La tabla está vacía.\n");
}

/* =========================================================================
   2. ESTRUCTURA DE DATOS: PILA DE INDENTACIÓN
   ========================================================================= */
#define MAX_DEPTH 100
int indent_stack[MAX_DEPTH] = {0};
int top = 0;


/* =========================================================================
   3. ESTRUCTURA DE DATOS: SCANNER OUTPUT (Double Linked List)
   ========================================================================= */
typedef struct TokenNode {
    char* token_name;
    char* lexeme;
    struct TokenNode* prev;
    struct TokenNode* next;
} TokenNode;

TokenNode* scanner_head = NULL;
TokenNode* scanner_tail = NULL;

/* Función que reemplaza los printf directos: Inserta en la DLL e imprime */
void add_token(const char* token_name, const char* lexeme) {
    // 1. Crear el nuevo nodo y enlazarlo
    TokenNode* new_node = (TokenNode*)malloc(sizeof(TokenNode));
    new_node->token_name = strdup(token_name);
    new_node->lexeme = strdup(lexeme);
    new_node->prev = scanner_tail;
    new_node->next = NULL;

    if (scanner_tail != NULL) {
        scanner_tail->next = new_node;
    } else {
        scanner_head = new_node; // Si la lista estaba vacía
    }
    scanner_tail = new_node;

    // 2. Imprimir en pantalla para feedback visual
    if (strcmp(token_name, "NEWLINE") == 0) {
        printf("\n<NEWLINE>\n");
    } else if (strcmp(token_name, "INDENT") == 0 || strcmp(token_name, "DEDENT") == 0) {
        printf("<%s> ", token_name);
    } else if (strcmp(token_name, "IDENTIFIER") == 0 || 
               strstr(token_name, "LITERAL") != NULL || 
               strcmp(token_name, "TL_IDENTIFIER") == 0) {
        printf("<%s: %s> ", token_name, lexeme);
    } else {
        printf("<%s> ", token_name);
    }
}

/* Función para imprimir el contenido de la Double Linked List al final */
void print_scanner_output() {
    TokenNode* curr = scanner_head;
    while (curr != NULL) {
        if (strlen(curr->lexeme) > 0) {
            // Formato con atributo: <token, lexema>
            printf("<%s,%s>\n", curr->token_name, curr->lexeme);
        } else {
            // Formato sin atributo: <token>
            printf("<%s>\n", curr->token_name);
        }
        curr = curr->next;
    }
}
%}

extern FILE *yyin;

DIGIT           [0-9]
LETTER          [a-zA-Z_]
HEX             [0-9a-fA-F]

%%

    /* 1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN */
[ \t]+          { /* Ignorar espacios en medio de la línea */ }

\n[ \t]*|\r\n[ \t]* { 
    add_token("NEWLINE", ""); 
    
    int current_indent = 0;
    for(int i = 0; yytext[i] != '\0'; i++) {
        if(yytext[i] == ' ') current_indent++;
        else if(yytext[i] == '\t') current_indent = (current_indent + 8) & ~7;
    }

    if (current_indent > indent_stack[top]) {
        if (top < MAX_DEPTH - 1) {
            indent_stack[++top] = current_indent;
            add_token("INDENT", "");
        } else {
            printf("[ERROR: Nivel de indentación máximo superado]");
        }
    } else if (current_indent < indent_stack[top]) {
        while (top > 0 && indent_stack[top] > current_indent) {
            top--;
            add_token("DEDENT", "");
        }
        if (indent_stack[top] != current_indent) {
            printf("[ERROR: Indentación inconsistente] ");
        }
    }
}

    /* 2) COMENTARIOS */
#.* { add_token("COMMENT", yytext); }

    /* 4) PALABRAS RESERVADAS */
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

    /* 11) TOKENS TRITON */
tl\.{LETTER}({LETTER}|{DIGIT})* { add_token("TL_IDENTIFIER", yytext); }

    /* 3) IDENTIFICADORES */
{LETTER}({LETTER}|{DIGIT})* { 
    add_token("IDENTIFIER", yytext); 
    insert_into_table(idTable, yytext, "Tabla_ID"); 
}

    /* 5) LITERALES NUMÉRICOS Y DE TEXTO */
0|[1-9]{DIGIT}*|0[xX]{HEX}+ { 
    add_token("INT_LITERAL", yytext); 
    insert_into_table(literalTable, yytext, "Tabla_Num");
}
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+ { 
    add_token("FLOAT_LITERAL", yytext); 
    insert_into_table(literalTable, yytext, "Tabla_Num");
}
\"([^"\\\n]|\\.)*\"|\'([^'\\\n]|\\.)*\' { add_token("STRING_LITERAL", yytext); }

    /* 7) OPERADORES DE ASIGNACIÓN */
"="             { add_token("OP_ASSIGN", yytext); }

    /* 6) OPERADORES ARITMÉTICOS */
"//"            { add_token("OP_DOUBLE_SLASH", yytext); }
"+"             { add_token("OP_PLUS", yytext); }
"-"             { add_token("OP_MINUS", yytext); }
"*"             { add_token("OP_STAR", yytext); }
"/"             { add_token("OP_SLASH", yytext); }
"%"             { add_token("OP_MOD", yytext); }

    /* 8) OPERADORES RELACIONALES */
"<="            { add_token("OP_LE", yytext); }
">="            { add_token("OP_GE", yytext); }
"=="            { add_token("OP_EQ", yytext); }
"!="            { add_token("OP_NEQ", yytext); }
"<"             { add_token("OP_LT", yytext); }
">"             { add_token("OP_GT", yytext); }

    /* 9) OPERADORES BIT A BIT */
"<<"            { add_token("OP_LSHIFT", yytext); }
">>"            { add_token("OP_RSHIFT", yytext); }
"&"             { add_token("OP_BIT_AND", yytext); }
"|"             { add_token("OP_BIT_OR", yytext); }
"^"             { add_token("OP_BIT_XOR", yytext); }
"~"             { add_token("OP_BIT_NOT", yytext); }

    /* 10) DELIMITADORES */
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

    /* 12) FIN DE ARCHIVO */
<<EOF>>         { 
                    while(top > 0) {
                        add_token("DEDENT", "");
                        top--;
                    }
                    
                    // Al terminar, mostramos todas las estructuras
                    print_scanner_output();
                    print_table(idTable, "TABLA DE IDENTIFICADORES");
                    print_table(literalTable, "TABLA DE LITERALES NUMERICOS");
                    return 0; 
                }

.               { printf("[ERROR LEXICO: %s]", yytext); }

%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Uso: %s <archivo_de_entrada.py>\n", argv[0]);
        return 1;
    }

    FILE *archivo = fopen(argv[1], "r");
    if (!archivo) {
        printf("Error: No se pudo abrir el archivo %s\n", argv[1]);
        return 1;
    }

    yyin = archivo;
    yylex();
    fclose(archivo);

    return 0;
}