/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "parser.y" /* yacc.c:339  */

#include<bits/stdc++.h>
using namespace std;
int lines=0;
extern "C" {
        int yyparse();
        int yylex(void);
        int yyerror(char* s)
        {
            printf("ERROR: %s Line Number: %d\n",s,lines);
            return 0;
        }
    }
extern FILE *yyin;
extern FILE *yyout;
template <typename T>
T parser_string(string str){
    stringstream ss;
    ss << str;
    T result("");
    ss >> result;
    return result;
}

#line 91 "parser.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parser.tab.h".  */
#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    Abstract = 258,
    Continue = 259,
    For = 260,
    New = 261,
    Switch = 262,
    Assert = 263,
    Default = 264,
    If = 265,
    Package = 266,
    Synchronized = 267,
    Boolean = 268,
    Do = 269,
    Goto = 270,
    Private = 271,
    This = 272,
    Break = 273,
    Double = 274,
    Implements = 275,
    Protected = 276,
    Throw = 277,
    Byte = 278,
    Else = 279,
    Import = 280,
    Public = 281,
    Throws_key = 282,
    Case = 283,
    Enum = 284,
    Instanceof = 285,
    Return = 286,
    Transient = 287,
    Catch = 288,
    Extends = 289,
    Int = 290,
    Short = 291,
    Try = 292,
    Char = 293,
    Final = 294,
    Interface = 295,
    Static = 296,
    Void = 297,
    Class = 298,
    Finally = 299,
    Long = 300,
    Strictfp = 301,
    Volatile = 302,
    Const = 303,
    Float = 304,
    Native = 305,
    Super = 306,
    While = 307,
    Underscore = 308,
    Permits = 309,
    Var = 310,
    Yield = 311,
    CharacterLiteral = 312,
    BooleanLiteral = 313,
    IntegerLiteral = 314,
    FloatingPointLiteral = 315,
    StringLiteral = 316,
    TextBlock = 317,
    NullLiteral = 318,
    LeftParenthesis = 319,
    RightParenthesis = 320,
    LeftCurlyBrace = 321,
    RightCurlyBrace = 322,
    LeftSquareBracket = 323,
    RightSquareBracket = 324,
    Semicolon = 325,
    Comma = 326,
    Dot = 327,
    AtSign = 328,
    Scope = 329,
    ellipsis = 330,
    ASSIGN = 331,
    GT = 332,
    LT = 333,
    EXCLAMATION = 334,
    TILDE = 335,
    QUESTIONMARK = 336,
    COLON = 337,
    ARROW = 338,
    EQUAL = 339,
    GE = 340,
    LE = 341,
    NOTEQUAL = 342,
    AND = 343,
    OR = 344,
    INC = 345,
    DEC = 346,
    ADD = 347,
    SUB = 348,
    MUL = 349,
    DIV = 350,
    BITAND = 351,
    BITOR = 352,
    CARET = 353,
    MOD = 354,
    LSHIFT = 355,
    RSHIFT = 356,
    URSHIFT = 357,
    ADD_ASSIGN = 358,
    SUB_ASSIGN = 359,
    MUL_ASSIGN = 360,
    DIV_ASSIGN = 361,
    AND_ASSIGN = 362,
    OR_ASSIGN = 363,
    XOR_ASSIGN = 364,
    MOD_ASSIGN = 365,
    LSHIFT_ASSIGN = 366,
    RSHIFT_ASSIGN = 367,
    URSHIFT_ASSIGN = 368,
    IdentifierChars = 369
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 26 "parser.y" /* yacc.c:355  */

    char* str;
    int num;
    float float_val;
    char sym;

#line 253 "parser.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 270 "parser.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

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

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
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


#if ! defined yyoverflow || YYERROR_VERBOSE

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
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
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
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  15
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   5418

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  115
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  165
/* YYNRULES -- Number of rules.  */
#define YYNRULES  467
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  852

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   369

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
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
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    80,    80,    83,    86,    87,    92,    95,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   113,   117,   117,   117,   120,   120,   122,
     125,   125,   127,   128,   132,   139,   139,   141,   142,   146,
     146,   149,   150,   155,   156,   157,   158,   161,   162,   163,
     164,   167,   168,   171,   171,   173,   174,   178,   179,   183,
     184,   188,   189,   192,   193,   195,   196,   199,   200,   201,
     204,   207,   208,   209,   210,   214,   217,   218,   219,   223,
     224,   228,   229,   230,   231,   236,   237,   238,   239,   240,
     241,   242,   243,   245,   246,   249,   249,   251,   251,   253,
     254,   255,   258,   259,   261,   261,   263,   265,   267,   267,
     269,   269,   272,   273,   276,   277,   280,   283,   286,   287,
     288,   289,   294,   295,   296,   297,   298,   299,   300,   301,
     304,   308,   309,   310,   311,   315,   316,   317,   318,   319,
     320,   321,   322,   323,   324,   325,   326,   327,   328,   329,
     330,   334,   335,   336,   337,   340,   340,   342,   342,   345,
     346,   348,   348,   352,   353,   354,   356,   360,   362,   363,
     364,   365,   369,   369,   371,   372,   373,   374,   375,   376,
     379,   380,   381,   382,   385,   386,   387,   388,   389,   390,
     391,   392,   393,   396,   398,   400,   402,   403,   404,   405,
     406,   407,   408,   411,   413,   415,   417,   418,   421,   423,
     425,   426,   429,   430,   433,   434,   435,   436,   437,   438,
     439,   440,   444,   445,   446,   447,   448,   449,   450,   451,
     454,   455,   458,   460,   460,   462,   463,   466,   468,   470,
     471,   473,   475,   476,   478,   479,   481,   487,   489,   493,
     493,   495,   495,   495,   496,   497,   498,   499,   500,   501,
     502,   505,   506,   507,   508,   509,   510,   511,   514,   514,
     516,   517,   518,   521,   522,   523,   524,   525,   526,   527,
     528,   532,   533,   534,   535,   537,   539,   542,   543,   544,
     547,   548,   551,   552,   554,   555,   556,   557,   560,   561,
     562,   563,   566,   567,   568,   569,   571,   572,   573,   574,
     577,   578,   579,   580,   584,   584,   587,   587,   589,   590,
     591,   592,   594,   595,   597,   598,   600,   601,   603,   604,
     605,   610,   611,   612,   613,   617,   619,   619,   621,   623,
     627,   628,   632,   634,   635,   636,   640,   640,   640,   640,
     640,   640,   640,   640,   640,   640,   640,   640,   642,   643,
     646,   647,   650,   651,   654,   655,   658,   659,   662,   663,
     666,   667,   668,   671,   672,   673,   674,   675,   676,   679,
     680,   683,   684,   685,   686,   690,   691,   692,   695,   696,
     697,   698,   701,   702,   703,   704,   705,   708,   710,   713,
     714,   715,   716,   719,   720,   721,   722,   724,   727,   730,
     731,   742,   743,   748,   749,   752,   752,   752,   752,   752,
     754,   754,   756,   757,   758,   762,   767,   768,   769,   770,
     774,   776,   777,   778,   781,   782,   786,   787,   792,   793,
     798,   801,   801,   803,   803,   805,   806,   809,   810,   812,
     813,   818,   818,   819,   819,   820,   821,   821,   822,   822,
     824,   825,   826,   827,   827,   827,   827,   827
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "Abstract", "Continue", "For", "New",
  "Switch", "Assert", "Default", "If", "Package", "Synchronized",
  "Boolean", "Do", "Goto", "Private", "This", "Break", "Double",
  "Implements", "Protected", "Throw", "Byte", "Else", "Import", "Public",
  "Throws_key", "Case", "Enum", "Instanceof", "Return", "Transient",
  "Catch", "Extends", "Int", "Short", "Try", "Char", "Final", "Interface",
  "Static", "Void", "Class", "Finally", "Long", "Strictfp", "Volatile",
  "Const", "Float", "Native", "Super", "While", "Underscore", "Permits",
  "Var", "Yield", "CharacterLiteral", "BooleanLiteral", "IntegerLiteral",
  "FloatingPointLiteral", "StringLiteral", "TextBlock", "NullLiteral",
  "LeftParenthesis", "RightParenthesis", "LeftCurlyBrace",
  "RightCurlyBrace", "LeftSquareBracket", "RightSquareBracket",
  "Semicolon", "Comma", "Dot", "AtSign", "Scope", "ellipsis", "ASSIGN",
  "GT", "LT", "EXCLAMATION", "TILDE", "QUESTIONMARK", "COLON", "ARROW",
  "EQUAL", "GE", "LE", "NOTEQUAL", "AND", "OR", "INC", "DEC", "ADD", "SUB",
  "MUL", "DIV", "BITAND", "BITOR", "CARET", "MOD", "LSHIFT", "RSHIFT",
  "URSHIFT", "ADD_ASSIGN", "SUB_ASSIGN", "MUL_ASSIGN", "DIV_ASSIGN",
  "AND_ASSIGN", "OR_ASSIGN", "XOR_ASSIGN", "MOD_ASSIGN", "LSHIFT_ASSIGN",
  "RSHIFT_ASSIGN", "URSHIFT_ASSIGN", "IdentifierChars", "$accept",
  "CompilationUnit", "OrdinaryCompilationUnit",
  "TopLevelClassOrInterfaceDeclarationList",
  "TopLevelClassOrInterfaceDeclaration", "ClassDeclaration",
  "NormalClassDeclaration", "Modifier", "ModifierList", "TypeParameters",
  "TypeParameterList", "CommaTypeParameterList", "ClassExtends",
  "ClassPermits", "CommaTypeNameList", "ClassBody",
  "ClassBodyDeclarationList", "ClassBodyDeclaration",
  "ClassMemberDeclaration", "FieldDeclaration", "VariableDeclaratorList",
  "CommaVariableDeclaratorList", "VariableDeclarator",
  "VariableDeclaratorId", "VariableInitializer", "UnannType",
  "UnannPrimitiveType", "UnannReferenceType", "UnannClassOrInterfaceType",
  "UnannClassType", "UnannTypeVariable", "UnannArrayType",
  "MethodDeclaration", "MethodHeader", "MethodDeclarator",
  "ReceiverParameter", "FormalParameterList", "CommaFormalParameterList",
  "FormalParameter", "VariableArityParameter", "VariableModifierList",
  "VariableModifier", "Throws", "ExceptionTypeList",
  "CommaExceptionTypeList", "ExceptionType", "MethodBody",
  "InstanceInitializer", "StaticInitializer", "ConstructorDeclaration",
  "ConstructorDeclarator", "SimpleTypeName", "ConstructorBody",
  "ExplicitConstructorInvocation", "ArrayInitializer",
  "VariableInitializerList", "CommaVariableInitializerList", "Block",
  "BlockStatements", "BlockStatement", "LocalClassOrInterfaceDeclaration",
  "LocalVariableDeclarationStatement", "LocalVariableDeclaration",
  "LocalVariableType", "Statement", "StatementNoShortIf",
  "StatementWithoutTrailingSubstatement", "EmptyStatement",
  "LabeledStatement", "ExpressionStatement", "StatementExpression",
  "IfThenStatement", "IfThenElseStatement", "IfThenElseStatementNoShortIf",
  "AssertStatement", "WhileStatement", "WhileStatementNoShortIf",
  "ForStatement", "ForStatementNoShortIf", "BasicForStatement",
  "BasicForStatementNoShortIf", "ForInit", "ForUpdate",
  "StatementExpressionList", "CommaStatementExpressionList",
  "EnhancedForStatement", "EnhancedForStatementNoShortIf",
  "BreakStatement", "YieldStatement", "ContinueStatement",
  "ReturnStatement", "ThrowStatement", "Pattern", "TypePattern", "Primary",
  "PrimaryNoNewArray", "ClassLiteral", "LeftRightSquareList",
  "ClassInstanceCreationExpression",
  "UnqualifiedClassInstanceCreationExpression",
  "ClassOrInterfaceTypeToInstantiate", "DotIdentifierList",
  "TypeArgumentsOrDiamond", "FieldAccess", "ArrayAccess",
  "MethodInvocation", "ArgumentList", "CommaExpressionList",
  "MethodReference", "ArrayCreationExpression", "DimExprs", "DimExprList",
  "DimExpr", "Expression", "AssignmentExpression", "Assignment",
  "LeftHandSide", "AssignmentOperator", "ConditionalExpression",
  "ConditionalOrExpression", "ConditionalAndExpression",
  "InclusiveOrExpression", "ExclusiveOrExpression", "AndExpression",
  "EqualityExpression", "RelationalExpression", "InstanceofExpression",
  "ShiftExpression", "AdditiveExpression", "MultiplicativeExpression",
  "UnaryExpression", "PreIncrementExpression", "PreDecrementExpression",
  "UnaryExpressionNotPlusMinus", "PostfixExpression",
  "PostIncrementExpression", "PostDecrementExpression", "CastExpression",
  "PrimitiveType", "NumericType", "IntegralType", "FloatingPointType",
  "ReferenceType", "ClassOrInterfaceType", "ClassType", "TypeVariable",
  "ArrayType", "Dims", "TypeParameter", "TypeBound", "TypeArguments",
  "TypeArgumentList", "CommaTypeArgumentList", "TypeArgument", "Wildcard",
  "WildcardBounds", "TypeName", "ExpressionName", "MethodName",
  "PackageOrTypeName", "AmbiguousName", "Identifier", "TypeIdentifier",
  "UnqualifiedMethodIdentifier", "Literal", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350,   351,   352,   353,   354,
     355,   356,   357,   358,   359,   360,   361,   362,   363,   364,
     365,   366,   367,   368,   369
};
# endif

#define YYPACT_NINF -582

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-582)))

#define YYTABLE_NINF -462

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     167,  -582,  -582,  -582,    -5,    94,  -582,   167,  -582,  -582,
    -582,  -582,   188,  -582,    58,  -582,  -582,    -5,  -582,    -5,
       3,  1205,    -5,   125,   159,    97,  -582,    58,    98,   139,
     144,   203,   181,   220,  -582,  -582,  -582,  -582,  -582,  -582,
    -582,  -582,   232,   190,  -582,  -582,  2464,  -582,  -582,  -582,
    1459,    -5,  1343,  -582,  -582,  -582,   190,   239,  -582,   257,
    -582,   239,  -582,  -582,    25,  -582,  -582,  -582,    87,   246,
    -582,  -582,  -582,  -582,   114,   238,   252,   322,   159,    97,
    -582,    97,  -582,  -582,   125,   159,    97,  -582,    -5,   759,
    -582,     3,  -582,   190,  -582,  -582,   334,   300,     7,   313,
     562,  4582,   330,   262,  -582,    28,  4582,  2943,  -582,   336,
     248,   352,  -582,  4582,  -582,  -582,  -582,  -582,  -582,  4582,
    -582,  -582,  4582,  4582,  -582,  -582,  -582,   374,  -582,  -582,
    2534,  -582,  -582,  -582,   350,   190,  -582,  -582,  -582,  -582,
    -582,   369,  -582,  -582,  -582,  -582,  -582,  -582,  -582,  -582,
    -582,  -582,  -582,  -582,   281,   372,  -582,   186,  -582,   157,
     633,   218,  -582,  -582,  -582,  1237,  -582,  -582,    95,   187,
     241,   239,   265,   373,   271,   375,   239,   378,   290,  1903,
     379,   387,   381,   294,  -582,  -582,   190,    25,    87,   397,
    -582,  -582,  -582,   394,    42,   391,   334,   307,   404,  -582,
      -5,  -582,  -582,  -582,  -582,  -582,    -5,  2375,   408,  -582,
     608,  -582,  -582,    -5,  -582,    -5,  -582,    97,  -582,  -582,
    -582,   159,    97,  -582,    97,  -582,  -582,   144,  -582,   133,
    -582,  -582,  -582,  -582,   399,   994,  -582,   144,   181,  -582,
    -582,  1162,  -582,   407,  4705,   416,   413,   306,   190,   410,
     262,  4582,  4582,  4582,  4582,  4582,  -582,  -582,   166,  -582,
    -582,  -582,   126,   396,   389,   392,   398,   143,   104,  -582,
     245,   296,   206,  -582,  -582,  -582,  -582,    95,  -582,  -582,
    -582,   265,  -582,   144,  4582,   424,   455,   308,  -582,   429,
     430,  -582,   431,   460,     8,     8,  4582,   434,   440,  -582,
    -582,  -582,   223,  -582,  -582,   190,   144,  -582,  -582,  -582,
    -582,   239,  -582,    61,     8,  4582,  -582,  -582,  -582,  -582,
    -582,  -582,  -582,  -582,  -582,  -582,  -582,  -582,  4582,  -582,
    -582,  -582,   463,   311,     8,  -582,    59,  -582,   504,   145,
     318,  3002,  4582,    62,     8,  3066,   190,  2814,   437,   442,
    -582,   408,  -582,  1486,  -582,   190,   444,  -582,  4641,  -582,
    -582,   445,   144,  -582,   446,   139,  -582,   456,   173,  -582,
    2604,  2674,   353,    65,   212,  -582,  -582,    31,   448,   457,
     461,  -582,  1563,   252,    98,  -582,  -582,    97,  -582,  -582,
    -582,  -582,  1876,  1876,  -582,  -582,   759,   464,  -582,  -582,
     239,   466,   468,  -582,  3130,   449,   467,   469,  -582,  3189,
    4582,   239,   413,  -582,   239,   476,   190,   144,   185,   184,
    -582,  -582,  -582,  -582,  -582,  4582,  4582,  4582,  4582,  4582,
    4582,  4582,  4582,  4582,  1723,  4582,  4582,  4582,  4582,  4582,
    4582,  4582,  4582,  4582,  4582,  4582,  4582,   477,  -582,  -582,
     474,   501,  -582,  -582,  -582,  -582,   190,   481,   190,  -582,
     482,  -582,  -582,  -582,     8,  -582,   190,   487,  -582,  -582,
     483,  -582,  -582,   512,   190,  -582,  -582,   552,  -582,  -582,
    -582,   356,   190,   495,   518,  -582,   497,   499,   503,  -582,
     190,   190,  -582,  -582,   511,  -582,  -582,  -582,  -582,  -582,
     509,   517,  -582,   190,  2207,  -582,  -582,  -582,   500,  -582,
      -5,   513,  3253,  3317,  -582,  2744,  -582,    54,   519,   522,
      52,  -582,   190,  -582,   343,  1771,  -582,  1563,   520,    14,
    -582,  -582,  -582,  -582,  -582,   759,  -582,  1815,   239,  4824,
     523,  4582,  5304,   524,  3381,    97,   529,   527,  -582,  -582,
    -582,  3440,  -582,  -582,  -582,  4582,   880,   532,   506,   396,
     389,   392,   398,   143,   104,   104,  -582,  -582,  -582,  -582,
    -582,  -582,   144,   245,   245,   245,   245,   296,   296,   296,
     206,   206,  -582,  -582,  -582,  2884,  -582,  -582,   535,  3504,
    -582,  2814,   540,  3568,  -582,  -582,  -582,  -582,     8,     8,
     541,  3632,  -582,  -582,  4582,   537,  -582,   548,  -582,  -582,
    1848,  -582,  -582,  -582,   550,   542,   225,   440,  -582,    -5,
     547,   554,   553,   557,  -582,   561,   -12,  3696,  3760,   565,
       4,  -582,   616,  -582,    44,   570,  -582,  1563,   190,  -582,
    -582,   239,   572,  -582,  2814,   573,  -582,  4884,   574,  -582,
    5304,  4944,   571,  -582,    97,  -582,    97,   577,  -582,  -582,
    -582,  4582,   581,   584,   585,  -582,   626,   628,  -582,  -582,
    -582,  -582,  -582,  3824,  -582,   589,  -582,  3888,  -582,   590,
     190,   592,   190,  -582,  3952,  -582,   593,  -582,  4582,  4016,
    -582,   594,  -582,  4641,   595,  -582,   596,  -582,  -582,   598,
    -582,   600,  4080,   599,   601,   607,   604,   612,  4144,   614,
    -582,  -582,  -582,  -582,  -582,   239,  -582,  2814,  2814,   615,
    2814,  -582,  2814,   618,  5004,  -582,  -582,    97,  -582,  4765,
    4582,  4582,  2814,  -582,   619,  -582,  -582,   622,  -582,   617,
    4208,  -582,  -582,   623,  -582,  -582,  -582,   624,  -582,  -582,
    4641,  -582,  -582,  -582,   625,   627,  4272,  -582,   629,  -582,
     631,   634,   638,  4336,  -582,  -582,  -582,  2814,  -582,  -582,
    2814,  2814,   642,  -582,  4400,   583,   640,   643,   646,  -582,
    -582,  -582,  4459,  -582,   648,  -582,  -582,  -582,  -582,   644,
     645,   651,  -582,  -582,  -582,   649,   653,   656,  -582,  -582,
    -582,  2814,  5064,   654,  4582,  4523,  2884,  2884,  -582,   660,
    -582,  -582,  -582,   657,  -582,  -582,   659,  -582,  2884,   661,
    5124,   665,  5184,   662,   670,  -582,  -582,  -582,  -582,  -582,
    2884,  2884,   666,  2884,  2884,   668,  5244,  2884,  -582,  -582,
    2884,  -582,  -582,  2884,  2884,   669,  -582,  -582,  -582,  -582,
    2884,  -582
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       0,    25,    24,    26,     0,     0,     2,     3,     4,     6,
       7,    28,     0,   461,     0,     1,     5,     0,    27,     0,
       0,     0,     0,     0,     0,     0,    14,     0,     0,    34,
     426,   460,    36,   452,   456,   451,    66,   421,   415,   417,
     416,   419,    26,     0,   418,   420,     0,    40,    50,    49,
       0,     0,     0,    41,    43,    47,     0,    63,    64,    67,
      70,    68,    69,    48,     0,    44,    45,    46,     0,     0,
     116,    65,   413,   414,    73,     0,    31,   436,     0,     0,
      22,     0,    10,    12,     0,     0,     0,    15,     0,     0,
     427,     0,    35,     0,   117,   460,    83,     0,     0,     0,
       0,     0,     0,    66,   253,     0,     0,     0,   106,     0,
       0,     0,   173,     0,   466,   465,   463,   464,   467,     0,
     160,   193,     0,     0,   460,   166,   172,     0,   104,   184,
       0,   162,   163,   164,     0,   168,   165,   174,   185,   175,
     186,     0,   176,   177,   187,   178,   179,   210,   211,   188,
     192,   189,   190,   191,   403,   249,   252,   256,   270,   257,
     258,   259,   260,   250,   196,     0,   197,   198,     0,   199,
     200,     0,    65,     0,   422,   425,   423,   424,     0,   404,
       0,     0,   453,    73,   455,   251,     0,     0,     0,     0,
     130,    39,    42,     0,    53,    58,    81,    60,     0,    76,
       0,    77,    78,   115,    80,   114,     0,     0,     0,   118,
       0,    71,    29,     0,    30,     0,   437,     0,    18,    20,
       8,     0,     0,    23,     0,    11,    13,   428,   412,   447,
     411,   445,   425,   424,     0,   442,   446,   426,    37,   457,
      84,     0,   242,     0,     0,     0,     0,     0,     0,     0,
     412,     0,     0,     0,     0,     0,   256,   259,     0,   339,
     341,   340,   358,   360,   362,   364,   366,   368,   370,   378,
     373,   381,   385,   388,   392,   393,   396,   399,   405,   406,
     402,   411,   453,   426,     0,     0,     0,     0,   240,     0,
       0,   244,     0,     0,     0,     0,     0,     0,     0,   257,
     258,   397,   404,   398,   105,   169,    73,   159,   161,   167,
     170,    60,   195,     0,     0,     0,   346,   350,   351,   347,
     348,   355,   357,   356,   349,   352,   353,   354,     0,   407,
     408,   431,     0,     0,     0,   432,     0,   433,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    71,     0,
      79,     0,   119,     0,    52,     0,     0,    54,     0,    82,
      59,   434,    74,   107,   109,   112,   113,   253,     0,   131,
       0,     0,   403,     0,   343,   120,   122,     0,     0,     0,
      96,   101,     0,    32,   439,   438,    16,     0,    19,    21,
       9,   429,     0,     0,   448,   440,     0,     0,   441,    38,
      86,     0,     0,   243,     0,   231,   233,     0,   230,     0,
       0,   331,   335,   336,   332,     0,     0,   281,     0,     0,
     401,   400,   394,   395,   206,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   268,   263,
       0,     0,   239,   246,   245,   264,     0,   288,     0,   324,
       0,   241,   255,   171,     0,   272,     0,   287,   321,   320,
       0,   342,   262,     0,     0,   322,   328,     0,   330,   254,
     261,     0,     0,     0,     0,   298,     0,   314,     0,   271,
       0,     0,   318,   292,     0,   454,   194,    51,   121,   123,
       0,     0,    55,     0,     0,    57,    62,    61,   435,    72,
       0,   108,     0,     0,   132,     0,   133,     0,     0,     0,
       0,    93,     0,   100,    60,     0,   126,     0,    95,     0,
      33,    17,   449,   450,   443,     0,    90,     0,    88,     0,
       0,     0,     0,   234,     0,   273,     0,     0,   333,   337,
     334,     0,   285,   282,   286,     0,     0,     0,     0,   361,
     363,   365,   367,   369,   371,   372,    66,   248,   380,   247,
      65,   379,    73,   375,   374,   377,   376,   382,   383,   384,
     386,   387,   389,   390,   391,     0,   269,   267,     0,     0,
     325,     0,     0,     0,   291,   266,   323,   329,     0,     0,
       0,     0,   265,   300,     0,   315,   290,     0,   319,   293,
       0,   127,    56,   152,     0,   155,     0,    61,   110,     0,
       0,     0,     0,     0,   134,     0,     0,     0,     0,     0,
       0,   102,     0,   124,     0,     0,    97,     0,     0,    99,
     444,    85,     0,    92,     0,     0,   232,     0,     0,   235,
       0,     0,     0,   277,   275,   338,   274,     0,   409,   410,
     207,     0,     0,     0,     0,   203,     0,   174,   181,   182,
     183,   212,   213,     0,   306,     0,   208,     0,   302,     0,
       0,   289,     0,   326,     0,   294,     0,   316,     0,     0,
     125,     0,   151,     0,   156,   154,     0,   111,   135,     0,
     140,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      94,   128,    98,   103,    89,    87,   214,     0,     0,     0,
       0,   236,     0,     0,     0,   279,   278,   276,   359,     0,
       0,     0,     0,   307,     0,   308,   303,     0,   304,     0,
       0,   327,   295,     0,   296,   317,   299,     0,   129,   157,
       0,   153,   137,   141,     0,     0,     0,   136,     0,   142,
       0,     0,     0,     0,    91,   216,   218,     0,   237,   215,
       0,     0,     0,   280,     0,   231,     0,     0,     0,   204,
     309,   305,     0,   310,     0,   297,   301,   158,   147,     0,
       0,     0,   138,   139,   146,     0,     0,     0,   220,   217,
     219,     0,     0,     0,     0,     0,     0,     0,   311,     0,
     312,   149,   148,     0,   145,   144,     0,   221,     0,     0,
       0,     0,     0,     0,     0,   209,   313,   150,   143,   222,
       0,     0,     0,     0,     0,     0,     0,     0,   226,   224,
       0,   238,   223,     0,     0,     0,   205,   228,   227,   225,
       0,   229
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -582,  -582,  -582,  -582,   689,    83,  -582,    81,   120,   130,
    -582,   335,    49,    23,   510,   -22,  -582,   697,  -582,  -582,
    -107,  -582,  -323,  -352,  -477,    -9,  -582,  -582,  -582,  -582,
    -582,  -582,  -582,   704,   713,  -201,  -226,  -582,  -483,  -582,
    -189,  -110,   -27,  -582,  -582,  -472,   575,  -582,  -582,  -582,
     708,   709,  -154,  -582,  -582,  -582,  -582,    32,  -165,  -117,
    -582,  -582,  -240,   639,   328,  -277,  -365,  -582,  -582,  -582,
    -233,  -582,  -582,  -582,  -582,  -582,  -582,  -582,  -582,  -582,
    -582,    36,  -581,  -237,  -582,  -582,  -582,  -582,  -582,  -582,
    -582,  -582,  -582,  -582,   563,  -582,  -582,  -143,    35,  -282,
     525,  -582,  -582,  1682,  1704,   178,  1646,  -582,  -582,  -582,
     514,  -582,   359,  1562,  -582,   320,  -582,  -582,   107,  -582,
     347,   348,   346,   349,   354,     2,  -582,   -36,    17,   -11,
    -104,   462,   605,   221,   747,   889,   981,  -582,   -78,    -1,
    -582,  -582,   -80,    -3,    11,  -182,   -75,   -51,   567,  -582,
    1691,   549,  -582,  -359,  -582,  -582,    55,  1208,  -582,  -582,
    -582,   -20,  1666,  -582,  -582
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     5,     6,     7,     8,   125,    10,    11,    12,    51,
      75,   214,    24,    25,    92,    26,    52,    53,    54,    55,
     193,   357,   194,   195,   505,   126,    57,    58,    59,    60,
      61,    62,    63,    64,   196,   378,   379,   528,   380,   381,
     127,   128,   208,   363,   511,   364,   204,    65,    66,    67,
      68,    69,   209,   370,   506,   616,   694,   129,   130,   131,
     132,   133,   134,   135,   136,   666,   137,   138,   139,   140,
     141,   142,   143,   668,   144,   145,   669,   146,   670,   147,
     671,   407,   645,   646,   543,   148,   672,   149,   150,   151,
     152,   153,   568,   569,   154,   155,   156,   287,   256,   158,
     245,   417,   553,   159,   160,   257,   486,   605,   162,   163,
     411,   412,   413,   487,   259,   260,   165,   328,   261,   262,
     263,   264,   265,   266,   267,   268,   269,   270,   271,   272,
     273,   274,   275,   276,   277,   278,   279,   280,   171,   281,
      72,    73,   173,   174,   175,   176,   177,   360,    76,   216,
      90,   234,   398,   235,   236,   394,   178,   179,   180,    33,
     181,   282,   283,   184,   185
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      34,    80,    82,    83,   405,    87,   199,   408,   201,   231,
     202,   406,    56,   308,   233,   402,    28,   304,   301,   303,
      71,   382,   246,    97,   366,   523,   182,   615,   310,   333,
      29,   465,   502,   385,   352,   340,   197,   534,   618,   703,
     401,   186,   371,    56,   636,   172,    79,    81,   521,    71,
      86,    71,   382,    70,   375,   709,   218,   219,   464,   220,
     464,   489,   223,   225,   226,   476,   719,   464,   464,   240,
     723,    34,    78,   239,    94,    32,    85,   242,   243,   349,
     249,   157,   518,     9,    70,   289,    89,   356,   230,   638,
       9,    46,    19,    18,    15,   203,   205,   247,   288,   230,
     232,   217,    95,   629,    49,   625,   522,   222,   224,    13,
     182,   232,    20,   355,   206,   311,   519,    31,    95,   522,
     331,    95,    95,   335,    21,   337,    71,   501,    95,   172,
      89,    18,    89,   221,   434,    49,    22,    89,   333,    89,
      89,    50,    95,   772,    23,    95,   238,   697,   420,   421,
     422,   423,   500,   207,   712,   231,    95,    84,    95,    19,
     233,   351,   479,    21,   382,   157,   197,   392,    95,   359,
      88,   419,    50,   418,   311,    95,   640,   639,  -130,    20,
     612,   435,   436,     1,   393,   329,   330,   182,   480,   437,
     438,    21,    89,     2,   567,   386,   481,   498,   463,   388,
     389,   377,   390,    28,     1,   515,   172,   426,     3,    71,
       4,  -425,   384,    20,     2,   427,   749,   365,   508,   205,
     667,   819,    89,    89,   161,    21,   232,   432,   249,     3,
     433,    17,   377,  -344,   230,   465,   424,   513,   489,   832,
      71,   835,   157,   172,   387,   294,   232,   295,   425,   556,
     555,  -202,    91,   198,   308,   845,  -202,  -202,   334,    95,
    -344,  -344,  -344,  -344,  -344,  -344,  -344,  -344,  -344,  -344,
    -344,  -461,   304,   787,   457,   459,   341,  -405,  -405,   157,
     342,  -461,   523,  -201,   520,   311,   344,   341,  -201,  -201,
     695,   342,    93,   467,   469,   343,   696,   344,    46,   635,
     444,   445,  -404,  -404,    95,   446,   406,   198,   161,   649,
     210,   642,   532,   533,   475,   212,   231,   233,   233,   483,
     294,   233,   295,   213,   492,   198,   495,   182,   366,   200,
     285,  -406,  -406,   285,   286,   311,   382,   332,   382,   198,
     582,   583,   584,    88,   377,   439,   440,   441,   382,   536,
     182,   182,    71,   313,   571,   314,   215,   524,   285,   233,
     548,   206,   339,   550,   241,   531,   164,   331,  -426,   172,
     172,   241,    89,   529,   410,   198,   450,   244,    88,   450,
     451,    71,   157,   473,   691,   161,   450,    36,   442,   443,
     484,   230,   230,    37,   284,   230,   552,    38,   308,   573,
     574,   575,   576,   232,   232,   157,   157,   232,   293,    39,
      40,   198,    41,   108,   406,   632,   296,   721,   406,    44,
     309,   382,   161,    45,   419,   517,   418,   314,   598,   112,
     599,   580,   581,   570,   564,   565,   588,   366,   590,   312,
     315,   667,   667,   345,   249,   232,   592,   334,   382,   336,
     164,   658,   338,   667,   596,   231,   577,   578,   579,   346,
     233,   353,   600,   347,   354,   667,   667,   358,   667,   667,
     607,   608,   667,   361,   207,   667,   395,   403,   667,   667,
     409,   410,   416,   311,   428,   667,   429,   643,    13,   775,
     430,   406,   408,   448,   431,   182,   406,   467,   449,   452,
     453,   454,   631,   455,   461,   462,   472,    28,   166,   311,
     478,  -427,   497,   285,   172,   503,   634,   510,   634,   525,
     512,   365,   526,   653,    71,   161,    71,   164,   634,   824,
     825,   541,   527,   538,   230,   535,    71,   537,   542,   544,
     551,   829,   585,   586,   587,   589,   232,   591,   161,   161,
     157,   593,   594,   838,   839,   595,   841,   842,   597,   601,
     846,   602,   603,   847,   164,   182,   848,   849,   450,   406,
     604,   182,   606,   851,   157,   228,   609,   157,   681,   683,
     610,    37,   611,   627,   619,    38,   628,   406,   661,   406,
     714,   637,   166,   647,   654,   650,   655,    39,    40,   673,
      41,   634,   660,   406,   677,   684,   592,    44,   688,    71,
     607,    45,   689,   693,   311,   692,    28,   698,   713,   699,
     157,    36,   701,   700,   182,   702,   157,    37,   634,   708,
     365,    38,   725,   710,   726,   711,    71,   715,   717,   720,
      89,   724,   727,    39,    40,   729,    41,   108,   730,   731,
     732,   167,  -180,    44,   735,   738,   740,    45,   744,   748,
     739,   751,   741,   756,   764,   804,   750,   164,   752,   166,
     753,   757,   758,   376,   759,   496,    31,   760,   763,   157,
     767,   782,   157,   770,   780,   157,   157,   781,   785,   786,
     164,   164,   789,   161,   837,   788,    16,   182,   182,   792,
     182,   793,   182,   795,   794,   773,   166,   801,   806,  -345,
     805,   807,   182,   810,   811,   812,   813,   161,   530,   814,
     161,   816,    13,   815,   820,   826,   830,   827,   172,   828,
     833,   840,   836,   843,   850,   167,  -345,  -345,  -345,  -345,
    -345,  -345,  -345,  -345,  -345,  -345,  -345,   182,   399,   192,
     182,   182,   157,   157,   187,   157,    96,   157,   188,   157,
     189,   414,   350,   161,   157,   776,   305,   157,   728,   161,
     372,   549,   228,   415,   559,   561,   560,   659,    37,   562,
     383,   182,    38,     0,   397,   563,   182,   182,     0,     0,
       0,     0,     0,   168,    39,    40,     0,    41,   182,     0,
       0,     0,   157,     0,    44,   157,   157,     0,    45,   166,
     182,   182,   167,   182,   182,     0,     0,   182,     0,     0,
     182,     0,   161,   182,   182,   161,     0,     0,   161,   161,
     182,     0,   166,   166,     0,   164,   157,   157,     0,     0,
     229,   157,   157,     0,     0,     0,     0,     0,     0,   167,
       0,     0,     0,   157,     0,   157,     0,   157,     0,   164,
       0,     0,   164,     0,     0,   157,   157,     0,   157,   157,
       0,   157,   157,    13,     0,   157,     0,   168,   157,   157,
       0,     0,     0,     0,     0,   157,   100,     0,     0,     0,
       0,     0,     0,   250,     0,   161,   161,   104,   161,    37,
     161,     0,   161,    38,     0,   164,     0,   161,     0,     0,
     161,   164,     0,   665,     0,    39,    40,     0,    41,   676,
       0,     0,   109,     0,     0,    44,     0,     0,     0,    45,
       0,   110,     0,     0,     0,   169,     0,   114,   115,   116,
     117,     0,     0,   118,   251,   161,     0,     0,   161,   161,
       0,     0,   167,     0,   168,     0,     0,     0,     0,   252,
     253,     0,     0,     0,   164,     0,     0,   164,     0,     0,
     164,   164,   716,     0,     0,   167,   167,   166,     0,   161,
     161,     0,     0,     0,   161,   161,     0,     0,     0,     0,
       0,   168,     0,     0,   124,     0,   161,     0,   161,     0,
     161,   166,     0,     0,   166,     0,     0,   228,   161,   161,
       0,   161,   161,    37,   161,   161,     0,    38,   161,   169,
       0,   161,   161,     0,     0,     0,     0,   170,   161,    39,
      40,     0,    41,     0,     0,     0,     0,   164,   164,    44,
     164,     0,   164,    45,   164,   765,   766,   166,   768,   164,
     769,     0,   164,   166,     0,     0,     0,     0,     0,     0,
     779,     0,     0,     0,     0,   396,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   229,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   164,     0,     0,
     164,   164,     0,     0,   168,   798,   169,     0,   799,   800,
       0,     0,     0,     0,     0,     0,   166,     0,    13,   166,
       0,   170,   166,   166,     0,     0,     0,   168,   168,     0,
     167,   164,   164,     0,     0,     0,   164,   164,     0,   817,
       0,     0,     0,   169,   665,   676,     0,     0,   164,     0,
     164,     0,   164,     0,   167,     0,   716,   167,     0,     0,
     164,   164,     0,   164,   164,     0,   164,   164,   765,   766,
     164,   768,   769,   164,   164,   779,     0,     0,   798,     0,
     164,   799,   800,     0,     0,    36,     0,     0,   817,   166,
     166,    37,   166,     0,   166,    38,   166,     0,   170,     0,
     167,   166,     0,     0,   166,     0,   167,    39,    40,     0,
      41,   108,     0,     0,     0,     0,     0,    44,     0,     0,
       0,    45,     0,     0,     0,     0,     0,     0,    36,     0,
       0,     1,     0,     0,    37,   170,     0,   400,    38,   166,
       0,     2,   166,   166,     0,     0,   169,     0,     0,     0,
      39,    40,     0,    41,     0,     0,    42,    43,     4,   167,
      44,     0,   167,     0,    45,   167,   167,     0,     0,   169,
     169,     0,   168,   166,   166,     0,     0,     0,   166,   166,
       0,    46,    47,     0,     0,    48,    13,     0,     0,     0,
     166,     0,   166,    22,   166,     0,   168,     0,     0,   168,
       0,     0,   166,   166,     0,   166,   166,     0,   166,   166,
       0,     0,   166,     0,     0,   166,   166,     0,     0,     0,
       0,     0,   166,   316,     0,     0,     0,     0,     0,    13,
       0,     0,   167,   167,     0,   167,     0,   167,   170,   167,
     302,   302,   168,     0,   167,     0,     0,   167,   168,     0,
     317,   318,   319,   320,   321,   322,   323,   324,   325,   326,
     327,   170,   170,     0,     0,     0,    36,     0,     0,     1,
       0,     0,    37,     0,     0,     0,    38,     0,     0,     2,
       0,     0,   167,     0,     0,   167,   167,     0,    39,    40,
       0,    41,     0,     0,    42,    43,     4,     0,    44,     0,
       0,   168,    45,     0,   168,     0,     0,   168,   168,     0,
       0,     0,     0,     0,   169,     0,   167,   167,     0,    46,
     191,   167,   167,    48,     0,   374,     0,     0,     0,     0,
       0,    22,     0,   167,     0,   167,     0,   167,   169,     0,
       0,   169,     0,     0,     0,   167,   167,     0,   167,   167,
       0,   167,   167,     0,     0,   167,     0,     0,   167,   167,
       0,     0,     0,     0,     0,   167,     0,    13,     0,     0,
     302,   302,   302,   302,   168,   168,     0,   168,     0,   168,
       0,   168,    36,     0,   169,     1,   168,     0,    37,   168,
     169,     0,    38,     0,     0,     2,     0,     0,     0,     0,
       0,     0,     0,     0,    39,    40,   170,    41,     0,    36,
       3,    43,    17,     0,    44,    37,     0,     0,    45,    38,
       0,     0,     0,     0,   168,     0,     0,   168,   168,     0,
     170,    39,    40,   170,    41,   108,     0,     0,     0,     0,
       0,    44,     0,   169,     0,    45,   169,    22,     0,   169,
     169,     0,     0,     0,     0,     0,     0,     0,   168,   168,
       0,   499,     0,   168,   168,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   168,   170,   168,     0,   168,
       0,     0,   170,    13,     0,     0,    36,   168,   168,     0,
     168,   168,    37,   168,   168,     0,    38,   168,     0,     0,
     168,   168,     0,     0,     0,     0,     0,   168,    39,    40,
      13,    41,   108,     0,     0,     0,   169,   169,    44,   169,
       0,   169,    45,   169,     0,     0,     0,     0,   169,     0,
       0,   169,     0,     0,     0,   170,     0,     0,   170,     0,
       0,   170,   170,     0,     0,   302,   302,   302,   302,   302,
     302,   302,     0,   302,   302,   302,   302,   302,   302,   302,
     302,   302,   302,   302,   302,     0,   169,     0,     0,   169,
     169,     0,     0,   258,     0,     0,     0,     0,   290,   292,
      14,     0,     0,     0,     0,   297,     0,    13,     0,     0,
       0,   298,     0,    27,     0,    30,    35,    74,    77,     0,
     169,   169,     0,     0,     0,   169,   169,     0,   170,   170,
       0,   170,     0,   170,     0,   170,     0,   169,     0,   169,
     170,   169,   183,   170,     0,     0,    74,   190,    74,   169,
     169,     0,   169,   169,     0,   169,   169,     0,     0,   169,
       0,     0,   169,   169,     0,     0,   566,     0,     0,   169,
       0,     0,    37,     0,     0,     0,    38,     0,   170,     0,
       0,   170,   170,     0,   227,   237,     0,    35,    39,    40,
       0,    41,   108,   302,   302,   211,    30,     0,    44,     0,
       0,     0,    45,     0,     0,     0,     0,     0,   112,     0,
       0,     0,   170,   170,    36,     0,     0,   170,   170,     0,
      37,   248,     0,   306,    38,     0,   183,     0,     0,   170,
       0,   170,     0,   170,   299,   299,    39,    40,     0,    41,
     108,   170,   170,   298,   170,   170,    44,   170,   170,     0,
      45,   170,     0,     0,   170,   170,   300,   300,    36,     0,
       0,   170,     0,     0,    37,     0,   633,    13,    38,     0,
       0,     0,     0,     0,     0,     0,   447,     0,     0,     0,
      39,    40,     0,    41,   108,     0,     0,     0,   460,     0,
      44,    36,     0,     0,    45,     0,   362,    37,     0,   302,
       0,    38,   237,   183,   348,     0,   306,   470,     0,    77,
     641,   237,     0,    39,    40,    13,    41,   108,     0,   228,
     471,     0,     0,    44,     0,    37,     0,    45,   373,    38,
       0,   237,     0,     0,   488,     0,     0,   306,     0,     0,
     183,    39,    40,   690,    41,     0,     0,     0,   391,     0,
     507,    44,     0,     0,     0,    45,     0,     0,     0,    13,
       0,     0,     0,     0,   299,   299,   299,   299,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   300,   300,   300,   300,
       0,     0,    13,     0,     0,     0,   540,   341,     0,     0,
       0,   342,   547,     0,     0,   343,     0,   344,     0,  -343,
       0,     0,     0,     0,     0,   456,   458,   557,   558,     0,
      13,   494,     0,     0,     0,     0,     0,   211,     0,     0,
       0,     0,     0,     0,   466,   468,  -343,  -343,  -343,  -343,
    -343,  -343,  -343,  -343,  -343,  -343,  -343,     0,     0,   306,
       0,     0,     0,     0,     0,   474,     0,   477,     0,     0,
     482,     0,     0,     0,   490,   491,   183,   183,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   306,     0,
       0,     0,     0,   509,     0,   546,     0,     0,   237,   237,
       0,     0,   237,     0,     0,     0,   617,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     572,     0,     0,   648,     0,     0,   652,     0,   554,   299,
     299,   299,   299,   299,   299,   299,     0,   299,   299,   299,
     299,   299,   299,   299,   299,   299,   299,   299,   299,     0,
       0,   300,   300,   300,   300,   300,   300,   300,     0,   300,
     300,   300,   300,   300,   300,   300,   300,   300,   300,   300,
     300,     0,     0,     0,     0,   248,     0,     0,   621,   623,
       0,     0,     0,     0,     0,     0,   687,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   237,     0,     0,     0,
       0,   183,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   306,     0,   306,     0,     0,     0,   657,     0,     0,
       0,   237,     0,   306,     0,     0,     0,     0,   626,     0,
       0,   630,     0,   100,     0,     0,     0,     0,     0,     0,
     250,     0,     0,     0,   104,     0,    37,     0,     0,     0,
      38,     0,     0,     0,     0,   675,     0,   299,   299,   679,
       0,     0,    39,    40,     0,    41,     0,   686,     0,   109,
     745,     0,    44,     0,     0,   507,    45,     0,   110,   300,
     300,     0,     0,   348,   114,   115,   116,   117,     0,     0,
     118,   504,   613,   705,   707,     0,   306,     0,   614,     0,
       0,     0,     0,     0,     0,   237,   252,   253,     0,   680,
     682,     0,   777,   778,     0,     0,     0,   122,   123,   254,
     255,     0,     0,   306,     0,     0,     0,     0,     0,     0,
       0,     0,   507,     0,     0,     0,     0,     0,     0,   734,
       0,   124,     0,   737,     0,     0,     0,     0,     0,     0,
     743,     0,     0,     0,     0,   747,   803,     0,     0,     0,
       0,     0,     0,   299,     0,     0,     0,     0,   755,     0,
       0,     0,     0,     0,   762,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   300,   821,   823,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    98,
      99,   100,     0,   101,     0,   102,   784,     0,   103,     0,
       0,     1,   367,   105,    37,   183,     0,   106,    38,     0,
       0,     2,   791,     0,     0,     0,   107,     0,     0,   797,
      39,    40,     0,    41,   108,     0,     3,   109,     4,     0,
      44,     0,     0,     0,    45,     0,   368,   111,   809,     0,
     112,   113,   114,   115,   116,   117,     0,     0,   118,   119,
       0,    46,   369,     0,     0,   121,     0,     0,     0,     0,
       0,     0,     0,    89,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   122,   123,     0,    98,    99,
     100,     0,   101,     0,   102,     0,     0,   103,     0,     0,
       1,   104,   105,    37,     0,     0,   106,    38,     0,   124,
       2,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,   108,     0,     3,   109,     4,     0,    44,
       0,     0,     0,    45,     0,   110,   111,     0,     0,   112,
     113,   114,   115,   116,   117,     0,     0,   118,   119,     0,
      46,   120,     0,     0,   121,     0,     0,     0,    98,    99,
     100,     0,   101,     0,   102,     0,     0,   103,     0,     0,
       1,   104,   105,    37,   122,   123,   106,    38,     0,     0,
       2,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,   108,     0,     3,   109,     4,   124,    44,
       0,     0,     0,    45,     0,   110,   111,     0,     0,   112,
     113,   114,   115,   116,   117,     0,     0,   118,   119,     0,
      46,   307,     0,     0,   121,     0,     0,     0,    98,    99,
     100,     0,   101,     0,   102,     0,     0,   103,     0,     0,
       1,   104,   105,    37,   122,   123,   106,    38,     0,     0,
       2,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,   108,     0,     3,   109,     4,   124,    44,
       0,     0,     0,    45,     0,   110,   111,     0,     0,   112,
     113,   114,   115,   116,   117,     0,     0,   118,   119,     0,
      46,   514,     0,     0,   121,     0,     0,     0,    98,    99,
     100,     0,   101,     0,   102,     0,     0,   103,     0,     0,
       1,   104,   105,    37,   122,   123,   106,    38,     0,     0,
       2,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,   108,     0,     3,   109,     4,   124,    44,
       0,     0,     0,    45,     0,   110,   111,     0,     0,   112,
     113,   114,   115,   116,   117,     0,     0,   118,   119,     0,
      46,   516,     0,     0,   121,     0,     0,     0,    98,    99,
     100,     0,   101,     0,   102,     0,     0,   103,     0,     0,
       1,   104,   105,    37,   122,   123,   106,    38,     0,     0,
       2,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,   108,     0,     3,   109,     4,   124,    44,
       0,     0,     0,    45,     0,   110,   111,     0,     0,   112,
     113,   114,   115,   116,   117,     0,     0,   118,   119,     0,
      46,   624,     0,     0,   121,     0,     0,     0,    98,    99,
     100,     0,   101,     0,   102,     0,     0,   250,     0,     0,
       0,   104,   105,    37,   122,   123,   106,    38,     0,     0,
       0,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,   124,    44,
       0,     0,     0,    45,     0,   110,   111,     0,     0,     0,
     113,   114,   115,   116,   117,     0,     0,   118,   119,     0,
      46,     0,     0,     0,   121,     0,     0,     0,    98,   662,
     100,     0,   101,     0,   663,     0,     0,   250,     0,     0,
       0,   104,   105,    37,   122,   123,   106,    38,     0,     0,
       0,     0,     0,     0,     0,   107,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,   124,    44,
       0,     0,     0,    45,     0,   110,   664,     0,     0,     0,
     113,   114,   115,   116,   117,     0,     0,   118,   119,   100,
      46,     0,     0,     0,   121,     0,   250,     0,     0,     0,
     104,     0,    37,     0,     0,     0,    38,     0,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,    39,    40,
       0,    41,     0,     0,     0,   109,     0,     0,    44,     0,
       0,     0,    45,     0,   110,     0,     0,     0,   124,     0,
     114,   115,   116,   117,     0,     0,   118,   251,   100,     0,
       0,     0,     0,   291,     0,   250,     0,     0,     0,   104,
       0,    37,   252,   253,     0,    38,     0,     0,     0,     0,
       0,     0,     0,   122,   123,   254,   255,    39,    40,     0,
      41,     0,     0,     0,   109,     0,     0,    44,     0,     0,
       0,    45,     0,   110,     0,     0,     0,   124,     0,   114,
     115,   116,   117,     0,     0,   118,   251,   485,     0,     0,
       0,     0,   100,     0,     0,     0,     0,     0,     0,   250,
       0,   252,   253,   104,     0,    37,     0,     0,     0,    38,
       0,     0,   122,   123,   254,   255,     0,     0,     0,     0,
       0,    39,    40,     0,    41,     0,     0,     0,   109,     0,
       0,    44,     0,     0,     0,    45,   124,   110,     0,     0,
       0,     0,     0,   114,   115,   116,   117,     0,     0,   118,
     251,   493,     0,     0,     0,     0,   100,     0,     0,     0,
       0,     0,     0,   250,     0,   252,   253,   104,     0,    37,
       0,     0,     0,    38,     0,     0,   122,   123,   254,   255,
       0,     0,     0,     0,     0,    39,    40,     0,    41,     0,
       0,     0,   109,     0,     0,    44,     0,     0,     0,    45,
     124,   110,     0,     0,     0,     0,     0,   114,   115,   116,
     117,     0,     0,   118,   251,   100,     0,     0,     0,     0,
     539,     0,   250,     0,     0,     0,   104,     0,    37,   252,
     253,     0,    38,     0,     0,     0,     0,     0,     0,     0,
     122,   123,   254,   255,    39,    40,     0,    41,     0,     0,
       0,   109,     0,     0,    44,     0,     0,     0,    45,     0,
     110,     0,     0,     0,   124,     0,   114,   115,   116,   117,
       0,     0,   118,   251,   545,     0,     0,     0,     0,   100,
       0,     0,     0,     0,     0,     0,   250,     0,   252,   253,
     104,     0,    37,     0,     0,     0,    38,     0,     0,   122,
     123,   254,   255,     0,     0,     0,     0,     0,    39,    40,
       0,    41,     0,     0,     0,   109,     0,     0,    44,     0,
       0,     0,    45,   124,   110,     0,     0,     0,     0,     0,
     114,   115,   116,   117,     0,     0,   118,   251,   620,     0,
       0,     0,     0,   100,     0,     0,     0,     0,     0,     0,
     250,     0,   252,   253,   104,     0,    37,     0,     0,     0,
      38,     0,     0,   122,   123,   254,   255,     0,     0,     0,
       0,     0,    39,    40,     0,    41,     0,     0,     0,   109,
       0,     0,    44,     0,     0,     0,    45,   124,   110,     0,
       0,     0,     0,     0,   114,   115,   116,   117,     0,     0,
     118,   251,   622,     0,     0,     0,     0,   100,     0,     0,
       0,     0,     0,     0,   250,     0,   252,   253,   104,     0,
      37,     0,     0,     0,    38,     0,     0,   122,   123,   254,
     255,     0,     0,     0,     0,     0,    39,    40,     0,    41,
       0,     0,     0,   109,     0,     0,    44,     0,     0,     0,
      45,   124,   110,     0,     0,     0,     0,     0,   114,   115,
     116,   117,     0,     0,   118,   251,   100,     0,     0,     0,
       0,   651,     0,   250,     0,     0,     0,   104,     0,    37,
     252,   253,     0,    38,     0,     0,     0,     0,     0,     0,
       0,   122,   123,   254,   255,    39,    40,     0,    41,     0,
       0,     0,   109,     0,     0,    44,     0,     0,     0,    45,
       0,   110,     0,     0,     0,   124,     0,   114,   115,   116,
     117,     0,     0,   118,   251,   656,     0,     0,     0,     0,
     100,     0,     0,     0,     0,     0,     0,   250,     0,   252,
     253,   104,     0,    37,     0,     0,     0,    38,     0,     0,
     122,   123,   254,   255,     0,     0,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,   124,   110,     0,     0,     0,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   251,   674,
       0,     0,     0,     0,   100,     0,     0,     0,     0,     0,
       0,   250,     0,   252,   253,   104,     0,    37,     0,     0,
       0,    38,     0,     0,   122,   123,   254,   255,     0,     0,
       0,     0,     0,    39,    40,     0,    41,     0,     0,     0,
     109,     0,     0,    44,     0,     0,     0,    45,   124,   110,
       0,     0,     0,     0,     0,   114,   115,   116,   117,     0,
       0,   118,   251,   678,     0,     0,     0,     0,   100,     0,
       0,     0,     0,     0,     0,   250,     0,   252,   253,   104,
       0,    37,     0,     0,     0,    38,     0,     0,   122,   123,
     254,   255,     0,     0,     0,     0,     0,    39,    40,     0,
      41,     0,     0,     0,   109,     0,     0,    44,     0,     0,
       0,    45,   124,   110,     0,     0,     0,     0,     0,   114,
     115,   116,   117,     0,     0,   118,   251,   685,     0,     0,
       0,     0,   100,     0,     0,     0,     0,     0,     0,   250,
       0,   252,   253,   104,     0,    37,     0,     0,     0,    38,
       0,     0,   122,   123,   254,   255,     0,     0,     0,     0,
       0,    39,    40,     0,    41,     0,     0,     0,   109,     0,
       0,    44,     0,     0,     0,    45,   124,   110,     0,     0,
       0,     0,     0,   114,   115,   116,   117,     0,     0,   118,
     251,   704,     0,     0,     0,     0,   100,     0,     0,     0,
       0,     0,     0,   250,     0,   252,   253,   104,     0,    37,
       0,     0,     0,    38,     0,     0,   122,   123,   254,   255,
       0,     0,     0,     0,     0,    39,    40,     0,    41,     0,
       0,     0,   109,     0,     0,    44,     0,     0,     0,    45,
     124,   110,     0,     0,     0,     0,     0,   114,   115,   116,
     117,     0,     0,   118,   251,   706,     0,     0,     0,     0,
     100,     0,     0,     0,     0,     0,     0,   250,     0,   252,
     253,   104,     0,    37,     0,     0,     0,    38,     0,     0,
     122,   123,   254,   255,     0,     0,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,   124,   110,     0,     0,     0,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   251,   733,
       0,     0,     0,     0,   100,     0,     0,     0,     0,     0,
       0,   250,     0,   252,   253,   104,     0,    37,     0,     0,
       0,    38,     0,     0,   122,   123,   254,   255,     0,     0,
       0,     0,     0,    39,    40,     0,    41,     0,     0,     0,
     109,     0,     0,    44,     0,     0,     0,    45,   124,   110,
       0,     0,     0,     0,     0,   114,   115,   116,   117,     0,
       0,   118,   251,   736,     0,     0,     0,     0,   100,     0,
       0,     0,     0,     0,     0,   250,     0,   252,   253,   104,
       0,    37,     0,     0,     0,    38,     0,     0,   122,   123,
     254,   255,     0,     0,     0,     0,     0,    39,    40,     0,
      41,     0,     0,     0,   109,     0,     0,    44,     0,     0,
       0,    45,   124,   110,     0,     0,     0,     0,     0,   114,
     115,   116,   117,     0,     0,   118,   251,   742,     0,     0,
       0,     0,   100,     0,     0,     0,     0,     0,     0,   250,
       0,   252,   253,   104,     0,    37,     0,     0,     0,    38,
       0,     0,   122,   123,   254,   255,     0,     0,     0,     0,
       0,    39,    40,     0,    41,     0,     0,     0,   109,     0,
       0,    44,     0,     0,     0,    45,   124,   110,     0,     0,
       0,     0,     0,   114,   115,   116,   117,     0,     0,   118,
     251,   746,     0,     0,     0,     0,   100,     0,     0,     0,
       0,     0,     0,   250,     0,   252,   253,   104,     0,    37,
       0,     0,     0,    38,     0,     0,   122,   123,   254,   255,
       0,     0,     0,     0,     0,    39,    40,     0,    41,     0,
       0,     0,   109,     0,     0,    44,     0,     0,     0,    45,
     124,   110,     0,     0,     0,     0,     0,   114,   115,   116,
     117,     0,     0,   118,   251,   754,     0,     0,     0,     0,
     100,     0,     0,     0,     0,     0,     0,   250,     0,   252,
     253,   104,     0,    37,     0,     0,     0,    38,     0,     0,
     122,   123,   254,   255,     0,     0,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,   124,   110,     0,     0,     0,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   251,   761,
       0,     0,     0,     0,   100,     0,     0,     0,     0,     0,
       0,   250,     0,   252,   253,   104,     0,    37,     0,     0,
       0,    38,     0,     0,   122,   123,   254,   255,     0,     0,
       0,     0,     0,    39,    40,     0,    41,     0,     0,     0,
     109,     0,     0,    44,     0,     0,     0,    45,   124,   110,
       0,     0,     0,     0,     0,   114,   115,   116,   117,     0,
       0,   118,   251,   783,     0,     0,     0,     0,   100,     0,
       0,     0,     0,     0,     0,   250,     0,   252,   253,   104,
       0,    37,     0,     0,     0,    38,     0,     0,   122,   123,
     254,   255,     0,     0,     0,     0,     0,    39,    40,     0,
      41,     0,     0,     0,   109,     0,     0,    44,     0,     0,
       0,    45,   124,   110,     0,     0,     0,     0,     0,   114,
     115,   116,   117,     0,     0,   118,   251,   790,     0,     0,
       0,     0,   100,     0,     0,     0,     0,     0,     0,   250,
       0,   252,   253,   104,     0,    37,     0,     0,     0,    38,
       0,     0,   122,   123,   254,   255,     0,     0,     0,     0,
       0,    39,    40,     0,    41,     0,     0,     0,   109,     0,
       0,    44,     0,     0,     0,    45,   124,   110,     0,     0,
       0,     0,     0,   114,   115,   116,   117,     0,     0,   118,
     251,   796,     0,     0,     0,     0,   100,     0,     0,     0,
       0,     0,     0,   250,     0,   252,   253,   104,     0,    37,
       0,     0,     0,    38,     0,     0,   122,   123,   254,   255,
       0,     0,     0,     0,     0,    39,    40,     0,    41,     0,
       0,     0,   109,     0,     0,    44,     0,     0,     0,    45,
     124,   110,     0,     0,     0,     0,     0,   114,   115,   116,
     117,     0,     0,   118,   251,   100,     0,     0,     0,     0,
     802,     0,   250,     0,     0,     0,   104,     0,    37,   252,
     253,     0,    38,     0,     0,     0,     0,     0,     0,     0,
     122,   123,   254,   255,    39,    40,     0,    41,     0,     0,
       0,   109,     0,     0,    44,     0,     0,     0,    45,     0,
     110,     0,     0,     0,   124,     0,   114,   115,   116,   117,
       0,     0,   118,   251,   808,     0,     0,     0,     0,   100,
       0,     0,     0,     0,     0,     0,   250,     0,   252,   253,
     104,     0,    37,     0,     0,     0,    38,     0,     0,   122,
     123,   254,   255,     0,     0,     0,     0,     0,    39,    40,
       0,    41,     0,     0,     0,   109,     0,     0,    44,     0,
       0,     0,    45,   124,   110,     0,     0,     0,     0,     0,
     114,   115,   116,   117,     0,     0,   118,   251,   100,     0,
       0,     0,     0,   822,     0,   250,     0,     0,     0,   104,
       0,    37,   252,   253,     0,    38,     0,     0,     0,     0,
       0,     0,     0,   122,   123,   254,   255,    39,    40,     0,
      41,     0,     0,     0,   109,     0,     0,    44,     0,     0,
       0,    45,     0,   110,     0,     0,     0,   124,     0,   114,
     115,   116,   117,     0,     0,   118,   251,   100,     0,     0,
       0,     0,     0,     0,   250,     0,     0,     0,   104,     0,
      37,   252,   253,     0,    38,     0,     0,     0,     0,     0,
       0,     0,   122,   123,   254,   255,    39,    40,     0,    41,
       0,     0,     0,   109,     0,     0,    44,     0,     0,     0,
      45,     0,   110,     0,     0,     0,   124,     0,   114,   115,
     116,   117,     0,     0,   118,   504,     0,     0,     0,     0,
       0,   100,     0,     0,     0,     0,     0,     0,   103,     0,
     252,   253,   104,     0,    37,     0,     0,     0,    38,     0,
       0,   122,   123,   254,   255,     0,     0,     0,     0,     0,
      39,    40,     0,    41,   108,     0,     0,   109,     0,     0,
      44,     0,     0,     0,    45,   124,   110,     0,     0,     0,
     112,     0,   114,   115,   116,   117,     0,     0,   118,   119,
       0,   100,     0,     0,     0,   404,     0,     0,   103,     0,
       0,     0,   104,     0,    37,     0,     0,     0,    38,     0,
       0,     0,     0,     0,     0,   122,   123,     0,     0,     0,
      39,    40,     0,    41,   108,     0,     0,   109,     0,     0,
      44,     0,     0,     0,    45,     0,   110,     0,     0,   124,
     112,     0,   114,   115,   116,   117,     0,     0,   118,   119,
     100,     0,     0,     0,     0,   774,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,     0,   122,   123,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,     0,   124,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   644,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   718,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   722,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   771,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   818,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   831,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   834,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,   844,
     100,     0,     0,     0,     0,     0,     0,   250,     0,     0,
       0,   104,     0,    37,     0,     0,     0,    38,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,    39,
      40,     0,    41,     0,     0,     0,   109,     0,     0,    44,
       0,     0,     0,    45,     0,   110,     0,     0,   124,     0,
       0,   114,   115,   116,   117,     0,     0,   118,   119,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   122,   123,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   124
};

static const yytype_int16 yycheck[] =
{
      20,    23,    24,    25,   244,    27,    57,   244,    59,    89,
      61,   244,    21,   130,    89,   241,    19,   127,   122,   123,
      21,   210,   100,    43,   206,   377,    46,   504,   135,   172,
      19,   313,   355,   215,   188,   178,    56,   396,   510,    51,
     241,    50,   207,    52,   527,    46,    23,    24,    17,    50,
      27,    52,   241,    21,   208,    51,    78,    79,     6,    81,
       6,   343,    84,    85,    86,     6,   647,     6,     6,    96,
     651,    91,    23,    93,    42,    20,    27,    70,    98,   186,
     100,    46,    17,     0,    52,   105,    78,   194,    89,    75,
       7,    66,    34,    12,     0,    70,    64,   100,    70,   100,
      89,    78,   114,    51,    21,    51,    75,    84,    85,   114,
     130,   100,    54,    71,    27,   135,    51,   114,   114,    75,
     171,   114,   114,   174,    66,   176,   127,   353,   114,   130,
      78,    50,    78,    84,    30,    52,    78,    78,   281,    78,
      78,    21,   114,   724,    14,   114,    91,   619,   252,   253,
     254,   255,   353,    66,   637,   235,   114,    27,   114,    34,
     235,   188,    17,    66,   353,   130,   186,    34,   114,   196,
      72,   251,    52,   251,   194,   114,   535,   529,    64,    54,
     503,    77,    78,    16,    51,    90,    91,   207,    43,    85,
      86,    66,    78,    26,   434,   217,    51,   351,   305,   221,
     222,   210,   224,   206,    16,   370,   207,    81,    41,   210,
      43,    72,   215,    54,    26,    89,   693,   206,   361,   187,
     585,   802,    78,    78,    46,    66,   215,    84,   248,    41,
      87,    43,   241,    76,   235,   517,    70,    64,   520,   820,
     241,   822,   207,   244,   221,    72,   235,    74,    82,    65,
      65,    65,    71,    68,   371,   836,    70,    71,    74,   114,
     103,   104,   105,   106,   107,   108,   109,   110,   111,   112,
     113,    68,   382,   750,   294,   295,    64,    90,    91,   244,
      68,    78,   634,    65,    72,   305,    74,    64,    70,    71,
      65,    68,    72,   313,   314,    72,    71,    74,    66,   525,
      94,    95,    90,    91,   114,    99,   539,    68,   130,   542,
      64,   537,   392,   393,   334,    77,   396,   392,   393,   339,
      72,   396,    74,    71,   344,    68,   346,   347,   510,    72,
      68,    90,    91,    68,    72,   355,   525,    72,   527,    68,
     444,   445,   446,    72,   353,   100,   101,   102,   537,   400,
     370,   371,   353,    72,   434,    74,    34,   377,    68,   434,
     411,    27,    72,   414,    64,   387,    46,   418,    74,   370,
     371,    64,    78,   382,    68,    68,    68,    64,    72,    68,
      72,   382,   347,    72,   610,   207,    68,    13,    92,    93,
      72,   392,   393,    19,    64,   396,   416,    23,   515,   435,
     436,   437,   438,   392,   393,   370,   371,   396,    72,    35,
      36,    68,    38,    39,   647,    72,    64,   650,   651,    45,
      70,   610,   244,    49,   504,    72,   504,    74,    72,    55,
      74,   442,   443,   434,   432,   433,   456,   619,   458,    70,
      68,   806,   807,    64,   464,   434,   466,    74,   637,    74,
     130,   555,    74,   818,   474,   535,   439,   440,   441,    72,
     535,    64,   482,    82,    70,   830,   831,    76,   833,   834,
     490,   491,   837,    69,    66,   840,    77,    70,   843,   844,
      64,    68,    72,   503,    88,   850,    97,   538,   114,   729,
      98,   724,   729,    69,    96,   515,   729,   517,    43,    70,
      70,    70,   522,    43,    70,    65,    43,   510,    46,   529,
       6,    74,    70,    68,   515,    71,   525,    71,   527,    71,
      64,   510,    65,   545,   525,   347,   527,   207,   537,   806,
     807,    82,    71,    65,   535,    71,   537,    71,    71,    70,
      64,   818,    65,    69,    43,    64,   535,    65,   370,   371,
     515,    64,    69,   830,   831,    43,   833,   834,     6,    64,
     837,    43,    65,   840,   244,   585,   843,   844,    68,   802,
      71,   591,    69,   850,   539,    13,    65,   542,   598,   599,
      71,    19,    65,    64,    71,    23,    64,   820,    82,   822,
     641,    71,   130,    70,    65,    71,    69,    35,    36,    64,
      38,   610,    70,   836,    64,    64,   626,    45,    71,   610,
     630,    49,    64,    71,   634,    65,   619,    70,   638,    65,
     585,    13,    65,    70,   644,    64,   591,    19,   637,    64,
     619,    23,   654,    17,   656,    65,   637,    65,    65,    65,
      78,    70,    65,    35,    36,    64,    38,    39,    64,    64,
      24,    46,    24,    45,    65,    65,    64,    49,    65,    65,
     680,    65,   682,    64,   715,    82,    71,   347,    70,   207,
      70,    70,    65,    65,    70,   347,   114,    65,    64,   644,
      65,    64,   647,    65,    65,   650,   651,    65,    65,    65,
     370,   371,    65,   515,    24,    70,     7,   717,   718,    70,
     720,    70,   722,    65,    70,   727,   244,    65,    65,    76,
      70,    65,   732,    65,    70,    70,    65,   539,   383,    70,
     542,    65,   114,    70,    70,    65,    65,    70,   729,    70,
      65,    65,    70,    65,    65,   130,   103,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,   767,   238,    52,
     770,   771,   717,   718,    50,   720,    43,   722,    50,   724,
      51,   247,   187,   585,   729,   729,   127,   732,   661,   591,
     207,   412,    13,   248,   427,   429,   428,   556,    19,   430,
     213,   801,    23,    -1,   235,   431,   806,   807,    -1,    -1,
      -1,    -1,    -1,    46,    35,    36,    -1,    38,   818,    -1,
      -1,    -1,   767,    -1,    45,   770,   771,    -1,    49,   347,
     830,   831,   207,   833,   834,    -1,    -1,   837,    -1,    -1,
     840,    -1,   644,   843,   844,   647,    -1,    -1,   650,   651,
     850,    -1,   370,   371,    -1,   515,   801,   802,    -1,    -1,
      81,   806,   807,    -1,    -1,    -1,    -1,    -1,    -1,   244,
      -1,    -1,    -1,   818,    -1,   820,    -1,   822,    -1,   539,
      -1,    -1,   542,    -1,    -1,   830,   831,    -1,   833,   834,
      -1,   836,   837,   114,    -1,   840,    -1,   130,   843,   844,
      -1,    -1,    -1,    -1,    -1,   850,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,   717,   718,    17,   720,    19,
     722,    -1,   724,    23,    -1,   585,    -1,   729,    -1,    -1,
     732,   591,    -1,   585,    -1,    35,    36,    -1,    38,   591,
      -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,
      -1,    51,    -1,    -1,    -1,    46,    -1,    57,    58,    59,
      60,    -1,    -1,    63,    64,   767,    -1,    -1,   770,   771,
      -1,    -1,   347,    -1,   207,    -1,    -1,    -1,    -1,    79,
      80,    -1,    -1,    -1,   644,    -1,    -1,   647,    -1,    -1,
     650,   651,   644,    -1,    -1,   370,   371,   515,    -1,   801,
     802,    -1,    -1,    -1,   806,   807,    -1,    -1,    -1,    -1,
      -1,   244,    -1,    -1,   114,    -1,   818,    -1,   820,    -1,
     822,   539,    -1,    -1,   542,    -1,    -1,    13,   830,   831,
      -1,   833,   834,    19,   836,   837,    -1,    23,   840,   130,
      -1,   843,   844,    -1,    -1,    -1,    -1,    46,   850,    35,
      36,    -1,    38,    -1,    -1,    -1,    -1,   717,   718,    45,
     720,    -1,   722,    49,   724,   717,   718,   585,   720,   729,
     722,    -1,   732,   591,    -1,    -1,    -1,    -1,    -1,    -1,
     732,    -1,    -1,    -1,    -1,    71,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    81,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   767,    -1,    -1,
     770,   771,    -1,    -1,   347,   767,   207,    -1,   770,   771,
      -1,    -1,    -1,    -1,    -1,    -1,   644,    -1,   114,   647,
      -1,   130,   650,   651,    -1,    -1,    -1,   370,   371,    -1,
     515,   801,   802,    -1,    -1,    -1,   806,   807,    -1,   801,
      -1,    -1,    -1,   244,   806,   807,    -1,    -1,   818,    -1,
     820,    -1,   822,    -1,   539,    -1,   818,   542,    -1,    -1,
     830,   831,    -1,   833,   834,    -1,   836,   837,   830,   831,
     840,   833,   834,   843,   844,   837,    -1,    -1,   840,    -1,
     850,   843,   844,    -1,    -1,    13,    -1,    -1,   850,   717,
     718,    19,   720,    -1,   722,    23,   724,    -1,   207,    -1,
     585,   729,    -1,    -1,   732,    -1,   591,    35,    36,    -1,
      38,    39,    -1,    -1,    -1,    -1,    -1,    45,    -1,    -1,
      -1,    49,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,
      -1,    16,    -1,    -1,    19,   244,    -1,    65,    23,   767,
      -1,    26,   770,   771,    -1,    -1,   347,    -1,    -1,    -1,
      35,    36,    -1,    38,    -1,    -1,    41,    42,    43,   644,
      45,    -1,   647,    -1,    49,   650,   651,    -1,    -1,   370,
     371,    -1,   515,   801,   802,    -1,    -1,    -1,   806,   807,
      -1,    66,    67,    -1,    -1,    70,   114,    -1,    -1,    -1,
     818,    -1,   820,    78,   822,    -1,   539,    -1,    -1,   542,
      -1,    -1,   830,   831,    -1,   833,   834,    -1,   836,   837,
      -1,    -1,   840,    -1,    -1,   843,   844,    -1,    -1,    -1,
      -1,    -1,   850,    76,    -1,    -1,    -1,    -1,    -1,   114,
      -1,    -1,   717,   718,    -1,   720,    -1,   722,   347,   724,
     122,   123,   585,    -1,   729,    -1,    -1,   732,   591,    -1,
     103,   104,   105,   106,   107,   108,   109,   110,   111,   112,
     113,   370,   371,    -1,    -1,    -1,    13,    -1,    -1,    16,
      -1,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    26,
      -1,    -1,   767,    -1,    -1,   770,   771,    -1,    35,    36,
      -1,    38,    -1,    -1,    41,    42,    43,    -1,    45,    -1,
      -1,   644,    49,    -1,   647,    -1,    -1,   650,   651,    -1,
      -1,    -1,    -1,    -1,   515,    -1,   801,   802,    -1,    66,
      67,   806,   807,    70,    -1,   207,    -1,    -1,    -1,    -1,
      -1,    78,    -1,   818,    -1,   820,    -1,   822,   539,    -1,
      -1,   542,    -1,    -1,    -1,   830,   831,    -1,   833,   834,
      -1,   836,   837,    -1,    -1,   840,    -1,    -1,   843,   844,
      -1,    -1,    -1,    -1,    -1,   850,    -1,   114,    -1,    -1,
     252,   253,   254,   255,   717,   718,    -1,   720,    -1,   722,
      -1,   724,    13,    -1,   585,    16,   729,    -1,    19,   732,
     591,    -1,    23,    -1,    -1,    26,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    35,    36,   515,    38,    -1,    13,
      41,    42,    43,    -1,    45,    19,    -1,    -1,    49,    23,
      -1,    -1,    -1,    -1,   767,    -1,    -1,   770,   771,    -1,
     539,    35,    36,   542,    38,    39,    -1,    -1,    -1,    -1,
      -1,    45,    -1,   644,    -1,    49,   647,    78,    -1,   650,
     651,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   801,   802,
      -1,    65,    -1,   806,   807,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   818,   585,   820,    -1,   822,
      -1,    -1,   591,   114,    -1,    -1,    13,   830,   831,    -1,
     833,   834,    19,   836,   837,    -1,    23,   840,    -1,    -1,
     843,   844,    -1,    -1,    -1,    -1,    -1,   850,    35,    36,
     114,    38,    39,    -1,    -1,    -1,   717,   718,    45,   720,
      -1,   722,    49,   724,    -1,    -1,    -1,    -1,   729,    -1,
      -1,   732,    -1,    -1,    -1,   644,    -1,    -1,   647,    -1,
      -1,   650,   651,    -1,    -1,   427,   428,   429,   430,   431,
     432,   433,    -1,   435,   436,   437,   438,   439,   440,   441,
     442,   443,   444,   445,   446,    -1,   767,    -1,    -1,   770,
     771,    -1,    -1,   101,    -1,    -1,    -1,    -1,   106,   107,
       4,    -1,    -1,    -1,    -1,   113,    -1,   114,    -1,    -1,
      -1,   119,    -1,    17,    -1,    19,    20,    21,    22,    -1,
     801,   802,    -1,    -1,    -1,   806,   807,    -1,   717,   718,
      -1,   720,    -1,   722,    -1,   724,    -1,   818,    -1,   820,
     729,   822,    46,   732,    -1,    -1,    50,    51,    52,   830,
     831,    -1,   833,   834,    -1,   836,   837,    -1,    -1,   840,
      -1,    -1,   843,   844,    -1,    -1,    13,    -1,    -1,   850,
      -1,    -1,    19,    -1,    -1,    -1,    23,    -1,   767,    -1,
      -1,   770,   771,    -1,    88,    89,    -1,    91,    35,    36,
      -1,    38,    39,   555,   556,    74,   100,    -1,    45,    -1,
      -1,    -1,    49,    -1,    -1,    -1,    -1,    -1,    55,    -1,
      -1,    -1,   801,   802,    13,    -1,    -1,   806,   807,    -1,
      19,   100,    -1,   127,    23,    -1,   130,    -1,    -1,   818,
      -1,   820,    -1,   822,   122,   123,    35,    36,    -1,    38,
      39,   830,   831,   251,   833,   834,    45,   836,   837,    -1,
      49,   840,    -1,    -1,   843,   844,   122,   123,    13,    -1,
      -1,   850,    -1,    -1,    19,    -1,    65,   114,    23,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   284,    -1,    -1,    -1,
      35,    36,    -1,    38,    39,    -1,    -1,    -1,   296,    -1,
      45,    13,    -1,    -1,    49,    -1,   200,    19,    -1,   661,
      -1,    23,   206,   207,   183,    -1,   210,   315,    -1,   213,
      65,   215,    -1,    35,    36,   114,    38,    39,    -1,    13,
     328,    -1,    -1,    45,    -1,    19,    -1,    49,   207,    23,
      -1,   235,    -1,    -1,   342,    -1,    -1,   241,    -1,    -1,
     244,    35,    36,    65,    38,    -1,    -1,    -1,   227,    -1,
     358,    45,    -1,    -1,    -1,    49,    -1,    -1,    -1,   114,
      -1,    -1,    -1,    -1,   252,   253,   254,   255,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   252,   253,   254,   255,
      -1,    -1,   114,    -1,    -1,    -1,   404,    64,    -1,    -1,
      -1,    68,   410,    -1,    -1,    72,    -1,    74,    -1,    76,
      -1,    -1,    -1,    -1,    -1,   294,   295,   425,   426,    -1,
     114,   345,    -1,    -1,    -1,    -1,    -1,   306,    -1,    -1,
      -1,    -1,    -1,    -1,   313,   314,   103,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,    -1,    -1,   353,
      -1,    -1,    -1,    -1,    -1,   334,    -1,   336,    -1,    -1,
     339,    -1,    -1,    -1,   343,   344,   370,   371,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   382,    -1,
      -1,    -1,    -1,   362,    -1,   409,    -1,    -1,   392,   393,
      -1,    -1,   396,    -1,    -1,    -1,   504,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     434,    -1,    -1,   541,    -1,    -1,   544,    -1,   417,   427,
     428,   429,   430,   431,   432,   433,    -1,   435,   436,   437,
     438,   439,   440,   441,   442,   443,   444,   445,   446,    -1,
      -1,   427,   428,   429,   430,   431,   432,   433,    -1,   435,
     436,   437,   438,   439,   440,   441,   442,   443,   444,   445,
     446,    -1,    -1,    -1,    -1,   464,    -1,    -1,   512,   513,
      -1,    -1,    -1,    -1,    -1,    -1,   604,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   510,    -1,    -1,    -1,
      -1,   515,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   525,    -1,   527,    -1,    -1,    -1,   551,    -1,    -1,
      -1,   535,    -1,   537,    -1,    -1,    -1,    -1,   517,    -1,
      -1,   520,    -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,
      13,    -1,    -1,    -1,    17,    -1,    19,    -1,    -1,    -1,
      23,    -1,    -1,    -1,    -1,   589,    -1,   555,   556,   593,
      -1,    -1,    35,    36,    -1,    38,    -1,   601,    -1,    42,
     688,    -1,    45,    -1,    -1,   693,    49,    -1,    51,   555,
     556,    -1,    -1,   572,    57,    58,    59,    60,    -1,    -1,
      63,    64,    65,   627,   628,    -1,   610,    -1,    71,    -1,
      -1,    -1,    -1,    -1,    -1,   619,    79,    80,    -1,   598,
     599,    -1,   730,   731,    -1,    -1,    -1,    90,    91,    92,
      93,    -1,    -1,   637,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   750,    -1,    -1,    -1,    -1,    -1,    -1,   673,
      -1,   114,    -1,   677,    -1,    -1,    -1,    -1,    -1,    -1,
     684,    -1,    -1,    -1,    -1,   689,   774,    -1,    -1,    -1,
      -1,    -1,    -1,   661,    -1,    -1,    -1,    -1,   702,    -1,
      -1,    -1,    -1,    -1,   708,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   661,   804,   805,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     4,
       5,     6,    -1,     8,    -1,    10,   740,    -1,    13,    -1,
      -1,    16,    17,    18,    19,   729,    -1,    22,    23,    -1,
      -1,    26,   756,    -1,    -1,    -1,    31,    -1,    -1,   763,
      35,    36,    -1,    38,    39,    -1,    41,    42,    43,    -1,
      45,    -1,    -1,    -1,    49,    -1,    51,    52,   782,    -1,
      55,    56,    57,    58,    59,    60,    -1,    -1,    63,    64,
      -1,    66,    67,    -1,    -1,    70,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    78,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    90,    91,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      16,    17,    18,    19,    -1,    -1,    22,    23,    -1,   114,
      26,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    39,    -1,    41,    42,    43,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    55,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      66,    67,    -1,    -1,    70,    -1,    -1,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      16,    17,    18,    19,    90,    91,    22,    23,    -1,    -1,
      26,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    39,    -1,    41,    42,    43,   114,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    55,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      66,    67,    -1,    -1,    70,    -1,    -1,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      16,    17,    18,    19,    90,    91,    22,    23,    -1,    -1,
      26,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    39,    -1,    41,    42,    43,   114,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    55,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      66,    67,    -1,    -1,    70,    -1,    -1,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      16,    17,    18,    19,    90,    91,    22,    23,    -1,    -1,
      26,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    39,    -1,    41,    42,    43,   114,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    55,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      66,    67,    -1,    -1,    70,    -1,    -1,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      16,    17,    18,    19,    90,    91,    22,    23,    -1,    -1,
      26,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    39,    -1,    41,    42,    43,   114,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    55,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      66,    67,    -1,    -1,    70,    -1,    -1,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      -1,    17,    18,    19,    90,    91,    22,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,   114,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    -1,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      66,    -1,    -1,    -1,    70,    -1,    -1,    -1,     4,     5,
       6,    -1,     8,    -1,    10,    -1,    -1,    13,    -1,    -1,
      -1,    17,    18,    19,    90,    91,    22,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,   114,    45,
      -1,    -1,    -1,    49,    -1,    51,    52,    -1,    -1,    -1,
      56,    57,    58,    59,    60,    -1,    -1,    63,    64,     6,
      66,    -1,    -1,    -1,    70,    -1,    13,    -1,    -1,    -1,
      17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    35,    36,
      -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,
      -1,    -1,    49,    -1,    51,    -1,    -1,    -1,   114,    -1,
      57,    58,    59,    60,    -1,    -1,    63,    64,     6,    -1,
      -1,    -1,    -1,    70,    -1,    13,    -1,    -1,    -1,    17,
      -1,    19,    79,    80,    -1,    23,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    90,    91,    92,    93,    35,    36,    -1,
      38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,
      -1,    49,    -1,    51,    -1,    -1,    -1,   114,    -1,    57,
      58,    59,    60,    -1,    -1,    63,    64,    65,    -1,    -1,
      -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    79,    80,    17,    -1,    19,    -1,    -1,    -1,    23,
      -1,    -1,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
      -1,    35,    36,    -1,    38,    -1,    -1,    -1,    42,    -1,
      -1,    45,    -1,    -1,    -1,    49,   114,    51,    -1,    -1,
      -1,    -1,    -1,    57,    58,    59,    60,    -1,    -1,    63,
      64,    65,    -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,    79,    80,    17,    -1,    19,
      -1,    -1,    -1,    23,    -1,    -1,    90,    91,    92,    93,
      -1,    -1,    -1,    -1,    -1,    35,    36,    -1,    38,    -1,
      -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,
     114,    51,    -1,    -1,    -1,    -1,    -1,    57,    58,    59,
      60,    -1,    -1,    63,    64,     6,    -1,    -1,    -1,    -1,
      70,    -1,    13,    -1,    -1,    -1,    17,    -1,    19,    79,
      80,    -1,    23,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      90,    91,    92,    93,    35,    36,    -1,    38,    -1,    -1,
      -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,    -1,
      51,    -1,    -1,    -1,   114,    -1,    57,    58,    59,    60,
      -1,    -1,    63,    64,    65,    -1,    -1,    -1,    -1,     6,
      -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    79,    80,
      17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    -1,    35,    36,
      -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,
      -1,    -1,    49,   114,    51,    -1,    -1,    -1,    -1,    -1,
      57,    58,    59,    60,    -1,    -1,    63,    64,    65,    -1,
      -1,    -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,
      13,    -1,    79,    80,    17,    -1,    19,    -1,    -1,    -1,
      23,    -1,    -1,    90,    91,    92,    93,    -1,    -1,    -1,
      -1,    -1,    35,    36,    -1,    38,    -1,    -1,    -1,    42,
      -1,    -1,    45,    -1,    -1,    -1,    49,   114,    51,    -1,
      -1,    -1,    -1,    -1,    57,    58,    59,    60,    -1,    -1,
      63,    64,    65,    -1,    -1,    -1,    -1,     6,    -1,    -1,
      -1,    -1,    -1,    -1,    13,    -1,    79,    80,    17,    -1,
      19,    -1,    -1,    -1,    23,    -1,    -1,    90,    91,    92,
      93,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,    38,
      -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,
      49,   114,    51,    -1,    -1,    -1,    -1,    -1,    57,    58,
      59,    60,    -1,    -1,    63,    64,     6,    -1,    -1,    -1,
      -1,    70,    -1,    13,    -1,    -1,    -1,    17,    -1,    19,
      79,    80,    -1,    23,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    90,    91,    92,    93,    35,    36,    -1,    38,    -1,
      -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,
      -1,    51,    -1,    -1,    -1,   114,    -1,    57,    58,    59,
      60,    -1,    -1,    63,    64,    65,    -1,    -1,    -1,    -1,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    79,
      80,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,   114,    51,    -1,    -1,    -1,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
      -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,
      -1,    13,    -1,    79,    80,    17,    -1,    19,    -1,    -1,
      -1,    23,    -1,    -1,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    -1,    35,    36,    -1,    38,    -1,    -1,    -1,
      42,    -1,    -1,    45,    -1,    -1,    -1,    49,   114,    51,
      -1,    -1,    -1,    -1,    -1,    57,    58,    59,    60,    -1,
      -1,    63,    64,    65,    -1,    -1,    -1,    -1,     6,    -1,
      -1,    -1,    -1,    -1,    -1,    13,    -1,    79,    80,    17,
      -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    90,    91,
      92,    93,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,
      38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,
      -1,    49,   114,    51,    -1,    -1,    -1,    -1,    -1,    57,
      58,    59,    60,    -1,    -1,    63,    64,    65,    -1,    -1,
      -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    79,    80,    17,    -1,    19,    -1,    -1,    -1,    23,
      -1,    -1,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
      -1,    35,    36,    -1,    38,    -1,    -1,    -1,    42,    -1,
      -1,    45,    -1,    -1,    -1,    49,   114,    51,    -1,    -1,
      -1,    -1,    -1,    57,    58,    59,    60,    -1,    -1,    63,
      64,    65,    -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,    79,    80,    17,    -1,    19,
      -1,    -1,    -1,    23,    -1,    -1,    90,    91,    92,    93,
      -1,    -1,    -1,    -1,    -1,    35,    36,    -1,    38,    -1,
      -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,
     114,    51,    -1,    -1,    -1,    -1,    -1,    57,    58,    59,
      60,    -1,    -1,    63,    64,    65,    -1,    -1,    -1,    -1,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    79,
      80,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,   114,    51,    -1,    -1,    -1,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
      -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,
      -1,    13,    -1,    79,    80,    17,    -1,    19,    -1,    -1,
      -1,    23,    -1,    -1,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    -1,    35,    36,    -1,    38,    -1,    -1,    -1,
      42,    -1,    -1,    45,    -1,    -1,    -1,    49,   114,    51,
      -1,    -1,    -1,    -1,    -1,    57,    58,    59,    60,    -1,
      -1,    63,    64,    65,    -1,    -1,    -1,    -1,     6,    -1,
      -1,    -1,    -1,    -1,    -1,    13,    -1,    79,    80,    17,
      -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    90,    91,
      92,    93,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,
      38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,
      -1,    49,   114,    51,    -1,    -1,    -1,    -1,    -1,    57,
      58,    59,    60,    -1,    -1,    63,    64,    65,    -1,    -1,
      -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    79,    80,    17,    -1,    19,    -1,    -1,    -1,    23,
      -1,    -1,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
      -1,    35,    36,    -1,    38,    -1,    -1,    -1,    42,    -1,
      -1,    45,    -1,    -1,    -1,    49,   114,    51,    -1,    -1,
      -1,    -1,    -1,    57,    58,    59,    60,    -1,    -1,    63,
      64,    65,    -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,    79,    80,    17,    -1,    19,
      -1,    -1,    -1,    23,    -1,    -1,    90,    91,    92,    93,
      -1,    -1,    -1,    -1,    -1,    35,    36,    -1,    38,    -1,
      -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,
     114,    51,    -1,    -1,    -1,    -1,    -1,    57,    58,    59,
      60,    -1,    -1,    63,    64,    65,    -1,    -1,    -1,    -1,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    79,
      80,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,   114,    51,    -1,    -1,    -1,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
      -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,
      -1,    13,    -1,    79,    80,    17,    -1,    19,    -1,    -1,
      -1,    23,    -1,    -1,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    -1,    35,    36,    -1,    38,    -1,    -1,    -1,
      42,    -1,    -1,    45,    -1,    -1,    -1,    49,   114,    51,
      -1,    -1,    -1,    -1,    -1,    57,    58,    59,    60,    -1,
      -1,    63,    64,    65,    -1,    -1,    -1,    -1,     6,    -1,
      -1,    -1,    -1,    -1,    -1,    13,    -1,    79,    80,    17,
      -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    90,    91,
      92,    93,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,
      38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,
      -1,    49,   114,    51,    -1,    -1,    -1,    -1,    -1,    57,
      58,    59,    60,    -1,    -1,    63,    64,    65,    -1,    -1,
      -1,    -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    79,    80,    17,    -1,    19,    -1,    -1,    -1,    23,
      -1,    -1,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
      -1,    35,    36,    -1,    38,    -1,    -1,    -1,    42,    -1,
      -1,    45,    -1,    -1,    -1,    49,   114,    51,    -1,    -1,
      -1,    -1,    -1,    57,    58,    59,    60,    -1,    -1,    63,
      64,    65,    -1,    -1,    -1,    -1,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,    79,    80,    17,    -1,    19,
      -1,    -1,    -1,    23,    -1,    -1,    90,    91,    92,    93,
      -1,    -1,    -1,    -1,    -1,    35,    36,    -1,    38,    -1,
      -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,
     114,    51,    -1,    -1,    -1,    -1,    -1,    57,    58,    59,
      60,    -1,    -1,    63,    64,     6,    -1,    -1,    -1,    -1,
      70,    -1,    13,    -1,    -1,    -1,    17,    -1,    19,    79,
      80,    -1,    23,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      90,    91,    92,    93,    35,    36,    -1,    38,    -1,    -1,
      -1,    42,    -1,    -1,    45,    -1,    -1,    -1,    49,    -1,
      51,    -1,    -1,    -1,   114,    -1,    57,    58,    59,    60,
      -1,    -1,    63,    64,    65,    -1,    -1,    -1,    -1,     6,
      -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    79,    80,
      17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    -1,    35,    36,
      -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,
      -1,    -1,    49,   114,    51,    -1,    -1,    -1,    -1,    -1,
      57,    58,    59,    60,    -1,    -1,    63,    64,     6,    -1,
      -1,    -1,    -1,    70,    -1,    13,    -1,    -1,    -1,    17,
      -1,    19,    79,    80,    -1,    23,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    90,    91,    92,    93,    35,    36,    -1,
      38,    -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,
      -1,    49,    -1,    51,    -1,    -1,    -1,   114,    -1,    57,
      58,    59,    60,    -1,    -1,    63,    64,     6,    -1,    -1,
      -1,    -1,    -1,    -1,    13,    -1,    -1,    -1,    17,    -1,
      19,    79,    80,    -1,    23,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    90,    91,    92,    93,    35,    36,    -1,    38,
      -1,    -1,    -1,    42,    -1,    -1,    45,    -1,    -1,    -1,
      49,    -1,    51,    -1,    -1,    -1,   114,    -1,    57,    58,
      59,    60,    -1,    -1,    63,    64,    -1,    -1,    -1,    -1,
      -1,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,
      79,    80,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,
      -1,    90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,
      35,    36,    -1,    38,    39,    -1,    -1,    42,    -1,    -1,
      45,    -1,    -1,    -1,    49,   114,    51,    -1,    -1,    -1,
      55,    -1,    57,    58,    59,    60,    -1,    -1,    63,    64,
      -1,     6,    -1,    -1,    -1,    70,    -1,    -1,    13,    -1,
      -1,    -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,
      -1,    -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,
      35,    36,    -1,    38,    39,    -1,    -1,    42,    -1,    -1,
      45,    -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,
      55,    -1,    57,    58,    59,    60,    -1,    -1,    63,    64,
       6,    -1,    -1,    -1,    -1,    70,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,    -1,   114,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    65,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,
      -1,    17,    -1,    19,    -1,    -1,    -1,    23,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    35,
      36,    -1,    38,    -1,    -1,    -1,    42,    -1,    -1,    45,
      -1,    -1,    -1,    49,    -1,    51,    -1,    -1,   114,    -1,
      -1,    57,    58,    59,    60,    -1,    -1,    63,    64,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    90,    91,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   114
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,    16,    26,    41,    43,   116,   117,   118,   119,   120,
     121,   122,   123,   114,   277,     0,   119,    43,   122,    34,
      54,    66,    78,   124,   127,   128,   130,   277,   258,   259,
     277,   114,   271,   274,   276,   277,    13,    19,    23,    35,
      36,    38,    41,    42,    45,    49,    66,    67,    70,   120,
     123,   124,   131,   132,   133,   134,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   162,   163,   164,   165,   166,
     172,   254,   255,   256,   277,   125,   263,   277,   127,   128,
     130,   128,   130,   130,   124,   127,   128,   130,    72,    78,
     265,    71,   129,    72,   172,   114,   149,   276,     4,     5,
       6,     8,    10,    13,    17,    18,    22,    31,    39,    42,
      51,    52,    55,    56,    57,    58,    59,    60,    63,    64,
      67,    70,    90,    91,   114,   120,   140,   155,   156,   172,
     173,   174,   175,   176,   177,   178,   179,   181,   182,   183,
     184,   185,   186,   187,   189,   190,   192,   194,   200,   202,
     203,   204,   205,   206,   209,   210,   211,   213,   214,   218,
     219,   220,   223,   224,   230,   231,   246,   247,   249,   250,
     251,   253,   254,   257,   258,   259,   260,   261,   271,   272,
     273,   275,   276,   277,   278,   279,   140,   148,   165,   166,
     277,    67,   132,   135,   137,   138,   149,   276,    68,   262,
      72,   262,   262,    70,   161,   172,    27,    66,   157,   167,
      64,   265,    77,    71,   126,    34,   264,   128,   130,   130,
     130,   127,   128,   130,   128,   130,   130,   277,    13,    81,
     254,   257,   259,   261,   266,   268,   269,   277,   271,   276,
     157,    64,    70,   276,    64,   215,   253,   258,   265,   276,
      13,    64,    79,    80,    92,    93,   213,   220,   228,   229,
     230,   233,   234,   235,   236,   237,   238,   239,   240,   241,
     242,   243,   244,   245,   246,   247,   248,   249,   250,   251,
     252,   254,   276,   277,    64,    68,    72,   212,    70,   276,
     228,    70,   228,    72,    72,    74,    64,   228,   228,   218,
     219,   245,   272,   245,   156,   178,   277,    67,   174,    70,
     135,   276,    70,    72,    74,    68,    76,   103,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   113,   232,    90,
      91,   262,    72,   212,    74,   262,    74,   262,    74,    72,
     212,    64,    68,    72,    74,    64,    72,    82,   265,   135,
     161,   157,   167,    64,    70,    71,   135,   136,    76,   157,
     262,    69,   277,   158,   160,   259,   260,    17,    51,    67,
     168,   173,   209,   265,   272,   167,    65,   140,   150,   151,
     153,   154,   155,   263,   258,   260,   130,   128,   130,   130,
     130,   265,    34,    51,   270,    77,    71,   266,   267,   129,
      65,   150,   151,    70,    70,   177,   185,   196,   198,    64,
      68,   225,   226,   227,   225,   215,    72,   216,   253,   257,
     245,   245,   245,   245,    70,    82,    81,    89,    88,    97,
      98,    96,    84,    87,    30,    77,    78,    85,    86,   100,
     101,   102,    92,    93,    94,    95,    99,   228,    69,    43,
      68,    72,    70,    70,    70,    43,   265,   276,   265,   276,
     228,    70,    65,   135,     6,   214,   265,   276,   265,   276,
     228,   228,    43,    72,   265,   276,     6,   265,     6,    17,
      43,    51,   265,   276,    72,    65,   221,   228,   228,   214,
     265,   265,   276,    65,   221,   276,   179,    70,   167,    65,
     150,   151,   137,    71,    64,   139,   169,   228,   212,   265,
      71,   159,    64,    64,    67,   173,    67,    72,    17,    51,
      72,    17,    75,   138,   276,    71,    65,    71,   152,   140,
     126,   130,   257,   257,   268,    71,   262,    71,    65,    70,
     228,    82,    71,   199,    70,    65,   221,   228,   262,   227,
     262,    64,   276,   217,   265,    65,    65,   228,   228,   235,
     236,   237,   238,   239,   240,   240,    13,   177,   207,   208,
     254,   257,   277,   242,   242,   242,   242,   243,   243,   243,
     244,   244,   245,   245,   245,    65,    69,    43,   276,    64,
     276,    65,   276,    64,    69,    43,   276,     6,    72,    74,
     276,    64,    43,    65,    71,   222,    69,   276,   276,    65,
      71,    65,   137,    65,    71,   139,   170,   228,   160,    71,
      65,   221,    65,   221,    67,    51,   265,    64,    64,    51,
     265,   276,    72,    65,   140,   151,   153,    71,    75,   138,
     268,    65,   151,   262,    65,   197,   198,    70,   228,   185,
      71,    70,   228,   130,    65,    69,    65,   221,   245,   248,
      70,    82,     5,    10,    52,   179,   180,   181,   188,   191,
     193,   195,   201,    64,    65,   221,   179,    64,    65,   221,
     265,   276,   265,   276,    64,    65,   221,   228,    71,    64,
      65,   151,    65,    71,   171,    65,    71,   160,    70,    65,
      70,    65,    64,    51,    65,   221,    65,   221,    64,    51,
      17,    65,   153,   276,   262,    65,   179,    65,    65,   197,
      65,   185,    65,   197,    70,   130,   130,    65,   233,    64,
      64,    64,    24,    65,   221,    65,    65,   221,    65,   276,
      64,   276,    65,   221,    65,   228,    65,   221,    65,   139,
      71,    65,    70,    70,    65,   221,    64,    70,    65,    70,
      65,    65,   221,    64,   262,   179,   179,    65,   179,   179,
      65,    65,   197,   130,    70,   177,   196,   228,   228,   179,
      65,    65,    64,    65,   221,    65,    65,   139,    70,    65,
      65,   221,    70,    70,    70,    65,    65,   221,   179,   179,
     179,    65,    70,   228,    82,    70,    65,    65,    65,   221,
      65,    70,    70,    65,    70,    70,    65,   179,    65,   197,
      70,   228,    70,   228,   180,   180,    65,    70,    70,   180,
      65,    65,   197,    65,    65,   197,    70,    24,   180,   180,
      65,   180,   180,    65,    65,   197,   180,   180,   180,   180,
      65,   180
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   115,   116,   117,   118,   118,   119,   120,   121,   121,
     121,   121,   121,   121,   121,   121,   121,   121,   121,   121,
     121,   121,   121,   121,   122,   122,   122,   123,   123,   124,
     125,   125,   126,   126,   127,   128,   128,   129,   129,   130,
     130,   131,   131,   132,   132,   132,   132,   133,   133,   133,
     133,   134,   134,   135,   135,   136,   136,   137,   137,   138,
     138,   139,   139,   140,   140,   141,   141,   142,   142,   142,
     143,   144,   144,   144,   144,   145,   146,   146,   146,   147,
     147,   148,   148,   148,   148,   149,   149,   149,   149,   149,
     149,   149,   149,   150,   150,   151,   151,   152,   152,   153,
     153,   153,   154,   154,   155,   155,   156,   157,   158,   158,
     159,   159,   160,   160,   161,   161,   162,   163,   164,   164,
     164,   164,   165,   165,   165,   165,   165,   165,   165,   165,
     166,   167,   167,   167,   167,   168,   168,   168,   168,   168,
     168,   168,   168,   168,   168,   168,   168,   168,   168,   168,
     168,   169,   169,   169,   169,   170,   170,   171,   171,   172,
     172,   173,   173,   174,   174,   174,   175,   176,   177,   177,
     177,   177,   178,   178,   179,   179,   179,   179,   179,   179,
     180,   180,   180,   180,   181,   181,   181,   181,   181,   181,
     181,   181,   181,   182,   183,   184,   185,   185,   185,   185,
     185,   185,   185,   186,   187,   188,   189,   189,   190,   191,
     192,   192,   193,   193,   194,   194,   194,   194,   194,   194,
     194,   194,   195,   195,   195,   195,   195,   195,   195,   195,
     196,   196,   197,   198,   198,   199,   199,   200,   201,   202,
     202,   203,   204,   204,   205,   205,   206,   207,   208,   209,
     209,   210,   210,   210,   210,   210,   210,   210,   210,   210,
     210,   211,   211,   211,   211,   211,   211,   211,   212,   212,
     213,   213,   213,   214,   214,   214,   214,   214,   214,   214,
     214,   215,   215,   215,   215,   216,   217,   218,   218,   218,
     219,   219,   220,   220,   220,   220,   220,   220,   220,   220,
     220,   220,   220,   220,   220,   220,   220,   220,   220,   220,
     220,   220,   220,   220,   221,   221,   222,   222,   223,   223,
     223,   223,   223,   223,   223,   223,   223,   223,   223,   223,
     223,   224,   224,   224,   224,   225,   226,   226,   227,   228,
     229,   229,   230,   231,   231,   231,   232,   232,   232,   232,
     232,   232,   232,   232,   232,   232,   232,   232,   233,   233,
     234,   234,   235,   235,   236,   236,   237,   237,   238,   238,
     239,   239,   239,   240,   240,   240,   240,   240,   240,   241,
     241,   242,   242,   242,   242,   243,   243,   243,   244,   244,
     244,   244,   245,   245,   245,   245,   245,   246,   247,   248,
     248,   248,   248,   249,   249,   249,   249,   250,   251,   252,
     252,   253,   253,   254,   254,   255,   255,   255,   255,   255,
     256,   256,   257,   257,   257,   258,   259,   259,   259,   259,
     260,   261,   261,   261,   262,   262,   263,   263,   264,   264,
     265,   266,   266,   267,   267,   268,   268,   269,   269,   270,
     270,   271,   271,   272,   272,   273,   274,   274,   275,   275,
     276,   277,   278,   279,   279,   279,   279,   279
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     1,     2,     1,     1,     5,     6,
       4,     5,     4,     5,     3,     4,     6,     7,     5,     6,
       5,     6,     4,     5,     1,     1,     1,     2,     1,     3,
       2,     1,     2,     3,     2,     3,     2,     2,     3,     3,
       2,     1,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     4,     3,     1,     2,     2,     3,     3,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     2,     4,     1,     3,     1,     2,     2,     2,     3,
       2,     2,     3,     2,     3,     5,     3,     6,     4,     6,
       4,     7,     5,     2,     4,     2,     1,     2,     3,     3,
       2,     1,     3,     4,     1,     2,     1,     2,     2,     1,
       2,     3,     1,     1,     1,     1,     1,     2,     2,     3,
       3,     4,     3,     4,     5,     6,     4,     5,     6,     7,
       1,     2,     3,     3,     4,     4,     5,     5,     6,     6,
       4,     5,     5,     8,     7,     7,     6,     6,     7,     7,
       8,     3,     2,     4,     3,     1,     2,     2,     3,     3,
       2,     2,     1,     1,     1,     1,     1,     2,     1,     2,
       2,     3,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     2,     1,     1,     1,     1,
       1,     1,     1,     5,     7,     7,     3,     5,     5,     5,
       1,     1,     1,     1,     6,     7,     7,     8,     7,     8,
       8,     9,     6,     7,     7,     8,     7,     8,     8,     9,
       1,     1,     1,     1,     2,     2,     3,     7,     7,     3,
       2,     3,     2,     3,     2,     3,     3,     1,     1,     1,
       1,     1,     1,     1,     3,     3,     1,     1,     1,     1,
       1,     3,     3,     3,     3,     4,     4,     4,     2,     3,
       1,     3,     3,     4,     5,     5,     6,     5,     6,     6,
       7,     2,     3,     2,     3,     2,     1,     3,     3,     5,
       4,     4,     3,     4,     5,     6,     6,     7,     3,     6,
       4,     7,     5,     6,     6,     7,     5,     6,     6,     7,
       7,     8,     8,     9,     1,     2,     2,     3,     3,     4,
       3,     3,     3,     4,     3,     4,     5,     6,     3,     4,
       3,     3,     3,     4,     4,     1,     1,     2,     3,     1,
       1,     1,     3,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     5,
       1,     3,     1,     3,     1,     3,     1,     3,     1,     3,
       1,     3,     3,     1,     3,     3,     3,     3,     1,     3,
       3,     1,     3,     3,     3,     1,     3,     3,     1,     3,
       3,     3,     1,     1,     2,     2,     1,     2,     2,     1,
       2,     2,     1,     1,     1,     1,     1,     2,     2,     4,
       4,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     2,     3,     4,
       1,     2,     2,     2,     2,     3,     1,     2,     2,     2,
       3,     2,     1,     2,     3,     1,     1,     1,     2,     2,
       2,     1,     1,     1,     3,     1,     1,     3,     1,     3,
       1,     1,     1,     1,     1,     1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
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

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



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

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
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
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
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
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
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


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
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
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
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
            /* Fall through.  */
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

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
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
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
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
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
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
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
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
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

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

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
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

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

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
| yyreduce -- Do a reduction.  |
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
      
#line 2936 "parser.tab.c" /* yacc.c:1646  */
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
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
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

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

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

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
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
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
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
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 830 "parser.y" /* yacc.c:1906  */




int main(int argc , char** argv){
    #ifdef YYDEBUG 
        yydebug = 1; 
    #endif

    ++argv, --argc; 
    if ( argc > 0 )yyin = fopen( argv[0], "r" );
    else yyin = stdin;
    yyparse();
    return 0;
}
