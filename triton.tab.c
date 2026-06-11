/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 18 "triton.y"

#include <stdio.h>
#include <stdlib.h>
#include "triton.h"    /* print_* / free_* de lex.yy.c */

extern int   yylineno;  /* número de línea actual (Flex)          */
extern FILE *yyin;      /* archivo fuente (Flex)                    */
extern char  yytext[];  /* texto del último token reconocido        */
extern int   yytok_col; /* columna donde empezó ese token (Flex)    */

void yyerror(const char *msg);
int  yylex(void);   /* prototipo explícito: evita warning de declaración implícita */

#line 85 "triton.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "triton.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_IDENTIFIER = 3,                 /* IDENTIFIER  */
  YYSYMBOL_INT_LITERAL = 4,                /* INT_LITERAL  */
  YYSYMBOL_FLOAT_LITERAL = 5,              /* FLOAT_LITERAL  */
  YYSYMBOL_STRING_LITERAL = 6,             /* STRING_LITERAL  */
  YYSYMBOL_NEWLINE = 7,                    /* NEWLINE  */
  YYSYMBOL_INDENT = 8,                     /* INDENT  */
  YYSYMBOL_DEDENT = 9,                     /* DEDENT  */
  YYSYMBOL_KW_IMPORT = 10,                 /* KW_IMPORT  */
  YYSYMBOL_KW_AS = 11,                     /* KW_AS  */
  YYSYMBOL_KW_DEF = 12,                    /* KW_DEF  */
  YYSYMBOL_TRITON_JIT = 13,                /* TRITON_JIT  */
  YYSYMBOL_KW_IF = 14,                     /* KW_IF  */
  YYSYMBOL_KW_ELIF = 15,                   /* KW_ELIF  */
  YYSYMBOL_KW_ELSE = 16,                   /* KW_ELSE  */
  YYSYMBOL_KW_FOR = 17,                    /* KW_FOR  */
  YYSYMBOL_KW_WHILE = 18,                  /* KW_WHILE  */
  YYSYMBOL_KW_IN = 19,                     /* KW_IN  */
  YYSYMBOL_KW_BREAK = 20,                  /* KW_BREAK  */
  YYSYMBOL_KW_CONTINUE = 21,               /* KW_CONTINUE  */
  YYSYMBOL_KW_RETURN = 22,                 /* KW_RETURN  */
  YYSYMBOL_KW_PASS = 23,                   /* KW_PASS  */
  YYSYMBOL_KW_AND = 24,                    /* KW_AND  */
  YYSYMBOL_KW_OR = 25,                     /* KW_OR  */
  YYSYMBOL_KW_NOT = 26,                    /* KW_NOT  */
  YYSYMBOL_KW_IS = 27,                     /* KW_IS  */
  YYSYMBOL_KW_TRUE = 28,                   /* KW_TRUE  */
  YYSYMBOL_KW_FALSE = 29,                  /* KW_FALSE  */
  YYSYMBOL_KW_NONE = 30,                   /* KW_NONE  */
  YYSYMBOL_OP_ASSIGN = 31,                 /* OP_ASSIGN  */
  YYSYMBOL_OP_PLUS_ASSIGN = 32,            /* OP_PLUS_ASSIGN  */
  YYSYMBOL_OP_MINUS_ASSIGN = 33,           /* OP_MINUS_ASSIGN  */
  YYSYMBOL_OP_STAR_ASSIGN = 34,            /* OP_STAR_ASSIGN  */
  YYSYMBOL_OP_SLASH_ASSIGN = 35,           /* OP_SLASH_ASSIGN  */
  YYSYMBOL_OP_PLUS = 36,                   /* OP_PLUS  */
  YYSYMBOL_OP_MINUS = 37,                  /* OP_MINUS  */
  YYSYMBOL_OP_STAR = 38,                   /* OP_STAR  */
  YYSYMBOL_OP_SLASH = 39,                  /* OP_SLASH  */
  YYSYMBOL_OP_DOUBLE_SLASH = 40,           /* OP_DOUBLE_SLASH  */
  YYSYMBOL_OP_MOD = 41,                    /* OP_MOD  */
  YYSYMBOL_OP_EQ = 42,                     /* OP_EQ  */
  YYSYMBOL_OP_NEQ = 43,                    /* OP_NEQ  */
  YYSYMBOL_OP_LT = 44,                     /* OP_LT  */
  YYSYMBOL_OP_LE = 45,                     /* OP_LE  */
  YYSYMBOL_OP_GT = 46,                     /* OP_GT  */
  YYSYMBOL_OP_GE = 47,                     /* OP_GE  */
  YYSYMBOL_OP_LSHIFT = 48,                 /* OP_LSHIFT  */
  YYSYMBOL_OP_RSHIFT = 49,                 /* OP_RSHIFT  */
  YYSYMBOL_OP_BIT_AND = 50,                /* OP_BIT_AND  */
  YYSYMBOL_OP_BIT_OR = 51,                 /* OP_BIT_OR  */
  YYSYMBOL_OP_BIT_XOR = 52,                /* OP_BIT_XOR  */
  YYSYMBOL_OP_BIT_NOT = 53,                /* OP_BIT_NOT  */
  YYSYMBOL_LPAREN = 54,                    /* LPAREN  */
  YYSYMBOL_RPAREN = 55,                    /* RPAREN  */
  YYSYMBOL_LBRACKET = 56,                  /* LBRACKET  */
  YYSYMBOL_RBRACKET = 57,                  /* RBRACKET  */
  YYSYMBOL_LBRACE = 58,                    /* LBRACE  */
  YYSYMBOL_RBRACE = 59,                    /* RBRACE  */
  YYSYMBOL_COMMA = 60,                     /* COMMA  */
  YYSYMBOL_COLON = 61,                     /* COLON  */
  YYSYMBOL_DOT = 62,                       /* DOT  */
  YYSYMBOL_SEMICOLON = 63,                 /* SEMICOLON  */
  YYSYMBOL_AT = 64,                        /* AT  */
  YYSYMBOL_ARROW = 65,                     /* ARROW  */
  YYSYMBOL_UMINUS = 66,                    /* UMINUS  */
  YYSYMBOL_YYACCEPT = 67,                  /* $accept  */
  YYSYMBOL_program = 68,                   /* program  */
  YYSYMBOL_stmt_list = 69,                 /* stmt_list  */
  YYSYMBOL_simple_stmt = 70,               /* simple_stmt  */
  YYSYMBOL_compound_stmt = 71,             /* compound_stmt  */
  YYSYMBOL_import_stmt = 72,               /* import_stmt  */
  YYSYMBOL_dotted_name = 73,               /* dotted_name  */
  YYSYMBOL_decorated_def = 74,             /* decorated_def  */
  YYSYMBOL_decorator = 75,                 /* decorator  */
  YYSYMBOL_func_def = 76,                  /* func_def  */
  YYSYMBOL_param_list = 77,                /* param_list  */
  YYSYMBOL_params = 78,                    /* params  */
  YYSYMBOL_param = 79,                     /* param  */
  YYSYMBOL_suite = 80,                     /* suite  */
  YYSYMBOL_if_stmt = 81,                   /* if_stmt  */
  YYSYMBOL_elif_chain = 82,                /* elif_chain  */
  YYSYMBOL_for_stmt = 83,                  /* for_stmt  */
  YYSYMBOL_while_stmt = 84,                /* while_stmt  */
  YYSYMBOL_return_stmt = 85,               /* return_stmt  */
  YYSYMBOL_expr = 86,                      /* expr  */
  YYSYMBOL_primary = 87,                   /* primary  */
  YYSYMBOL_subscript = 88,                 /* subscript  */
  YYSYMBOL_atom = 89,                      /* atom  */
  YYSYMBOL_dict_items = 90,                /* dict_items  */
  YYSYMBOL_dict_pairs = 91,                /* dict_pairs  */
  YYSYMBOL_list_items = 92,                /* list_items  */
  YYSYMBOL_expr_list = 93,                 /* expr_list  */
  YYSYMBOL_arg_list = 94,                  /* arg_list  */
  YYSYMBOL_arguments = 95,                 /* arguments  */
  YYSYMBOL_argument = 96                   /* argument  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if 1

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* 1 */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   861

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  67
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  30
/* YYNRULES -- Number of rules.  */
#define YYNRULES  120
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  212

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   321


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   140,   140,   149,   150,   151,   152,   158,   159,   160,
     161,   162,   163,   172,   175,   178,   181,   184,   200,   201,
     202,   203,   204,   210,   213,   220,   229,   236,   248,   258,
     259,   260,   270,   277,   284,   290,   295,   303,   304,   308,
     309,   320,   326,   331,   336,   351,   352,   367,   368,   373,
     381,   382,   383,   389,   397,   402,   408,   416,   417,   422,
     437,   438,   448,   449,   450,   452,   453,   454,   455,   456,
     457,   458,   459,   460,   467,   468,   469,   470,   471,   473,
     474,   475,   476,   477,   478,   480,   481,   483,   497,   498,
     499,   500,   512,   513,   514,   515,   516,   527,   528,   529,
     530,   531,   532,   533,   534,   535,   536,   542,   543,   547,
     548,   554,   555,   559,   560,   566,   567,   571,   572,   582,
     583
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if 1
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "IDENTIFIER",
  "INT_LITERAL", "FLOAT_LITERAL", "STRING_LITERAL", "NEWLINE", "INDENT",
  "DEDENT", "KW_IMPORT", "KW_AS", "KW_DEF", "TRITON_JIT", "KW_IF",
  "KW_ELIF", "KW_ELSE", "KW_FOR", "KW_WHILE", "KW_IN", "KW_BREAK",
  "KW_CONTINUE", "KW_RETURN", "KW_PASS", "KW_AND", "KW_OR", "KW_NOT",
  "KW_IS", "KW_TRUE", "KW_FALSE", "KW_NONE", "OP_ASSIGN", "OP_PLUS_ASSIGN",
  "OP_MINUS_ASSIGN", "OP_STAR_ASSIGN", "OP_SLASH_ASSIGN", "OP_PLUS",
  "OP_MINUS", "OP_STAR", "OP_SLASH", "OP_DOUBLE_SLASH", "OP_MOD", "OP_EQ",
  "OP_NEQ", "OP_LT", "OP_LE", "OP_GT", "OP_GE", "OP_LSHIFT", "OP_RSHIFT",
  "OP_BIT_AND", "OP_BIT_OR", "OP_BIT_XOR", "OP_BIT_NOT", "LPAREN",
  "RPAREN", "LBRACKET", "RBRACKET", "LBRACE", "RBRACE", "COMMA", "COLON",
  "DOT", "SEMICOLON", "AT", "ARROW", "UMINUS", "$accept", "program",
  "stmt_list", "simple_stmt", "compound_stmt", "import_stmt",
  "dotted_name", "decorated_def", "decorator", "func_def", "param_list",
  "params", "param", "suite", "if_stmt", "elif_chain", "for_stmt",
  "while_stmt", "return_stmt", "expr", "primary", "subscript", "atom",
  "dict_items", "dict_pairs", "list_items", "expr_list", "arg_list",
  "arguments", "argument", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-86)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -86,    13,   253,   -86,   -86,   -86,   -86,   -86,   -86,    39,
      50,     7,   100,    64,   322,   -86,   -86,   425,   -86,   425,
     -86,   -86,   -86,   425,   425,   425,   425,   425,    15,    12,
     -86,   -86,   -86,    32,   -86,   -86,   -86,   -86,   -86,   741,
     107,   -86,   -86,   -86,    -8,   -86,     3,   -86,   460,   -86,
     294,   -36,   -86,     8,   -86,   346,   741,   809,   -86,   -86,
     673,   741,    -5,     4,   483,     0,    11,   -86,   -86,   -86,
     425,   425,   425,    76,   425,   425,   425,   425,   425,   425,
     425,   425,   425,   425,   425,   425,   425,   425,   425,   425,
     425,   425,   425,   425,   425,   425,   425,   460,     2,   104,
     106,   111,   -86,   114,    88,   741,    66,    65,   -86,   -86,
     117,   -86,   425,   -86,   117,   -86,   -86,   425,   425,   -86,
     425,    -3,   809,   775,   425,    -3,    59,    59,   -86,   -86,
     -86,   -86,    -3,    -3,    -3,    -3,    -3,    -3,   206,   206,
     192,   139,    95,   741,   741,   741,   741,   741,    72,   425,
     521,    89,   -86,   -86,   -86,   -20,    93,    90,   -86,   425,
     142,   460,    42,    96,   398,   -86,   741,   741,   559,    -3,
     -86,   741,   425,   -86,   425,   425,     1,   114,   741,   -86,
     -86,   -86,   -86,   425,    91,   -86,   -86,   117,   425,   741,
     741,   707,   -86,   117,   425,   -86,   197,   597,   117,   -86,
     741,   425,   -86,   635,   -86,   117,   -86,   741,   117,    96,
     -86,   -86
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       3,     0,     2,     1,    97,    98,    99,   100,     6,     0,
       0,     0,     0,     0,     0,     9,    10,    60,    11,     0,
     101,   102,   103,     0,     0,     0,   111,   107,     0,     0,
       5,     7,    18,     0,    19,    20,    21,    22,     8,    17,
      87,    91,    25,    26,    23,    36,     0,    29,   115,    49,
       0,    87,    56,     0,    59,     0,    61,    64,    85,    86,
       0,   113,     0,   112,     0,     0,   108,    31,     4,    28,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   115,     0,     0,
       0,     0,    35,    37,    97,   119,     0,   116,   117,    48,
       0,    55,     0,    58,     0,   104,   105,     0,     0,   106,
       0,    72,    63,    62,     0,    71,    79,    80,    81,    82,
      83,    84,    65,    66,    67,    68,    69,    70,    77,    78,
      76,    74,    75,    12,    13,    14,    15,    16,     0,    96,
      92,     0,    88,    24,    27,    41,     0,    38,    39,     0,
       0,     0,     0,    50,     0,    57,   114,   109,     0,    73,
      90,    95,    94,    89,     0,     0,     0,     0,   120,    30,
     118,    46,     3,     0,     0,    47,    54,     0,     0,    93,
      43,    42,    34,     0,     0,    40,     0,     0,     0,    53,
     110,     0,    32,     0,    45,     0,    52,    44,     0,    50,
      33,    51
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -86,   -86,   -31,   -86,   -86,   -86,   -86,   -86,   -86,   122,
     -86,   -86,   -18,   -85,   -86,   -49,   -86,   -86,   -86,    -2,
      -1,   -86,   -86,   -86,   -86,   -86,   -86,    67,   -86,     5
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_uint8 yydefgoto[] =
{
       0,     1,     2,    29,    30,    31,    44,    32,    33,    34,
     156,   157,   158,   163,    35,   185,    36,    37,    38,   105,
      51,   151,    41,    65,    66,    62,    63,   106,   107,   108
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      39,    40,   192,   100,   102,     4,     5,     6,     7,   111,
      50,   174,    55,     3,    47,    56,    67,    57,    97,    68,
      98,    58,    59,    60,    61,    64,    99,   112,    19,   165,
      20,    21,    22,    75,    76,    77,    78,    79,    80,    23,
      42,   175,    43,   181,    10,    87,    88,    89,    90,    91,
     182,    45,   116,    46,   101,    24,    25,   103,    26,   119,
      27,    48,   193,   149,   117,    52,   194,    53,   121,   122,
     123,   120,   125,   126,   127,   128,   129,   130,   131,   132,
     133,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   147,   124,   150,    77,    78,    79,
      80,    49,   199,     4,     5,     6,     7,   152,   202,   153,
     164,   183,   184,   206,   154,   166,   167,   155,   168,   159,
     209,   160,   169,   210,   162,   161,    19,   170,    20,    21,
      22,    75,    76,    77,    78,    79,    80,    23,    92,    93,
      94,    95,    96,    87,    88,    89,   173,   171,   176,   179,
     177,   196,   198,    24,    25,    69,    26,   178,    27,   195,
     211,    97,     0,    98,   148,     0,   180,     0,     0,    99,
     189,     0,   190,   191,     0,    75,    76,    77,    78,    79,
      80,   197,     0,     0,     0,     0,   200,    87,    88,    89,
       0,    91,   203,     0,    39,    40,     0,     0,     0,   207,
       4,     5,     6,     7,     8,     0,   204,     9,     0,    10,
      11,    12,     0,     0,    13,    14,     0,    15,    16,    17,
      18,     0,     0,    19,     0,    20,    21,    22,    75,    76,
      77,    78,    79,    80,    23,     0,     0,     0,     0,     0,
      87,    88,    75,    76,    77,    78,    79,    80,     0,     0,
      24,    25,     0,    26,     0,    27,     4,     5,     6,     7,
       8,    28,     0,     9,     0,    10,    11,    12,     0,     0,
      13,    14,     0,    15,    16,    17,    18,     0,     0,    19,
       0,    20,    21,    22,     0,     0,     0,     0,     0,     0,
      23,     0,     0,     0,     0,   109,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    24,    25,     0,    26,
       0,    27,     0,    70,     0,     0,     0,    28,    71,    72,
      73,    74,     0,    54,     0,     4,     5,     6,     7,     0,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,   113,    19,     0,
      20,    21,    22,     0,     0,   110,     0,     0,     0,    23,
       0,     0,     0,     0,     0,    70,     0,     0,     0,     0,
      71,    72,    73,    74,     0,    24,    25,     0,    26,     0,
      27,     0,    75,    76,    77,    78,    79,    80,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    90,    91,   186,
       0,     0,     0,     0,     0,     0,     0,   114,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    70,     0,     0,
       0,     0,    71,    72,    73,    74,     0,     0,     4,     5,
       6,     7,     0,     0,    75,    76,    77,    78,    79,    80,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    19,     0,    20,    21,    22,     0,     0,     0,   187,
       0,     0,    23,   104,     5,     6,     7,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    24,    25,
       0,    26,     0,    27,     0,     0,    19,     0,    20,    21,
      22,     0,     0,     0,     0,     0,     0,    23,     0,     0,
       0,     0,    70,     0,     0,     0,     0,    71,    72,    73,
      74,     0,     0,    24,    25,     0,    26,     0,    27,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    85,
      86,    87,    88,    89,    90,    91,     0,     0,     0,     0,
      70,     0,     0,     0,   118,    71,    72,    73,    74,     0,
       0,     0,     0,     0,     0,     0,     0,    75,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    90,    91,     0,     0,     0,     0,    70,     0,
       0,     0,   172,    71,    72,    73,    74,     0,     0,     0,
       0,     0,     0,     0,     0,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89,
      90,    91,     0,     0,     0,     0,    70,     0,     0,     0,
     188,    71,    72,    73,    74,     0,     0,     0,     0,     0,
       0,     0,     0,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    88,    89,    90,    91,
       0,     0,     0,     0,    70,     0,     0,     0,   205,    71,
      72,    73,    74,     0,     0,     0,     0,     0,     0,     0,
       0,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    90,    91,     0,     0,
       0,     0,    70,     0,     0,     0,   208,    71,    72,    73,
      74,     0,     0,     0,     0,     0,     0,     0,     0,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    85,
      86,    87,    88,    89,    90,    91,    70,     0,   115,     0,
       0,    71,    72,    73,    74,     0,     0,     0,   201,     0,
       0,     0,     0,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    88,    89,    90,    91,
      70,     0,     0,     0,     0,    71,    72,    73,    74,     0,
       0,     0,     0,     0,     0,     0,     0,    75,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    90,    91,    70,     0,     0,     0,     0,    71,
       0,    73,    74,     0,     0,     0,     0,     0,     0,     0,
       0,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    90,    91,    70,     0,
       0,     0,     0,     0,     0,    73,    74,     0,     0,     0,
       0,     0,     0,     0,     0,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89,
      90,    91
};

static const yytype_int16 yycheck[] =
{
       2,     2,     1,    11,     1,     3,     4,     5,     6,     1,
      12,    31,    14,     0,     7,    17,     1,    19,    54,     7,
      56,    23,    24,    25,    26,    27,    62,    19,    26,   114,
      28,    29,    30,    36,    37,    38,    39,    40,    41,    37,
       1,    61,     3,     1,    12,    48,    49,    50,    51,    52,
       8,     1,    57,     3,    62,    53,    54,    54,    56,    59,
      58,    54,    61,    61,    60,     1,    65,     3,    70,    71,
      72,    60,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    19,    98,    38,    39,    40,
      41,     1,   187,     3,     4,     5,     6,     3,   193,     3,
     112,    15,    16,   198,     3,   117,   118,     3,   120,    31,
     205,    55,   124,   208,     7,    60,    26,    55,    28,    29,
      30,    36,    37,    38,    39,    40,    41,    37,    31,    32,
      33,    34,    35,    48,    49,    50,    57,   149,    55,     7,
      60,   182,    61,    53,    54,    33,    56,   159,    58,   177,
     209,    54,    -1,    56,    97,    -1,   161,    -1,    -1,    62,
     172,    -1,   174,   175,    -1,    36,    37,    38,    39,    40,
      41,   183,    -1,    -1,    -1,    -1,   188,    48,    49,    50,
      -1,    52,   194,    -1,   196,   196,    -1,    -1,    -1,   201,
       3,     4,     5,     6,     7,    -1,     9,    10,    -1,    12,
      13,    14,    -1,    -1,    17,    18,    -1,    20,    21,    22,
      23,    -1,    -1,    26,    -1,    28,    29,    30,    36,    37,
      38,    39,    40,    41,    37,    -1,    -1,    -1,    -1,    -1,
      48,    49,    36,    37,    38,    39,    40,    41,    -1,    -1,
      53,    54,    -1,    56,    -1,    58,     3,     4,     5,     6,
       7,    64,    -1,    10,    -1,    12,    13,    14,    -1,    -1,
      17,    18,    -1,    20,    21,    22,    23,    -1,    -1,    26,
      -1,    28,    29,    30,    -1,    -1,    -1,    -1,    -1,    -1,
      37,    -1,    -1,    -1,    -1,     1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    53,    54,    -1,    56,
      -1,    58,    -1,    19,    -1,    -1,    -1,    64,    24,    25,
      26,    27,    -1,     1,    -1,     3,     4,     5,     6,    -1,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,     1,    26,    -1,
      28,    29,    30,    -1,    -1,    61,    -1,    -1,    -1,    37,
      -1,    -1,    -1,    -1,    -1,    19,    -1,    -1,    -1,    -1,
      24,    25,    26,    27,    -1,    53,    54,    -1,    56,    -1,
      58,    -1,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,     1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    61,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    19,    -1,    -1,
      -1,    -1,    24,    25,    26,    27,    -1,    -1,     3,     4,
       5,     6,    -1,    -1,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    26,    -1,    28,    29,    30,    -1,    -1,    -1,    61,
      -1,    -1,    37,     3,     4,     5,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    53,    54,
      -1,    56,    -1,    58,    -1,    -1,    26,    -1,    28,    29,
      30,    -1,    -1,    -1,    -1,    -1,    -1,    37,    -1,    -1,
      -1,    -1,    19,    -1,    -1,    -1,    -1,    24,    25,    26,
      27,    -1,    -1,    53,    54,    -1,    56,    -1,    58,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    -1,    -1,    -1,    -1,
      19,    -1,    -1,    -1,    61,    24,    25,    26,    27,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    -1,    -1,    -1,    -1,    19,    -1,
      -1,    -1,    61,    24,    25,    26,    27,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    -1,    -1,    -1,    -1,    19,    -1,    -1,    -1,
      61,    24,    25,    26,    27,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      -1,    -1,    -1,    -1,    19,    -1,    -1,    -1,    61,    24,
      25,    26,    27,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    -1,    -1,
      -1,    -1,    19,    -1,    -1,    -1,    61,    24,    25,    26,
      27,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    19,    -1,    55,    -1,
      -1,    24,    25,    26,    27,    -1,    -1,    -1,    31,    -1,
      -1,    -1,    -1,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      19,    -1,    -1,    -1,    -1,    24,    25,    26,    27,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    19,    -1,    -1,    -1,    -1,    24,
      -1,    26,    27,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    19,    -1,
      -1,    -1,    -1,    -1,    -1,    26,    27,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    68,    69,     0,     3,     4,     5,     6,     7,    10,
      12,    13,    14,    17,    18,    20,    21,    22,    23,    26,
      28,    29,    30,    37,    53,    54,    56,    58,    64,    70,
      71,    72,    74,    75,    76,    81,    83,    84,    85,    86,
      87,    89,     1,     3,    73,     1,     3,     7,    54,     1,
      86,    87,     1,     3,     1,    86,    86,    86,    86,    86,
      86,    86,    92,    93,    86,    90,    91,     1,     7,    76,
      19,    24,    25,    26,    27,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    31,    32,    33,    34,    35,    54,    56,    62,
      11,    62,     1,    54,     3,    86,    94,    95,    96,     1,
      61,     1,    19,     1,    61,    55,    57,    60,    61,    59,
      60,    86,    86,    86,    19,    86,    86,    86,    86,    86,
      86,    86,    86,    86,    86,    86,    86,    86,    86,    86,
      86,    86,    86,    86,    86,    86,    86,    86,    94,    61,
      86,    88,     3,     3,     3,     3,    77,    78,    79,    31,
      55,    60,     7,    80,    86,    80,    86,    86,    86,    86,
      55,    86,    61,    57,    31,    61,    55,    60,    86,     7,
      96,     1,     8,    15,    16,    82,     1,    61,    61,    86,
      86,    86,     1,    61,    65,    79,    69,    86,    61,    80,
      86,    31,    80,    86,     9,    61,    80,    86,    61,    80,
      80,    82
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    67,    68,    69,    69,    69,    69,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    71,    71,
      71,    71,    71,    72,    72,    72,    73,    73,    74,    75,
      75,    75,    76,    76,    76,    76,    76,    77,    77,    78,
      78,    79,    79,    79,    79,    80,    80,    81,    81,    81,
      82,    82,    82,    83,    83,    83,    83,    84,    84,    84,
      85,    85,    86,    86,    86,    86,    86,    86,    86,    86,
      86,    86,    86,    86,    86,    86,    86,    86,    86,    86,
      86,    86,    86,    86,    86,    86,    86,    86,    87,    87,
      87,    87,    88,    88,    88,    88,    88,    89,    89,    89,
      89,    89,    89,    89,    89,    89,    89,    90,    90,    91,
      91,    92,    92,    93,    93,    94,    94,    95,    95,    96,
      96
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     0,     3,     2,     2,     1,     1,     1,
       1,     1,     3,     3,     3,     3,     3,     1,     1,     1,
       1,     1,     1,     2,     4,     2,     1,     3,     2,     2,
       5,     2,     7,     9,     6,     3,     2,     0,     1,     1,
       3,     1,     3,     3,     5,     4,     2,     5,     3,     2,
       0,     5,     3,     6,     5,     3,     2,     4,     3,     2,
       1,     2,     3,     3,     2,     3,     3,     3,     3,     3,
       3,     3,     3,     4,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     2,     2,     1,     3,     4,
       4,     1,     1,     3,     2,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     3,     3,     0,     1,     3,
       5,     0,     1,     1,     3,     0,     1,     1,     3,     1,
       3
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


/* Context of a parse error.  */
typedef struct
{
  yy_state_t *yyssp;
  yysymbol_kind_t yytoken;
} yypcontext_t;

/* Put in YYARG at most YYARGN of the expected tokens given the
   current YYCTX, and return the number of tokens stored in YYARG.  If
   YYARG is null, return the number of expected tokens (guaranteed to
   be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
   Return 0 if there are more than YYARGN expected tokens, yet fill
   YYARG up to YYARGN. */
static int
yypcontext_expected_tokens (const yypcontext_t *yyctx,
                            yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  int yyn = yypact[+*yyctx->yyssp];
  if (!yypact_value_is_default (yyn))
    {
      /* Start YYX at -YYN if negative to avoid negative indexes in
         YYCHECK.  In other words, skip the first -YYN actions for
         this state because they are default actions.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;
      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yyx;
      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
        if (yycheck[yyx + yyn] == yyx && yyx != YYSYMBOL_YYerror
            && !yytable_value_is_error (yytable[yyx + yyn]))
          {
            if (!yyarg)
              ++yycount;
            else if (yycount == yyargn)
              return 0;
            else
              yyarg[yycount++] = YY_CAST (yysymbol_kind_t, yyx);
          }
    }
  if (yyarg && yycount == 0 && 0 < yyargn)
    yyarg[0] = YYSYMBOL_YYEMPTY;
  return yycount;
}




#ifndef yystrlen
# if defined __GLIBC__ && defined _STRING_H
#  define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
# else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
# endif
#endif

#ifndef yystpcpy
# if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#  define yystpcpy stpcpy
# else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
# endif
#endif

#ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;
      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
#endif


static int
yy_syntax_error_arguments (const yypcontext_t *yyctx,
                           yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yyctx->yytoken != YYSYMBOL_YYEMPTY)
    {
      int yyn;
      if (yyarg)
        yyarg[yycount] = yyctx->yytoken;
      ++yycount;
      yyn = yypcontext_expected_tokens (yyctx,
                                        yyarg ? yyarg + 1 : yyarg, yyargn - 1);
      if (yyn == YYENOMEM)
        return YYENOMEM;
      else
        yycount += yyn;
    }
  return yycount;
}

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return -1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return YYENOMEM if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                const yypcontext_t *yyctx)
{
  enum { YYARGS_MAX = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  yysymbol_kind_t yyarg[YYARGS_MAX];
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* Actual size of YYARG. */
  int yycount = yy_syntax_error_arguments (yyctx, yyarg, YYARGS_MAX);
  if (yycount == YYENOMEM)
    return YYENOMEM;

  switch (yycount)
    {
#define YYCASE_(N, S)                       \
      case N:                               \
        yyformat = S;                       \
        break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
    }

  /* Compute error message size.  Don't count the "%s"s, but reserve
     room for the terminator.  */
  yysize = yystrlen (yyformat) - 2 * yycount + 1;
  {
    int yyi;
    for (yyi = 0; yyi < yycount; ++yyi)
      {
        YYPTRDIFF_T yysize1
          = yysize + yytnamerr (YY_NULLPTR, yytname[yyarg[yyi]]);
        if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
          yysize = yysize1;
        else
          return YYENOMEM;
      }
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return -1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yytname[yyarg[yyi++]]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 12: /* simple_stmt: primary OP_ASSIGN expr  */
#line 171 "triton.y"
      { if ((yyvsp[-2].entry) >= 0) update_id_role((yyvsp[-2].entry), "variable"); }
#line 1722 "triton.tab.c"
    break;

  case 13: /* simple_stmt: primary OP_PLUS_ASSIGN expr  */
#line 174 "triton.y"
      { if ((yyvsp[-2].entry) >= 0) update_id_role((yyvsp[-2].entry), "variable"); }
#line 1728 "triton.tab.c"
    break;

  case 14: /* simple_stmt: primary OP_MINUS_ASSIGN expr  */
#line 177 "triton.y"
      { if ((yyvsp[-2].entry) >= 0) update_id_role((yyvsp[-2].entry), "variable"); }
#line 1734 "triton.tab.c"
    break;

  case 15: /* simple_stmt: primary OP_STAR_ASSIGN expr  */
#line 180 "triton.y"
      { if ((yyvsp[-2].entry) >= 0) update_id_role((yyvsp[-2].entry), "variable"); }
#line 1740 "triton.tab.c"
    break;

  case 16: /* simple_stmt: primary OP_SLASH_ASSIGN expr  */
#line 183 "triton.y"
      { if ((yyvsp[-2].entry) >= 0) update_id_role((yyvsp[-2].entry), "variable"); }
#line 1746 "triton.tab.c"
    break;

  case 24: /* import_stmt: KW_IMPORT dotted_name KW_AS IDENTIFIER  */
#line 219 "triton.y"
      { update_id_role((yyvsp[0].entry), "alias_modulo"); }
#line 1752 "triton.tab.c"
    break;

  case 25: /* import_stmt: KW_IMPORT error  */
#line 221 "triton.y"
      { fprintf(stderr,
            "  Regla rota : import_stmt → import <módulo>\n"
            "                           | import <módulo> as <alias>\n"
            "  Sugerencia : ¿El nombre del módulo es un identificador válido?\n");
        YYABORT; }
#line 1762 "triton.tab.c"
    break;

  case 26: /* dotted_name: IDENTIFIER  */
#line 235 "triton.y"
      { update_id_role((yyvsp[0].entry), "modulo"); (yyval.entry) = (yyvsp[0].entry); }
#line 1768 "triton.tab.c"
    break;

  case 27: /* dotted_name: dotted_name DOT IDENTIFIER  */
#line 242 "triton.y"
      { update_id_role((yyvsp[0].entry), "modulo"); (yyval.entry) = (yyvsp[0].entry); }
#line 1774 "triton.tab.c"
    break;

  case 31: /* decorator: AT error  */
#line 261 "triton.y"
      { fprintf(stderr,
            "  Regla rota : decorator → @triton.jit\n"
            "                         | @triton.jit(<args>)\n"
            "  Sugerencia : Solo se permiten @triton.jit o @tl.jit.\n"
            "               Si la función no es un kernel, escríbela sin decorador.\n");
        YYABORT; }
#line 1785 "triton.tab.c"
    break;

  case 32: /* func_def: KW_DEF IDENTIFIER LPAREN param_list RPAREN COLON suite  */
#line 276 "triton.y"
      { update_id_role((yyvsp[-5].entry), "funcion"); }
#line 1791 "triton.tab.c"
    break;

  case 33: /* func_def: KW_DEF IDENTIFIER LPAREN param_list RPAREN ARROW expr COLON suite  */
#line 283 "triton.y"
      { update_id_role((yyvsp[-7].entry), "funcion"); }
#line 1797 "triton.tab.c"
    break;

  case 34: /* func_def: KW_DEF IDENTIFIER LPAREN param_list RPAREN error  */
#line 285 "triton.y"
      { fprintf(stderr,
            "  Regla rota : func_def → def <nombre>(<params>) : <bloque>\n"
            "                        | def <nombre>(<params>) -> <tipo> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' (o '->') al final del encabezado de la función?\n");
        YYABORT; }
#line 1807 "triton.tab.c"
    break;

  case 35: /* func_def: KW_DEF IDENTIFIER error  */
#line 291 "triton.y"
      { fprintf(stderr,
            "  Regla rota : func_def → def <nombre>(<params>) : <bloque>\n"
            "  Sugerencia : ¿Faltan los paréntesis '(' ')' de los parámetros?\n");
        YYABORT; }
#line 1816 "triton.tab.c"
    break;

  case 36: /* func_def: KW_DEF error  */
#line 296 "triton.y"
      { fprintf(stderr,
            "  Regla rota : func_def → def <nombre>(<params>) : <bloque>\n"
            "  Sugerencia : 'def' debe ir seguido de un nombre de función válido.\n");
        YYABORT; }
#line 1825 "triton.tab.c"
    break;

  case 41: /* param: IDENTIFIER  */
#line 325 "triton.y"
      { update_id_role((yyvsp[0].entry), "parametro"); }
#line 1831 "triton.tab.c"
    break;

  case 42: /* param: IDENTIFIER COLON expr  */
#line 330 "triton.y"
      { update_id_role((yyvsp[-2].entry), "parametro"); }
#line 1837 "triton.tab.c"
    break;

  case 43: /* param: IDENTIFIER OP_ASSIGN expr  */
#line 335 "triton.y"
      { update_id_role((yyvsp[-2].entry), "parametro"); }
#line 1843 "triton.tab.c"
    break;

  case 44: /* param: IDENTIFIER COLON expr OP_ASSIGN expr  */
#line 340 "triton.y"
      { update_id_role((yyvsp[-4].entry), "parametro"); }
#line 1849 "triton.tab.c"
    break;

  case 46: /* suite: NEWLINE error  */
#line 353 "triton.y"
      { fprintf(stderr,
            "  Regla rota : suite → NEWLINE INDENT <sentencias> DEDENT\n"
            "  Sugerencia : El bloque de código debe estar indentado.\n"
            "               Agrega espacios o un tab al inicio de cada sentencia del bloque.\n");
        YYABORT; }
#line 1859 "triton.tab.c"
    break;

  case 48: /* if_stmt: KW_IF expr error  */
#line 369 "triton.y"
      { fprintf(stderr,
            "  Regla rota : if_stmt → if <condición> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' al final de la condición del 'if'?\n");
        YYABORT; }
#line 1868 "triton.tab.c"
    break;

  case 49: /* if_stmt: KW_IF error  */
#line 374 "triton.y"
      { fprintf(stderr,
            "  Regla rota : if_stmt → if <condición> : <bloque>\n"
            "  Sugerencia : 'if' debe ir seguido de una expresión booleana válida.\n");
        YYABORT; }
#line 1877 "triton.tab.c"
    break;

  case 53: /* for_stmt: KW_FOR IDENTIFIER KW_IN expr COLON suite  */
#line 396 "triton.y"
      { update_id_role((yyvsp[-4].entry), "variable_ciclo"); }
#line 1883 "triton.tab.c"
    break;

  case 54: /* for_stmt: KW_FOR IDENTIFIER KW_IN expr error  */
#line 398 "triton.y"
      { fprintf(stderr,
            "  Regla rota : for_stmt → for <var> in <expr> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' al final del encabezado del 'for'?\n");
        YYABORT; }
#line 1892 "triton.tab.c"
    break;

  case 55: /* for_stmt: KW_FOR IDENTIFIER error  */
#line 403 "triton.y"
      { fprintf(stderr,
            "  Regla rota : for_stmt → for <var> in <expr> : <bloque>\n"
            "  Sugerencia : Después de la variable del 'for' se espera la palabra 'in'.\n"
            "               Ejemplo: for i in range(10):\n");
        YYABORT; }
#line 1902 "triton.tab.c"
    break;

  case 56: /* for_stmt: KW_FOR error  */
#line 409 "triton.y"
      { fprintf(stderr,
            "  Regla rota : for_stmt → for <var> in <expr> : <bloque>\n"
            "  Sugerencia : 'for' debe ir seguido de un identificador (variable de iteración).\n");
        YYABORT; }
#line 1911 "triton.tab.c"
    break;

  case 58: /* while_stmt: KW_WHILE expr error  */
#line 418 "triton.y"
      { fprintf(stderr,
            "  Regla rota : while_stmt → while <condición> : <bloque>\n"
            "  Sugerencia : ¿Falta ':' al final de la condición del 'while'?\n");
        YYABORT; }
#line 1920 "triton.tab.c"
    break;

  case 59: /* while_stmt: KW_WHILE error  */
#line 423 "triton.y"
      { fprintf(stderr,
            "  Regla rota : while_stmt → while <condición> : <bloque>\n"
            "  Sugerencia : 'while' debe ir seguido de una expresión booleana válida.\n");
        YYABORT; }
#line 1929 "triton.tab.c"
    break;

  case 88: /* primary: primary DOT IDENTIFIER  */
#line 497 "triton.y"
                                  { (yyval.entry) = -1; }
#line 1935 "triton.tab.c"
    break;

  case 89: /* primary: primary LBRACKET subscript RBRACKET  */
#line 498 "triton.y"
                                          { (yyval.entry) = -1; }
#line 1941 "triton.tab.c"
    break;

  case 90: /* primary: primary LPAREN arg_list RPAREN  */
#line 499 "triton.y"
                                          { (yyval.entry) = -1; }
#line 1947 "triton.tab.c"
    break;

  case 91: /* primary: atom  */
#line 500 "triton.y"
                                          { (yyval.entry) = (yyvsp[0].entry); }
#line 1953 "triton.tab.c"
    break;

  case 97: /* atom: IDENTIFIER  */
#line 527 "triton.y"
                               { (yyval.entry) = (yyvsp[0].entry); }
#line 1959 "triton.tab.c"
    break;

  case 98: /* atom: INT_LITERAL  */
#line 528 "triton.y"
                               { (yyval.entry) = -1; }
#line 1965 "triton.tab.c"
    break;

  case 99: /* atom: FLOAT_LITERAL  */
#line 529 "triton.y"
                               { (yyval.entry) = -1; }
#line 1971 "triton.tab.c"
    break;

  case 100: /* atom: STRING_LITERAL  */
#line 530 "triton.y"
                               { (yyval.entry) = -1; }
#line 1977 "triton.tab.c"
    break;

  case 101: /* atom: KW_TRUE  */
#line 531 "triton.y"
                               { (yyval.entry) = -1; }
#line 1983 "triton.tab.c"
    break;

  case 102: /* atom: KW_FALSE  */
#line 532 "triton.y"
                               { (yyval.entry) = -1; }
#line 1989 "triton.tab.c"
    break;

  case 103: /* atom: KW_NONE  */
#line 533 "triton.y"
                               { (yyval.entry) = -1; }
#line 1995 "triton.tab.c"
    break;

  case 104: /* atom: LPAREN expr RPAREN  */
#line 534 "triton.y"
                               { (yyval.entry) = -1; }
#line 2001 "triton.tab.c"
    break;

  case 105: /* atom: LBRACKET list_items RBRACKET  */
#line 535 "triton.y"
                                   { (yyval.entry) = -1; }
#line 2007 "triton.tab.c"
    break;

  case 106: /* atom: LBRACE dict_items RBRACE  */
#line 536 "triton.y"
                                   { (yyval.entry) = -1; }
#line 2013 "triton.tab.c"
    break;


#line 2017 "triton.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      {
        yypcontext_t yyctx
          = {yyssp, yytoken};
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = yysyntax_error (&yymsg_alloc, &yymsg, &yyctx);
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == -1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *,
                             YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (yymsg)
              {
                yysyntax_error_status
                  = yysyntax_error (&yymsg_alloc, &yymsg, &yyctx);
                yymsgp = yymsg;
              }
            else
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = YYENOMEM;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == YYENOMEM)
          YYNOMEM;
      }
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
  return yyresult;
}

#line 586 "triton.y"


/* ════════════════════════════════════════════════════════════════
   §4  CÓDIGO C DE APOYO
   ════════════════════════════════════════════════════════════════ */

/*
 * yyerror — llamada automáticamente por Bison al detectar un error.
 *
 * Con %define parse.error verbose, Bison genera msg con el formato:
 *   "syntax error, unexpected <TOKEN>, expecting <X> or <Y>"
 * lo que ya indica qué se encontró y qué se esperaba.
 * Esta función añade localización (línea + columna) y el lexema exacto.
 *
 * Las reglas de error de cada producción imprimirán después la regla
 * gramatical violada y una sugerencia de corrección.
 */
void yyerror(const char *msg) {
    fprintf(stderr,
        "\n╔══════════════════════════════════════════════════════════╗\n"
        "║  ERROR SINTÁCTICO                                        ║\n"
        "╠══════════════════════════════════════════════════════════╣\n"
        "  Ubicación : línea %d, columna %d\n"
        "  Token     : \"%s\"\n"
        "  Problema  : %s\n",
        yylineno, yytok_col, yytext, msg);
    fprintf(stderr,
        "╚══════════════════════════════════════════════════════════╝\n");
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo.py>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror("fopen");
        return EXIT_FAILURE;
    }
    yyin = f;

    /* ── Análisis léxico + sintáctico ── */
    int parse_result = yyparse();
    fclose(yyin);

    /* ── Imprimir output del scanner y tablas ── */
    printf("\n════════════════════════════════════════════════════════════\n");
    printf("SCANNER OUTPUT\n");
    printf("════════════════════════════════════════════════════════════\n");
    print_scanner_output();
    print_id_table();
    print_num_table();
    print_str_table();
    print_statistics();

    /* ── Resultado del análisis sintáctico ── */
    printf("════════════════════════════════════════════════════════════\n");
    if (parse_result == 0) {
        printf("ANÁLISIS SINTÁCTICO: [OK] — El programa es sintácticamente correcto.\n");
    } else {
        printf("ANÁLISIS SINTÁCTICO: [ERROR] — Se encontraron errores sintácticos.\n");
    }
    printf("════════════════════════════════════════════════════════════\n\n");

    /* ── Liberar memoria ── */
    free_scanner_output();
    free_symbol_tables();

    return parse_result;
}
