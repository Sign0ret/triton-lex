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

/* ── Estadísticas ───────────────────────────────────────────────── */
extern void print_statistics(void);

/* ── Liberación de memoria ─────────────────────────────────────── */
extern void free_scanner_output(void);
extern void free_symbol_tables(void);

#endif /* TRITON_H */
