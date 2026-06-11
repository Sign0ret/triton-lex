#ifndef TRITON_H
#define TRITON_H

/*
 * triton.h — Declaraciones compartidas entre lex.yy.c y triton.tab.c
 *
 * Las implementaciones viven en triton.l (compilado como lex.yy.c).
 * triton.y incluye este header para acceder a las tablas de símbolos
 * y las funciones de impresión/liberación.
 */

/* ── Impresión de salida del scanner ────────────────────────────── */
extern void print_scanner_output(void);

/* ── Impresión de tablas de símbolos ───────────────────────────── */
extern void print_id_table(void);
extern void print_num_table(void);
extern void print_str_table(void);

/*
 * update_id_role — actualiza el campo "role" de un IDNode ya existente.
 * Llamada por el PARSER (triton.y) al reconocer construcciones semánticas:
 *   func_def   → role = "funcion"
 *   param      → role = "parametro"
 *   for_stmt   → role = "variable_ciclo"
 *   assignment → role = "variable"
 *   import as  → role = "alias_modulo"
 *   import mod → role = "modulo"
 *
 * Si entry == -1 (primario complejo sin identificador raíz), no hace nada.
 */
extern void update_id_role(int entry, const char* role);

/* ── Estadísticas ───────────────────────────────────────────────── */
extern void print_statistics(void);

/* ── Liberación de memoria ─────────────────────────────────────── */
extern void free_scanner_output(void);
extern void free_symbol_tables(void);

#endif /* TRITON_H */
