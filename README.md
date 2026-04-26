# Analizador Léxico Triton-DSL

Este proyecto es un **Lexer** robusto desarrollado en Flex y C. Está diseñado para procesar lenguajes con sintaxis basada en espacios significativos (estilo Python) y tokens específicos para kernels de GPU (estilo Triton).

## 🚀 Funcionalidades Clave

- **Indentación Automática:** Implementa la lógica de Python para generar tokens `<INDENT>` y `<DEDENT>` mediante una pila de estados.
- **Tabla de Símbolos Inteligente:** Utiliza un Hash Map para evitar la duplicidad de identificadores y literales.
- **Flujo de Tokens Persistente:** Los tokens no solo se imprimen, se guardan en una Lista Doblemente Enlazada (DLL) para ser consumidos por un Parser.
- **Soporte Triton:** Reconocimiento especializado de namespaces `tl.*`.

## 🏗️ Estructuras de Datos

1.  **Hash Map (Chaining):** Dos tablas independientes (Símbolos y Literales) que utilizan el algoritmo de hash `djb2`. Las colisiones se resuelven mediante listas enlazadas.
2.  **Double Linked List (DLL):** Estructura que almacena el `scanner_output`. Permite un recorrido bidireccional de los tokens, facilitando el análisis sintáctico futuro.
3.  **Pila (Stack):** Un arreglo LIFO que rastrea los niveles de espacios en blanco (indentación) para manejar bloques anidados de código.



## 🛠️ Compilación y Ejecución

Asegúrate de tener instalados `flex` y `gcc`.

### Opción 2: Construcción Por Pasos
Si deseas limpiar, compilar y ejecutar todo en un solo paso:
```bash
chmod +x build.sh
./build.sh

### Construcción Rápida (Build & Run)
Si deseas limpiar, compilar y ejecutar todo en un solo paso:
```bash
chmod +x build.sh
./build.sh

