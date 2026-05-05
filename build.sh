#!/bin/bash

LEX_FILE="triton.l"
EXE_NAME="triton_lexer"
TEST_FILE="codigo.py"
CC="gcc"
CFLAGS="-Wall -Werror -g"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}BUILD: TRITON LEXER${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"

# 1. Limpiar
echo -e "${YELLOW}[1/3] Limpiando archivos antiguos...${NC}"
rm -f lex.yy.c $EXE_NAME lex.yy.o
echo -e "${GREEN}    [OK] Limpieza completada${NC}\n"

# 2. Generar código C con Flex
echo -e "${YELLOW}[2/3] Ejecutando Flex (generando lex.yy.c)...${NC}"
if flex $LEX_FILE 2>&1; then
    echo -e "${GREEN}    [OK] lex.yy.c generado correctamente${NC}\n"
else
    echo -e "${RED}    [ERROR] Falló la ejecución de Flex${NC}"
    echo -e "${RED}    Instala flex: apt-get install flex (Linux) o brew install flex (macOS)${NC}\n"
    exit 1
fi

# 3. Compilar con GCC
echo -e "${YELLOW}[3/3] Compilando con GCC...${NC}"
if $CC $CFLAGS -o $EXE_NAME lex.yy.c -lfl 2>&1; then
    echo -e "${GREEN}    [OK] Compilación exitosa${NC}\n"
else
    echo -e "${RED}    [ERROR] Falló la compilación${NC}"
    echo -e "${RED}    Verifica que tengas gcc y libfl instalados${NC}\n"
    exit 1
fi

# 4. Ejecutar test si existe
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}EJECUCIÓN: Analizando archivo de prueba${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"

if [ -f "$TEST_FILE" ]; then
    echo -e "${YELLOW}Analizando: $TEST_FILE${NC}\n"
    ./$EXE_NAME $TEST_FILE
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        echo -e "\n${GREEN}[OK] Análisis completado exitosamente${NC}\n"
    else
        echo -e "\n${YELLOW}[NOTA] El análisis terminó con código: $EXIT_CODE${NC}\n"
        echo -e "${YELLOW}Esto puede indicar errores léxicos en el archivo de prueba${NC}\n"
    fi
else
    echo -e "${YELLOW}[NOTA] Archivo de prueba '$TEST_FILE' no encontrado${NC}\n"
    echo -e "${YELLOW}Uso: ./$EXE_NAME <archivo.py>${NC}\n"
fi