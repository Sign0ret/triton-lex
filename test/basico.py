# Prueba: Identificadores, palabras reservadas basicas y numericos
# Cubre: COMMENT, KW_IMPORT, KW_AS, KW_DEF, IDENTIFIER, AT, ARROW
# Cubre: INT_LITERAL (decimal, hex, bin, oct), FLOAT_LITERAL (simple, exp)
# Cubre: OP_ASSIGN, OP_STAR, LPAREN, RPAREN, COMMA, DOT, COLON
# Cubre: NEWLINE, INDENT, DEDENT (al EOF)
import triton
import triton.language as tl

@triton.jit
def add_kernel(x_ptr, y_ptr, n_elements) -> None:
    pid = tl.program_id(axis=0)
    block_start = pid * 1024

    mask_hex = 0xFF
    mask_bin = 0b1010
    mask_oct = 0o755
    float_val = 3.14159
    exp_val = 1.5e-3
