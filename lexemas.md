ESPECIFICACIÓN LÉXICA COMPLETA (Triton-like DSL) - Tokens Individuales

------------------------------------------------------------------
1) ESPACIOS EN BLANCO Y CONTROL DE INDENTACIÓN
------------------------------------------------------------------
WHITESPACE        ::= [ \t]+
NEWLINE           ::= \r?\n
INDENT            ::= ^[ \t]+ (requiere manejo de pila en el lexer)
DEDENT            ::= (generado dinámicamente por el lexer)

------------------------------------------------------------------
2) COMENTARIOS
------------------------------------------------------------------
COMMENT           ::= #.* (ignorado)

------------------------------------------------------------------
3) IDENTIFICADORES
------------------------------------------------------------------
IDENTIFIER        ::= [A-Za-z_][A-Za-z0-9_]*

------------------------------------------------------------------
4) PALABRAS RESERVADAS (KEYWORDS Y LITERALES BOOLEANOS)
------------------------------------------------------------------
KW_DEF            ::= \bdef\b
KW_IF             ::= \bif\b
KW_ELIF           ::= \belif\b
KW_ELSE           ::= \belse\b
KW_FOR            ::= \bfor\b
KW_WHILE          ::= \bwhile\b
KW_IN             ::= \bin\b
KW_BREAK          ::= \bbreak\b
KW_CONTINUE       ::= \bcontinue\b
KW_RETURN         ::= \breturn\b
KW_PASS           ::= \bpass\b
KW_AND            ::= \band\b
KW_OR             ::= \bor\b
KW_NOT            ::= \bnot\b
KW_IS             ::= \bis\b
KW_TRUE           ::= \bTrue\b
KW_FALSE          ::= \bFalse\b
KW_NONE           ::= \bNone\b

------------------------------------------------------------------
5) LITERALES (NUMÉRICOS Y DE TEXTO)
------------------------------------------------------------------
INT_LITERAL       ::= \b(0|[1-9][0-9]*|0x[0-9A-Fa-f]+)\b
FLOAT_LITERAL     ::= \b[0-9]+\.[0-9]*([eE][+-]?[0-9]+)?|\.[0-9]+([eE][+-]?[0-9]+)?|\b[0-9]+[eE][+-]?[0-9]+\b
STRING_LITERAL    ::= "([^"\\]|\\.)*"|'([^'\\]|\\.)*'

------------------------------------------------------------------
6) OPERADORES ARITMÉTICOS
------------------------------------------------------------------
OP_PLUS           ::= \+
OP_MINUS          ::= -
OP_STAR           ::= \*
OP_SLASH          ::= /
OP_DOUBLE_SLASH   ::= //
OP_MOD            ::= %

------------------------------------------------------------------
7) OPERADORES DE ASIGNACIÓN
------------------------------------------------------------------
OP_ASSIGN         ::= =

------------------------------------------------------------------
8) OPERADORES RELACIONALES (COMPARACIÓN)
------------------------------------------------------------------
OP_LT             ::= <
OP_GT             ::= >
OP_LE             ::= <=
OP_GE             ::= >=
OP_EQ             ::= ==
OP_NEQ            ::= !=

------------------------------------------------------------------
9) OPERADORES BIT A BIT (BITWISE)
------------------------------------------------------------------
OP_LSHIFT         ::= <<
OP_RSHIFT         ::= >>
OP_BIT_AND        ::= &
OP_BIT_OR         ::= \|
OP_BIT_XOR        ::= \^
OP_BIT_NOT        ::= ~

------------------------------------------------------------------
10) DELIMITADORES Y PUNTUACIÓN
------------------------------------------------------------------
LPAREN            ::= \(
RPAREN            ::= \)
LBRACKET          ::= \[
RBRACKET          ::= \]
LBRACE            ::= \{
RBRACE            ::= \}
COMMA             ::= ,
COLON             ::= :
DOT               ::= \.
ARROW             ::= ->
SEMICOLON         ::= ;
AT                ::= @

------------------------------------------------------------------
11) TOKENS ESPECÍFICOS DE TRITON (NAMESPACE)
------------------------------------------------------------------
TL_IDENTIFIER     ::= \btl\.[A-Za-z_][A-Za-z0-9_]*\b

NOTA: Alternativamente, puede tokenizarse como la secuencia:
      IDENTIFIER("tl") DOT IDENTIFIER("nombre_funcion")

------------------------------------------------------------------
12) FIN DE ARCHIVO
------------------------------------------------------------------
EOF               ::= \Z

