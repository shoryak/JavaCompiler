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
    abstract = 258,                /* abstract  */
    continue = 259,                /* continue  */
    for = 260,                     /* for  */
    new = 261,                     /* new  */
    switch = 262,                  /* switch  */
    assert = 263,                  /* assert  */
    default = 264,                 /* default  */
    if = 265,                      /* if  */
    package = 266,                 /* package  */
    synchronized = 267,            /* synchronized  */
    boolean = 268,                 /* boolean  */
    do = 269,                      /* do  */
    goto = 270,                    /* goto  */
    private = 271,                 /* private  */
    this = 272,                    /* this  */
    break = 273,                   /* break  */
    double = 274,                  /* double  */
    implements = 275,              /* implements  */
    protected = 276,               /* protected  */
    throw = 277,                   /* throw  */
    byte = 278,                    /* byte  */
    else = 279,                    /* else  */
    import = 280,                  /* import  */
    public = 281,                  /* public  */
    throws = 282,                  /* throws  */
    case = 283,                    /* case  */
    enum = 284,                    /* enum  */
    instanceof = 285,              /* instanceof  */
    return = 286,                  /* return  */
    transient = 287,               /* transient  */
    catch = 288,                   /* catch  */
    extends = 289,                 /* extends  */
    int = 290,                     /* int  */
    short = 291,                   /* short  */
    try = 292,                     /* try  */
    char = 293,                    /* char  */
    final = 294,                   /* final  */
    interface = 295,               /* interface  */
    static = 296,                  /* static  */
    void = 297,                    /* void  */
    class = 298,                   /* class  */
    finally = 299,                 /* finally  */
    long = 300,                    /* long  */
    strictfp = 301,                /* strictfp  */
    volatile = 302,                /* volatile  */
    const = 303,                   /* const  */
    float = 304,                   /* float  */
    native = 305,                  /* native  */
    super = 306,                   /* super  */
    while = 307,                   /* while  */
    underscore = 308,              /* underscore  */
    exports = 309,                 /* exports  */
    opens = 310,                   /* opens  */
    requires = 311,                /* requires  */
    uses = 312,                    /* uses  */
    module = 313,                  /* module  */
    permits = 314,                 /* permits  */
    sealed = 315,                  /* sealed  */
    var = 316,                     /* var  */
    provides = 318,                /* provides  */
    to = 319,                      /* to  */
    with = 320,                    /* with  */
    open = 321,                    /* open  */
    record = 322,                  /* record  */
    transitive = 323,              /* transitive  */
    yield = 324,                   /* yield  */
    CharacterLiteral = 325,        /* CharacterLiteral  */
    BooleanLiteral = 326,          /* BooleanLiteral  */
    IntegerLiteral = 327,          /* IntegerLiteral  */
    FloatingPointLiteral = 328,    /* FloatingPointLiteral  */
    StringLiteral = 329,           /* StringLiteral  */
    TextBlock = 330,               /* TextBlock  */
    NullLiteral = 331,             /* NullLiteral  */
    LeftParenthesis = 332,         /* LeftParenthesis  */
    RightParenthesis = 333,        /* RightParenthesis  */
    LeftCurlyBrace = 334,          /* LeftCurlyBrace  */
    RightCurlyBrace = 335,         /* RightCurlyBrace  */
    LeftSquareBracket = 336,       /* LeftSquareBracket  */
    RightSquareBracket = 337,      /* RightSquareBracket  */
    Semicolon = 338,               /* Semicolon  */
    Comma = 339,                   /* Comma  */
    Dot = 340,                     /* Dot  */
    AtSign = 341,                  /* AtSign  */
    Scope = 342,                   /* Scope  */
    ellipsis = 343,                /* ellipsis  */
    ASSIGN = 344,                  /* ASSIGN  */
    GT = 345,                      /* GT  */
    LT = 346,                      /* LT  */
    EXCLAMATION = 347,             /* EXCLAMATION  */
    TILDE = 348,                   /* TILDE  */
    QUESTIONMARK = 349,            /* QUESTIONMARK  */
    COLON = 350,                   /* COLON  */
    ARROW = 351,                   /* ARROW  */
    EQUAL = 352,                   /* EQUAL  */
    GE = 353,                      /* GE  */
    LE = 354,                      /* LE  */
    NOTEQUAL = 355,                /* NOTEQUAL  */
    AND = 356,                     /* AND  */
    OR = 357,                      /* OR  */
    INC = 358,                     /* INC  */
    DEC = 359,                     /* DEC  */
    ADD = 360,                     /* ADD  */
    SUB = 361,                     /* SUB  */
    MUL = 362,                     /* MUL  */
    DIV = 363,                     /* DIV  */
    BITAND = 364,                  /* BITAND  */
    BITOR = 365,                   /* BITOR  */
    CARET = 366,                   /* CARET  */
    MOD = 367,                     /* MOD  */
    LSHIFT = 368,                  /* LSHIFT  */
    RSHIFT = 369,                  /* RSHIFT  */
    URSHIFT = 370,                 /* URSHIFT  */
    ADD_ASSIGN = 371,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 372,              /* SUB_ASSIGN  */
    MUL_ASSIGN = 373,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 374,              /* DIV_ASSIGN  */
    AND_ASSIGN = 375,              /* AND_ASSIGN  */
    OR_ASSIGN = 376,               /* OR_ASSIGN  */
    XOR_ASSIGN = 377,              /* XOR_ASSIGN  */
    MOD_ASSIGN = 378,              /* MOD_ASSIGN  */
    LSHIFT_ASSIGN = 379,           /* LSHIFT_ASSIGN  */
    RSHIFT_ASSIGN = 380,           /* RSHIFT_ASSIGN  */
    URSHIFT_ASSIGN = 381,          /* URSHIFT_ASSIGN  */
    IdentifierChars = 382          /* IdentifierChars  */
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

#line 197 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
