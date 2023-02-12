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

%token<str> Identifier
%token<str> abstract continue for new switch assert default if package synchronized boolean do goto private this break double implements protected throw byte else import public throws case enum instanceof return transient catch extends int short try char final interface static void class finally long strictfp volatile const float native super while underscore
%token<str> exports opens requires uses module permits sealed var non-sealed provides to with open record transitive yield
%token CharacterLiteral 
%token BooleanLiteral
%token IntegerLiteral
%token FloatingPointLiteral
%token StringLiteral
%token TextBlock 
%token NullLiteral
%token LeftParenthesis  RightParenthesis  LeftCurlyBrace RightCurlyBrace LeftSquareBracket  RightSquareBracket
%token Semicolon Comma  Period  AtSign 
%token Scope ellipsis 
%token ASSIGN GT LT EXCLAMATION TILDE QUESTIONMARK COLON ARROW EQUAL GE LE NOTEQUAL AND OR INC DEC ADD SUB MUL DIV BITAND BITOR CARET MOD LSHIFT RSHIFT URSHIFT ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN MOD_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN URSHIFT_ASSIGN 

%type<str> CompilationUnit  OrdinaryCompilationUnit  ModularCompilationUnit ImportDeclaration ImportDeclarationList PackageDeclaration ModuleDeclaration TopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclarationList
%type<str> ClassDeclaration InterfaceDeclaration EnumDeclaration RecordDeclaration ClassBody ClassExtends ClassExtendsOpt ClassImplements ClassImplementsOpt ClassModifier ClassModifierList ClassPermits ClassPermitsOpt 
%type<str> TypeIdentifier TypeParameters TypeParametersOpt Annotation

%%

program : 
    | program identifier {printf("%s\n", $2);}
;

CompilationUnit: OrdinaryCompilationUnit
    | ModularCompilationUnit
;

OrdinaryCompilationUnit: ImportDeclarationList TopLevelClassOrInterfaceDeclarationList
    | PackageDeclaration ImportDeclarationList TopLevelClassOrInterfaceDeclarationList 
;

ImportDeclarationList: 
    | ImportDeclarationList ImportDeclaration
;


PackageDeclaration :
;

ImportDeclaration : 
;
TopLevelClassOrInterfaceDeclarationList:
    | TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration
;

ModularCompilationUnit: ImportDeclarationList ModuleDeclaration ;

TopLevelClassOrInterfaceDeclaration: ClassDeclaration
    | InterfaceDeclaration
;

ClassDeclaration: NormalClassDeclaration
    | EnumDeclaration
    | RecordDeclaration
;

NormalClassDeclaration : ClassModifierList class TypeIdentifier TypeParametersOpt ClassExtendsOpt ClassImplementsOpt ClassPermitsOpt ClassBody
;
//  {ClassModifier} class TypeIdentifier [TypeParameters] [ClassExtends] [ClassImplements] [ClassPermits] ClassBody
ClassModifierList : 
    | ClassModifierList ClassModifier
;

TypeParametersOpt : 
    | TypeParameters
;

ClassExtendsOpt :
    | ClassExtends
;

ClassImplementsOpt:
    | ClassImplements
;

ClassPermitsOpt:
    | ClassPermits;

ClassModifier: Annotation | public | protected | private | abstract | static | final | sealed | non-sealed | strictfp

Annotation:
;

TypeIdentifier :
;

TypeParameters: LT TypeParameterList GT
;
// < TypeParameterList >
TypeParameterList: TypeParameter CommaTypeParameterList

CommaTypeParameterList : 
    | Comma TypeParameter CommaTypeParameterList


TypeParameter: TypeParameterModifierList TypeIdentifier TypeBoundOpt
;
//{TypeParameterModifier} TypeIdentifier [TypeBound] 
TypeParameterModifierList : 
    | TypeParameterModifierList TypeParameterModifier
;

TypeBoundOpt : 
    | TypeBound
;

TypeParameterModifier: Annotation;

TypeBound: extends TypeVariable
    | extends ClassOrInterfaceType AdditionalBoundList
;

AdditionalBoundList : 
    | AdditionalBoundList AdditionalBound
;

AdditionalBound: Amprescent InterfaceType
// & InterfaceType 
;

ClassExtends: extends ClassType;


ClassType: AnnotationList TypeIdentifier TypeArgumentsOpt
| PackageName Period AnnotationList TypeIdentifier TypeArgumentsOpt
| ClassOrInterfaceType Period AnnotationList TypeIdentifier TypeArgumentsOpt
;
// ClassType: {Annotation} TypeIdentifier [TypeArguments]
// | PackageName . {Annotation} TypeIdentifier [TypeArguments]
// | ClassOrInterfaceType . {Annotation} TypeIdentifier [TypeArguments]
// ;

AnnotationList : 
| AnnotationList Annotation
;

TypeArgumentsOpt : 
    | TypeArguments
;

ClassOrInterfaceType: ClassType
| InterfaceType
;

InterfaceType: ClassType
;

ClassImplements: implements InterfaceTypeList;

InterfaceTypeList: InterfaceType CommaInterfaceTypeList
;
//InterfaceType {, InterfaceType}

CommaInterfaceTypeList :
| Comma InterfaceType CommaInterfaceTypeList
;

ClassPermits: permits TypeName CommaTypeNameList

CommaTypeNameList : 
 | Comma TypeName CommaTypeNameList
;


TypeName: TypeIdentifier
| PackageOrTypeName Period TypeIdentifier
; 

PackageOrTypeName: Identifier
    | PackageOrTypeName Period Identifier
;

ClassBody: ClassBodyDeclarationBracesList
;

ClassBodyDeclarationBraces : LeftCurlyBrace ClassBodyDeclaration RightCurlyBrace
;

ClassBracesBodyDeclarationBracesList : 
    | ClassBodyDeclarationBracesList ClassBodyDeclarationBraces
;

ClassBodyDeclaration: ClassMemberDeclaration
    |InstanceInitializer
    |StaticInitializer
    |ConstructorDeclaration
;

ClassMemberDeclaration: FieldDeclaration
    | MethodDeclaration
    | ClassDeclaration
    | InterfaceDeclaration
    | Semicolon
;

InstanceInitializer: Block
;

StaticInitializer: static Block
;

ConstructorDeclaration: ConstructorModifierList ConstructorDeclarator ThrowsOpt ConstructorBody
;

ConstructorModifierList : Block
;

ConstructorDeclaration: ConstructorModifierList ConstructorDeclarator ThrowsOpt ConstructorBody
;

ConstructorModifierList : 
    | ConstructorModifierList ConstructorModifier
;

ThrowsOpt :
    | Throws
;

ConstructorModifier: Annotation  | public | protected | private
;

ConstructorDeclarator: TypeParametersOpt SimpleTypeName LeftParenthesis ReceiverParameterCommaOpt FormalParameterListOpt RightParenthesis
;

ReceiverParameterCommaOpt: 
    | ReceiverParameter Comma
;

FormalParameterListOpt:
    | FormalParameterList
;

SimpleTypeName: TypeIdentifier
;


// ConstructorBody: { [ExplicitConstructorInvocation] [BlockStatements] }
ConstructorBody: 
    | ConstructorBody ExplicitConstructorInvocationOpt BlockStatementsOpt
;

ExplicitConstructorInvocationOpt:
    | ExplicitConstructorInvocation
;

BlockStatementsOpt :
    | BlockStatements
;

ExplicitConstructorInvocation: TypeArgumentsOpt this LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
    | TypeArgumentsOpt super LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
    | ExpressionName Period TypeArgumentsOpt super LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
    | Primary Period TypeArgumentsOpt super LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
;

ArgumentListOpt:
    | ArgumentList
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
