#!/bin/bash

# --- CONFIGURACIÓN ---
LEX_FILE="triton.l"
EXE_NAME="triton_lexer"
TEST_FILE="codigo.py"

echo "--- 1. Limpiando archivos antiguos ---"
rm -f lex.yy.c $EXE_NAME

echo "--- 2. Ejecutando Flex ---"
if flex $LEX_FILE; then
    echo "   [OK] lex.yy.c generado."
else
    echo "   [ERROR] Falló Flex."
    exit 1
fi

echo "--- 3. Compilando con GCC ---"
if gcc lex.yy.c -o $EXE_NAME; then
    echo "   [OK] Ejecutable '$EXE_NAME' creado."
else
    echo "   [ERROR] Falló la compilación."
    exit 1
fi

echo "--- 4. Ejecutando Lexer con $TEST_FILE ---"
if [ -f "$TEST_FILE" ]; then
    ./$EXE_NAME $TEST_FILE
else
    echo "   [ERROR] No se encontró el archivo $TEST_FILE"
fi