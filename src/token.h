/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 1005 "parser.y"

    #include <vector>
    #include <cstdio>
    #include <cstring>
    struct Node;
    Node* createNode(const char* value, std::vector<Node*> children);
    Node* createNode(const char* value);
    Node* createNode(const char* value, std::string lexeme, std::string type);
    int buildTree(Node*, int parentno , int co);

#line 59 "parser.tab.h"

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ABSTRACT = 258,
    CONTINUE = 259,
    FOR = 260,
    NEW = 261,
    SWITCH = 262,
    ASSERT = 263,
    DEFAULT = 264,
    IF = 265,
    PACKAGE = 266,
    SYNCHRONIZED = 267,
    BOOLEAN = 268,
    DO = 269,
    GOTO = 270,
    PRIVATE = 271,
    THIS = 272,
    BREAK = 273,
    DOUBLE = 274,
    IMPLEMENTS = 275,
    PROTECTED = 276,
    THROW = 277,
    BYTE = 278,
    ELSE = 279,
    IMPORT = 280,
    PUBLIC = 281,
    THROWS = 282,
    CASE = 283,
    ENUM = 284,
    INSTANCEOF = 285,
    RETURN = 286,
    TRANSIENT = 287,
    CATCH = 288,
    EXTENDS = 289,
    INT = 290,
    SHORT = 291,
    TRY = 292,
    CHAR = 293,
    FINAL = 294,
    INTERFACE = 295,
    STATIC = 296,
    VOID = 297,
    CLASS = 298,
    FINALLY = 299,
    LONG = 300,
    STRICTFP = 301,
    VOLATILE = 302,
    CONST = 303,
    FLOAT = 304,
    NATIVE = 305,
    SUPER = 306,
    WHILE = 307,
    UNDERSCORE = 308,
    EXPORTS = 309,
    OPENS = 310,
    REQUIRES = 311,
    USES = 312,
    MODULE = 313,
    PERMITS = 314,
    SEALED = 315,
    VAR = 316,
    PROVIDES = 317,
    TO = 318,
    WITH = 319,
    OPEN = 320,
    RECORD = 321,
    TRANSITIVE = 322,
    YIELD = 323,
    CharacterLiteral = 324,
    BooleanLiteral = 325,
    IntegerLiteral = 326,
    FloatingPointLiteral = 327,
    StringLiteral = 328,
    TextBlock = 329,
    NullLiteral = 330,
    LeftParenthesis = 331,
    RightParenthesis = 332,
    LeftCurlyBrace = 333,
    RightCurlyBrace = 334,
    LeftSquareBracket = 335,
    RightSquareBracket = 336,
    Semicolon = 337,
    Comma = 338,
    Dot = 339,
    AtSign = 340,
    Scope = 341,
    ellipsis = 342,
    ASSIGN = 343,
    GT = 344,
    LT = 345,
    EXCLAMATION = 346,
    TILDE = 347,
    QUESTIONMARK = 348,
    COLON = 349,
    ARROW = 350,
    EQUAL = 351,
    GE = 352,
    LE = 353,
    NOTEQUAL = 354,
    AND = 355,
    OR = 356,
    INC = 357,
    DEC = 358,
    ADD = 359,
    SUB = 360,
    MUL = 361,
    DIV = 362,
    BITAND = 363,
    BITOR = 364,
    CARET = 365,
    MOD = 366,
    LSHIFT = 367,
    RSHIFT = 368,
    URSHIFT = 369,
    ADD_ASSIGN = 370,
    SUB_ASSIGN = 371,
    MUL_ASSIGN = 372,
    DIV_ASSIGN = 373,
    AND_ASSIGN = 374,
    OR_ASSIGN = 375,
    XOR_ASSIGN = 376,
    MOD_ASSIGN = 377,
    LSHIFT_ASSIGN = 378,
    RSHIFT_ASSIGN = 379,
    URSHIFT_ASSIGN = 380,
    IdentifierChars = 381
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 1016 "parser.y"

    Node* node;
    char* str;
    int num;
    float float_val;
    char sym;

#line 205 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
