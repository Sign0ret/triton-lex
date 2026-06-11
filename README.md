# Compilador Triton-DSL — Fases I y II

Este proyecto implementa las dos primeras fases de un compilador para un subconjunto del lenguaje **Triton GPU Kernel** (sintaxis Python-like con decoradores `@triton.jit`):

- **Fase I — Analizador Léxico (Scanner):** `triton.l` compilado con Flex
- **Fase II — Analizador Sintáctico (Parser):** `triton.y` compilado con Bison

---

## Arquitectura general

```
archivo.py
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│  SCANNER  (triton.l / lex.yy.c)                            │
│                                                             │
│  • Tokeniza el código fuente                               │
│  • Gestiona INDENT / DEDENT                                │
│  • Llena las tablas de símbolos (IDs, números, strings)    │
└───────────────────────────┬─────────────────────────────────┘
                            │ stream de tokens + yylval.entry
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  PARSER  (triton.y / triton.tab.c)                         │
│                                                             │
│  • Valida la gramática CFG de Triton-DSL                   │
│  • Ejecuta acciones semánticas en cada reducción           │
│  • Actualiza el campo "role" en la tabla de identificadores│
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
              Salida: Scanner Output + Symbol Tables
                      + resultado sintáctico
```

---

## Fase I — Analizador Léxico (`triton.l`)

### Responsabilidades

El scanner tokeniza el código fuente y resuelve tres problemas específicos del lenguaje:

**1. Indentación significativa (estilo Python)**
Triton-DSL usa indentación para delimitar bloques. El lexer mantiene una **pila de indentación** (`indent_stack[]`) y emite los tokens `INDENT` y `DEDENT` automáticamente al detectar cambios de nivel. Para ello usa una cola de tokens (`tok_queue[]`) que permite encolar varios tokens (p.ej. `NEWLINE` + `DEDENT` + `DEDENT`) desde una sola regla Flex.

**2. Continuación implícita de línea**
Dentro de `()`, `[]` o `{}`, los saltos de línea no son significativos. El contador `paren_depth` deshabilita la emisión de `NEWLINE`/`INDENT`/`DEDENT` mientras haya paréntesis abiertos.

**3. Decoradores Triton**
`@triton.jit` y `@tl.jit` se reconocen como el token único `TRITON_JIT`, aprovechando que Flex aplica longest-match. Cualquier otro `@` queda como `AT` y provocará error en el parser.

### Tablas de símbolos (listas enlazadas)

| Tabla | Nodo | Campos |
|-------|------|--------|
| Identificadores | `IDNode` | `entry`, `lexeme`, `role` |
| Números | `NumNode` | `entry`, `lexeme`, `type` (`"int"` / `"float"`) |
| Strings | `StrNode` | `entry`, `lexeme` |

Todas usan inserción por cabeza con búsqueda de duplicados, garantizando que cada lexema aparece una sola vez. El campo `entry` es el índice que se pasa al parser vía `yylval.entry`.

El campo **`role`** de `IDNode` se inicializa como `"identificador"` en el lexer y es **actualizado por el parser** al reconocer el rol semántico del identificador dentro del programa (ver Fase II).

### Errores léxicos detectados

| Patrón | Error |
|--------|-------|
| `0x` sin dígitos hex | Prefijo hexadecimal inválido |
| `0b` sin dígitos binarios | Prefijo binario inválido |
| `0o` sin dígitos octales | Prefijo octal inválido |
| `1.2e` sin exponente | Exponente de float incompleto |
| `3abc` | Token inválido (dígito + letra) |
| `"texto\n` sin cerrar | String sin terminar |
| Cualquier otro carácter | Carácter no reconocido |

Todos los errores léxicos son **fatales**: el scanner imprime las tablas del estado actual y termina.

---

## Fase II — Analizador Sintáctico (`triton.y`)

### Responsabilidades

El parser recibe el stream de tokens del scanner y cumple dos objetivos:

1. **Validación sintáctica:** verifica que el programa sigue la gramática CFG de Triton-DSL, reportando errores detallados con número de línea, columna y token problemático.
2. **Actualización semántica de la tabla de símbolos:** mediante acciones en las reglas yacc, actualiza el campo `role` de los identificadores según su uso en el programa.

### Gramática (CFG)

La gramática es LALR(1), generada sin ambigüedades gracias a las declaraciones `%left`/`%right` de precedencia de operadores. Los puntos clave del diseño son:

- `stmt_list` distingue sentencias simples (terminan en `NEWLINE`) de compuestas (terminan en `DEDENT`), y acepta líneas en blanco.
- `primary` se usa como LHS de asignación en lugar de una categoría `target` separada. Esto evita conflictos reduce/reduce cuando `IDENTIFIER DOT IDENTIFIER` compite entre varias reglas con lookahead `(`.
- `elif_chain → ε` resuelve el *dangling-else* dejando que Bison aplique shift por defecto (asocia el `else` con el `if` más cercano).
- `subscript` cubre `a[i]`, `a[i:j]`, `a[i:]`, `a[:j]` y `a[:]`.

### Acciones semánticas y actualización de tablas

Cada vez que el parser reduce una regla relevante, llama a `update_id_role(entry, rol)`, que busca el `IDNode` por `entry` y actualiza su campo `role`.

| Regla yacc | Rol asignado | Ejemplo |
|------------|-------------|---------|
| `func_def → def ID (...)` | `"funcion"` | `def matmul_kernel(...)` |
| `param → ID` / `ID: T` / `ID=v` | `"parametro"` | `(A, B, stride: int = 1)` |
| `for_stmt → for ID in expr` | `"variable_ciclo"` | `for i in range(n):` |
| `primary OP_ASSIGN expr` | `"variable"` | `acc = tl.zeros(...)` |
| `primary OP_X_ASSIGN expr` | `"variable"` | `acc += a * b` |
| `import mod as ID` | `"alias_modulo"` | `import triton.language as tl` |
| `dotted_name → ID` | `"modulo"` | `import triton` |

#### Propagación del `entry` en `primary` y `atom`

Para que las acciones de asignación puedan identificar el LHS, `primary` y `atom` están declarados con `%type <entry>`. La regla es simple:

- Si el primario es un **identificador simple** (`atom → IDENTIFIER`), se propaga su `entry`.
- Si es un primario **compuesto** (`x.attr`, `a[i]`, `f(...)`), se propaga **−1** como centinela.

En la acción de asignación se verifica: `if ($1 >= 0) update_id_role($1, "variable")`. Si el LHS es compuesto (p.ej. `x.y = 1`) no hay un único identificador raíz que actualizar, lo cual es correcto.

### Errores sintácticos

El parser usa `%define parse.error verbose` para que Bison genere mensajes del tipo:
```
syntax error, unexpected TOKEN, expecting X or Y
```
Además, cada construcción importante tiene una rama `error` con mensaje descriptivo en español que indica la regla rota y una sugerencia de corrección. Todos los errores sintácticos llaman a `YYABORT`, que detiene el análisis inmediatamente.

---

## Compilación y ejecución

### Requisitos

- `flex`
- `bison`
- `gcc`

### Build completo

```bash
chmod +x build.sh
./build.sh
```

Esto ejecuta en orden: `bison`, `flex`, `gcc` y deja el ejecutable `triton_parser`.

### Uso

```bash
./triton_parser archivo.py
```

### Salida

1. **Errores léxicos o sintácticos** (si los hay) en `stderr`
2. **Scanner output:** lista de tokens `<TOKEN,entry>` o `<TOKEN>` en `stdout`
3. **Symbol Table: Identifiers** — lexema + rol semántico
4. **Symbol Table: Numbers** — lexema + tipo (`int`/`float`)
5. **Symbol Table: Strings** — lexema
6. **Estadísticas del lexer**
7. **Resultado del análisis sintáctico:** `[OK]` o `[ERROR]`

---

## Suite de pruebas

```bash
chmod +x test.sh
./test.sh
```

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `valid_kernel.py` | ✅ Válido | Kernel Triton completo bien formado |
| `err_bin_prefix.py` | ❌ Léxico | Prefijo binario sin dígitos (`0b`) |
| `err_caracter.py` | ❌ Léxico | Carácter inválido no reconocido |
| `err_float_dot_e.py` | ❌ Léxico | Float con punto y exponente mal formado |
| `err_float_exp_signo.py` | ❌ Léxico | Exponente con signo pero sin dígitos |
| `err_float_exp.py` | ❌ Léxico | Exponente incompleto |
| `err_hex_prefix.py` | ❌ Léxico | Prefijo hexadecimal sin dígitos (`0x`) |
| `err_oct_prefix.py` | ❌ Léxico | Prefijo octal sin dígitos (`0o`) |
| `err_string_doble.py` | ❌ Léxico | String con comillas dobles sin cerrar |
| `err_string_simple.py` | ❌ Léxico | String con comillas simples sin cerrar |
| `err_token_invalido.py` | ❌ Léxico | Token que comienza con dígito (`3abc`) |
| `err_syn_def_no_colon.py` | ❌ Sintáctico | `def` sin `:` al final |
| `err_syn_for_no_in.py` | ❌ Sintáctico | `for` sin `in` |
| `err_syn_if_no_colon.py` | ❌ Sintáctico | `if` sin `:` |
| `err_syn_no_indent.py` | ❌ Sintáctico | Bloque sin indentar |

---

## Estructura del proyecto

```
triton-lex/
├── triton.l          # Especificación Flex (lexer)
├── triton.y          # Especificación Bison (parser + acciones semánticas)
├── triton.h          # Declaraciones compartidas entre lexer y parser
├── build.sh          # Script de compilación
├── test.sh           # Suite de pruebas automatizada
├── cfg_triton_dsl.md # Documentación de la CFG
└── test/             # Archivos de prueba (.py)
```
