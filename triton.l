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

/* Arreglo de punteros a HashNode (nuestro mapa) */
HashNode* hashTable[HASH_SIZE] = {NULL};

/* Función Hash (djb2 de Dan Bernstein) */
unsigned int hash(const char* str) {
    unsigned long hash_val = 5381;
    int c;
    while ((c = *str++)) {
        hash_val = ((hash_val << 5) + hash_val) + c; /* hash_val * 33 + c */
    }
    return hash_val % HASH_SIZE;
}

/* Función para insertar en el Hash Map */
void insert_identifier(const char* name) {
    unsigned int index = hash(name);
    HashNode* curr = hashTable[index];
    
    /* 1. Comprobar si ya existe en la cubeta (evitar duplicados) */
    while(curr != NULL) {
        if(strcmp(curr->name, name) == 0) return; 
        curr = curr->next;
    }
    
    /* 2. No existe, creamos el nodo y lo insertamos al inicio de la lista de esa cubeta */
    HashNode* new_node = (HashNode*)malloc(sizeof(HashNode));
    new_node->name = strdup(name);
    new_node->next = hashTable[index];
    hashTable[index] = new_node;
    
    printf(" [Registrado en Hash Map (Bucket %d): %s] ", index, name);
}

/* Función para imprimir el contenido al finalizar */
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
%}

/* Declaración para que el compilador de C reconozca yyin */
extern FILE *yyin;

/* Definiciones auxiliares */
DIGIT           [0-9]
LETTER          [a-zA-Z_]
HEX             [0-9a-fA-F]

%%

    /* 1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN */
[ \t]+          { /* Ignorar */ }
\n|\r\n         { printf("\n<NEWLINE>\n"); }

    /* 2) COMENTARIOS */
#.* { printf("<COMMENT>"); }

    /* 4) PALABRAS RESERVADAS (Keywords y booleanos) */
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

    /* 11) TOKENS ESPECÍFICOS DE TRITON (Namespace) */
tl\.{LETTER}({LETTER}|{DIGIT})* { printf("<TL_IDENTIFIER: %s>", yytext); }

    /* 3) IDENTIFICADORES (Registro en el Hash Map) */
{LETTER}({LETTER}|{DIGIT})* { 
    printf("<IDENTIFIER: %s>", yytext); 
    insert_identifier(yytext); 
}

    /* 5) LITERALES (NUMÉRICOS Y DE TEXTO) */
0|[1-9]{DIGIT}*|0[xX]{HEX}+                                     { printf("<INT_LITERAL: %s>", yytext); }
({DIGIT}*\.{DIGIT}+|{DIGIT}+\.)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+   { printf("<FLOAT_LITERAL: %s>", yytext); }
\"([^"\\\n]|\\.)*\"|\'([^'\\\n]|\\.)*\'                         { printf("<STRING_LITERAL>"); }

    /* 7) OPERADORES DE ASIGNACIÓN */
"="             { printf("<OP_ASSIGN>"); }

    /* 6) OPERADORES ARITMÉTICOS */
"//"            { printf("<OP_DOUBLE_SLASH>"); }
"+"             { printf("<OP_PLUS>"); }
"-"             { printf("<OP_MINUS>"); }
"*"             { printf("<OP_STAR>"); }
"/"             { printf("<OP_SLASH>"); }
"%"             { printf("<OP_MOD>"); }

    /* 8) OPERADORES RELACIONALES (COMPARACIÓN) */
"<="            { printf("<OP_LE>"); }
">="            { printf("<OP_GE>"); }
"=="            { printf("<OP_EQ>"); }
"!="            { printf("<OP_NEQ>"); }
"<"             { printf("<OP_LT>"); }
">"             { printf("<OP_GT>"); }

    /* 9) OPERADORES BIT A BIT (BITWISE) */
"<<"            { printf("<OP_LSHIFT>"); }
">>"            { printf("<OP_RSHIFT>"); }
"&"             { printf("<OP_BIT_AND>"); }
"|"             { printf("<OP_BIT_OR>"); }
"^"             { printf("<OP_BIT_XOR>"); }
"~"             { printf("<OP_BIT_NOT>"); }

    /* 10) DELIMITADORES Y PUNTUACIÓN */
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
                    print_hash_map();
                    return 0; 
                }

.               { printf("[ERROR LEXICO: %s]", yytext); }

%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    // 1. Verificar que se haya pasado un archivo como argumento
    if (argc < 2) {
        printf("Uso: %s <archivo_de_entrada.py>\n", argv[0]);
        return 1;
    }

    // 2. Intentar abrir el archivo en modo lectura
    FILE *archivo = fopen(argv[1], "r");
    if (!archivo) {
        printf("Error: No se pudo abrir el archivo %s\n", argv[1]);
        return 1;
    }

    // 3. Asignar el archivo a yyin para que Flex lo lea
    yyin = archivo;

    // 4. Ejecutar el análisis léxico
    yylex();

    // 5. Cerrar el archivo
    fclose(archivo);

    return 0;
}