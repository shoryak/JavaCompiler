%{
    #include<bits/stdc++.h>
  
    #include "token.h"
  #include<string.h>
  using namespace std;
  extern "C" {
        int yylex(void);
    }
    template <typename T>
    T parser_number(string numstr){
        stringstream ss;
        ss << numstr;
        T result(0);
        ss >> result;
        return result;
    }
    unordered_map<string,string > mp1;
    unordered_map<string,int > mp2;
    int linenum=0;
    std::ofstream myfile;
    vector<string>v;
    //
%}

%option yylineno

%option noyywrap 

IntegerTypeSuffix   [lL]
Digit    [0]|[1-9]
Underscores [_]+
DigitorUnderscore   {Digit}|[_]
DigitsandUNderscores    {DigitorUnderscore}+
Digits  {Digit}|{Digit}{DigitsandUNderscores}?{Digit}   
Nonzerodigit    [1-9]
DECIMALNUMERAL  [0]|{Nonzerodigit}{Digits}?|{Nonzerodigit}{Underscores}{Digits}
DecimalIntegerLiteral   {DECIMALNUMERAL}{IntegerTypeSuffix}?

Hexdigit    [0-9a-fA-F]
HexdigitsOrUnderscore   [_]|{Hexdigit}
HexdigitsAndUnderscores {HexdigitsOrUnderscore}+
Hexdigits   {Hexdigit}|{Hexdigit}{HexdigitsAndUnderscores}?{Hexdigit}
HexNumeral  [0][x]{Hexdigits}|[0][X]{Hexdigits}
HexIntegerLiteral   {HexNumeral}{IntegerTypeSuffix}?


OctalDigit  [0-7]
OctalDigitOrUnderscore {OctalDigit}|[_]
OctalDigitAndUnderscore {OctalDigitOrUnderscore}+
OctalDigits {OctalDigit}|{OctalDigit}{OctalDigitAndUnderscore}?{OctalDigit}
OctalNumeral    [0]{OctalDigits}|[0]{Underscores}{OctalDigits}
OctalIntegerLiteral {OctalNumeral}{IntegerTypeSuffix}?

Binarydigit [01]
BinarydigitOrUnderscore {Binarydigit}|[_]
BinarydigitAndUnderscore    {BinarydigitOrUnderscore}+
Binarydigits    {Binarydigit}|{Binarydigit}{BinarydigitAndUnderscore}?{Binarydigit}
BinaryNumeral   [0][b]{Binarydigits}|[0][B]{Binarydigits}
BinaryIntegerLiteral    {BinaryNumeral}{IntegerTypeSuffix}?



FloatTypeSuffix [fFdD]
SignedInteger [+-]?{Digits}
ExpIndicator [eE]
ExpPart {ExpIndicator}{SignedInteger}

BinaryExpIndicator  [pP]
BinaryExp   {BinaryExpIndicator}{SignedInteger}
HexSignificand  {HexNumeral}[.]*|[0][x]{Hexdigits}?[.]{Hexdigits}|[0][X]{Hexdigits}?[.]{Hexdigits}
HexadecimalFloatingPointLiteral {HexSignificand}{BinaryExp}{FloatTypeSuffix}*

DecimalFloatingPointLiteral {Digits}[.]{Digits}?{ExpPart}?{FloatTypeSuffix}?|[.]{Digits}{ExpPart}?{FloatTypeSuffix}?|{Digits}{ExpPart}{FloatTypeSuffix}?|{Digits}{ExpPart}?{FloatTypeSuffix}
FloatingPointLiteral {DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}

BooleanLiteral true|false
NullLiteral null
OctalEscape [\\]{OctalDigit}|[\\]{OctalDigit}{OctalDigit}|[\\][0-3]{OctalDigit}{OctalDigit}

CharLiteral \'\\b\'|\'\\s\'|\'\\t\'|\'\\n\'|\'\\f\'|\'\\\'|\'\"\'|\'\\r\'|\'\\r\\n\'|\'{OctalEscape}\'
Literals {DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{FloatingPointLiteral}|{BooleanLiteral}|{CharLiteral}|{NullLiteral}|{BinaryIntegerLiteral}

%%

[ \t\r\f]+  {}

"//".* {}

[/][*][^*]*[*][*]*([^*/][^*]*[*][*]*)*[/]   {}

\n {linenum++;}


"abstract" { yylval.str = strdup(yytext); return ABSTRACT ;}
"continue" { yylval.str = strdup(yytext); return CONTINUE ;}
"for" { yylval.str = strdup(yytext); return FOR ;}
"new" { yylval.str = strdup(yytext); return NEW ;}
"switch" { yylval.str = strdup(yytext); return SWITCH ;}
"assert" { yylval.str = strdup(yytext); return ASSERT ;}
"default" { yylval.str = strdup(yytext); return DEFAULT ;}
"if" { yylval.str = strdup(yytext); return IF ;}
"package" { yylval.str = strdup(yytext); return PACKAGE ;}
"synchronized" { yylval.str = strdup(yytext); return SYNCHRONIZED ;}
"boolean" { yylval.str = strdup(yytext); return BOOLEAN ;}
"do" { yylval.str = strdup(yytext); return DO ;}
"goto" { yylval.str = strdup(yytext); return GOTO ;}
"private" { yylval.str = strdup(yytext); return PRIVATE ;}
"this" { yylval.str = strdup(yytext); return THIS ;}
"break" { yylval.str = strdup(yytext); return BREAK ;}
"double" { yylval.str = strdup(yytext); return DOUBLE ;}
"implements" { yylval.str = strdup(yytext); return IMPLEMENTS ;}
"protected" { yylval.str = strdup(yytext); return PROTECTED ;}
"throw" { yylval.str = strdup(yytext); return THROW ;}
"byte" { yylval.str = strdup(yytext); return BYTE ;}
"else" { yylval.str = strdup(yytext); return ELSE ;}
"import" { yylval.str = strdup(yytext); return IMPORT ;}
"public" { yylval.str = strdup(yytext); return PUBLIC ;}
"throws" { yylval.str = strdup(yytext); return THROWS ;}
"case" { yylval.str = strdup(yytext); return CASE ;}
"enum" { yylval.str = strdup(yytext); return ENUM ;}
"instanceof" { yylval.str = strdup(yytext); return INSTANCEOF ;}
"return" { yylval.str = strdup(yytext); return RETURN ;}
"transient" { yylval.str = strdup(yytext); return TRANSIENT ;}
"catch" { yylval.str = strdup(yytext); return CATCH ;}
"extends" { yylval.str = strdup(yytext); return EXTENDS ;}
"int" { yylval.str = strdup(yytext); return INT ;}
"short" { yylval.str = strdup(yytext); return SHORT ;}
"try" { yylval.str = strdup(yytext); return TRY ;}
"char" { yylval.str = strdup(yytext); return CHAR ;}
"final" { yylval.str = strdup(yytext); return FINAL ;}
"interface" { yylval.str = strdup(yytext); return INTERFACE ;}
"static" { yylval.str = strdup(yytext); return STATIC ;}
"void" { yylval.str = strdup(yytext); return VOID ;}
"class" { yylval.str = strdup(yytext); return CLASS ;}
"finally" { yylval.str = strdup(yytext); return FINALLY ;}
"long" { yylval.str = strdup(yytext); return LONG ;}
"strictfp" { yylval.str = strdup(yytext); return STRICTFP ;}
"volatile" { yylval.str = strdup(yytext); return VOLATILE ;}
"const" { yylval.str = strdup(yytext); return CONST ;}
"float" { yylval.str = strdup(yytext); return FLOAT ;}
"native" { yylval.str = strdup(yytext); return NATIVE ;}
"super" { yylval.str = strdup(yytext); return SUPER ;}
"while" { yylval.str = strdup(yytext); return WHILE ;}
"_" { yylval.str = strdup(yytext); return UNDERSCORE ;}

"exports"   { yylval.str = strdup(yytext); return EXPORTS; }
"opens"     { yylval.str = strdup(yytext); return OPENS; }
"requires"  { yylval.str = strdup(yytext); return REQUIRES; }
"uses"      { yylval.str = strdup(yytext); return USES; }
"module"    { yylval.str = strdup(yytext); return MODULE; }
"permits"   { yylval.str = strdup(yytext); return PERMITS; }
"sealed"    { yylval.str = strdup(yytext); return SEALED; }
"var"       { yylval.str = strdup(yytext); return VAR; }
"provides"  { yylval.str = strdup(yytext); return PROVIDES; }
"to"        { yylval.str = strdup(yytext); return TO; }
"with"      { yylval.str = strdup(yytext); return WITH; }
"open"      { yylval.str = strdup(yytext); return OPEN; }
"record"    { yylval.str = strdup(yytext); return RECORD; }
"transitive"    { yylval.str = strdup(yytext); return TRANSITIVE; }

"(" {   yylval.node = createNode(strdup(yytext)); return LeftParenthesis;}
")" {   yylval.node = createNode(strdup(yytext)); return RightParenthesis;}
"{" {   yylval.node = createNode(strdup(yytext)); return LeftCurlyBrace ;}
"}" {   yylval.node = createNode(strdup(yytext)); return RightCurlyBrace; }
"[" { yylval.node = createNode(strdup(yytext)); return LeftSquareBracket;}
"]" { yylval.node = createNode(strdup(yytext)); return RightSquareBracket;}
";" { yylval.node = createNode(strdup(yytext)); return Semicolon;}
"," { yylval.node = createNode(strdup(yytext)); return Comma;}
"." { yylval.node = createNode(strdup(yytext)); return Dot;}
"..." { yylval.node = createNode(strdup(yytext)); return ellipsis;}
"@" { yylval.node = createNode(strdup(yytext)); return AtSign;}
"::" { yylval.node = createNode(strdup(yytext)); return Scope;}

"=" { yylval.node = createNode(strdup(yytext)); return ASSIGN ;}
">" { yylval.node = createNode(strdup(yytext)); return GT ;}
"<" { yylval.node = createNode(strdup(yytext)); return LT ;}
"!" { yylval.node = createNode(strdup(yytext)); return EXCLAMATION ;}
"~" { yylval.node = createNode(strdup(yytext)); return TILDE ;}
"?" { yylval.node = createNode(strdup(yytext)); return QUESTIONMARK ;}
":" { yylval.node = createNode(strdup(yytext)); return COLON ;}
"->" { yylval.node = createNode(strdup(yytext)); return ARROW ;}
"==" { yylval.node = createNode(strdup(yytext)); return EQUAL ;}
">=" { yylval.node = createNode(strdup(yytext)); return GE ;}
"<=" { yylval.node = createNode(strdup(yytext)); return LE ;}
"!=" { yylval.node = createNode(strdup(yytext)); return NOTEQUAL ;}
"&&" { yylval.node = createNode(strdup(yytext)); return AND ;}
"||" { yylval.node = createNode(strdup(yytext)); return OR ;}
"++" { yylval.node = createNode(strdup(yytext)); return INC ;}
"--" { yylval.node = createNode(strdup(yytext)); return DEC ;}
"+" { yylval.node = createNode(strdup(yytext)); return ADD ;}
"-" { yylval.node = createNode(strdup(yytext)); return SUB ;}
"*" { yylval.node = createNode(strdup(yytext)); return MUL ;}
"/" { yylval.node = createNode(strdup(yytext)); return DIV ;}
"&" { yylval.node = createNode(strdup(yytext)); return BITAND ;}
"|" { yylval.node = createNode(strdup(yytext)); return BITOR ;}
"^" { yylval.node = createNode(strdup(yytext)); return CARET ;}
"%" { yylval.node = createNode(strdup(yytext)); return MOD ;}
"<<" { yylval.node = createNode(strdup(yytext)); return LSHIFT ;}
">>" { yylval.node = createNode(strdup(yytext)); return RSHIFT ;}
">>>" { yylval.node = createNode(strdup(yytext)); return URSHIFT ;}
"+=" { yylval.node = createNode(strdup(yytext)); return ADD_ASSIGN ;}
"-=" { yylval.node = createNode(strdup(yytext)); return SUB_ASSIGN ;}
"*=" { yylval.node = createNode(strdup(yytext)); return MUL_ASSIGN ;}
"/=" { yylval.node = createNode(strdup(yytext)); return DIV_ASSIGN ;}
"&=" { yylval.node = createNode(strdup(yytext)); return AND_ASSIGN ;}
"|=" { yylval.node = createNode(strdup(yytext)); return OR_ASSIGN ;}
"^=" { yylval.node = createNode(strdup(yytext)); return XOR_ASSIGN ;}
"%=" { yylval.node = createNode(strdup(yytext)); return MOD_ASSIGN ;}
"<<=" { yylval.node = createNode(strdup(yytext)); return LSHIFT_ASSIGN ;}
">>=" { yylval.node = createNode(strdup(yytext)); return RSHIFT_ASSIGN ;}
">>>=" { yylval.node = createNode(strdup(yytext)); return URSHIFT_ASSIGN ;}




(\"\"\")[ ]*([\n\r]|[\r][\n])([^\\]|(\\\\))*(\"\"\") {mp1[yytext]="Literal";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); yylval.node = createNode(strdup(yytext)); return TextBlock;}


[\"]([^\"\\\n]|(\\\")|(\\\\))*[\"] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);
    yylval.node = createNode(strdup(yytext));
    return StringLiteral;
}


[\'][\\][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[0]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}


[\'][\'][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[1]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}
[\'].[\'] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);
    yylval.node = createNode(strdup(yytext));
    return CharacterLiteral;

}


{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} {yylval.node =createNode(strdup(yytext)); return IntegerLiteral; }
{FloatingPointLiteral} {yylval.node=createNode(strdup(yytext)); return FloatingPointLiteral;}
{BooleanLiteral} {yylval.node=createNode(strdup(yytext)); return BooleanLiteral;}
{CharLiteral} {yylval.node=createNode(strdup(yytext)); return CharacterLiteral;}
{NullLiteral} {yylval.node=createNode(strdup(yytext)); return NullLiteral;}


[a-zA-Z$_]+[$_a-zA-Z0-9]* {mp1[yytext]="Identifier";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); yylval.node = createNode(strdup(yytext)) ;return IdentifierChars;}
\".*\" { cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[0]<<endl; }

. {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[0]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}

%%


// int main(int argc, char **argv ){

    
//     ++argv;
//     --argc; 
//     if (argc > 0)yyin = fopen( argv[0], "r" );
//     else yyin = stdin;
//     yylex();
//     myfile.open ("example.csv");
//     myfile<<"Lexeme,Token,Count"<<endl;
//     cout<<"#####STATS#####"<<endl;
//     cout<<"Lexeme,Token,Count"<<endl;
//     for(auto x:v){
//        cout<<x<<","<<mp1[x]<<","<<mp2[x]<<endl;
//         myfile<<x<<","<<mp1[x]<<","<<mp2[x]<<endl;
//     }

//     myfile.close();

// return 0;
// }
