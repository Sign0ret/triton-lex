# Gramática Libre de Contexto — Triton-DSL

**Curso:** TC3002B — Módulo 3: Compiladores  
**Fase:** Capítulo 3 — Análisis Sintáctico  
**Basado en:** output del scanner `triton.l` (Flex/C)

---

## 1. Especificación Informal

La gramática describe un subconjunto de Python orientado a kernels de GPU (estilo Triton). Las reglas en lenguaje natural son las siguientes:

### 1.1 Programa
Un **programa** es una secuencia de cero o más sentencias de alto nivel separadas por saltos de línea (`NEWLINE`).

### 1.2 Sentencias de alto nivel
Una **sentencia** puede ser:
- Una sentencia de importación (`import X` o `import X as Y`).
- Una definición de función, opcionalmente precedida de un decorador (`@nombre`).
- Una sentencia de control de flujo: `if/elif/else`, `for`, `while`.
- Una sentencia de salto: `return`, `break`, `continue`, `pass`.
- Una asignación simple (`x = expr`) o aumentada (`x += expr`, etc.).
- Una expresión sola (p. ej., una llamada a función).
- Un comentario.

### 1.3 Bloques (suite)
Un **bloque** se forma con `NEWLINE INDENT`, seguido de una o más sentencias, y cerrado con `DEDENT`. Este mecanismo refleja la indentación significativa de Python.

### 1.4 Definición de función
Una **función** comienza con `def`, seguido del nombre del identificador, una lista de parámetros entre paréntesis, opcionalmente una anotación de retorno (`-> expr`), dos puntos y un bloque. Un parámetro puede tener valor por defecto (`param = expr`) y anotación de tipo (`param : tipo`).

### 1.5 Decoradores
El único decorador válido en Triton-DSL es `@triton.jit` (con o sin argumentos). El lexer lo reconoce como token único `TRITON_JIT` mediante longest-match, antes de la regla genérica de `@`. Cualquier otro decorador llega al parser como `AT` y produce un error sintáctico inmediato.

### 1.6 Control de flujo
- **if:** `if expr : suite` seguido de cero o más cláusulas `elif expr : suite` y opcionalmente `else : suite`.
- **for:** `for IDENTIFIER in expr : suite`
- **while:** `while expr : suite`

### 1.7 Sentencias simples
- **return:** `return` opcionalmente seguido de una expresión.
- **break / continue / pass:** tokens solos.
- **Asignación:** un `primary` (identificador, acceso a atributo, subscript o llamada encadenada) seguido de `=` y una expresión. Usar un LHS `primary` evita el conflicto reduce/reduce que surgía con un no-terminal `target` independiente.
- **Asignación aumentada:** un `primary` seguido de `+=`, `-=`, `*=` o `/=` y una expresión.

### 1.8 Expresiones
Las expresiones respetan la siguiente jerarquía de **precedencia** (de menor a mayor), con la recursión izquierda que impone **asociatividad izquierda** salvo donde se indica:

| Nivel | Operadores | Asociatividad |
|-------|-----------|---------------|
| 1 | `or` | izquierda |
| 2 | `and` | izquierda |
| 3 | `not` (unario) | derecha (prefijo) |
| 4 | `==`, `!=`, `<`, `<=`, `>`, `>=`, `is`, `in` | izquierda |
| 5 | `\|` (bit OR) | izquierda |
| 6 | `^` (bit XOR) | izquierda |
| 7 | `&` (bit AND) | izquierda |
| 8 | `<<`, `>>` | izquierda |
| 9 | `+`, `-` | izquierda |
| 10 | `*`, `/`, `//`, `%` | izquierda |
| 11 | `-` (unario), `~` (bit NOT) | derecha (prefijo) |
| 12 | `.` (atributo), `[...]` (subscript/slice), `(...)` (llamada) | izquierda (postfijo) |
| 13 | Átomos: literales, identificadores, `(expr)`, `[lista]` | — |

### 1.9 Llamadas a función y acceso a atributos
Una **llamada** es un primario seguido de `( lista_de_argumentos )`. Los argumentos pueden ser posicionales o con nombre (`kw=expr`). El acceso a atributo es `primario . IDENTIFIER`. El subscript es `primario [ expr ]` o `primario [ expr : expr ]` (slice).

### 1.10 Literales y constantes
Los **átomos** incluyen: `INT_LITERAL`, `FLOAT_LITERAL`, `STRING_LITERAL`, `True`, `False`, `None`, identificadores, expresiones entre paréntesis y listas entre corchetes.

---

## 2. Especificación Formal

### 2.1 Definición de la gramática

La gramática se define como la 4-tupla:

**G = (V, T, P, S)**

---

### 2.2 Conjunto de terminales T

Los terminales son los tokens producidos por el scanner `triton.l`:

```
T = {
  -- Estructura --
  NEWLINE, INDENT, DEDENT, COMMENT,

  -- Palabras reservadas --
  KW_IMPORT, KW_AS, KW_DEF,
  KW_IF, KW_ELIF, KW_ELSE,
  KW_FOR, KW_WHILE, KW_IN,
  KW_BREAK, KW_CONTINUE, KW_RETURN, KW_PASS,
  KW_AND, KW_OR, KW_NOT, KW_IS,
  KW_TRUE, KW_FALSE, KW_NONE,

  -- Identificadores y literales --
  IDENTIFIER, INT_LITERAL, FLOAT_LITERAL, STRING_LITERAL,

  -- Operadores de asignación --
  OP_ASSIGN, OP_PLUS_ASSIGN, OP_MINUS_ASSIGN,
  OP_STAR_ASSIGN, OP_SLASH_ASSIGN,

  -- Operadores aritméticos --
  OP_PLUS, OP_MINUS, OP_STAR, OP_SLASH,
  OP_DOUBLE_SLASH, OP_MOD,

  -- Operadores relacionales --
  OP_EQ, OP_NEQ, OP_LT, OP_LE, OP_GT, OP_GE,

  -- Operadores bit a bit --
  OP_LSHIFT, OP_RSHIFT,
  OP_BIT_AND, OP_BIT_OR, OP_BIT_XOR, OP_BIT_NOT,

  -- Delimitadores --
  LPAREN, RPAREN, LBRACKET, RBRACKET, LBRACE, RBRACE,
  COMMA, COLON, DOT, SEMICOLON, AT, ARROW,

  -- Token compuesto (lexer) --
  TRITON_JIT    /* reconoce "@triton.jit" o "@tl.jit" como unidad */
}
```

---

### 2.3 Conjunto de no-terminales V

```
V = {
  program, stmt_list, stmt,
  import_stmt,
  decorated_def, decorator,
  func_def, param_list, param_tail, param, default_param,
  suite,
  if_stmt, elif_chain,
  for_stmt, while_stmt,
  simple_stmt,
  return_stmt, assign_stmt, augassign_op,
  expr_stmt,
  expr,
  or_expr, and_expr, not_expr,
  cmp_expr, cmp_op,
  bitor_expr, bitxor_expr, bitand_expr,
  shift_expr, shift_op,
  add_expr, mul_expr, mul_op,
  unary_expr,
  primary,
  atom,
  arg_list, arg_tail, argument,
  list_items, list_tail,
  dict_items, dict_pairs,
  slice,
  dotted_name, dotted_tail
}
```

---

### 2.4 Símbolo inicial S

```
S = program
```

---

### 2.5 Conjunto de producciones P

#### Programa y lista de sentencias

```
program     → stmt_list

stmt_list   → stmt NEWLINE stmt_list
            | stmt NEWLINE
            | ε
```

#### Sentencias

```
stmt        → import_stmt
            | decorated_def
            | func_def
            | if_stmt
            | for_stmt
            | while_stmt
            | simple_stmt
            | COMMENT
```

#### Importaciones

```
import_stmt → KW_IMPORT dotted_name
            | KW_IMPORT dotted_name KW_AS IDENTIFIER

dotted_name → IDENTIFIER dotted_tail

dotted_tail → DOT IDENTIFIER dotted_tail
            | ε
```

#### Decoradores y definiciones de función

```
decorated_def → decorator func_def

decorator     → TRITON_JIT NEWLINE
              | TRITON_JIT LPAREN arg_list RPAREN NEWLINE

func_def      → KW_DEF IDENTIFIER LPAREN param_list RPAREN COLON suite
              | KW_DEF IDENTIFIER LPAREN param_list RPAREN ARROW expr COLON suite

param_list    → param param_tail
              | ε

param_tail    → COMMA param param_tail
              | ε

param         → IDENTIFIER
              | IDENTIFIER COLON expr
              | default_param

default_param → IDENTIFIER OP_ASSIGN expr
              | IDENTIFIER COLON expr OP_ASSIGN expr
```

#### Bloque (suite)

```
suite         → NEWLINE INDENT stmt_list DEDENT
```

#### Sentencias de control de flujo

```
if_stmt       → KW_IF expr COLON suite elif_chain

elif_chain    → KW_ELIF expr COLON suite elif_chain
              | KW_ELSE COLON suite
              | ε

for_stmt      → KW_FOR IDENTIFIER KW_IN expr COLON suite

while_stmt    → KW_WHILE expr COLON suite
```

#### Sentencias simples

```
simple_stmt   → return_stmt
              | KW_BREAK
              | KW_CONTINUE
              | KW_PASS
              | assign_stmt
              | expr_stmt

return_stmt   → KW_RETURN expr
              | KW_RETURN

assign_stmt   → primary OP_ASSIGN expr
              | primary augassign_op expr

augassign_op  → OP_PLUS_ASSIGN
              | OP_MINUS_ASSIGN
              | OP_STAR_ASSIGN
              | OP_SLASH_ASSIGN

expr_stmt     → expr
```

---

#### Expresiones (precedencia por cascada)

> Las producciones con recursión izquierda imponen asociatividad izquierda.  
> La producción `not_expr` usa recursión derecha (prefijo).

```
expr          → expr KW_OR or_expr
              | or_expr

or_expr       → or_expr KW_AND not_expr
              | not_expr

not_expr      → KW_NOT not_expr
              | cmp_expr

cmp_expr      → cmp_expr cmp_op bitor_expr
              | bitor_expr

cmp_op        → OP_EQ
              | OP_NEQ
              | OP_LT
              | OP_LE
              | OP_GT
              | OP_GE
              | KW_IS
              | KW_IN

bitor_expr    → bitor_expr OP_BIT_OR bitxor_expr
              | bitxor_expr

bitxor_expr   → bitxor_expr OP_BIT_XOR bitand_expr
              | bitand_expr

bitand_expr   → bitand_expr OP_BIT_AND shift_expr
              | shift_expr

shift_expr    → shift_expr shift_op add_expr
              | add_expr

shift_op      → OP_LSHIFT
              | OP_RSHIFT

add_expr      → add_expr OP_PLUS mul_expr
              | add_expr OP_MINUS mul_expr
              | mul_expr

mul_expr      → mul_expr mul_op unary_expr
              | unary_expr

mul_op        → OP_STAR
              | OP_SLASH
              | OP_DOUBLE_SLASH
              | OP_MOD

unary_expr    → OP_MINUS unary_expr
              | OP_BIT_NOT unary_expr
              | primary
```

---

#### Primarios (acceso a atributo, subscript, llamada)

```
primary       → primary DOT IDENTIFIER
              | primary LBRACKET slice RBRACKET
              | primary LPAREN arg_list RPAREN
              | atom

slice         → expr COLON expr
              | expr COLON
              | COLON expr
              | expr
```

---

#### Átomos

```
atom          → IDENTIFIER
              | INT_LITERAL
              | FLOAT_LITERAL
              | STRING_LITERAL
              | KW_TRUE
              | KW_FALSE
              | KW_NONE
              | LPAREN expr RPAREN
              | LBRACKET list_items RBRACKET
              | LBRACE dict_items RBRACE
```

---

#### Listas y argumentos

```
list_items    → expr list_tail
              | ε

list_tail     → COMMA expr list_tail
              | ε

dict_items    → dict_pairs
              | ε

dict_pairs    → expr COLON expr
              | dict_pairs COMMA expr COLON expr

arg_list      → argument arg_tail
              | ε

arg_tail      → COMMA argument arg_tail
              | ε

argument      → expr
              | IDENTIFIER OP_ASSIGN expr
```

---

### 2.6 Resumen de la 4-tupla

| Componente | Descripción |
|-----------|-------------|
| **V** | 36 no-terminales (ver §2.3) |
| **T** | 52 terminales / tokens (ver §2.2) |
| **P** | Producciones listadas en §2.5 |
| **S** | `program` |

### 2.7 Observaciones sobre ambigüedad y recursión

1. **Ambigüedad eliminada:** La cascada de precedencia (`expr → or_expr → ... → primary`) garantiza un único árbol de derivación para cualquier expresión aritmética, relacional o lógica.

2. **Recursión izquierda presente:** Las producciones de `expr`, `or_expr`, `and_expr`, `cmp_expr`, `bitor_expr`, `bitxor_expr`, `bitand_expr`, `shift_expr`, `add_expr`, `mul_expr` y `primary` son **inmediatamente recursivas por la izquierda**. Esto es correcto para un parser *bottom-up* (LR). Para un parser *top-down* (LL/Recursive Descent) deberán eliminarse aplicando la transformación `A → βA'  /  A' → αA' | ε`.

3. **Dangling else:** Resuelto con la regla `elif_chain → ε`, que obliga a asociar el `else` con el `if` más cercano sin `else`. Equivalente a la regla *most-closely-nested*.

4. **Decorador restringido (`TRITON_JIT`):** El lexer reconoce `"@triton.jit"` como token único `TRITON_JIT` (longest-match, antes de la regla genérica `@`). `decorator` solo acepta `TRITON_JIT`; cualquier otro `@nombre` llega al parser como `AT` y activa el error inmediatamente.

5. **LHS de asignación (`primary`):** `assign_stmt` usa `primary` como destino en lugar del antiguo no-terminal `target` o de `expr`. Esto impide que expresiones aritméticas aparezcan como LHS (`1+2 = x` falla) sin introducir el conflicto reduce/reduce que surgía con un `target` competidor.

6. **Semicolón (`SEMICOLON`):** El token `;` produce error léxico inmediato. Triton-DSL no admite separación de sentencias con `;`; cada sentencia debe ocupar su propia línea.
