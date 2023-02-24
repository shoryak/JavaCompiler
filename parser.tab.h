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
#line 26 "parser.y" /* yacc.c:1909  */

    char* str;
    int num;
    float float_val;
    char sym;

#line 176 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
