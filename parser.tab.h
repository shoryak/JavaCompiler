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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
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
    Abstract = 258,                /* Abstract  */
    Continue = 259,                /* Continue  */
    For = 260,                     /* For  */
    New = 261,                     /* New  */
    Switch = 262,                  /* Switch  */
    Assert = 263,                  /* Assert  */
    Default = 264,                 /* Default  */
    If = 265,                      /* If  */
    Package = 266,                 /* Package  */
    Synchronized = 267,            /* Synchronized  */
    Boolean = 268,                 /* Boolean  */
    Do = 269,                      /* Do  */
    Goto = 270,                    /* Goto  */
    Private = 271,                 /* Private  */
    This = 272,                    /* This  */
    Break = 273,                   /* Break  */
    Double = 274,                  /* Double  */
    Implements = 275,              /* Implements  */
    Protected = 276,               /* Protected  */
    Throw = 277,                   /* Throw  */
    Byte = 278,                    /* Byte  */
    Else = 279,                    /* Else  */
    Import = 280,                  /* Import  */
    Public = 281,                  /* Public  */
    Throws_key = 282,              /* Throws_key  */
    Case = 283,                    /* Case  */
    Enum = 284,                    /* Enum  */
    Instanceof = 285,              /* Instanceof  */
    Return = 286,                  /* Return  */
    Transient = 287,               /* Transient  */
    Catch = 288,                   /* Catch  */
    Extends = 289,                 /* Extends  */
    Int = 290,                     /* Int  */
    Short = 291,                   /* Short  */
    Try = 292,                     /* Try  */
    Char = 293,                    /* Char  */
    Final = 294,                   /* Final  */
    Interface = 295,               /* Interface  */
    Static = 296,                  /* Static  */
    Void = 297,                    /* Void  */
    Class = 298,                   /* Class  */
    Finally = 299,                 /* Finally  */
    Long = 300,                    /* Long  */
    Strictfp = 301,                /* Strictfp  */
    Volatile = 302,                /* Volatile  */
    Const = 303,                   /* Const  */
    Float = 304,                   /* Float  */
    Native = 305,                  /* Native  */
    Super = 306,                   /* Super  */
    While = 307,                   /* While  */
    Underscore = 308,              /* Underscore  */
    Permits = 309,                 /* Permits  */
    Var = 310,                     /* Var  */
    Yield = 311,                   /* Yield  */
    CharacterLiteral = 312,        /* CharacterLiteral  */
    BooleanLiteral = 313,          /* BooleanLiteral  */
    IntegerLiteral = 314,          /* IntegerLiteral  */
    FloatingPointLiteral = 315,    /* FloatingPointLiteral  */
    StringLiteral = 316,           /* StringLiteral  */
    TextBlock = 317,               /* TextBlock  */
    NullLiteral = 318,             /* NullLiteral  */
    LeftParenthesis = 319,         /* LeftParenthesis  */
    RightParenthesis = 320,        /* RightParenthesis  */
    LeftCurlyBrace = 321,          /* LeftCurlyBrace  */
    RightCurlyBrace = 322,         /* RightCurlyBrace  */
    LeftSquareBracket = 323,       /* LeftSquareBracket  */
    RightSquareBracket = 324,      /* RightSquareBracket  */
    Semicolon = 325,               /* Semicolon  */
    Comma = 326,                   /* Comma  */
    Dot = 327,                     /* Dot  */
    AtSign = 328,                  /* AtSign  */
    Scope = 329,                   /* Scope  */
    ellipsis = 330,                /* ellipsis  */
    ASSIGN = 331,                  /* ASSIGN  */
    GT = 332,                      /* GT  */
    LT = 333,                      /* LT  */
    EXCLAMATION = 334,             /* EXCLAMATION  */
    TILDE = 335,                   /* TILDE  */
    QUESTIONMARK = 336,            /* QUESTIONMARK  */
    COLON = 337,                   /* COLON  */
    ARROW = 338,                   /* ARROW  */
    EQUAL = 339,                   /* EQUAL  */
    GE = 340,                      /* GE  */
    LE = 341,                      /* LE  */
    NOTEQUAL = 342,                /* NOTEQUAL  */
    AND = 343,                     /* AND  */
    OR = 344,                      /* OR  */
    INC = 345,                     /* INC  */
    DEC = 346,                     /* DEC  */
    ADD = 347,                     /* ADD  */
    SUB = 348,                     /* SUB  */
    MUL = 349,                     /* MUL  */
    DIV = 350,                     /* DIV  */
    BITAND = 351,                  /* BITAND  */
    BITOR = 352,                   /* BITOR  */
    CARET = 353,                   /* CARET  */
    MOD = 354,                     /* MOD  */
    LSHIFT = 355,                  /* LSHIFT  */
    RSHIFT = 356,                  /* RSHIFT  */
    URSHIFT = 357,                 /* URSHIFT  */
    ADD_ASSIGN = 358,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 359,              /* SUB_ASSIGN  */
    MUL_ASSIGN = 360,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 361,              /* DIV_ASSIGN  */
    AND_ASSIGN = 362,              /* AND_ASSIGN  */
    OR_ASSIGN = 363,               /* OR_ASSIGN  */
    XOR_ASSIGN = 364,              /* XOR_ASSIGN  */
    MOD_ASSIGN = 365,              /* MOD_ASSIGN  */
    LSHIFT_ASSIGN = 366,           /* LSHIFT_ASSIGN  */
    RSHIFT_ASSIGN = 367,           /* RSHIFT_ASSIGN  */
    URSHIFT_ASSIGN = 368,          /* URSHIFT_ASSIGN  */
    IdentifierChars = 369          /* IdentifierChars  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 26 "parser.y"

    char* str;
    int num;
    float float_val;
    char sym;

#line 185 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
