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


"abstract" { yylval.node = createNode(strdup(yytext)); return Abstract ;}
"continue" { yylval.node = createNode(strdup(yytext)); return Continue ;}
"for" { yylval.node = createNode(strdup(yytext)); return For ;}
"new" { yylval.node = createNode(strdup(yytext)); return New ;}
"switch" { yylval.node = createNode(strdup(yytext)); return Switch ;}
"assert" { yylval.node = createNode(strdup(yytext)); return Assert ;}
"default" { yylval.node = createNode(strdup(yytext)); return Default ;}
"if" { yylval.node = createNode(strdup(yytext)); return If ;}
"package" { yylval.node = createNode(strdup(yytext)); return Package ;}
"synchronized" { yylval.node = createNode(strdup(yytext)); return Synchronized ;}
"boolean" { yylval.node = createNode(strdup(yytext)); return Boolean ;}
"do" { yylval.node = createNode(strdup(yytext)); return Do ;}
"goto" { yylval.node = createNode(strdup(yytext)); return Goto ;}
"private" { yylval.node = createNode(strdup(yytext)); return Private ;}
"this" { yylval.node = createNode(strdup(yytext)); return This ;}
"break" { yylval.node = createNode(strdup(yytext)); return Break ;}
"double" { yylval.node = createNode(strdup(yytext)); return Double ;}
"implements" { yylval.node = createNode(strdup(yytext)); return Implements ;}
"protected" { yylval.node = createNode(strdup(yytext)); return Protected ;}
"throw" { yylval.node = createNode(strdup(yytext)); return Throw ;}
"byte" { yylval.node = createNode(strdup(yytext)); return Byte ;}
"else" { yylval.node = createNode(strdup(yytext)); return Else ;}
"import" { yylval.node = createNode(strdup(yytext)); return Import ;}
"public" { yylval.node = createNode(strdup(yytext)); return Public ;}
"throws" { yylval.node = createNode(strdup(yytext)); return Throws_key ;}
"case" { yylval.node = createNode(strdup(yytext)); return Case ;}
"enum" { yylval.node = createNode(strdup(yytext)); return Enum ;}
"instanceof" { yylval.node = createNode(strdup(yytext)); return Instanceof ;}
"return" { yylval.node = createNode(strdup(yytext)); return Return ;}
"transient" { yylval.node = createNode(strdup(yytext)); return Transient ;}
"catch" { yylval.node = createNode(strdup(yytext)); return Catch ;}
"extends" { yylval.node = createNode(strdup(yytext)); return Extends ;}
"int" { yylval.node = createNode(strdup(yytext)); return Int ;}
"short" { yylval.node = createNode(strdup(yytext)); return Short ;}
"try" { yylval.node = createNode(strdup(yytext)); return Try ;}
"char" { yylval.node = createNode(strdup(yytext)); return Char ;}
"final" { yylval.node = createNode(strdup(yytext)); return Final ;}
"interface" { yylval.node = createNode(strdup(yytext)); return Interface ;}
"static" { yylval.node = createNode(strdup(yytext)); return Static ;}
"void" { yylval.node = createNode(strdup(yytext)); return Void ;}
"class" { yylval.node = createNode(strdup(yytext)); return Class ;}
"finally" { yylval.node = createNode(strdup(yytext)); return Finally ;}
"long" { yylval.node = createNode(strdup(yytext)); return Long ;}
"strictfp" { yylval.node = createNode(strdup(yytext)); return Strictfp ;}
"volatile" { yylval.node = createNode(strdup(yytext)); return Volatile ;}
"const" { yylval.node = createNode(strdup(yytext)); return Const ;}
"float" { yylval.node = createNode(strdup(yytext)); return Float ;}
"native" { yylval.node = createNode(strdup(yytext)); return Native ;}
"super" { yylval.node = createNode(strdup(yytext)); return Super ;}
"while" { yylval.node = createNode(strdup(yytext)); return While ;}
"_" { yylval.node = createNode(strdup(yytext)); return Underscore ;}


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


{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} {yylval.str=strdup(yytext); return IntegerLiteral; }
{FloatingPointLiteral} {yylval.str=strdup(yytext); return FloatingPointLiteral;}
{BooleanLiteral} {yylval.str=strdup(yytext); return BooleanLiteral;}
{CharLiteral} {yylval.str=strdup(yytext); return CharacterLiteral;}
{NullLiteral} {yylval.str=strdup(yytext); return NullLiteral;}


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
