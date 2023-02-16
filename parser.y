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
%token<str> abstract Continue for new switch assert default if package synchronized boolean do goto private this break double implements protected throw byte else import public throws case enum instanceof return transient catch extends int short try char final interface static void class finally long strictfp volatile const float native super while underscore
%token<str> CharacterLiteral 
%token<str> BooleanLiteral
%token<str> IntegerLiteral
%token<str> FloatingPointLiteral 
%token<str> StringLiteral
%token<str> TextBlock 
%token<str> NullLiteral
%token<str> LeftParenthesis  RightParenthesis  LeftCurlyBrace RightCurlyBrace LeftSquareBracket  RightSquareBracket
%token<str> Semicolon Comma  Dot  AtSign 
%token<str> Scope ellipsis 
%token<str> ASSIGN GT LT EXCLAMATION TILDE QUESTIONMARK COLON ARROW EQUAL GE LE NOTEQUAL AND OR INC DEC ADD SUB MUL DIV BITAND BITOR CARET MOD LSHIFT RSHIFT URSHIFT ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN MOD_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN URSHIFT_ASSIGN 
%token<str> IdentifierChars

%type<str> CompilationUnit  OrdinaryCompilationUnit  
%type<str> ClassDeclaration  ClassBody ClassExtends  ClassModifier ClassModifierList ClassPermits
%type<str> TypeIdentifier TypeParameters TypeParameterList CommaTypeParameterList 
%type<str> ThrowStatement RelationalExpression 
%type<str> TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration NormalClassDeclaration 
%type<str> CommaTypeNameList ClassBodyDeclaration ClassMemberDeclaration FieldDeclaration FieldModifierList VariableDeclaratorList
%type<str> CommaVariableDeclaratorList VariableDeclarator VariableDeclaratorId VariableInitializer UnannType UnannPrimitiveType UnannReferenceType
%type<str> UnannClassOrInterfaceType UnannClassType UnannTypeVariable UnannArrayType MethodDeclaration MethodModifierList
%type<str> MethodModifier MethodHeader Result MethodDeclarator ReceiverParameter FormalParameterList CommaFormalParameterList FormalParameter
%type<str> VariableArityParameter VariableModifierList VariableModifier Throws ExceptionTypeList CommaExceptionTypeList ExceptionType MethodBody
%type<str> InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorModifierList ConstructorModifier ConstructorDeclarator
%type<str> SimpleTypeName ConstructorBody ExplicitConstructorInvocation ArrayInitializer VariableInitializerList CommaVariableInitializerList
%type<str> Block BlockStatements BlockStatementList BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration
%type<str> LocalVariableType Statement ForStatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement
%type<str> ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement
%type<str> WhileStatementNoShortIf ForStatement 

%type<str> BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate StatementExpressionList CommaStatementExpressionList EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement 
%type<str> BitOrClassTypeList 
%type<str> Pattern TypePattern Primary PrimaryNoNewArray ClassLiteral LeftRightSquareList ClassInstanceCreationExpression
%type<str> DotIdentifierList TypeArgumentsOrDiamond FieldAccess ArrayAccess MethodInvocation ArgumentList CommaExpressionList MethodReference
%type<str> ArrayCreationExpression DimExprs DimExprList DimExpr Expression AssignmentExpression Assignment LeftHandSide AssignmentOperator ConditionalExpression
%type<str> ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression InstanceofExpression
%type<str> ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression PreIncrementExpression PreDecrementExpression
%type<str> UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression ConstantExpression Type PrimitiveType
%type<str> NumericType IntegralType FloatingPointType ReferenceType ClassOrInterfaceType ClassType TypeVariable ArrayType
%type<str> Dims  TypeParameter TypeBound TypeArguments TypeArgumentLists CommaTypeArgumentList TypeArgument Wildcard WildcardBounds TypeName
%type<str> ExpressionName MethodName   UnqualifiedMethodIdentifier Literal
%%

CompilationUnit: OrdinaryCompilationUnit
;

OrdinaryCompilationUnit: TopLevelClassOrInterfaceDeclarationList
;

TopLevelClassOrInterfaceDeclarationList: TopLevelClassOrInterfaceDeclaration
    | TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration
;



TopLevelClassOrInterfaceDeclaration: ClassDeclaration
;

ClassDeclaration: NormalClassDeclaration
;

NormalClassDeclaration :  class TypeIdentifier ClassExtends  ClassPermits ClassBody
| ClassModifierList class TypeIdentifier  ClassExtends  ClassPermits ClassBody
| class TypeIdentifier  ClassExtends   ClassBody
| ClassModifierList class TypeIdentifier  ClassExtends   ClassBody
| class TypeIdentifier    ClassPermits ClassBody
| ClassModifierList class TypeIdentifier    ClassPermits ClassBody
| class TypeIdentifier     ClassBody
| ClassModifierList class TypeIdentifier     ClassBody
| class TypeIdentifier TypeParameters ClassExtends  ClassPermits ClassBody
| ClassModifierList class TypeIdentifier TypeParameters ClassExtends  ClassPermits ClassBody
| class TypeIdentifier TypeParameters ClassExtends   ClassBody
| ClassModifierList class TypeIdentifier TypeParameters ClassExtends   ClassBody
| class TypeIdentifier TypeParameters   ClassPermits ClassBody
| ClassModifierList class TypeIdentifier TypeParameters   ClassPermits ClassBody
| class TypeIdentifier TypeParameters    ClassBody
| ClassModifierList class TypeIdentifier TypeParameters    ClassBody
;

ClassModifierList : ClassModifier
    | ClassModifierList ClassModifier
;


ClassModifier: public | private | static  


TypeParameters: LT TypeParameterList GT
;

TypeParameterList: TypeParameter CommaTypeParameterList | TypeParameter

CommaTypeParameterList : Comma TypeParameter
    | Comma TypeParameter CommaTypeParameterList



ClassExtends: extends ClassType;






ClassPermits: permits TypeName CommaTypeNameList | permits TypeName

CommaTypeNameList : Comma TypeName
 |Comma TypeName  CommaTypeNameList 
;


ClassBody: LeftCurlyBrace ClassBodyDeclarationList RightCurlyBrace | LeftCurlyBrace  RightCurlyBrace
;

ClassBodyDeclarationList : ClassBodyDeclaration
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
    | Semicolon
;

FieldDeclaration: FieldModifierList UnannType VariableDeclaratorList Semicolon
|  UnannType VariableDeclaratorList Semicolon

FieldModifierList : FieldModifier | FieldModifierList FieldModifier 

FieldModifier:  public  | private 

VariableDeclaratorList: VariableDeclarator | VariableDeclarator CommaVariableDeclaratorList

CommaVariableDeclaratorList : Comma VariableDeclarator
| VariableDeclaratorList Comma VariableDeclarator
;


VariableDeclarator: VariableDeclaratorId ASSIGN VariableInitializer
| VariableDeclaratorId
;


VariableDeclaratorId: Identifier Dims
| Identifier



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
;

UnannClassType: TypeIdentifier TypeArguments
| UnannClassOrInterfaceType Dot TypeIdentifier TypeArguments
| TypeIdentifier 
| UnannClassOrInterfaceType Dot TypeIdentifier 
| TypeIdentifier TypeArguments
| UnannClassOrInterfaceType Dot  TypeIdentifier TypeArguments
| UnannClassOrInterfaceType Dot  TypeIdentifier 
;


UnannTypeVariable: TypeIdentifier


UnannArrayType: UnannPrimitiveType Dims
| UnannClassOrInterfaceType Dims
| UnannTypeVariable Dims
;


MethodDeclaration: MethodModifierList MethodHeader MethodBody
|  MethodHeader MethodBody

MethodModifierList : MethodModifier | MethodModifierList MethodModifier 

MethodModifier: public | protected | private | static | native | strictfp

MethodHeader: Result MethodDeclarator 
|  Result MethodDeclarator Throws
| TypeParameters  Result MethodDeclarator Throws
| TypeParameters  Result MethodDeclarator 
;

Result: UnannType | void


MethodDeclarator: Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis 
| Identifier LeftParenthesis RightParenthesis 
| Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis 
| Identifier LeftParenthesis FormalParameterList RightParenthesis 
| Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis Dims
| Identifier LeftParenthesis RightParenthesis Dims
| Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis Dims
| Identifier LeftParenthesis FormalParameterList RightParenthesis Dims

ReceiverParameter: UnannType  this
| UnannType Identifier Dot this


FormalParameterList: FormalParameter CommaFormalParameterList | FormalParameter

CommaFormalParameterList : Comma FormalParameter | CommaFormalParameterList Comma FormalParameter

FormalParameter: VariableModifierList UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableArityParameter
;

VariableArityParameter:  UnannType  ellipsis Identifier
| VariableModifierList UnannType  ellipsis Identifier

VariableModifierList : VariableModifier| VariableModifierList VariableModifier 

VariableModifier: final

Throws: throws ExceptionTypeList

ExceptionTypeList: ExceptionType CommaExceptionTypeList | ExceptionType

CommaExceptionTypeList : Comma ExceptionType | CommaExceptionTypeList Comma ExceptionType


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

ConstructorDeclaration: ConstructorDeclarator ConstructorBody
| ConstructorModifierList ConstructorDeclarator ConstructorBody
| ConstructorDeclarator Throws ConstructorBody
| ConstructorModifierList ConstructorDeclarator Throws ConstructorBody
;

ConstructorModifierList : ConstructorModifier
    | ConstructorModifierList ConstructorModifier
;


ConstructorModifier: public | protected | private
;

ConstructorDeclarator:  SimpleTypeName LeftParenthesis  RightParenthesis
|TypeParameters SimpleTypeName LeftParenthesis  RightParenthesis
| SimpleTypeName LeftParenthesis ReceiverParameter Comma RightParenthesis
|TypeParameters SimpleTypeName LeftParenthesis ReceiverParameter Comma RightParenthesis
| SimpleTypeName LeftParenthesis  FormalParameterList RightParenthesis
|TypeParameters SimpleTypeName LeftParenthesis  FormalParameterList RightParenthesis
| SimpleTypeName LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
|TypeParameters SimpleTypeName LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
;

SimpleTypeName: TypeIdentifier
;


ConstructorBody: LeftParenthesis  RightParenthesis
| LeftParenthesis ExplicitConstructorInvocation RightParenthesis
| LeftParenthesis  BlockStatements RightParenthesis
| LeftParenthesis ExplicitConstructorInvocation BlockStatements RightParenthesis
;


ExplicitConstructorInvocation:  this LeftParenthesis RightParenthesis Semicolon
| TypeArguments this LeftParenthesis RightParenthesis Semicolon
| this LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments this LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments super LeftParenthesis ArgumentList RightParenthesis Semicolon
| super LeftParenthesis RightParenthesis Semicolon
| super LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments super LeftParenthesis  RightParenthesis Semicolon    
| ExpressionName Dot TypeArguments super LeftParenthesis ArgumentList RightParenthesis Semicolon
| ExpressionName Dot TypeArguments super LeftParenthesis RightParenthesis Semicolon
| ExpressionName Dot super LeftParenthesis ArgumentList RightParenthesis Semicolon
| ExpressionName Dot super LeftParenthesis RightParenthesis Semicolon     
| Primary Dot  super LeftParenthesis RightParenthesis Semicolon
| Primary Dot TypeArguments super LeftParenthesis RightParenthesis Semicolon
| Primary Dot  super LeftParenthesis ArgumentList RightParenthesis Semicolon
| Primary Dot TypeArguments super LeftParenthesis ArgumentList RightParenthesis Semicolon
;


ArrayInitializer: LeftParenthesis  Comma RightParenthesis 
| LeftParenthesis  RightParenthesis
| LeftParenthesis VariableInitializerList Comma RightParenthesis 
| LeftParenthesis VariableInitializerList  RightParenthesis


VariableInitializerList: VariableInitializer | VariableInitializer CommaVariableInitializerList

CommaVariableInitializerList :  Comma VariableInitializer | CommaVariableInitializerList Comma VariableInitializer


Block: LeftParenthesis BlockStatements RightParenthesis
|  LeftParenthesis RightParenthesis

BlockStatements: BlockStatementList

BlockStatementList : BlockStatement | BlockStatementList BlockStatement

BlockStatement: LocalClassOrInterfaceDeclaration
| LocalVariableDeclarationStatement
| Statement
;
LocalClassOrInterfaceDeclaration: ClassDeclaration
;


LocalVariableDeclarationStatement: LocalVariableDeclaration Semicolon

LocalVariableDeclaration: LocalVariableType 
| VariableModifierList LocalVariableType 
| LocalVariableType VariableDeclaratorList
| VariableModifierList LocalVariableType VariableDeclaratorList



LocalVariableType: UnannType | var

Statement: StatementWithoutTrailingSubstatement
| LabeledStatement
| IfThenStatement
| IfThenElseStatement
| WhileStatement
| ForStatement
;

StatementNoShortIf: StatementWithoutTrailingSubstatement
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


WhileStatement: while LeftParenthesis Expression RightParenthesis Statement

WhileStatementNoShortIf: while LeftParenthesis Expression RightParenthesis StatementNoShortIf

ForStatement: BasicForStatement
| EnhancedForStatement
;

ForStatementNoShortIf: BasicForStatementNoShortIf
| EnhancedForStatementNoShortIf
;

BasicForStatement: for LeftParenthesis  Semicolon  Semicolon  RightParenthesis Statement
| for LeftParenthesis ForInit Semicolon  Semicolon  RightParenthesis Statement
| for LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis Statement
| for LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis Statement
| for LeftParenthesis  Semicolon Expression Semicolon  RightParenthesis Statement
| for LeftParenthesis ForInit Semicolon Expression Semicolon  RightParenthesis Statement
| for LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
| for LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis Statement



BasicForStatementNoShortIf: for LeftParenthesis  Semicolon  Semicolon RightParenthesis StatementNoShortIf
| for LeftParenthesis ForInit Semicolon  Semicolon RightParenthesis StatementNoShortIf
| for LeftParenthesis  Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
| for LeftParenthesis ForInit Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
| for LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
| for LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
| for LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
| for LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf


ForInit: StatementExpressionList
| LocalVariableDeclaration
;

ForUpdate: StatementExpressionList

StatementExpressionList: StatementExpression  | StatementExpression CommaStatementExpressionList

CommaStatementExpressionList : Comma StatementExpression
| CommaStatementExpressionList Comma StatementExpression 
;

EnhancedForStatement: for LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement

EnhancedForStatementNoShortIf: for LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf

BreakStatement: break Identifier Semicolon
| break  Semicolon

YieldStatement: yield Expression Semicolon

ContinueStatement: Continue Semicolon
| Continue Identifier Semicolon
| Continue  Semicolon

ReturnStatement: return Semicolon
| return Expression Semicolon
| return  Semicolon

ThrowStatement: throw Expression Semicolon

BitOrClassTypeList : BITOR ClassType
| BitOrClassTypeList BITOR ClassType


Pattern: TypePattern 

TypePattern: LocalVariableDeclaration



Primary: PrimaryNoNewArray | ArrayCreationExpression

PrimaryNoNewArray: Literal | ClassLiteral | this
| TypeName Dot this
| LeftParenthesis Expression RightParenthesis
| ClassInstanceCreationExpression
| FieldAccess
| ArrayAccess
| MethodInvocation
| MethodReference
;

ClassLiteral: TypeName  Dot class
| NumericType  Dot class
| boolean  Dot class
| void Dot class
| TypeName LeftRightSquareList Dot class
| NumericType LeftRightSquareList Dot class
| boolean LeftRightSquareList Dot class
;

LeftRightSquareList:  LeftSquareBracket RightSquareBracket | LeftRightSquareList LeftSquareBracket RightSquareBracket

ClassInstanceCreationExpression: UnqualifiedClassInstanceCreationExpression
| ExpressionName Dot UnqualifiedClassInstanceCreationExpression
| Primary Dot UnqualifiedClassInstanceCreationExpression
;

UnqualifiedClassInstanceCreationExpression: new  ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis 
| new TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis 
| new  ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| new TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| new  ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
| new TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
| new  ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
| new TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody



ClassOrInterfaceTypeToInstantiate: Identifier DotIdentifierList
|  Identifier DotIdentifierList TypeArgumentsOrDiamond
|  Identifier DotIdentifierList
|  Identifier DotIdentifierList TypeArgumentsOrDiamond

DotIdentifierList : Dot Identifier 

TypeArgumentsOrDiamond: TypeArguments
;

FieldAccess: Primary Dot Identifier
| super Dot Identifier
| TypeName Dot super Dot Identifier
;

ArrayAccess:ExpressionName LeftSquareBracket Expression RightSquareBracket
| PrimaryNoNewArray LeftSquareBracket Expression RightSquareBracket
;

MethodInvocation: MethodName LeftParenthesis  RightParenthesis
| MethodName LeftParenthesis ArgumentList RightParenthesis

| TypeName Dot  Identifier LeftParenthesis  RightParenthesis
| TypeName Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| ExpressionName Dot  Identifier LeftParenthesis  RightParenthesis
| ExpressionName Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| ExpressionName Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| ExpressionName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| Primary Dot  Identifier LeftParenthesis  RightParenthesis
| Primary Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| Primary Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| Primary Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis

| super Dot  Identifier LeftParenthesis  RightParenthesis
| super Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| super Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| super Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| TypeName Dot super Dot  Identifier LeftParenthesis  RightParenthesis
| TypeName Dot super Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot super Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot super Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
;


ArgumentList: Expression | Expression CommaExpressionList 
;

CommaExpressionList : Comma Expression | CommaExpressionList Comma Expression 

MethodReference: ExpressionName Scope Identifier
|  ExpressionName Scope TypeArguments Identifier
| Primary Scope Identifier
|  Primary Scope TypeArguments 

| ReferenceType Scope Identifier
|  ReferenceType Scope TypeArguments Identifier

| super Scope Identifier
|  super Scope TypeArguments Identifier

| TypeName Dot super Scope Identifier
|  TypeName Dot super Scope TypeArguments Identifier

| ClassType Scope  new
| ClassType Scope TypeArguments new
| ArrayType Scope new
;



ArrayCreationExpression: new PrimitiveType DimExprs 
| new ClassOrInterfaceType DimExprs 
| new PrimitiveType DimExprs Dims
| new ClassOrInterfaceType DimExprs Dims
;


DimExprs:  DimExprList

DimExprList : DimExpr | DimExprList DimExpr

DimExpr: LeftSquareBracket Expression RightSquareBracket

Expression: AssignmentExpression
;


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

RelationalExpression: ShiftExpression
| RelationalExpression LT ShiftExpression
| RelationalExpression GT ShiftExpression
| RelationalExpression LE ShiftExpression
| RelationalExpression GE ShiftExpression
| InstanceofExpression


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
;

PostfixExpression: Primary
| ExpressionName
| PostIncrementExpression
| PostDecrementExpression

PostIncrementExpression:  PostfixExpression INC


PostDecrementExpression: PostfixExpression DEC


CastExpression: LeftParenthesis PrimitiveType RightParenthesis UnaryExpression
| LeftParenthesis ReferenceType  RightParenthesis UnaryExpressionNotPlusMinus
;

ConstantExpression: Expression


Type: PrimitiveType
| ReferenceType
;


PrimitiveType:  NumericType
|  boolean
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
;



ClassType:  TypeIdentifier 
| TypeIdentifier TypeArguments
| ClassOrInterfaceType Dot  TypeIdentifier 
| ClassOrInterfaceType Dot  TypeIdentifier TypeArguments
;


TypeVariable: TypeIdentifier

ArrayType: PrimitiveType Dims
| ClassOrInterfaceType Dims
| TypeVariable Dims
;

Dims: LeftSquareBracket RightSquareBracket 
| LeftSquareBracket RightSquareBracket LeftRightSquareList



TypeParameter:  TypeIdentifier 
| TypeIdentifier TypeBound




TypeBound: extends TypeVariable
    | extends ClassOrInterfaceType 
;



TypeArguments: LT TypeArgumentList GT


TypeArgumentList: TypeArgument CommaTypeArgumentList | TypeArgument

CommaTypeArgumentList :  Comma TypeArgument |  TypeArgumentList Comma TypeArgument

TypeArgument: ReferenceType
| Wildcard
;

Wildcard: QUESTIONMARK 
| QUESTIONMARK WildcardBounds

WildcardBounds: extends ReferenceType
| super ReferenceType
;

// ModuleName: Identifier | ModuleName Dot Identifier
// PackageName: Identifier | PackageName Dot Identifier
TypeName: TypeIdentifier 
ExpressionName: Identifier
MethodName: UnqualifiedMethodIdentifier
// PackageOrTypeName: Identifier | PackageOrTypeName Dot Identifier
// AmbiguousName: Identifier | AmbiguousName Dot Identifier

Identifier :  IdentifierChars
TypeIdentifier : IdentifierChars 
UnqualifiedMethodIdentifier : IdentifierChars 
Literal : IntegerLiteral | FloatingPointLiteral | BooleanLiteral |CharacterLiteral


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
