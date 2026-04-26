%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASH_SIZE 256

/* --- ESTRUCTURA DE DATOS: HASH MAP CON CHAINING --- */
typedef struct HashNode {
    char* name;
    struct HashNode* next;
} HashNode;

HashNode* hashTable[HASH_SIZE] = {NULL};

unsigned int hash(const char* str) {
    unsigned long hash_val = 5381;
    int c;
    while ((c = *str++)) {
        hash_val = ((hash_val << 5) + hash_val) + c;
    }
    return hash_val % HASH_SIZE;
}

void insert_identifier(const char* name) {
    unsigned int index = hash(name);
    HashNode* curr = hashTable[index];
    
    while(curr != NULL) {
        if(strcmp(curr->name, name) == 0) return; 
        curr = curr->next;
    }
    
    HashNode* new_node = (HashNode*)malloc(sizeof(HashNode));
    new_node->name = strdup(name);
    new_node->next = hashTable[index];
    hashTable[index] = new_node;
    
    printf(" [Registrado en Hash Map: %s] ", name);
}

void print_hash_map() {
    printf("\n\n--- TABLA DE SÍMBOLOS (HASH MAP) ---\n");
    int empty = 1;
    for(int i = 0; i < HASH_SIZE; i++) {
        if(hashTable[i] != NULL) {
            empty = 0;
            printf("Bucket %03d: ", i);
            HashNode* curr = hashTable[i];
            while(curr != NULL) {
                printf("[%s] -> ", curr->name);
                curr = curr->next;
            }
            printf("NULL\n");
        }
    }
    if (empty) printf("La tabla está vacía.\n");
}

/* --- ESTRUCTURA DE DATOS: PILA DE INDENTACIÓN --- */
#define MAX_DEPTH 100
int indent_stack[MAX_DEPTH] = {0}; // Inicializamos con indentación 0
int top = 0;

%}

extern FILE *yyin;

DIGIT           [0-9]
LETTER          [a-zA-Z_]
HEX             [0-9a-fA-F]

%%

    /* 1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN (CON PILA) */
[ \t]+          { /* Ignorar espacios en medio de la línea */ }

\n[ \t]*|\r\n[ \t]* { 
    printf("\n<NEWLINE>\n"); 
    
    // Contar el nivel de indentación actual
    int current_indent = 0;
    for(int i = 0; yytext[i] != '\0'; i++) {
        if(yytext[i] == ' ') current_indent++;
        else if(yytext[i] == '\t') current_indent = (current_indent + 8) & ~7; // Tab normalizado a 8 espacios
    }

    // Lógica de Stack
    if (current_indent > indent_stack[top]) {
        // Aumentó la indentación
        if (top < MAX_DEPTH - 1) {
            indent_stack[++top] = current_indent;
            printf("<INDENT> ");
        } else {
            printf("[ERROR: Nivel de indentación máximo superado]");
        }
    } else if (current_indent < indent_stack[top]) {
        // Disminuyó la indentación (puede requerir múltiples DEDENT)
        while (top > 0 && indent_stack[top] > current_indent) {
            top--;
            printf("<DEDENT> ");
        }
        // Validar que la indentación coincida con un nivel previo
        if (indent_stack[top] != current_indent) {
            printf("[ERROR: Indentación inconsistente] ");
        }
    }
}

    /* 2) COMENTARIOS */
#.* { printf("<COMMENT>"); }

    /* 4) PALABRAS RESERVADAS */
"def"           { printf("<KW_DEF>"); }
"if"            { printf("<KW_IF>"); }
"elif"          { printf("<KW_ELIF>"); }
"else"          { printf("<KW_ELSE>"); }
"for"           { printf("<KW_FOR>"); }
"while"         { printf("<KW_WHILE>"); }
"in"            { printf("<KW_IN>"); }
"break"         { printf("<KW_BREAK>"); }
"continue"      { printf("<KW_CONTINUE>"); }
"return"        { printf("<KW_RETURN>"); }
"pass"          { printf("<KW_PASS>"); }
"and"           { printf("<KW_AND>"); }
"or"            { printf("<KW_OR>"); }
"not"           { printf("<KW_NOT>"); }
"is"            { printf("<KW_IS>"); }
"True"          { printf("<KW_TRUE>"); }
"False"         { printf("<KW_FALSE>"); }
"None"          { printf("<KW_NONE>"); }

    /* 11) TOKENS TRITON */
tl\.{LETTER}({LETTER}|{DIGIT})* { printf("<TL_IDENTIFIER: %s>", yytext); }

    /* 3) IDENTIFICADORES */
{LETTER}({LETTER}|{DIGIT})* { 
    printf("<IDENTIFIER: %s>", yytext); 
    insert_identifier(yytext); 
}

    /* 5) LITERALES */
0|[1-9]{DIGIT}*|0[xX]{HEX}+                                     { printf("<INT_LITERAL: %s>", yytext); }
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+   { printf("<FLOAT_LITERAL: %s>", yytext); }
\"([^"\\\n]|\\.)*\"|\'([^'\\\n]|\\.)*\'                         { printf("<STRING_LITERAL>"); }

    /* 7) OPERADORES DE ASIGNACIÓN (Reducido a "=") */
"="             { printf("<OP_ASSIGN>"); }

    /* 6) OPERADORES ARITMÉTICOS */
"//"            { printf("<OP_DOUBLE_SLASH>"); }
"+"             { printf("<OP_PLUS>"); }
"-"             { printf("<OP_MINUS>"); }
"*"             { printf("<OP_STAR>"); }
"/"             { printf("<OP_SLASH>"); }
"%"             { printf("<OP_MOD>"); }

    /* 8) OPERADORES RELACIONALES */
"<="            { printf("<OP_LE>"); }
">="            { printf("<OP_GE>"); }
"=="            { printf("<OP_EQ>"); }
"!="            { printf("<OP_NEQ>"); }
"<"             { printf("<OP_LT>"); }
">"             { printf("<OP_GT>"); }

    /* 9) OPERADORES BIT A BIT */
"<<"            { printf("<OP_LSHIFT>"); }
">>"            { printf("<OP_RSHIFT>"); }
"&"             { printf("<OP_BIT_AND>"); }
"|"             { printf("<OP_BIT_OR>"); }
"^"             { printf("<OP_BIT_XOR>"); }
"~"             { printf("<OP_BIT_NOT>"); }

    /* 10) DELIMITADORES */
"->"            { printf("<ARROW>"); }
"("             { printf("<LPAREN>"); }
")"             { printf("<RPAREN>"); }
"["             { printf("<LBRACKET>"); }
"]"             { printf("<RBRACKET>"); }
"{"             { printf("<LBRACE>"); }
"}"             { printf("<RBRACE>"); }
","             { printf("<COMMA>"); }
":"             { printf("<COLON>"); }
"."             { printf("<DOT>"); }
";"             { printf("<SEMICOLON>"); }
"@"             { printf("<AT>"); }

    /* 12) FIN DE ARCHIVO */
<<EOF>>         { 
                    // Limpiar la pila de indentación generando los DEDENT faltantes
                    while(top > 0) {
                        printf("\n<DEDENT> (EOF)");
                        top--;
                    }
                    print_hash_map();
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