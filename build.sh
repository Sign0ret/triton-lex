#!/bin/bash

# ═════════════════════════════════════════════════════════════════════════════
# BUILD: TRITON PARSER  (Flex + Bison)
# ═════════════════════════════════════════════════════════════════════════════

LEX_FILE="triton.l"
YACC_FILE="triton.y"
EXE_NAME="triton_parser"
TEST_FILE="codigo.py"
CC="gcc"
CFLAGS="-Wall -g"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}BUILD: TRITON PARSER${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"

# ── 1. Limpiar ──────────────────────────────────────────────────────────────
echo -e "${YELLOW}[1/4] Limpiando archivos anteriores...${NC}"
rm -f lex.yy.c triton.tab.c triton.tab.h $EXE_NAME
echo -e "${GREEN}    [OK]${NC}\n"

# ── 2. Bison: genera triton.tab.c y triton.tab.h ───────────────────────────
echo -e "${YELLOW}[2/4] Ejecutando Bison (generando triton.tab.c / triton.tab.h)...${NC}"
if bison -d $YACC_FILE 2>&1; then
    echo -e "${GREEN}    [OK] triton.tab.c y triton.tab.h generados${NC}\n"
else
    echo -e "${RED}    [ERROR] Falló Bison${NC}"
    echo -e "${RED}    Instala bison: apt-get install bison  (Linux)${NC}"
    echo -e "${RED}                  brew install bison      (macOS)${NC}\n"
    exit 1
fi

# ── 3. Flex: genera lex.yy.c ────────────────────────────────────────────────
echo -e "${YELLOW}[3/4] Ejecutando Flex (generando lex.yy.c)...${NC}"
if flex $LEX_FILE 2>&1; then
    echo -e "${GREEN}    [OK] lex.yy.c generado${NC}\n"
else
    echo -e "${RED}    [ERROR] Falló Flex${NC}"
    echo -e "${RED}    Instala flex: apt-get install flex  (Linux)${NC}"
    echo -e "${RED}                 brew install flex      (macOS)${NC}\n"
    exit 1
fi

# ── 4. GCC: compila y enlaza ─────────────────────────────────────────────────
echo -e "${YELLOW}[4/4] Compilando con GCC...${NC}"
if $CC $CFLAGS -o $EXE_NAME triton.tab.c lex.yy.c -lfl 2>&1; then
    echo -e "${GREEN}    [OK] Ejecutable '$EXE_NAME' listo${NC}\n"
else
    echo -e "${RED}    [ERROR] Falló la compilación${NC}\n"
    exit 1
fi

# ── Ejecutar sobre el archivo de prueba ─────────────────────────────────────
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}EJECUCIÓN: Analizando '$TEST_FILE'${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"

if [ -f "$TEST_FILE" ]; then
    ./$EXE_NAME $TEST_FILE
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}[OK] Análisis completado exitosamente${NC}\n"
    else
        echo -e "${YELLOW}[NOTA] El análisis terminó con código: $EXIT_CODE${NC}\n"
    fi
else
    echo -e "${YELLOW}[NOTA] '$TEST_FILE' no encontrado.  Uso: ./$EXE_NAME <archivo.py>${NC}\n"
fi
