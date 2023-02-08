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

"abstract"|"continue"|"for"|"new"|"switch"|"assert"|"default"|"if"|"package"|"synchronized"|"boolean"|"do"|"goto"|"private "|"this"|"break"|"double"|"implements"|"protected"|"throw"|"byte"|"else"|"import"|"public"|"throws"|"case"|"enum"|"instanceof"|"return"|"transient"|"catch"|"extends"|"int"|"short"|"try"|"char"|"final"|"interface"|"static"|"void"|"class"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"while"|"_" {
    mp1[yytext]="Keyword"; mp2[yytext]++; if(mp2[yytext]!=1){} else v.push_back(yytext);
}
"exports"|"opens"|"requires"|"uses"|"module"|"permits"|"sealed"|"var"|"non-sealed"|"provides"|"to"|"with"|"open"|"record"|"transitive"|"yield" {
    mp1[yytext]="Keyword"; mp2[yytext]++; if(mp2[yytext]!=1){} else v.push_back(yytext);
}

"("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::" {mp1[yytext]="Separator"; mp2[yytext]++; if(mp2[yytext]!=1){} else v.push_back(yytext);}

"="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>=" {
    mp1[yytext]="Operator"; mp2[yytext]++; if(mp2[yytext]!=1){} else v.push_back(yytext);
}

(\"\"\")[ ]*([\n\r]|[\r][\n])([^\\]|(\\\\))*(\"\"\") {mp1[yytext]="Literal";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext);}


[\"]([^\"\\\n]|(\\\")|(\\\\))*[\"] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);

}


[\'][\\][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[0]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}

[\'][\'][\'] {cout<<yytext<<" "<<" Line number is "<<yylineno<< " Illegal Character is "<<yytext[1]<<endl; mp1[yytext]="Illegal";mp2[yytext]++;}
[\'].[\'] {

    mp1[yytext]="Literal";
    mp2[yytext]++; 
    if(mp2[yytext]!=1){} else v.push_back(yytext);

}


{Literals} {mp1[yytext]="Literal";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext);}

[a-zA-Z$_]+[$_a-zA-Z0-9]* {mp1[yytext]="Identifier";mp2[yytext]++;if(mp2[yytext]!=1){} else v.push_back(yytext); yylval.str = strdup(yytext) ;return IDENTIFIER;}
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
