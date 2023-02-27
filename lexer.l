%{
#define YY_NO_UNPUT

#include "token.h"
#include <string.h>
#include <string>

extern "C" {
    int yylex(void);
}

int linenum = 0;

Node* PrefixedNode(std::string prefix, const char* matched)
{
    prefix.append(matched);
    return createNode(strdup(prefix.c_str()));
}

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

"//".*  {}

[/][*][^*]*[*][*]*([^*/][^*]*[*][*]*)*[/]   {}

\n { linenum++; }

"abstract" { yylval.node = PrefixedNode("Keyword__", yytext); return ABSTRACT ;}
"continue" { yylval.node = PrefixedNode("Keyword__", yytext); return CONTINUE ;}
"for" { yylval.node = PrefixedNode("Keyword__", yytext); return FOR ;}
"new" { yylval.node = PrefixedNode("Keyword__", yytext); return NEW ;}
"switch" { yylval.node = PrefixedNode("Keyword__", yytext); return SWITCH ;}
"assert" { yylval.node = PrefixedNode("Keyword__", yytext); return ASSERT ;}
"default" { yylval.node = PrefixedNode("Keyword__", yytext); return DEFAULT ;}
"if" { yylval.node = PrefixedNode("Keyword__", yytext); return IF ;}
"package" { yylval.node = PrefixedNode("Keyword__", yytext); return PACKAGE ;}
"synchronized" { yylval.node = PrefixedNode("Keyword__", yytext); return SYNCHRONIZED ;}
"boolean" { yylval.node = PrefixedNode("Keyword__", yytext); return BOOLEAN ;}
"do" { yylval.node = PrefixedNode("Keyword__", yytext); return DO ;}
"goto" { yylval.node = PrefixedNode("Keyword__", yytext); return GOTO ;}
"private" { yylval.node = PrefixedNode("Keyword__", yytext); return PRIVATE ;}
"this" { yylval.node = PrefixedNode("Keyword__", yytext); return THIS ;}
"break" { yylval.node = PrefixedNode("Keyword__", yytext); return BREAK ;}
"double" { yylval.node = PrefixedNode("Keyword__", yytext); return DOUBLE ;}
"implements" { yylval.node = PrefixedNode("Keyword__", yytext); return IMPLEMENTS ;}
"protected" { yylval.node = PrefixedNode("Keyword__", yytext); return PROTECTED ;}
"throw" { yylval.node = PrefixedNode("Keyword__", yytext); return THROW ;}
"byte" { yylval.node = PrefixedNode("Keyword__", yytext); return BYTE ;}
"else" { yylval.node = PrefixedNode("Keyword__", yytext); return ELSE ;}
"import" { yylval.node = PrefixedNode("Keyword__", yytext); return IMPORT ;}
"public" { yylval.node = PrefixedNode("Keyword__", yytext); return PUBLIC ;}
"throws" { yylval.node = PrefixedNode("Keyword__", yytext); return THROWS ;}
"case" { yylval.node = PrefixedNode("Keyword__", yytext); return CASE ;}
"enum" { yylval.node = PrefixedNode("Keyword__", yytext); return ENUM ;}
"instanceof" { yylval.node = PrefixedNode("Keyword__", yytext); return INSTANCEOF ;}
"return" { yylval.node = PrefixedNode("Keyword__", yytext); return RETURN ;}
"transient" { yylval.node = PrefixedNode("Keyword__", yytext); return TRANSIENT ;}
"catch" { yylval.node = PrefixedNode("Keyword__", yytext); return CATCH ;}
"extends" { yylval.node = PrefixedNode("Keyword__", yytext); return EXTENDS ;}
"int" { yylval.node = PrefixedNode("Keyword__", yytext); return INT ;}
"short" { yylval.node = PrefixedNode("Keyword__", yytext); return SHORT ;}
"try" { yylval.node = PrefixedNode("Keyword__", yytext); return TRY ;}
"char" { yylval.node = PrefixedNode("Keyword__", yytext); return CHAR ;}
"final" { yylval.node = PrefixedNode("Keyword__", yytext); return FINAL ;}
"interface" { yylval.node = PrefixedNode("Keyword__", yytext); return INTERFACE ;}
"static" { yylval.node = PrefixedNode("Keyword__", yytext); return STATIC ;}
"void" { yylval.node = PrefixedNode("Keyword__", yytext); return VOID ;}
"class" { yylval.node = PrefixedNode("Keyword__", yytext); return CLASS ;}
"finally" { yylval.node = PrefixedNode("Keyword__", yytext); return FINALLY ;}
"long" { yylval.node = PrefixedNode("Keyword__", yytext); return LONG ;}
"strictfp" { yylval.node = PrefixedNode("Keyword__", yytext); return STRICTFP ;}
"volatile" { yylval.node = PrefixedNode("Keyword__", yytext); return VOLATILE ;}
"const" { yylval.node = PrefixedNode("Keyword__", yytext); return CONST ;}
"float" { yylval.node = PrefixedNode("Keyword__", yytext); return FLOAT ;}
"native" { yylval.node = PrefixedNode("Keyword__", yytext); return NATIVE ;}
"super" { yylval.node = PrefixedNode("Keyword__", yytext); return SUPER ;}
"while" { yylval.node = PrefixedNode("Keyword__", yytext); return WHILE ;}
"_" { yylval.node = PrefixedNode("Keyword__", yytext); return UNDERSCORE ;}

"exports"   { yylval.node = PrefixedNode("Keyword__", yytext); return EXPORTS; }
"opens"     { yylval.node = PrefixedNode("Keyword__", yytext); return OPENS; }
"requires"  { yylval.node = PrefixedNode("Keyword__", yytext); return REQUIRES; }
"uses"      { yylval.node = PrefixedNode("Keyword__", yytext); return USES; }
"module"    { yylval.node = PrefixedNode("Keyword__", yytext); return MODULE; }
"permits"   { yylval.node = PrefixedNode("Keyword__", yytext); return PERMITS; }
"sealed"    { yylval.node = PrefixedNode("Keyword__", yytext); return SEALED; }
"var"       { yylval.node = PrefixedNode("Keyword__", yytext); return VAR; }
"provides"  { yylval.node = PrefixedNode("Keyword__", yytext); return PROVIDES; }
"to"        { yylval.node = PrefixedNode("Keyword__", yytext); return TO; }
"with"      { yylval.node = PrefixedNode("Keyword__", yytext); return WITH; }
"open"      { yylval.node = PrefixedNode("Keyword__", yytext); return OPEN; }
"record"    { yylval.node = PrefixedNode("Keyword__", yytext); return RECORD; }
"transitive"    { yylval.node = PrefixedNode("Keyword__", yytext); return TRANSITIVE; }

"(" { yylval.node = PrefixedNode("Separator__", yytext); return LeftParenthesis; }
")" { yylval.node = PrefixedNode("Separator__", yytext); return RightParenthesis; }
"{" { yylval.node = PrefixedNode("Separator__", yytext); return LeftCurlyBrace; }
"}" { yylval.node = PrefixedNode("Separator__", yytext); return RightCurlyBrace; }
"[" { yylval.node = PrefixedNode("Separator__", yytext); return LeftSquareBracket; }
"]" { yylval.node = PrefixedNode("Separator__", yytext); return RightSquareBracket; }
";" { yylval.node = PrefixedNode("Separator__", yytext); return Semicolon; }
"," { yylval.node = PrefixedNode("Separator__", yytext); return Comma; }
"." { yylval.node = PrefixedNode("Separator__", yytext); return Dot; }
"..." { yylval.node = PrefixedNode("Separator__", yytext); return ellipsis;}
"@" { yylval.node = PrefixedNode("Separator__", yytext); return AtSign;}
"::" { yylval.node = PrefixedNode("Separator__", yytext); return Scope;}

"=" { yylval.node = PrefixedNode("", yytext); return ASSIGN; }
">" { yylval.node = PrefixedNode("", yytext); return GT; }
"<" { yylval.node = PrefixedNode("", yytext); return LT; }
"!" { yylval.node = PrefixedNode("", yytext); return EXCLAMATION; }
"~" { yylval.node = PrefixedNode("", yytext); return TILDE; }
"?" { yylval.node = PrefixedNode("", yytext); return QUESTIONMARK; }
":" { yylval.node = PrefixedNode("", yytext); return COLON; }
"->" { yylval.node = PrefixedNode("", yytext); return ARROW; }
"==" { yylval.node = PrefixedNode("", yytext); return EQUAL; }
">=" { yylval.node = PrefixedNode("", yytext); return GE; }
"<=" { yylval.node = PrefixedNode("", yytext); return LE; }
"!=" { yylval.node = PrefixedNode("", yytext); return NOTEQUAL; }
"&&" { yylval.node = PrefixedNode("", yytext); return AND; }
"||" { yylval.node = PrefixedNode("", yytext); return OR; }
"++" { yylval.node = PrefixedNode("", yytext); return INC; }
"--" { yylval.node = PrefixedNode("", yytext); return DEC; }
"+" { yylval.node = PrefixedNode("", yytext); return ADD; }
"-" { yylval.node = PrefixedNode("", yytext); return SUB; }
"*" { yylval.node = PrefixedNode("", yytext); return MUL; }
"/" { yylval.node = PrefixedNode("", yytext); return DIV; }
"&" { yylval.node = PrefixedNode("", yytext); return BITAND; }
"|" { yylval.node = PrefixedNode("", yytext); return BITOR; }
"^" { yylval.node = PrefixedNode("", yytext); return CARET; }
"%" { yylval.node = PrefixedNode("", yytext); return MOD; }
"<<" { yylval.node = PrefixedNode("", yytext); return LSHIFT; }
">>" { yylval.node = PrefixedNode("", yytext); return RSHIFT; }
">>>" { yylval.node = PrefixedNode("", yytext); return URSHIFT; }
"+=" { yylval.node = PrefixedNode("", yytext); return ADD_ASSIGN; }
"-=" { yylval.node = PrefixedNode("", yytext); return SUB_ASSIGN; }
"*=" { yylval.node = PrefixedNode("", yytext); return MUL_ASSIGN; }
"/=" { yylval.node = PrefixedNode("", yytext); return DIV_ASSIGN; }
"&=" { yylval.node = PrefixedNode("", yytext); return AND_ASSIGN; }
"|=" { yylval.node = PrefixedNode("", yytext); return OR_ASSIGN; }
"^=" { yylval.node = PrefixedNode("", yytext); return XOR_ASSIGN; }
"%=" { yylval.node = PrefixedNode("", yytext); return MOD_ASSIGN; }
"<<=" { yylval.node = PrefixedNode("", yytext); return LSHIFT_ASSIGN; }
">>=" { yylval.node = PrefixedNode("", yytext); return RSHIFT_ASSIGN; }
">>>=" { yylval.node = PrefixedNode("", yytext); return URSHIFT_ASSIGN; }

\"([^\"\\]|\\.)*\" {
    int matched_length = strlen(yytext);
    std::string str = "";
    for(int i = 0; i < matched_length; i++) {
        if(yytext[i] == '\\') str += "\\\\";
        else if(yytext[i] == '\"') str += "\\\"";
        else if(yytext[i] == '\'') str += "\\\'";
        else str.push_back(yytext[i]);
    }
    yylval.node = createNode(strdup(str.c_str()));
    return StringLiteral;
}

{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} { yylval.node = PrefixedNode("Literal__", yytext); return IntegerLiteral; }
{FloatingPointLiteral} { yylval.node = PrefixedNode("Literal__", yytext); return FloatingPointLiteral; }
{BooleanLiteral} { yylval.node = PrefixedNode("Literal__", yytext); return BooleanLiteral; }
{CharLiteral} { yylval.node = PrefixedNode("Literal__", yytext); return CharacterLiteral; }
{NullLiteral} { yylval.node = PrefixedNode("Literal__", yytext); return NullLiteral; }

(\"\"\")[ ]*([\n\r]|[\r][\n])([^\\]|(\\\\))*(\"\"\") { yylval.node = PrefixedNode("Identifier__", yytext); return TextBlock;}
[\'][\\][\'] { std::cout << yytext << " Line number is " << yylineno << " Illegal Character is " << yytext[0] << '\n'; }
[\'][\'][\'] { std::cout << yytext << " Line number is " << yylineno << " Illegal Character is " << yytext[1] << '\n'; }
[\'].[\'] { yylval.node = PrefixedNode("Literal__", yytext); return CharacterLiteral; }

[a-zA-Z$_]+[$_a-zA-Z0-9]* { yylval.node = PrefixedNode("Identifier__", yytext); return IdentifierChars; }


. { std::cout << yytext<<" Line number is " << yylineno << " Illegal Character is " << yytext[0] << '\n'; }

%%
