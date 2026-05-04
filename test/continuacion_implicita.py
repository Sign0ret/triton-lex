# Prueba: Continuacion implicita de linea en listas y diccionarios
# Cubre: paren_depth con [] y {} (newlines dentro sin generar NEWLINE/INDENT)
# Cubre: LBRACKET, RBRACKET, LBRACE, RBRACE, COMMA, COLON, STRING_LITERAL
def test_continuacion():
    lista = [
        1,
        2,
        3
    ]
    diccionario = {
        'a': 1,
        'b': 2
    }
