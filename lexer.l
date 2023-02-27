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


"abstract" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return ABSTRACT ;}
"continue" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CONTINUE ;}
"for" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return FOR ;}
"new" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return NEW ;}
"switch" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return SWITCH ;}
"assert" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return ASSERT ;}
"default" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return DEFAULT ;}
"if" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return IF ;}
"package" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return PACKAGE ;}
"synchronized" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return SYNCHRONIZED ;}
"boolean" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return BOOLEAN ;}
"do" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return DO ;}
"goto" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return GOTO ;}
"private" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return PRIVATE ;}
"this" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return THIS ;}
"break" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return BREAK ;}
"double" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return DOUBLE ;}
"implements" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return IMPLEMENTS ;}
"protected" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return PROTECTED ;}
"throw" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return THROW ;}
"byte" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return BYTE ;}
"else" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return ELSE ;}
"import" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return IMPORT ;}
"public" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return PUBLIC ;}
"throws" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return THROWS ;}
"case" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CASE ;}
"enum" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return ENUM ;}
"instanceof" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return INSTANCEOF ;}
"return" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return RETURN ;}
"transient" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return TRANSIENT ;}
"catch" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CATCH ;}
"extends" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return EXTENDS ;}
"int" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return INT ;}
"short" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return SHORT ;}
"try" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return TRY ;}
"char" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CHAR ;}
"final" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return FINAL ;}
"interface" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return INTERFACE ;}
"static" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return STATIC ;}
"void" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return VOID ;}
"class" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CLASS ;}
"finally" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return FINALLY ;}
"long" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return LONG ;}
"strictfp" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return STRICTFP ;}
"volatile" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return VOLATILE ;}
"const" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CONST ;}
"float" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return FLOAT ;}
"native" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return NATIVE ;}
"super" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return SUPER ;}
"while" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return WHILE ;}
"_" { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return UNDERSCORE ;}

"exports"   { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return EXPORTS; }
"opens"     { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return OPENS; }
"requires"  { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return REQUIRES; }
"uses"      { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return USES; }
"module"    { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return MODULE; }
"permits"   { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return PERMITS; }
"sealed"    { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return SEALED; }
"var"       { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return VAR; }
"provides"  { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return PROVIDES; }
"to"        { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return TO; }
"with"      { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return WITH; }
"open"      { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return OPEN; }
"record"    { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return RECORD; }
"transitive"    { string str="Keyword"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return TRANSITIVE; }

"(" { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return LeftParenthesis;}
")" {   string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return RightParenthesis;}
"{" {   string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return LeftCurlyBrace ;}
"}" {   string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return RightCurlyBrace; }
"[" { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return LeftSquareBracket;}
"]" { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return RightSquareBracket;}
";" { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return Semicolon;}
"," { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return Comma;}
"." { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return Dot;}
"..." { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return ellipsis;}
"@" { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return AtSign;}
"::" { string str="Separator"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return Scope;}

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



\"([^\"\\]|\\.)*\" {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);
    string str;
    for(int i=1;i<strlen(yytext)-1;i++) str.push_back(yytext[i]);
    yylval.node = createNode(strdup(const_cast<char*>(str.c_str())));
    cout<<"abcd"<<endl;
    return StringLiteral;
}





{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return IntegerLiteral; }
{FloatingPointLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return FloatingPointLiteral;}
{BooleanLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return BooleanLiteral;}
{CharLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CharacterLiteral;}
{NullLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return NullLiteral;}

(\"\"\")[ ]*([\n\r]|[\r][\n])([^\\]|(\\\\))*(\"\"\") {mp1[yytext]="Literal";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); string str="Identifier"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return TextBlock;}


[\'][\\][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[0]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}


[\'][\'][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[1]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}
[\'].[\'] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);
    string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ;
    return CharacterLiteral;

}


{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return IntegerLiteral; }
{FloatingPointLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return FloatingPointLiteral;}
{BooleanLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return BooleanLiteral;}
{CharLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return CharacterLiteral;}
{NullLiteral} {string str="Literal"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ; return NullLiteral;}


[a-zA-Z$_]+[$_a-zA-Z0-9]* {mp1[yytext]="Identifier";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); string str="Identifier"; str.push_back('_');str.push_back('_'); for(int i=0;i<strlen(yytext);i++){str.push_back(yytext[i]);} yylval.node = createNode(strdup(const_cast<char*>(str.c_str()))) ;return IdentifierChars;}


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
