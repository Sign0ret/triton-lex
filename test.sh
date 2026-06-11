#!/bin/bash

# ═════════════════════════════════════════════════════════════════════════════
# TEST SCRIPT - TRITON PARSER  (Flex + Bison)
# ═════════════════════════════════════════════════════════════════════════════

LEX_FILE="triton.l"
YACC_FILE="triton.y"
EXE_NAME="triton_parser"
TEST_DIR="test"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} INICIANDO COMPILACIÓN Y PRUEBAS DEL PARSER${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"

# ── FASE 1: COMPILACIÓN ──────────────────────────────────────────────────────
echo -e "${YELLOW}[Fase 1] Compilando analizador léxico + sintáctico...${NC}"

rm -f triton.tab.c triton.tab.h lex.yy.c $EXE_NAME

if bison -d $YACC_FILE 2>&1; then
    echo -e "  ${GREEN}✓ Bison generó triton.tab.c / triton.tab.h${NC}"
else
    echo -e "  ${RED}✗ Error al ejecutar Bison${NC}"; exit 1
fi

if flex $LEX_FILE 2>&1; then
    echo -e "  ${GREEN}✓ Flex generó lex.yy.c${NC}"
else
    echo -e "  ${RED}✗ Error al ejecutar Flex${NC}"; exit 1
fi

if gcc -Wall -g -o $EXE_NAME triton.tab.c lex.yy.c -lfl 2>&1; then
    echo -e "  ${GREEN}✓ GCC compiló '$EXE_NAME' correctamente${NC}\n"
else
    echo -e "  ${RED}✗ Error durante la compilación${NC}"; exit 1
fi

# ── FASE 2: TESTING ───────────────────────────────────────────────────────────
echo -e "${YELLOW}[Fase 2] Ejecutando suite de pruebas...${NC}\n"

FILES=$(ls $TEST_DIR/*.py 2>/dev/null)
if [ -z "$FILES" ]; then
    echo -e "${RED}Error: No se encontraron archivos .py en $TEST_DIR/${NC}"; exit 1
fi

PASS=0; FAIL=0

for TEST_FILE in $FILES; do
    FILENAME=$(basename "$TEST_FILE")

    echo -e "${CYAN}▶ Analizando: $FILENAME${NC}"
    echo "------------------------------------------------------------"

    ./$EXE_NAME "$TEST_FILE"
    EXIT_CODE=$?

    echo "------------------------------------------------------------"

    if [[ "$FILENAME" == err_* ]]; then
        # Se espera error (léxico o sintáctico)
        if [ $EXIT_CODE -ne 0 ]; then
            echo -e "${GREEN}  [PASS] Error detectado correctamente (código $EXIT_CODE).${NC}\n"
            PASS=$((PASS+1))
        else
            echo -e "${RED}  [FAIL] Se esperaba un error pero el análisis fue exitoso.${NC}\n"
            FAIL=$((FAIL+1))
        fi
    else
        # Se espera éxito léxico Y sintáctico
        if [ $EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}  [PASS] Análisis completado sin errores.${NC}\n"
            PASS=$((PASS+1))
        else
            echo -e "${RED}  [FAIL] Error inesperado (código $EXIT_CODE).${NC}\n"
            FAIL=$((FAIL+1))
        fi
    fi
done

echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} RESULTADOS: ${GREEN}$PASS PASS${NC} / ${RED}$FAIL FAIL${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"
