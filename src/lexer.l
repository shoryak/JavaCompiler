%{
#define YY_NO_UNPUT

#include <iostream>
#include <string>
#include <cstring>
#include "token.h"

extern "C" {
    int yylex(void);
}

int linenum = 1;

std::string KEYWORD_PREFIX      = "Keyword__";
std::string IDENTIFIER_PREFIX   = "Identifier__";
std::string SEPARATOR_PREFIX    = "Separator__";
std::string LITERAL_PREFIX      = "Literal__";

std::string KEYWORD_SUFFIX      = "";
std::string IDENTIFIER_SUFFIX   = "";
std::string SEPARATOR_SUFFIX    = "";
std::string LITERAL_SUFFIX      = "";

Node* FixedNode(std::string prefix, const char* matched, std::string suffix, std::string type = "")
{
    std::string res = prefix;
    res.append(matched);
    res += suffix;
    return createNode(strdup(res.c_str()), std::string(matched), type);
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

"abstract" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return ABSTRACT ;}
"continue" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return CONTINUE ;}
"for" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return FOR ;}
"new" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return NEW ;}
"switch" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return SWITCH ;}
"assert" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return ASSERT ;}
"default" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return DEFAULT ;}
"if" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return IF ;}
"package" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return PACKAGE ;}
"synchronized" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return SYNCHRONIZED ;}
"boolean" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "boolean"); return BOOLEAN ;}
"do" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return DO ;}
"goto" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return GOTO ;}
"private" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return PRIVATE ;}
"this" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return THIS ;}
"break" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return BREAK ;}
"double" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "double"); return DOUBLE ;}
"implements" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return IMPLEMENTS ;}
"protected" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return PROTECTED ;}
"throw" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return THROW ;}
"byte" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "byte"); return BYTE ;}
"else" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return ELSE ;}
"import" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return IMPORT ;}
"public" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return PUBLIC ;}
"throws" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return THROWS ;}
"case" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return CASE ;}
"enum" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return ENUM ;}
"instanceof" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return INSTANCEOF ;}
"return" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return RETURN ;}
"transient" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return TRANSIENT ;}
"catch" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return CATCH ;}
"extends" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return EXTENDS ;}
"int" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "int"); return INT ;}
"short" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "short"); return SHORT ;}
"try" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return TRY ;}
"char" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "char"); return CHAR ;}
"final" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return FINAL ;}
"interface" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return INTERFACE ;}
"static" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return STATIC ;}
"void" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return VOID ;}
"class" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "$class"); return CLASS ;}
"finally" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return FINALLY ;}
"long" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "long"); return LONG ;}
"strictfp" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return STRICTFP ;}
"volatile" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return VOLATILE ;}
"const" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return CONST ;}
"float" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX, "float"); return FLOAT ;}
"native" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return NATIVE ;}
"super" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return SUPER ;}
"while" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return WHILE ;}
"_" { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return UNDERSCORE ;}

"exports"   { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return EXPORTS; }
"opens"     { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return OPENS; }
"requires"  { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return REQUIRES; }
"uses"      { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return USES; }
"module"    { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return MODULE; }
"permits"   { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return PERMITS; }
"sealed"    { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return SEALED; }
"var"       { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return VAR; }
"provides"  { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return PROVIDES; }
"to"        { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return TO; }
"with"      { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return WITH; }
"open"      { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return OPEN; }
"record"    { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return RECORD; }
"transitive"    { yylval.node = FixedNode(KEYWORD_PREFIX, yytext, KEYWORD_SUFFIX); return TRANSITIVE; }

"(" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return LeftParenthesis; }
")" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return RightParenthesis; }
"{" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return LeftCurlyBrace; }
"}" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return RightCurlyBrace; }
"[" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return LeftSquareBracket; }
"]" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return RightSquareBracket; }
";" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return Semicolon; }
"," { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return Comma; }
"." { yylval.node = FixedNode("", yytext, ""); return Dot; }
"..." { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return ellipsis;}
"@" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return AtSign;}
"::" { yylval.node = FixedNode(SEPARATOR_PREFIX, yytext, SEPARATOR_SUFFIX); return Scope;}

"=" { yylval.node = FixedNode("", yytext, ""); return ASSIGN; }
">" { yylval.node = FixedNode("", yytext, ""); return GT; }
"<" { yylval.node = FixedNode("", yytext, ""); return LT; }
"!" { yylval.node = FixedNode("", yytext, ""); return EXCLAMATION; }
"~" { yylval.node = FixedNode("", yytext, ""); return TILDE; }
"?" { yylval.node = FixedNode("", yytext, ""); return QUESTIONMARK; }
":" { yylval.node = FixedNode("", yytext, ""); return COLON; }
"->" { yylval.node = FixedNode("", yytext, ""); return ARROW; }
"==" { yylval.node = FixedNode("", yytext, ""); return EQUAL; }
">=" { yylval.node = FixedNode("", yytext, ""); return GE; }
"<=" { yylval.node = FixedNode("", yytext, ""); return LE; }
"!=" { yylval.node = FixedNode("", yytext, ""); return NOTEQUAL; }
"&&" { yylval.node = FixedNode("", yytext, ""); return AND; }
"||" { yylval.node = FixedNode("", yytext, ""); return OR; }
"++" { yylval.node = FixedNode("", yytext, ""); return INC; }
"--" { yylval.node = FixedNode("", yytext, ""); return DEC; }
"+" { yylval.node = FixedNode("", yytext, ""); return ADD; }
"-" { yylval.node = FixedNode("", yytext, ""); return SUB; }
"*" { yylval.node = FixedNode("", yytext, ""); return MUL; }
"/" { yylval.node = FixedNode("", yytext, ""); return DIV; }
"&" { yylval.node = FixedNode("", yytext, ""); return BITAND; }
"|" { yylval.node = FixedNode("", yytext, ""); return BITOR; }
"^" { yylval.node = FixedNode("", yytext, ""); return CARET; }
"%" { yylval.node = FixedNode("", yytext, ""); return MOD; }
"<<" { yylval.node = FixedNode("", yytext, ""); return LSHIFT; }
">>" { yylval.node = FixedNode("", yytext, ""); return RSHIFT; }
">>>" { yylval.node = FixedNode("", yytext, ""); return URSHIFT; }
"+=" { yylval.node = FixedNode("", yytext, ""); return ADD_ASSIGN; }
"-=" { yylval.node = FixedNode("", yytext, ""); return SUB_ASSIGN; }
"*=" { yylval.node = FixedNode("", yytext, ""); return MUL_ASSIGN; }
"/=" { yylval.node = FixedNode("", yytext, ""); return DIV_ASSIGN; }
"&=" { yylval.node = FixedNode("", yytext, ""); return AND_ASSIGN; }
"|=" { yylval.node = FixedNode("", yytext, ""); return OR_ASSIGN; }
"^=" { yylval.node = FixedNode("", yytext, ""); return XOR_ASSIGN; }
"%=" { yylval.node = FixedNode("", yytext, ""); return MOD_ASSIGN; }
"<<=" { yylval.node = FixedNode("", yytext, ""); return LSHIFT_ASSIGN; }
">>=" { yylval.node = FixedNode("", yytext, ""); return RSHIFT_ASSIGN; }
">>>=" { yylval.node = FixedNode("", yytext, ""); return URSHIFT_ASSIGN; }

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

{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral} { yylval.node = FixedNode(LITERAL_PREFIX, yytext, LITERAL_SUFFIX); return IntegerLiteral; }
{FloatingPointLiteral} { yylval.node = FixedNode(LITERAL_PREFIX, yytext, LITERAL_SUFFIX); return FloatingPointLiteral; }
{BooleanLiteral} { yylval.node = FixedNode(LITERAL_PREFIX, yytext, LITERAL_SUFFIX); return BooleanLiteral; }
{CharLiteral} { yylval.node = FixedNode(LITERAL_PREFIX, yytext, LITERAL_SUFFIX); return CharacterLiteral; }
{NullLiteral} { yylval.node = FixedNode(LITERAL_PREFIX, yytext, LITERAL_SUFFIX); return NullLiteral; }

(\"\"\")[ ]*([\n\r]|[\r][\n])([^\\]|(\\\\))*(\"\"\") { yylval.node = FixedNode(IDENTIFIER_PREFIX, yytext, IDENTIFIER_SUFFIX); return TextBlock;}
[\'][\\][\'] { std::cout << yytext << " Line number is " << yylineno << " Illegal Character is " << yytext[0] << '\n'; }
[\'][\'][\'] { std::cout << yytext << " Line number is " << yylineno << " Illegal Character is " << yytext[1] << '\n'; }
[\'].[\'] { yylval.node = FixedNode(LITERAL_PREFIX, yytext, LITERAL_SUFFIX); return CharacterLiteral; }

[a-zA-Z$_]+[$_a-zA-Z0-9]* { yylval.node = FixedNode(IDENTIFIER_PREFIX, yytext, IDENTIFIER_SUFFIX, std::string(yytext)); return IdentifierChars; }


. { std::cout << yytext<<" Line number is " << yylineno << " Illegal Character is " << yytext[0] << '\n'; }

%%
