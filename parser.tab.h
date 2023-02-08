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
    IDENTIFIER = 258,
    ABSTRACT = 259,
    CONTINUE = 260,
    FOR = 261,
    NEW = 262,
    SWITCH = 263,
    ASSERT = 264,
    DEFAULT = 265,
    IF = 266,
    PACKAGE = 267,
    SYNCHRONIZED = 268,
    BOOLEAN = 269,
    DO = 270,
    GOTO = 271,
    PRIVATE = 272,
    THIS = 273,
    BREAK = 274,
    DOUBLE = 275,
    IMPLEMENTS = 276,
    PROTECTED = 277,
    THROW = 278,
    BYTE = 279,
    ELSE = 280,
    IMPORT = 281,
    PUBLIC = 282,
    THROWS = 283,
    CASE = 284,
    ENUM = 285,
    INSTANCEOF = 286,
    RETURN = 287,
    TRANSIENT = 288,
    CATCH = 289,
    EXTENDS = 290,
    INT = 291,
    SHORT = 292,
    TRY = 293,
    CHAR = 294,
    FINAL = 295,
    INTERFACE = 296,
    STATIC = 297,
    VOID = 298,
    CLASS = 299,
    FINALLY = 300,
    LONG = 301,
    STRICTFP = 302,
    VOLATILE = 303,
    CONST = 304,
    FLOAT = 305,
    NATIVE = 306,
    SUPER = 307,
    WHILE = 308,
    UNDERSCORE = 309,
    EXPORTS = 310,
    OPENS = 311,
    REQUIRES = 312,
    USES = 313,
    MODULE = 314,
    PERMITS = 315,
    SEALED = 316,
    VAR = 317,
    PROVIDES = 319,
    TO = 320,
    WITH = 321,
    OPEN = 322,
    RECORD = 323,
    TRANSITIVE = 324,
    YIELD = 325
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 46 "parser.y" /* yacc.c:1909  */

    char* str;
    int num;
    float float_val;
    char sym;

#line 131 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
