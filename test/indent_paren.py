# Prueba: Pila de indentacion y continuacion implicita de linea
# Cubre: NEWLINE dentro de parentesis (continuacion implicita, paren_depth > 0)
# Cubre: INDENT multinivel, DEDENT multinivel
# Cubre: KW_DEF, KW_FOR, KW_IN, KW_IF, KW_TRUE
# Cubre: OP_LSHIFT, OP_RSHIFT, OP_BIT_AND
# Cubre: OP_ASSIGN, OP_PLUS
# Cubre: LPAREN, RPAREN (con newlines dentro)
# Cubre: INT_LITERAL (hex: 0x0F)
def calculo_complejo():
    x = tl.load(
        ptr + offset,
        mask = mask,
        other = 0.0
    )

    for i in range(10):
        if True:
            y = x << 2
            z = y >> 1
            w = z & 0x0F
