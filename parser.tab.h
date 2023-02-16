/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

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
    abstract = 258,
    Continue = 259,
    for = 260,
    new = 261,
    switch = 262,
    assert = 263,
    default = 264,
    if = 265,
    package = 266,
    synchronized = 267,
    boolean = 268,
    do = 269,
    goto = 270,
    private = 271,
    this = 272,
    break = 273,
    double = 274,
    implements = 275,
    protected = 276,
    throw = 277,
    byte = 278,
    else = 279,
    import = 280,
    public = 281,
    throws = 282,
    case = 283,
    enum = 284,
    instanceof = 285,
    return = 286,
    transient = 287,
    catch = 288,
    extends = 289,
    int = 290,
    short = 291,
    try = 292,
    char = 293,
    final = 294,
    interface = 295,
    static = 296,
    void = 297,
    class = 298,
    finally = 299,
    long = 300,
    strictfp = 301,
    volatile = 302,
    const = 303,
    float = 304,
    native = 305,
    super = 306,
    while = 307,
    underscore = 308,
    exports = 309,
    opens = 310,
    requires = 311,
    uses = 312,
    module = 313,
    permits = 314,
    sealed = 315,
    var = 316,
    provides = 318,
    to = 319,
    with = 320,
    open = 321,
    record = 322,
    transitive = 323,
    yield = 324,
    CharacterLiteral = 325,
    BooleanLiteral = 326,
    IntegerLiteral = 327,
    FloatingPointLiteral = 328,
    StringLiteral = 329,
    TextBlock = 330,
    NullLiteral = 331,
    LeftParenthesis = 332,
    RightParenthesis = 333,
    LeftCurlyBrace = 334,
    RightCurlyBrace = 335,
    LeftSquareBracket = 336,
    RightSquareBracket = 337,
    Semicolon = 338,
    Comma = 339,
    Dot = 340,
    AtSign = 341,
    Scope = 342,
    ellipsis = 343,
    ASSIGN = 344,
    GT = 345,
    LT = 346,
    EXCLAMATION = 347,
    TILDE = 348,
    QUESTIONMARK = 349,
    COLON = 350,
    ARROW = 351,
    EQUAL = 352,
    GE = 353,
    LE = 354,
    NOTEQUAL = 355,
    AND = 356,
    OR = 357,
    INC = 358,
    DEC = 359,
    ADD = 360,
    SUB = 361,
    MUL = 362,
    DIV = 363,
    BITAND = 364,
    BITOR = 365,
    CARET = 366,
    MOD = 367,
    LSHIFT = 368,
    RSHIFT = 369,
    URSHIFT = 370,
    ADD_ASSIGN = 371,
    SUB_ASSIGN = 372,
    MUL_ASSIGN = 373,
    DIV_ASSIGN = 374,
    AND_ASSIGN = 375,
    OR_ASSIGN = 376,
    XOR_ASSIGN = 377,
    MOD_ASSIGN = 378,
    LSHIFT_ASSIGN = 379,
    RSHIFT_ASSIGN = 380,
    URSHIFT_ASSIGN = 381,
    IdentifierChars = 382
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 26 "parser.y" /* yacc.c:1909  */

    char* str;
    int num;
    float float_val;
    char sym;

#line 188 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
