%{
    #include<bits/stdc++.h>
  
    #include "parser.tab.h"
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


"abstract" { yylval.str = strdup(yytext); return abstract ;}
"continue" { yylval.str = strdup(yytext); return continue ;}
"for" { yylval.str = strdup(yytext); return for ;}
"new" { yylval.str = strdup(yytext); return new ;}
"switch" { yylval.str = strdup(yytext); return switch ;}
"assert" { yylval.str = strdup(yytext); return assert ;}
"default" { yylval.str = strdup(yytext); return default ;}
"if" { yylval.str = strdup(yytext); return if ;}
"package" { yylval.str = strdup(yytext); return package ;}
"synchronized" { yylval.str = strdup(yytext); return synchronized ;}
"boolean" { yylval.str = strdup(yytext); return boolean ;}
"do" { yylval.str = strdup(yytext); return do ;}
"goto" { yylval.str = strdup(yytext); return goto ;}
"private" { yylval.str = strdup(yytext); return private ;}
"this" { yylval.str = strdup(yytext); return this ;}
"break" { yylval.str = strdup(yytext); return break ;}
"double" { yylval.str = strdup(yytext); return double ;}
"implements" { yylval.str = strdup(yytext); return implements ;}
"protected" { yylval.str = strdup(yytext); return protected ;}
"throw" { yylval.str = strdup(yytext); return throw ;}
"byte" { yylval.str = strdup(yytext); return byte ;}
"else" { yylval.str = strdup(yytext); return else ;}
"import" { yylval.str = strdup(yytext); return import ;}
"public" { yylval.str = strdup(yytext); return public ;}
"throws" { yylval.str = strdup(yytext); return throws ;}
"case" { yylval.str = strdup(yytext); return case ;}
"enum" { yylval.str = strdup(yytext); return enum ;}
"instanceof" { yylval.str = strdup(yytext); return instanceof ;}
"return" { yylval.str = strdup(yytext); return return ;}
"transient" { yylval.str = strdup(yytext); return transient ;}
"catch" { yylval.str = strdup(yytext); return catch ;}
"extends" { yylval.str = strdup(yytext); return extends ;}
"int" { yylval.str = strdup(yytext); return int ;}
"short" { yylval.str = strdup(yytext); return short ;}
"try" { yylval.str = strdup(yytext); return try ;}
"char" { yylval.str = strdup(yytext); return char ;}
"final" { yylval.str = strdup(yytext); return final ;}
"interface" { yylval.str = strdup(yytext); return interface ;}
"static" { yylval.str = strdup(yytext); return static ;}
"void" { yylval.str = strdup(yytext); return void ;}
"class" { yylval.str = strdup(yytext); return class ;}
"finally" { yylval.str = strdup(yytext); return finally ;}
"long" { yylval.str = strdup(yytext); return long ;}
"strictfp" { yylval.str = strdup(yytext); return strictfp ;}
"volatile" { yylval.str = strdup(yytext); return volatile ;}
"const" { yylval.str = strdup(yytext); return const ;}
"float" { yylval.str = strdup(yytext); return float ;}
"native" { yylval.str = strdup(yytext); return native ;}
"super" { yylval.str = strdup(yytext); return super ;}
"while" { yylval.str = strdup(yytext); return while ;}
"_" { yylval.str = strdup(yytext); return underscore ;}


"(" {   yylval.str = strdup(yytext); return LeftParenthesis;}
")" {   yylval.str = strdup(yytext); return RightParenthesis;}
"{" {   yylval.str = strdup(yytext); return LeftCurlyBrace ;}
"}" {   yylval.str = strdup(yytext); return RightCurlyBrace; }
"[" { yylval.str = strdup(yytext); return LeftSquareBracket;}
"]" { yylval.str = strdup(yytext); return RightSquareBracket;}
";" { yylval.str = strdup(yytext); return Semicolon;}
"," { yylval.str = strdup(yytext); return Comma;}
"." { yylval.str = strdup(yytext); return Period;}
"..." { yylval.str = strdup(yytext); return ellipsis;}
"@" { yylval.str = strdup(yytext); return AtSign;}
"::" { yylval.str = strdup(yytext); return Scope;}

"=" { yylval.str = strdup(yytext); return ASSIGN ;}
">" { yylval.str = strdup(yytext); return GT ;}
"<" { yylval.str = strdup(yytext); return LT ;}
"!" { yylval.str = strdup(yytext); return EXCLAMATION ;}
"~" { yylval.str = strdup(yytext); return TILDE ;}
"?" { yylval.str = strdup(yytext); return QUESTIONMARK ;}
":" { yylval.str = strdup(yytext); return COLON ;}
"->" { yylval.str = strdup(yytext); return ARROW ;}
"==" { yylval.str = strdup(yytext); return EQUAL ;}
">=" { yylval.str = strdup(yytext); return GE ;}
"<=" { yylval.str = strdup(yytext); return LE ;}
"!=" { yylval.str = strdup(yytext); return NOTEQUAL ;}
"&&" { yylval.str = strdup(yytext); return AND ;}
"||" { yylval.str = strdup(yytext); return OR ;}
"++" { yylval.str = strdup(yytext); return INC ;}
"--" { yylval.str = strdup(yytext); return DEC ;}
"+" { yylval.str = strdup(yytext); return ADD ;}
"-" { yylval.str = strdup(yytext); return SUB ;}
"*" { yylval.str = strdup(yytext); return MUL ;}
"/" { yylval.str = strdup(yytext); return DIV ;}
"&" { yylval.str = strdup(yytext); return BITAND ;}
"|" { yylval.str = strdup(yytext); return BITOR ;}
"^" { yylval.str = strdup(yytext); return CARET ;}
"%" { yylval.str = strdup(yytext); return MOD ;}
"<<" { yylval.str = strdup(yytext); return LSHIFT ;}
">>" { yylval.str = strdup(yytext); return RSHIFT ;}
">>>" { yylval.str = strdup(yytext); return URSHIFT ;}
"+=" { yylval.str = strdup(yytext); return ADD_ASSIGN ;}
"-=" { yylval.str = strdup(yytext); return SUB_ASSIGN ;}
"*=" { yylval.str = strdup(yytext); return MUL_ASSIGN ;}
"/=" { yylval.str = strdup(yytext); return DIV_ASSIGN ;}
"&=" { yylval.str = strdup(yytext); return AND_ASSIGN ;}
"|=" { yylval.str = strdup(yytext); return OR_ASSIGN ;}
"^=" { yylval.str = strdup(yytext); return XOR_ASSIGN ;}
"%=" { yylval.str = strdup(yytext); return MOD_ASSIGN ;}
"<<=" { yylval.str = strdup(yytext); return LSHIFT_ASSIGN ;}
">>=" { yylval.str = strdup(yytext); return RSHIFT_ASSIGN ;}
">>>=" { yylval.str = strdup(yytext); return URSHIFT_ASSIGN ;}




(\"\"\")[ ]*([\n\r]|[\r][\n])([^\\]|(\\\\))*(\"\"\") {mp1[yytext]="Literal";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); yylval.str = strdup(yytext); return TextBlock;}


[\"]([^\"\\\n]|(\\\")|(\\\\))*[\"] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);
    yylval.str = strdup(yytext);
    return StringLiteral;
}


[\'][\\][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[0]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}


[\'][\'][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[1]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}
[\'].[\'] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);
    yylval.str = strdup(yytext);
    return CharLiteral;

}


{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} {yylval.str=strdup(yytext); return IntegerLiteral; }
{FloatingPointLiteral} {yylval.str=strdup(yyetxt); return FloatingPointLiteral}
{BooleanLiteral} {yylval.str=strdup(yyetxt); return BooleanLiteral;}
{CharLiteral} {yylval.str=strdup(yyetxt); return CharLiteral;}
{NullLiteral} {yylval.str=strdup(yyetxt); return NullLiteral;}


[a-zA-Z$_]+[$_a-zA-Z0-9]* {mp1[yytext]="Identifier";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); yylval.str = strdup(yytext) ;return IdentifierChars;}
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
