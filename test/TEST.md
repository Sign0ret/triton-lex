# Documentación de Tests — Triton Lexer

## Resumen

La suite de pruebas cubre el **100%** de las reglas gramaticales y el **100%** de las rutas de error definidas en `triton.l`.

- **Archivos base**: Tokens válidos (deben terminar con código 0)
- **err_*.py**: Errores léxicos (deben terminar con código ≠ 0)

---

## Parte 1: Cobertura de Gramática (Tokens Válidos)

| Archivo | Descripción | Tokens Cubiertos |
|---------|-------------|------------------|
| `basico.py` | Identificadores, imports, decorador, literales numéricos, arrow | `COMMENT`, `KW_IMPORT`, `KW_AS`, `KW_DEF`, `IDENTIFIER`, `AT`, `ARROW`, `DOT`, `COMMA`, `COLON`, `LPAREN`, `RPAREN`, `OP_ASSIGN`, `OP_STAR`, `INT_LITERAL`, `FLOAT_LITERAL`, `NEWLINE`, `INDENT`, `DEDENT` |
| `operadores_strings.py` | Operadores, condicionales, todas las variantes de strings (incluyendo escapes) | `KW_IF`, `KW_ELIF`, `KW_ELSE`, `KW_RETURN`, `KW_PASS`, `KW_AND`, `KW_NOT`, `KW_NONE`, `KW_FALSE`, `OP_PLUS_ASSIGN`, `OP_DOUBLE_SLASH`, `OP_PLUS`, `OP_MOD`, `OP_LE`, `OP_NEQ`, `STRING_LITERAL` (simples, dobles, triples, con escapes `\n`, `\"`) |
| `indent_paren.py` | Indentación multinivel, continuación implícita en paréntesis | `KW_FOR`, `KW_IN`, `KW_IF`, `KW_TRUE`, `OP_LSHIFT`, `OP_RSHIFT`, `OP_BIT_AND`, `OP_ASSIGN`, `OP_PLUS` |
| `tokens_restantes.py` | Bucles, colecciones, operadores y delimitadores restantes | `KW_WHILE`, `KW_OR`, `KW_BREAK`, `KW_CONTINUE`, `KW_IS`, `OP_MINUS`, `OP_SLASH`, `OP_MINUS_ASSIGN`, `OP_STAR_ASSIGN`, `OP_SLASH_ASSIGN`, `OP_GE`, `OP_EQ`, `OP_GT`, `OP_LT`, `OP_BIT_OR`, `OP_BIT_XOR`, `OP_BIT_NOT`, `LBRACKET`, `RBRACKET`, `LBRACE`, `RBRACE`, `SEMICOLON` |
| `numericos_completos.py` | Todas las variantes de literales flotantes | `FLOAT_LITERAL` (`.5`, `5.e10`, `1e10`, `2E+3`, `3.14`, `0.0`), `INT_LITERAL` |
| `continuacion_implicita.py` | Continuación implícita en listas y diccionarios | `LBRACKET`, `RBRACKET`, `LBRACE`, `RBRACE`, `COMMA`, `COLON`, `STRING_LITERAL`, `INT_LITERAL` (newlines dentro de `[]`/`{}` ignorados por `paren_depth`) |

**Total tokens cubiertos: 100%** ✅

---

## Parte 2: Cobertura de Errores Léxicos

| Archivo | Error que dispara |
|---------|-------------------|
| `err_token_invalido.py` | Identificador que inicia con dígito (`1abc`) |
| `err_hex_prefix.py` | Prefijo hexadecimal sin dígitos (`0x`) |
| `err_bin_prefix.py` | Prefijo binario sin dígitos (`0b`) |
| `err_oct_prefix.py` | Prefijo octal sin dígitos (`0o`) |
| `err_float_exp.py` | Exponente de float incompleto (`1.5e`) |
| `err_float_exp_signo.py` | Exponente con signo pero sin dígitos (`1.5e+`) |
| `err_float_dot_e.py` | Punto + `e` sin dígitos después (`1.e`) |
| `err_string_doble.py` | String sin cerrar con comilla doble |
| `err_string_simple.py` | String sin cerrar con comilla simple |
| `err_caracter.py` | Carácter inesperado (`$`) |

**Total errores cubiertos: 100%** ✅

---

## Cómo ejecutar

```bash
chmod +x test.sh
./test.sh
```
