# Analizador Léxico Triton-DSL

Este proyecto es un **Lexer** robusto desarrollado en Flex y C. Está diseñado para procesar lenguajes con sintaxis basada en espacios significativos (estilo Python) y tokens específicos para kernels de GPU (estilo Triton).

## 🚀 Funcionalidades Clave

- **Indentación Automática:** Implementa la lógica de Python para generar tokens `<INDENT>` y `<DEDENT>` mediante una pila de estados.
- **Tabla de Símbolos Inteligente:** Utiliza listas enlazadas para evitar la duplicidad de identificadores y literales.
- **Flujo de Tokens Persistente:** Los tokens no solo se imprimen, se guardan en una Lista Enlazada Simple para ser consumidos por un Parser.
- **Soporte Triton:** Reconocimiento especializado de namespaces `tl.*`.

## 🏗️ Estructuras de Datos

1. **Tablas de Símbolos (Listas Enlazadas):** Tres tablas independientes para identificadores, literales numéricos y literales de texto. Cada una es una lista enlazada simple con inserción por cabeza para evitar duplicados.
2. **Scanner Output (Lista Enlazada Simple):** Almacena el flujo de tokens generado en una lista enlazada simple con punteros a cabeza y cola para inserción O(1).
3. **Pila de Indentación:** Un arreglo LIFO que rastrea los niveles de espacios en blanco para generar los tokens `<INDENT>` y `<DEDENT>`, más un contador `paren_depth` para manejar la continuación implícita de línea dentro de paréntesis, corchetes y llaves.

## 🛠️ Compilación y Ejecución

Asegúrate de tener instalados `flex` y `gcc`.

### Build & Run
Si deseas limpiar, compilar y ejecutar todo en un solo paso:
```bash
chmod +x build.sh
./build.sh
```

### Ejecución de Tests
Para compilar y ejecutar la suite completa de pruebas:
```bash
chmod +x test.sh
./test.sh
```

## 🧪 Suite de Pruebas

| Archivo | Tipo | Descripción |
|---|---|---|
| `err_bin_prefix.py` | ❌ Error | Prefijo binario sin dígitos (`0b`) |
| `err_caracter.py` | ❌ Error | Carácter inválido no reconocido |
| `err_float_dot_e.py` | ❌ Error | Float con punto y exponente mal formado |
| `err_float_exp_signo.py` | ❌ Error | Exponente con signo pero sin dígitos |
| `err_float_exp.py` | ❌ Error | Exponente incompleto |
| `err_hex_prefix.py` | ❌ Error | Prefijo hexadecimal sin dígitos (`0x`) |
| `err_oct_prefix.py` | ❌ Error | Prefijo octal sin dígitos (`0o`) |
| `err_string_doble.py` | ❌ Error | String con comillas dobles sin cerrar |
| `err_string_simple.py` | ❌ Error | String con comillas simples sin cerrar |
| `err_token_invalido.py` | ❌ Error | Identificador que comienza con dígito |
