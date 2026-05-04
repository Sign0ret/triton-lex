# Prueba: Bucles, colecciones y tokens restantes
# Cubre: KW_WHILE, KW_OR, KW_BREAK, KW_CONTINUE, KW_IS
# Cubre: OP_MINUS, OP_SLASH, OP_MINUS_ASSIGN, OP_STAR_ASSIGN, OP_SLASH_ASSIGN
# Cubre: OP_GE, OP_EQ, OP_GT, OP_LT
# Cubre: OP_BIT_OR, OP_BIT_XOR, OP_BIT_NOT
# Cubre: LBRACKET, RBRACKET (listas)
# Cubre: LBRACE, RBRACE (diccionarios)
# Cubre: SEMICOLON
def bucle_y_colecciones():
    lista = [1, 2, 3]
    diccionario = {'clave': 42};

    while True or False:
        if lista[0] > 10:
            break
        elif lista[1] < 5:
            continue

        a = 10 - 2
        b = a / 2
        a -= 1
        b *= 2
        b /= 2

        if a >= b and a == b:
            c = a | b
            d = c ^ a
            e = ~d

        if a is None:
            pass
