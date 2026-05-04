# Prueba: Operadores, condicionales y literales de texto
# Cubre: KW_DEF, KW_IF, KW_ELIF, KW_ELSE, KW_RETURN, KW_PASS
# Cubre: KW_AND, KW_NOT, KW_NONE, KW_FALSE
# Cubre: OP_PLUS_ASSIGN, OP_DOUBLE_SLASH, OP_PLUS, OP_MOD
# Cubre: OP_LE, OP_NEQ
# Cubre: STRING_LITERAL (doble simple, comilla simple, triple-doble, triple-simple, con escapes)
# Cubre: NEWLINE, INDENT, DEDENT
def operaciones_logicas():
    acc += 1.0
    val = (10 // 2) + (5 % 3)

    if acc <= 10.0 and not False:
        mensaje = "Exito simple"
        simple = 'comilla simple'
        multilinea = """Este es un
        string multilinea en
        Triton"""
        multilinea_simple = '''triple comilla
        simple multilinea'''
        escape_doble = "con salto\nde linea"
        escape_simple = 'con comilla \" interna'
    elif acc != 0:
        pass
    else:
        return None
