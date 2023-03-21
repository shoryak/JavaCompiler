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
/* "%code requires" blocks.  */
#line 1130 "parser.y"

    #include <vector>
    #include <cstdio>
    #include <cstring>
    struct Node;
    Node* createNode(const char* value, std::vector<Node*> children);
    Node* createNode(const char* value);
    Node* createNode(const char* value, std::string lexeme, std::string type);
    int buildTree(Node*, int parentno , int co);

#line 60 "parser.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ABSTRACT = 258,                /* ABSTRACT  */
    CONTINUE = 259,                /* CONTINUE  */
    FOR = 260,                     /* FOR  */
    NEW = 261,                     /* NEW  */
    SWITCH = 262,                  /* SWITCH  */
    ASSERT = 263,                  /* ASSERT  */
    DEFAULT = 264,                 /* DEFAULT  */
    IF = 265,                      /* IF  */
    PACKAGE = 266,                 /* PACKAGE  */
    SYNCHRONIZED = 267,            /* SYNCHRONIZED  */
    BOOLEAN = 268,                 /* BOOLEAN  */
    DO = 269,                      /* DO  */
    GOTO = 270,                    /* GOTO  */
    PRIVATE = 271,                 /* PRIVATE  */
    THIS = 272,                    /* THIS  */
    BREAK = 273,                   /* BREAK  */
    DOUBLE = 274,                  /* DOUBLE  */
    IMPLEMENTS = 275,              /* IMPLEMENTS  */
    PROTECTED = 276,               /* PROTECTED  */
    THROW = 277,                   /* THROW  */
    BYTE = 278,                    /* BYTE  */
    ELSE = 279,                    /* ELSE  */
    IMPORT = 280,                  /* IMPORT  */
    PUBLIC = 281,                  /* PUBLIC  */
    THROWS = 282,                  /* THROWS  */
    CASE = 283,                    /* CASE  */
    ENUM = 284,                    /* ENUM  */
    INSTANCEOF = 285,              /* INSTANCEOF  */
    RETURN = 286,                  /* RETURN  */
    TRANSIENT = 287,               /* TRANSIENT  */
    CATCH = 288,                   /* CATCH  */
    EXTENDS = 289,                 /* EXTENDS  */
    INT = 290,                     /* INT  */
    SHORT = 291,                   /* SHORT  */
    TRY = 292,                     /* TRY  */
    CHAR = 293,                    /* CHAR  */
    FINAL = 294,                   /* FINAL  */
    INTERFACE = 295,               /* INTERFACE  */
    STATIC = 296,                  /* STATIC  */
    VOID = 297,                    /* VOID  */
    CLASS = 298,                   /* CLASS  */
    FINALLY = 299,                 /* FINALLY  */
    LONG = 300,                    /* LONG  */
    STRICTFP = 301,                /* STRICTFP  */
    VOLATILE = 302,                /* VOLATILE  */
    CONST = 303,                   /* CONST  */
    FLOAT = 304,                   /* FLOAT  */
    NATIVE = 305,                  /* NATIVE  */
    SUPER = 306,                   /* SUPER  */
    WHILE = 307,                   /* WHILE  */
    UNDERSCORE = 308,              /* UNDERSCORE  */
    EXPORTS = 309,                 /* EXPORTS  */
    OPENS = 310,                   /* OPENS  */
    REQUIRES = 311,                /* REQUIRES  */
    USES = 312,                    /* USES  */
    MODULE = 313,                  /* MODULE  */
    PERMITS = 314,                 /* PERMITS  */
    SEALED = 315,                  /* SEALED  */
    VAR = 316,                     /* VAR  */
    PROVIDES = 317,                /* PROVIDES  */
    TO = 318,                      /* TO  */
    WITH = 319,                    /* WITH  */
    OPEN = 320,                    /* OPEN  */
    RECORD = 321,                  /* RECORD  */
    TRANSITIVE = 322,              /* TRANSITIVE  */
    YIELD = 323,                   /* YIELD  */
    CharacterLiteral = 324,        /* CharacterLiteral  */
    BooleanLiteral = 325,          /* BooleanLiteral  */
    IntegerLiteral = 326,          /* IntegerLiteral  */
    FloatingPointLiteral = 327,    /* FloatingPointLiteral  */
    StringLiteral = 328,           /* StringLiteral  */
    TextBlock = 329,               /* TextBlock  */
    NullLiteral = 330,             /* NullLiteral  */
    LeftParenthesis = 331,         /* LeftParenthesis  */
    RightParenthesis = 332,        /* RightParenthesis  */
    LeftCurlyBrace = 333,          /* LeftCurlyBrace  */
    RightCurlyBrace = 334,         /* RightCurlyBrace  */
    LeftSquareBracket = 335,       /* LeftSquareBracket  */
    RightSquareBracket = 336,      /* RightSquareBracket  */
    Semicolon = 337,               /* Semicolon  */
    Comma = 338,                   /* Comma  */
    Dot = 339,                     /* Dot  */
    AtSign = 340,                  /* AtSign  */
    Scope = 341,                   /* Scope  */
    ellipsis = 342,                /* ellipsis  */
    ASSIGN = 343,                  /* ASSIGN  */
    GT = 344,                      /* GT  */
    LT = 345,                      /* LT  */
    EXCLAMATION = 346,             /* EXCLAMATION  */
    TILDE = 347,                   /* TILDE  */
    QUESTIONMARK = 348,            /* QUESTIONMARK  */
    COLON = 349,                   /* COLON  */
    ARROW = 350,                   /* ARROW  */
    EQUAL = 351,                   /* EQUAL  */
    GE = 352,                      /* GE  */
    LE = 353,                      /* LE  */
    NOTEQUAL = 354,                /* NOTEQUAL  */
    AND = 355,                     /* AND  */
    OR = 356,                      /* OR  */
    INC = 357,                     /* INC  */
    DEC = 358,                     /* DEC  */
    ADD = 359,                     /* ADD  */
    SUB = 360,                     /* SUB  */
    MUL = 361,                     /* MUL  */
    DIV = 362,                     /* DIV  */
    BITAND = 363,                  /* BITAND  */
    BITOR = 364,                   /* BITOR  */
    CARET = 365,                   /* CARET  */
    MOD = 366,                     /* MOD  */
    LSHIFT = 367,                  /* LSHIFT  */
    RSHIFT = 368,                  /* RSHIFT  */
    URSHIFT = 369,                 /* URSHIFT  */
    ADD_ASSIGN = 370,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 371,              /* SUB_ASSIGN  */
    MUL_ASSIGN = 372,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 373,              /* DIV_ASSIGN  */
    AND_ASSIGN = 374,              /* AND_ASSIGN  */
    OR_ASSIGN = 375,               /* OR_ASSIGN  */
    XOR_ASSIGN = 376,              /* XOR_ASSIGN  */
    MOD_ASSIGN = 377,              /* MOD_ASSIGN  */
    LSHIFT_ASSIGN = 378,           /* LSHIFT_ASSIGN  */
    RSHIFT_ASSIGN = 379,           /* RSHIFT_ASSIGN  */
    URSHIFT_ASSIGN = 380,          /* URSHIFT_ASSIGN  */
    IdentifierChars = 381          /* IdentifierChars  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 1141 "parser.y"

    Node* node;
    char* str;
    int num;
    float float_val;
    char sym;

#line 211 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
