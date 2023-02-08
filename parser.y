%{
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
%}

%union {
    char* str;
    int num;
    float float_val;
    char sym;
}

%token<str> IDENTIFIER
%token<str> ABSTRACT , CONTINUE,FOR,NEW,SWITCH,ASSERT,DEFAULT,IF,PACKAGE,SYNCHRONIZED,BOOLEAN,DO,GOTO,PRIVATE,THIS,BREAK,DOUBLE,IMPLEMENTS,PROTECTED,THROW,BYTE,ELSE,IMPORT,PUBLIC,THROWS,CASE,ENUM,INSTANCEOF,RETURN,TRANSIENT,CATCH,EXTENDS,INT,SHORT,TRY,CHAR,FINAL,INTERFACE,STATIC,VOID,CLASS,FINALLY,LONG,STRICTFP,VOLATILE,CONST,FLOAT,NATIVE,SUPER,WHILE, UNDERSCORE
%token<str> EXPORTS,OPENS,REQUIRES,USES,MODULE,PERMITS,SEALED,VAR,NON-SEALED,PROVIDES,TO,WITH,OPEN,RECORD,TRANSITIVE,YIELD

%%

program : 
    | program IDENTIFIER {printf("%s\n", $2);}
;

%%


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
