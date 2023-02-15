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

%type<str> Identifier
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
%token Semicolon Comma  Dot  AtSign 
%token Scope ellipsis 
%token ASSIGN GT LT EXCLAMATION TILDE QUESTIONMARK COLON ARROW EQUAL GE LE NOTEQUAL AND OR INC DEC ADD SUB MUL DIV BITAND BITOR CARET MOD LSHIFT RSHIFT URSHIFT ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN MOD_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN URSHIFT_ASSIGN 
%token IdentifierChars

%type<str> CompilationUnit  OrdinaryCompilationUnit  ModularCompilationUnit ImportDeclaration ImportDeclarationList PackageDeclaration ModuleDeclaration TopLevelClassOrInterfaceDeclaration TopLevelClassOrInterfaceDeclarationList
%type<str> ClassDeclaration InterfaceDeclaration EnumDeclaration RecordDeclaration ClassBody ClassExtends ClassExtendsOpt ClassImplements ClassImplementsOpt ClassModifier ClassModifierList ClassPermits ClassPermitsOpt 
%type<str> TypeIdentifier TypeParameters TypeParametersOpt Annotation

%%

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

ModularCompilationUnit: ImportDeclarationList ModuleDeclaration Semicolon

TopLevelClassOrInterfaceDeclaration: ClassDeclaration
    | InterfaceDeclaration
;

ClassDeclaration: NormalClassDeclaration
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



ClassExtends: extends ClassType;


// ClassType: {Annotation} TypeIdentifier TypeArgumentsOpt
// | PackageName . {Annotation} TypeIdentifier TypeArgumentsOpt
// | ClassOrInterfaceType . {Annotation} TypeIdentifier TypeArgumentsOpt
// ;

AnnotationList : 
| AnnotationList Annotation
;

TypeArgumentsOpt : 
    | TypeArguments
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
| PackageOrTypeName Dot TypeIdentifier
; 

PackageOrTypeName: Identifier
    | PackageOrTypeName Dot Identifier
;


ClassBody: LeftCurlyBrace ClassBodyDeclarationList RightCurlyBrace
;

ClassBodyDeclarationList : 
| ClassBodyDeclarationList ClassBodyDeclaration
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

FieldDeclaration: FieldModifierList UnannType VariableDeclaratorList Semicolon

FieldModifierList : | FieldModifierList FieldModifier 

FieldModifier:  Annotation | public |  protected | private | static  | final | transient | volatile

VariableDeclaratorList: VariableDeclarator {, VariableDeclarator}

CommaVariableDeclaratorList : 
| VariableDeclaratorList Comma VariableDeclarator
;


VariableDeclarator: VariableDeclaratorId AssignVariableInitializerOpt

AssignVariableInitializer : ASSIGN VariableInitializer

AssignVariableInitializerOpt : | AssignVariableInitializer

VariableDeclaratorId: Identifier DimsOpt

VariableInitializer: Expression
| ArrayInitializer
;

UnannType: UnannPrimitiveType
| UnannReferenceType
;
UnannPrimitiveType: NumericType
| boolean
;

UnannReferenceType: UnannClassOrInterfaceType
| UnannTypeVariable
| UnannArrayType
;

UnannClassOrInterfaceType: UnannClassType
| UnannInterfaceType
;

UnannClassType: TypeIdentifier TypeArgumentsOpt
| PackageName Dot AnnotationList TypeIdentifier TypeArgumentsOpt
| UnannClassOrInterfaceType Dot AnnotationList TypeIdentifier TypeArgumentsOpt
;

UnannInterfaceType: UnannClassType

UnannTypeVariable: TypeIdentifier


UnannArrayType: UnannPrimitiveType Dims
| UnannClassOrInterfaceType Dims
| UnannTypeVariable Dims
;


MethodDeclaration: {MethodModifier} MethodHeader MethodBody

MethodModifierList : | MethodModifierList MethodModifier 

MethodModifier: Annotation | public | protected | private | abstract | static | final | synchronized | native | strictfp

MethodHeader: Result MethodDeclarator ThrowsOpt
| TypeParameters AnnotationList Result MethodDeclarator ThrowsOpt
;

Result: UnannType | void


MethodDeclarator: Identifier LeftParenthesis ReceiverParameterCommaOpt FormalParameterListOpt RightParenthesis DimsOpt

ReceiverParameterCommaOpt : | ReceiverParameter Comma

ReceiverParameter: AnnotationList UnannType IdentifierDotOpt this

IdentifierDotOpt : | Identifier Dot

FormalParameterList: FormalParameter CommaFormalParameterList

CommaFormalParameterList : | CommaFormalParameterList Comma FormalParameter

FormalParameter: VariableModifierList UnannType VariableDeclaratorId
| VariableArityParameter
;

VariableArityParameter: VariableModifierList UnannType AnnotationList ellipsis Identifier

VariableModifier: Annotation | final

Throws: throws ExceptionTypeList

ExceptionTypeList: ExceptionType CommaExceptionTypeList

CommaExceptionTypeList : | CommaExceptionTypeList Comma ExceptionType


ExceptionType: ClassType
| TypeVariable
;

MethodBody: Block
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
ConstructorBody: LeftParenthesis ExplicitConstructorInvocationOpt BlockStatementsOpt RightParenthesis
;

ExplicitConstructorInvocationOpt:
    | ExplicitConstructorInvocation
;

BlockStatementsOpt :
    | BlockStatements
;

ExplicitConstructorInvocation: TypeArgumentsOpt this LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
    | TypeArgumentsOpt super LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
    | ExpressionName Dot TypeArgumentsOpt super LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
    | Primary Dot TypeArgumentsOpt super LeftParenthesis ArgumentListOpt RightParenthesis Semicolon
;

ArgumentListOpt:
    | ArgumentList
;

ArrayInitializer: LeftParenthesis VariableInitializerListOpt CommaOpt RightParenthesis

CommaOpt : | Comma

VariableInitializerListOpt :  | VariableInitializerList

VariableInitializerList: VariableInitializer {, VariableInitializer}

CommaVariableInitializerList :  | CommaVariableInitializerList Comma VariableInitializer

Block: LeftParenthesis BlockStatementsOpt RightParenthesis

BlockStatements: BlockStatement BlockStatementList

BlockStatementList : | BlockStatementList BlockStatement

BlockStatement: LocalClassOrInterfaceDeclaration
| LocalVariableDeclarationStatement
| Statement
;
LocalClassOrInterfaceDeclaration: ClassDeclaration
| NormalInterfaceDeclaration
;


LocalVariableDeclarationStatement: LocalVariableDeclaration Semicolon

LocalVariableDeclaration: VariableModifierList LocalVariableType VariableDeclaratorList

VariableModifierList : | VariableModifierList VariableModifier 

LocalVariableType: UnannType | var

Statement: StatementWithoutTrailingSubstatement
| LabeledStatement
| IfThenStatement
| IfThenElseStatement
| WhileStatement
| ForStatement
;

StatementNoShortIf: StatementWithoutTrailingSubstatement
| LabeledStatementNoShortIf
| IfThenElseStatementNoShortIf
| WhileStatementNoShortIf
| ForStatementNoShortIf
;

StatementWithoutTrailingSubstatement: Block
| EmptyStatement
| ExpressionStatement
| AssertStatement
| BreakStatement
| ContinueStatement
| ReturnStatement
| ThrowStatement
| TryStatement
| YieldStatement
;

EmptyStatement: Semicolon

LabeledStatement: Identifier COLON Statement

ExpressionStatement: StatementExpression Semicolon

StatementExpression: Assignment
| PreIncrementExpression
| PreDecrementExpression
| PostIncrementExpression
| PostDecrementExpression
| MethodInvocation
| ClassInstanceCreationExpression
;

IfThenStatement: if LeftParenthesis Expression RightParenthesis Statement

IfThenElseStatement: if LeftParenthesis Expression RightParenthesis StatementNoShortIf else Statement

IfThenElseStatementNoShortIf: if LeftParenthesis Expression RightParenthesis StatementNoShortIf else StatementNoShortIf

AssertStatement: assert Expression Semicolon
| assert Expression COLON Expression Semicolon

SwitchStatement: 

WhileStatement: while LeftParenthesis Expression RightParenthesis Statement

WhileStatementNoShortIf: while LeftParenthesis Expression RightParenthesis StatementNoShortIf

ForStatement: BasicForStatement
| EnhancedForStatement
;

ForStatementNoShortIf: BasicForStatementNoShortIf
| EnhancedForStatementNoShortIf
;

BasicForStatement: for LeftParenthesis ForInitOpt Semicolon ExpressionOpt Semicolon ForUpdateOpt RightParenthesis Statement


BasicForStatementNoShortIf: for LeftParenthesis ForInitOpt Semicolon ExpressionOpt Semicolon ForUpdateOpt RightParenthesis StatementNoShortIf


ForInitOpt : | ForInit 

ExpressionOpt : | Expression 

ForUpdateOpt: | ForUpdate


ForInit: StatementExpressionList
| LocalVariableDeclaration
;

ForUpdate: StatementExpressionList

StatementExpressionList: StatementExpression CommaStatementExpressionList

CommaStatementExpressionList : 
| CommaStatementExpressionList Comma StatementExpression 
;

EnhancedForStatement: for LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement

EnhancedForStatementNoShortIf: for LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf

BreakStatement: break IdentifierOpt Semicolon

IdentifierOpt: | Identifier 

YieldStatement: yield Expression Semicolon

ContinueStatement: continue IdentifierOpt Semicolon

ReturnStatement: return ExpressionOpt Semicolon

TryStatement: try Block Catches
| try Block CatchesOpt Finally
| TryWithResourcesStatement
;

CatchesOpt :  | Catches


Catches: CatchClause CatchClauseList

CatchClauseList :  | CatchClauseList CatchClause


CatchClause: catch LeftParenthesis CatchFormalParameter RightParenthesis 

CatchFormalParameter: VariableModifierList CatchType VariableDeclaratorId

CatchType: UnannClassType BitOrClassTypeList

BitOrClassTypeList : 
| BitOrClassTypeList BITOR ClassType

Finally: finally Block

Pattern: TypePattern 

TypePattern: LocalVariableDeclaration



Primary: PrimaryNoNewArray | ArrayCreationExpression

PrimaryNoNewArray: Literal | ClassLiteral | this
| TypeName . this
| LeftParenthesis Expression RightParenthesis
| ClassInstanceCreationExpression
| FieldAccess
| ArrayAccess
| MethodInvocation
| MethodReference
;

ClassLiteral: TypeName LeftRightSquareList Dot class
| NumericType LeftRightSquareList Dot class
| boolean LeftRightSquareList Dot class
| void Dot class
;

LeftRightSquareList:  | LeftRightSquareList LeftSquareBracket RightSquareBracket

ClassInstanceCreationExpression: UnqualifiedClassInstanceCreationExpression
| ExpressionName Dot UnqualifiedClassInstanceCreationExpression
| Primary Dot UnqualifiedClassInstanceCreationExpression
;

UnqualifiedClassInstanceCreationExpression: new TypeArgumentsOpt ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentListOpt RightParenthesis [ClassBody]


ClassBodyOpt : | ClassBody


ClassOrInterfaceTypeToInstantiate: AnnotationList Identifier {. {Annotation} Identifier} [TypeArgumentsOrDiamond]


TypeArgumentsOrDiamond: TypeArguments
| LT GT
;

FieldAccess: Primary Dot Identifier
| super Dot Identifier
| TypeName Dot super Dot Identifier
;

ArrayAccess:ExpressionName LeftSquareBracket Expression RightSquareBracket
| PrimaryNoNewArray LeftSquareBracket Expression RightSquareBracket
;

MethodInvocation: MethodName LeftParenthesis ArgumentListOpt RightParenthesis
| TypeName Dot TypeArgumentsOpt Identifier LeftParenthesis ArgumentListOpt RightParenthesis
| ExpressionName Dot TypeArgumentsOpt Identifier LeftParenthesis ArgumentListOpt RightParenthesis
| Primary Dot TypeArgumentsOpt Identifier LeftParenthesis ArgumentListOpt RightParenthesis
| super Dot TypeArgumentsOpt Identifier LeftParenthesis ArgumentListOpt RightParenthesis
| TypeName Dot super Dot TypeArgumentsOpt Identifier LeftParenthesis ArgumentListOpt RightParenthesis
;


ArgumentList: Expression CommaExpressionList
;

CommaExpressionList : | CommaExpressionList Comma Expression 

MethodReference: ExpressionName Scope TypeArgumentsOpt Identifier
| Primary Scope TypeArgumentsOpt Identifier
| ReferenceType Scope TypeArgumentsOpt Identifier
| super Scope TypeArgumentsOpt Identifier
| TypeName Dot super Scope TypeArgumentsOpt Identifier
| ClassType Scope TypeArgumentsOpt new
| ArrayType Scope new
| ArrayCreationExpression 
;



ArrayCreationExpression: new PrimitiveType DimExprs DimsOpt
| new ClassOrInterfaceType DimExprs DimsOpt
;

DimsOpt : | Dims

DimExprs: DimExpr DimExprList

DimExprList : | DimExprList DimExpr

DimExpr: AnnotationList LeftSquareBracket Expression RightSquareBracket

Expression: LambdaExpression
| AssignmentExpression
;

LambdaExpression :

AssignmentExpression: ConditionalExpression
| Assignment
;


Assignment: LeftHandSide AssignmentOperator Expression

LeftHandSide: ExpressionName
| FieldAccess
| ArrayAccess
;


AssignmentOperator: ASSIGN | MUL_ASSIGN  | DIV_ASSIGN |  MOD_ASSIGN | ADD_ASSIGN | SUB_ASSIGN | LSHIFT_ASSIGN | RSHIFT_ASSIGN | URSHIFT_ASSIGN | AND_ASSIGN | XOR_ASSIGN | OR_ASSIGN

ConditionalExpression: ConditionalOrExpression
| ConditionalOrExpression QUESTIONMARK Expression COLON ConditionalExpression
| ConditionalOrExpression QUESTIONMARK Expression COLON LambdaExpression
;

ConditionalOrExpression: ConditionalAndExpression
| ConditionalOrExpression OR ConditionalAndExpression
;

ConditionalAndExpression: InclusiveOrExpression
| ConditionalAndExpression AND InclusiveOrExpression
;

InclusiveOrExpression: ExclusiveOrExpression
| InclusiveOrExpression BITOR ExclusiveOrExpression 
;

ExclusiveOrExpression: AndExpression
| ExclusiveOrExpression CARET AndExpression
;

AndExpression: EqualityExpression
| AndExpression BITAND EqualityExpression
;

EqualityExpression: RelationalExpression
| EqualityExpression EQUAL RelationalExpression
| EqualityExpression NOTEQUAL RelationalExpression
;

EqualityExpression: RelationalExpression
| EqualityExpression EQUAL RelationalExpression
| EqualityExpression NOTEQUAL RelationalExpression
;

InstanceofExpression: RelationalExpression instanceof ReferenceType
| RelationalExpression instanceof Pattern
;

ShiftExpression: AdditiveExpression
| ShiftExpression LSHIFT AdditiveExpression
| ShiftExpression RSHIFT AdditiveExpression
| ShiftExpression URSHIFT AdditiveExpression
;


AdditiveExpression: MultiplicativeExpression
| AdditiveExpression ADD MultiplicativeExpression
| AdditiveExpression SUB MultiplicativeExpression
;

MultiplicativeExpression: UnaryExpression
| MultiplicativeExpression MUL UnaryExpression
| MultiplicativeExpression DIV UnaryExpression
| MultiplicativeExpression MOD UnaryExpression
;

UnaryExpression: PreIncrementExpression
| PreDecrementExpression
| ADD UnaryExpression
| SUB UnaryExpression
| UnaryExpressionNotPlusMinus
;

PreIncrementExpression: INC UnaryExpression

PreDecrementExpression: DEC UnaryExpression
;

UnaryExpressionNotPlusMinus: PostfixExpression
| TILDE UnaryExpression
| EXCLAMATION UnaryExpression
| CastExpression
| SwitchExpression
;

PostfixExpression: Primary
| ExpressionName
| PostIncrementExpression
| PostDecrementExpression

PostIncrementExpression:  PostfixExpression INC


PostDecrementExpression: PostfixExpression DEC


CastExpression: LeftParenthesis PrimitiveType RightParenthesis UnaryExpression
| LeftParenthesis ReferenceType AdditionalBoundList RightParenthesis UnaryExpressionNotPlusMinus
| LeftParenthesis ReferenceType AdditionalBoundList RightParenthesis LambdaExpression
;

ConstantExpression: Expression

Type: PrimitiveType
| ReferenceType
;


PrimitiveType: AnnotationList NumericType
| AnnotationList boolean
;

NumericType: IntegralType
| FloatingPointType
;

IntegralType:  byte | short | int | long | char

FloatingPointType:  float | double

ReferenceType: ClassOrInterfaceType
| TypeVariable
| ArrayType
;


ClassOrInterfaceType: ClassType
| InterfaceType
;

InterfaceType: ClassType
;


ClassType: AnnotationList TypeIdentifier TypeArgumentsOpt
| PackageName Dot AnnotationList TypeIdentifier TypeArgumentsOpt
| ClassOrInterfaceType Dot AnnotationList TypeIdentifier TypeArgumentsOpt
;


TypeVariable: AnnotationList TypeIdentifier

ArrayType: PrimitiveType Dims
| ClassOrInterfaceType Dims
| TypeVariable Dims
;

Dims: AnnotationList LeftSquareBracket RightSquareBracket AnnotationListLeftRightSquareList

AnnotationListLeftRightSquareList :  | AnnotationList LeftSquareBracket RightSquareBracket

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

TypeArguments: LT TypeArgumentList GT


TypeArgumentList: TypeArgument {, TypeArgument}

CommaTypeArgumentList : |  TypeArgumentList Comma TypeArgument

TypeArgument: ReferenceType
| Wildcard
;

Wildcard: AnnotationList QUESTIONMARK WildcardBoundsOpt

WildcardBoundsOpt :  |  WildcardBounds 

WildcardBounds: extends ReferenceType
| super ReferenceType
;

ModuleName: Identifier | ModuleName Dot Identifier
PackageName: Identifier | PackageName Dot Identifier
TypeName: TypeIdentifier | PackageOrTypeName Dot TypeIdentifier
ExpressionName: Identifier | AmbiguousName Dot Identifier
MethodName: UnqualifiedMethodIdentifier
PackageOrTypeName: Identifier | PackageOrTypeName Dot Identifier
AmbiguousName: Identifier | AmbiguousName Dot Identifier

Identifier :  IdentifierChars
TypeIdentifier : IdentifierChars | abstract | continue | for | new | switch | assert | default | if | package | synchronized | boolean | do | goto | private | this | break | double | implements | protected | throw | byte | else | import | public | throws | case | enum | instanceof | return | transient | catch | extends | int | short | try | char | final | interface | static | void | class | finally | long | strictfp | volatile | const | float | native | super | while | underscore
| exports | opens | requires | uses | module | non-sealed | provides | to | with | open | transitive

UnqualifiedMethodIdentifier : IdentifierChars | abstract | continue | for | new | switch | assert | default | if | package | synchronized | boolean | do | goto | private | this | break | double | implements | protected | throw | byte | else | import | public | throws | case | enum | instanceof | return | transient | catch | extends | int | short | try | char | final | interface | static | void | class | finally | long | strictfp | volatile | const | float | native | super | while | underscore
| exports | opens | requires | uses | module | non-sealed | provides | to | with | open | transitive | permits | record | sealed | var

Literal : IntegerLiteral | FloatingPointLiteral | BooleanLiteral |CharacterLiteral
|StringLiteral
|TextBlock
|NullLiteral

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
