/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_TRITON_TAB_H_INCLUDED
# define YY_YY_TRITON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IDENTIFIER = 258,              /* IDENTIFIER  */
    INT_LITERAL = 259,             /* INT_LITERAL  */
    FLOAT_LITERAL = 260,           /* FLOAT_LITERAL  */
    STRING_LITERAL = 261,          /* STRING_LITERAL  */
    NEWLINE = 262,                 /* NEWLINE  */
    INDENT = 263,                  /* INDENT  */
    DEDENT = 264,                  /* DEDENT  */
    KW_IMPORT = 265,               /* KW_IMPORT  */
    KW_AS = 266,                   /* KW_AS  */
    KW_DEF = 267,                  /* KW_DEF  */
    KW_JIT = 268,                  /* KW_JIT  */
    KW_IF = 269,                   /* KW_IF  */
    KW_ELIF = 270,                 /* KW_ELIF  */
    KW_ELSE = 271,                 /* KW_ELSE  */
    KW_FOR = 272,                  /* KW_FOR  */
    KW_WHILE = 273,                /* KW_WHILE  */
    KW_IN = 274,                   /* KW_IN  */
    KW_BREAK = 275,                /* KW_BREAK  */
    KW_CONTINUE = 276,             /* KW_CONTINUE  */
    KW_RETURN = 277,               /* KW_RETURN  */
    KW_PASS = 278,                 /* KW_PASS  */
    KW_AND = 279,                  /* KW_AND  */
    KW_OR = 280,                   /* KW_OR  */
    KW_NOT = 281,                  /* KW_NOT  */
    KW_IS = 282,                   /* KW_IS  */
    KW_TRUE = 283,                 /* KW_TRUE  */
    KW_FALSE = 284,                /* KW_FALSE  */
    KW_NONE = 285,                 /* KW_NONE  */
    OP_ASSIGN = 286,               /* OP_ASSIGN  */
    OP_PLUS_ASSIGN = 287,          /* OP_PLUS_ASSIGN  */
    OP_MINUS_ASSIGN = 288,         /* OP_MINUS_ASSIGN  */
    OP_STAR_ASSIGN = 289,          /* OP_STAR_ASSIGN  */
    OP_SLASH_ASSIGN = 290,         /* OP_SLASH_ASSIGN  */
    OP_PLUS = 291,                 /* OP_PLUS  */
    OP_MINUS = 292,                /* OP_MINUS  */
    OP_STAR = 293,                 /* OP_STAR  */
    OP_SLASH = 294,                /* OP_SLASH  */
    OP_DOUBLE_SLASH = 295,         /* OP_DOUBLE_SLASH  */
    OP_MOD = 296,                  /* OP_MOD  */
    OP_EQ = 297,                   /* OP_EQ  */
    OP_NEQ = 298,                  /* OP_NEQ  */
    OP_LT = 299,                   /* OP_LT  */
    OP_LE = 300,                   /* OP_LE  */
    OP_GT = 301,                   /* OP_GT  */
    OP_GE = 302,                   /* OP_GE  */
    OP_LSHIFT = 303,               /* OP_LSHIFT  */
    OP_RSHIFT = 304,               /* OP_RSHIFT  */
    OP_BIT_AND = 305,              /* OP_BIT_AND  */
    OP_BIT_OR = 306,               /* OP_BIT_OR  */
    OP_BIT_XOR = 307,              /* OP_BIT_XOR  */
    OP_BIT_NOT = 308,              /* OP_BIT_NOT  */
    LPAREN = 309,                  /* LPAREN  */
    RPAREN = 310,                  /* RPAREN  */
    LBRACKET = 311,                /* LBRACKET  */
    RBRACKET = 312,                /* RBRACKET  */
    LBRACE = 313,                  /* LBRACE  */
    RBRACE = 314,                  /* RBRACE  */
    COMMA = 315,                   /* COMMA  */
    COLON = 316,                   /* COLON  */
    DOT = 317,                     /* DOT  */
    SEMICOLON = 318,               /* SEMICOLON  */
    AT = 319,                      /* AT  */
    ARROW = 320,                   /* ARROW  */
    UMINUS = 321                   /* UMINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 36 "triton.y"

    int entry;   /* índice en la tabla de símbolos correspondiente */

#line 134 "triton.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_TRITON_TAB_H_INCLUDED  */
