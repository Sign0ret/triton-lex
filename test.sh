#!/bin/bash

# ═════════════════════════════════════════════════════════════════════════════
# TEST SCRIPT - TRITON LEXER
# ═════════════════════════════════════════════════════════════════════════════

LEX_FILE="triton.l"
EXE_NAME="triton_lexer"

# Directorio de tests
TEST_DIR="test"

# Configuración de colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} INICIANDO COMPILACIÓN Y PRUEBAS DEL LEXER${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"

# --- FASE 1: COMPILACIÓN ---
echo -e "${YELLOW}[Fase 1] Compilando analizador léxico...${NC}"

if flex $LEX_FILE; then
    echo -e "  ${GREEN}✓ Flex generó lex.yy.c correctamente${NC}"
else
    echo -e "  ${RED}✗ Error al ejecutar Flex${NC}"
    exit 1
fi

if gcc -Wall -g -o $EXE_NAME lex.yy.c; then
    echo -e "  ${GREEN}✓ GCC compiló el ejecutable '$EXE_NAME'${NC}\n"
else
    echo -e "  ${RED}✗ Error durante la compilación con GCC${NC}"
    exit 1
fi

# --- FASE 2: TESTING ---
echo -e "${YELLOW}[Fase 2] Ejecutando suite de pruebas...${NC}\n"

# Obtener todos los archivos .py en el directorio de test
FILES=$(ls $TEST_DIR/*.py 2>/dev/null)

if [ -z "$FILES" ]; then
    echo -e "${RED}Error: No se encontraron archivos .py en $TEST_DIR/${NC}"
    exit 1
fi

for TEST_FILE in $FILES; do
    FILENAME=$(basename "$TEST_FILE")
    
    echo -e "${CYAN}▶ Analizando: $FILENAME${NC}"
    echo "------------------------------------------------------------"
    
    # Ejecutar lexer
    ./$EXE_NAME "$TEST_FILE"
    EXIT_CODE=$?
    
    echo "------------------------------------------------------------"
    
    # Determinar si es un test de error por el prefijo 'err_'
    if [[ "$FILENAME" == err_* ]]; then
        if [ $EXIT_CODE -ne 0 ]; then
            echo -e "${GREEN}  [PASS] Error detectado correctamente (Código $EXIT_CODE).${NC}\n"
        else
            echo -e "${RED}  [FAIL] Se esperaba un error pero el análisis fue exitoso.${NC}\n"
        fi
    else
        if [ $EXIT_CODE -eq 0 ]; then
            echo -e "${GREEN}  [PASS] Análisis completado sin errores.${NC}\n"
        else
            echo -e "${RED}  [FAIL] Error inesperado en el análisis (Código $EXIT_CODE).${NC}\n"
        fi
    fi
done

echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} PRUEBAS FINALIZADAS${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"