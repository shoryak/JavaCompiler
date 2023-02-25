%{
#include<bits/stdc++.h>
using namespace std;
int lines=0;
int yyparse(void);
extern "C" {
        int yylex(void);
        int yyerror(char* s)
        {
            printf("ERROR: %s Line Number: %d\n",s,lines);
            return 1;
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


%token<str> ABSTRACT CONTINUE FOR NEW SWITCH ASSERT DEFAULT IF PACKAGE SYNCHRONIZED BOOLEAN DO GOTO PRIVATE THIS BREAK DOUBLE IMPLEMENTS PROTECTED THROW BYTE ELSE IMPORT PUBLIC THROWS CASE ENUM INSTANCEOF RETURN TRANSIENT CATCH EXTENDS INT SHORT TRY CHAR FINAL INTERFACE STATIC VOID CLASS FINALLY LONG STRICTFP VOLATILE CONST FLOAT NATIVE SUPER WHILE UNDERSCORE
%token<str> EXPORTS OPENS REQUIRES USES MODULE PERMITS SEALED VAR PROVIDES TO WITH OPEN RECORD TRANSITIVE YIELD
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
%type<str> CommaTypeNameList ClassBodyDeclaration ClassMemberDeclaration FieldDeclaraFieldModifierList FieldDeclaration VariableDeclaratorList
%type<str> CommaVariableDeclaratorList VariableDeclarator VariableDeclaratorId VariableInitializer UnannType UnannPrimitiveType UnannReferenceType
%type<str> UnannClassOrInterfaceType UnannClassType UnannTypeVariable UnannArrayType MethodDeclaration MethodModifierList
%type<str> MethodModifier MethodHeader Result MethodDeclarator ReceiverParameter FormalParameterList CommaFormalParameterList FormalParameter
%type<str> VariableArityParameter VariableModifierList VariableModifier Throws ExceptionTypeList CommaExceptionTypeList ExceptionType MethodBody
%type<str> InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorModifierList ConstructorModifier ConstructorDeclarator
%type<str> SimpleTypeName ConstructorBody ExplicitConstructorInvocation ArrayInitializer VariableInitializerList CommaVariableInitializerList
%type<str> Block BlockStatements BlockStatementList BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration
%type<str> LocalVariableType Statement ForStatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement
%type<str> ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement
%type<str> WhileStatementNoShortIf ForStatement ModifierList Modifier

%type<str> BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate StatementExpressionList CommaStatementExpressionList EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement 
%type<str> BitOrClassTypeList 
%type<str> Pattern TypePattern Primary PrimaryNoNewArray ClassLiteral LeftRightSquareList ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression
%type<str> Identifier AmbiguousName
%type<str> DotIdentifierList TypeArgumentsOrDiamond FieldAccess ArrayAccess MethodInvocation ArgumentList CommaExpressionList MethodReference
%type<str> ArrayCreationExpression DimExprs DimExprList DimExpr Expression AssignmentExpression Assignment LeftHandSide AssignmentOperator ConditionalExpression
%type<str> ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression InstanceofExpression
%type<str> ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression PreIncrementExpression PreDecrementExpression
%type<str> UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression ConstantExpression Type PrimitiveType
%type<str> NumericType IntegralType FloatingPointType ReferenceType ClassOrInterfaceType ClassType TypeVariable ArrayType
%type<str> Dims  TypeParameter TypeBound TypeArguments TypeArgumentList CommaTypeArgumentList TypeArgument Wildcard WildcardBounds TypeName PackageOrTypeName
%type<str> ExpressionName MethodName   UnqualifiedMethodIdentifier Literal

%type<str> ContextualKeywords TypeIdentifierKeywords
%type<str> DotId

%start MethodInvocation

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

NormalClassDeclaration :  CLASS TypeIdentifier ClassExtends  ClassPermits ClassBody
| ModifierList CLASS TypeIdentifier  ClassExtends  ClassPermits ClassBody
| CLASS TypeIdentifier  ClassExtends   ClassBody
| ModifierList CLASS TypeIdentifier  ClassExtends   ClassBody
| CLASS TypeIdentifier    ClassPermits ClassBody
| ModifierList CLASS TypeIdentifier    ClassPermits ClassBody
| CLASS TypeIdentifier     ClassBody
| ModifierList CLASS TypeIdentifier     ClassBody
| CLASS TypeIdentifier TypeParameters ClassExtends  ClassPermits ClassBody
| ModifierList CLASS TypeIdentifier TypeParameters ClassExtends  ClassPermits ClassBody
| CLASS TypeIdentifier TypeParameters ClassExtends   ClassBody
| ModifierList CLASS TypeIdentifier TypeParameters ClassExtends   ClassBody
| CLASS TypeIdentifier TypeParameters   ClassPermits ClassBody
| ModifierList CLASS TypeIdentifier TypeParameters   ClassPermits ClassBody
| CLASS TypeIdentifier TypeParameters    ClassBody
| ModifierList CLASS TypeIdentifier TypeParameters    ClassBody
;


Modifier : PUBLIC | PRIVATE | STATIC  


ModifierList : ModifierList Modifier | Modifier

TypeParameters: LT TypeParameterList GT
;

TypeParameterList: TypeParameter CommaTypeParameterList | TypeParameter

CommaTypeParameterList : Comma TypeParameter
    | Comma TypeParameter CommaTypeParameterList



ClassExtends: EXTENDS ClassType;






ClassPermits: PERMITS TypeName CommaTypeNameList | PERMITS TypeName

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

FieldDeclaration: ModifierList UnannType VariableDeclaratorList Semicolon
|  UnannType VariableDeclaratorList Semicolon


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
| BOOLEAN
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
;


UnannTypeVariable: TypeIdentifier


UnannArrayType: UnannPrimitiveType Dims
| UnannClassOrInterfaceType Dims
| UnannTypeVariable Dims
;


MethodDeclaration: ModifierList MethodHeader MethodBody
|  MethodHeader MethodBody



MethodHeader:UnannType MethodDeclarator 
| UnannType MethodDeclarator Throws
| VOID MethodDeclarator 
|  VOID MethodDeclarator Throws
;



MethodDeclarator: Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis 
| Identifier LeftParenthesis RightParenthesis 
| Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis 
| Identifier LeftParenthesis FormalParameterList RightParenthesis 
| Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis Dims
| Identifier LeftParenthesis RightParenthesis Dims
| Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis Dims
| Identifier LeftParenthesis FormalParameterList RightParenthesis Dims

ReceiverParameter: UnannType  THIS
| UnannType Identifier Dot THIS


FormalParameterList: FormalParameter CommaFormalParameterList | FormalParameter

CommaFormalParameterList : Comma FormalParameter | CommaFormalParameterList Comma FormalParameter

FormalParameter: VariableModifierList UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableArityParameter
;

VariableArityParameter:  UnannType  ellipsis Identifier
| VariableModifierList UnannType  ellipsis Identifier

VariableModifierList : VariableModifier| VariableModifierList VariableModifier 

VariableModifier: FINAL

Throws: THROWS ExceptionTypeList

ExceptionTypeList: ExceptionType CommaExceptionTypeList | ExceptionType

CommaExceptionTypeList : Comma ExceptionType | CommaExceptionTypeList Comma ExceptionType


ExceptionType: ClassType
;

MethodBody: Block
| Semicolon
;

InstanceInitializer: Block
;

StaticInitializer: STATIC Block
;

ConstructorDeclaration: ConstructorDeclarator ConstructorBody
| ModifierList ConstructorDeclarator ConstructorBody
| ConstructorDeclarator Throws ConstructorBody
| ModifierList ConstructorDeclarator Throws ConstructorBody
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


ConstructorBody: LeftCurlyBrace  RightCurlyBrace
| LeftCurlyBrace ExplicitConstructorInvocation RightCurlyBrace
| LeftCurlyBrace  BlockStatements RightCurlyBrace
| LeftCurlyBrace ExplicitConstructorInvocation BlockStatements RightCurlyBrace
;


ExplicitConstructorInvocation:  THIS LeftParenthesis RightParenthesis Semicolon
| TypeArguments THIS LeftParenthesis RightParenthesis Semicolon
| THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
| SUPER LeftParenthesis RightParenthesis Semicolon
| SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments SUPER LeftParenthesis  RightParenthesis Semicolon    
| ExpressionName Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
| ExpressionName Dot TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
| ExpressionName Dot SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
| ExpressionName Dot SUPER LeftParenthesis RightParenthesis Semicolon     
| Primary Dot  SUPER LeftParenthesis RightParenthesis Semicolon
| Primary Dot TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
| Primary Dot  SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
| Primary Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
;


ArrayInitializer: LeftCurlyBrace  Comma RightCurlyBrace
| LeftCurlyBrace  RightCurlyBrace
| LeftCurlyBrace VariableInitializerList Comma RightCurlyBrace
| LeftCurlyBrace VariableInitializerList  RightCurlyBrace


VariableInitializerList: VariableInitializer | VariableInitializer CommaVariableInitializerList

CommaVariableInitializerList :  Comma VariableInitializer | CommaVariableInitializerList Comma VariableInitializer


Block: LeftCurlyBrace BlockStatements RightCurlyBrace
|  LeftCurlyBrace RightCurlyBrace

BlockStatements: BlockStatements BlockStatement | BlockStatement;

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



LocalVariableType: UnannType | VAR

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

IfThenStatement: IF LeftParenthesis Expression RightParenthesis Statement

IfThenElseStatement: IF LeftParenthesis Expression RightParenthesis StatementNoShortIf ELSE Statement

IfThenElseStatementNoShortIf: IF LeftParenthesis Expression RightParenthesis StatementNoShortIf ELSE StatementNoShortIf

AssertStatement: ASSERT Expression Semicolon
| ASSERT Expression COLON Expression Semicolon


WhileStatement: WHILE LeftParenthesis Expression RightParenthesis Statement

WhileStatementNoShortIf: WHILE LeftParenthesis Expression RightParenthesis StatementNoShortIf

ForStatement: BasicForStatement
| EnhancedForStatement
;

ForStatementNoShortIf: BasicForStatementNoShortIf
| EnhancedForStatementNoShortIf
;

BasicForStatement: FOR LeftParenthesis  Semicolon  Semicolon  RightParenthesis Statement
| FOR LeftParenthesis ForInit Semicolon  Semicolon  RightParenthesis Statement
| FOR LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis Statement
| FOR LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis Statement
| FOR LeftParenthesis  Semicolon Expression Semicolon  RightParenthesis Statement
| FOR LeftParenthesis ForInit Semicolon Expression Semicolon  RightParenthesis Statement
| FOR LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
| FOR LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis Statement



BasicForStatementNoShortIf: FOR LeftParenthesis  Semicolon  Semicolon RightParenthesis StatementNoShortIf
| FOR LeftParenthesis ForInit Semicolon  Semicolon RightParenthesis StatementNoShortIf
| FOR LeftParenthesis  Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
| FOR LeftParenthesis ForInit Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
| FOR LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
| FOR LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
| FOR LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
| FOR LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf


ForInit: StatementExpressionList
| LocalVariableDeclaration
;

ForUpdate: StatementExpressionList

StatementExpressionList: StatementExpression  | StatementExpression CommaStatementExpressionList

CommaStatementExpressionList : Comma StatementExpression
| CommaStatementExpressionList Comma StatementExpression 
;

EnhancedForStatement: FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement

EnhancedForStatementNoShortIf: FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf

BreakStatement: BREAK Identifier Semicolon
| BREAK  Semicolon

YieldStatement: YIELD Expression Semicolon

ContinueStatement: CONTINUE Semicolon
| CONTINUE Identifier Semicolon

ReturnStatement: RETURN Semicolon
| RETURN Expression Semicolon

ThrowStatement: THROW Expression Semicolon

BitOrClassTypeList : BITOR ClassType
| BitOrClassTypeList BITOR ClassType


Pattern: TypePattern 

TypePattern: LocalVariableDeclaration



Primary: PrimaryNoNewArray | ArrayCreationExpression

PrimaryNoNewArray: Literal | ClassLiteral | THIS
| TypeName Dot THIS
| LeftParenthesis Expression RightParenthesis
| ClassInstanceCreationExpression
| FieldAccess
| ArrayAccess
| MethodInvocation
| MethodReference
;

ClassLiteral: TypeName  Dot CLASS
| NumericType  Dot CLASS
| BOOLEAN  Dot CLASS
| VOID Dot CLASS
| TypeName LeftRightSquareList Dot CLASS
| NumericType LeftRightSquareList Dot CLASS
| BOOLEAN LeftRightSquareList Dot CLASS
;

LeftRightSquareList:  LeftSquareBracket RightSquareBracket | LeftRightSquareList LeftSquareBracket RightSquareBracket

ClassInstanceCreationExpression: UnqualifiedClassInstanceCreationExpression
| ExpressionName Dot UnqualifiedClassInstanceCreationExpression
| Primary Dot UnqualifiedClassInstanceCreationExpression
;

UnqualifiedClassInstanceCreationExpression: NEW  ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis 
| NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis 
| NEW  ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| NEW  ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
| NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
| NEW  ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
| NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody



ClassOrInterfaceTypeToInstantiate: Identifier
| Identifier DotIdentifierList
|  Identifier DotIdentifierList TypeArgumentsOrDiamond

DotIdentifierList : Dot Identifier | DotIdentifierList Dot Identifier

TypeArgumentsOrDiamond: TypeArguments
;

FieldAccess: Primary Dot Identifier
| SUPER Dot Identifier
| TypeName Dot SUPER Dot Identifier
;

ArrayAccess:ExpressionName LeftSquareBracket Expression RightSquareBracket
| PrimaryNoNewArray LeftSquareBracket Expression RightSquareBracket
;

DotId:  Dot Identifier

MethodInvocation: MethodName LeftParenthesis  RightParenthesis
| MethodName LeftParenthesis ArgumentList RightParenthesis

| TypeName Dot Identifier LeftParenthesis  RightParenthesis
| TypeName Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| ExpressionName DotId LeftParenthesis RightParenthesis
| ExpressionName Dot TypeArguments Identifier LeftParenthesis RightParenthesis
| ExpressionName DotId LeftParenthesis ArgumentList RightParenthesis
| ExpressionName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| Primary Dot  Identifier LeftParenthesis  RightParenthesis
| Primary Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| Primary Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| Primary Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis

| SUPER Dot  Identifier LeftParenthesis  RightParenthesis
| SUPER Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| SUPER Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| TypeName Dot SUPER Dot  Identifier LeftParenthesis  RightParenthesis
| TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot SUPER Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
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

| SUPER Scope Identifier
|  SUPER Scope TypeArguments Identifier

| TypeName Dot SUPER Scope Identifier
|  TypeName Dot SUPER Scope TypeArguments Identifier

| ClassType Scope  NEW
| ClassType Scope TypeArguments NEW
| ArrayType Scope NEW
;



ArrayCreationExpression: NEW PrimitiveType DimExprs 
| NEW ClassOrInterfaceType DimExprs 
| NEW PrimitiveType DimExprs Dims
| NEW ClassOrInterfaceType DimExprs Dims
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


InstanceofExpression: RelationalExpression INSTANCEOF ReferenceType
| RelationalExpression INSTANCEOF Pattern
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
|  BOOLEAN
;



NumericType: IntegralType
| FloatingPointType
;

IntegralType:  BYTE | SHORT | INT | LONG | CHAR

FloatingPointType:  FLOAT | DOUBLE

ReferenceType: ClassOrInterfaceType
| ArrayType
;


ClassOrInterfaceType: UnannClassOrInterfaceType
;



ClassType:  TypeIdentifier 
| TypeIdentifier TypeArguments
| ClassOrInterfaceType Dot  TypeIdentifier 
| ClassOrInterfaceType Dot  TypeIdentifier TypeArguments
;

ArrayType: PrimitiveType Dims
| ClassOrInterfaceType Dims
;

Dims: LeftSquareBracket RightSquareBracket 
| LeftSquareBracket RightSquareBracket LeftRightSquareList



TypeParameter:  TypeIdentifier 
| TypeIdentifier TypeBound




TypeBound: EXTENDS ClassOrInterfaceType 
;



TypeArguments: LT TypeArgumentList GT


TypeArgumentList: TypeArgument CommaTypeArgumentList | TypeArgument

CommaTypeArgumentList :  Comma TypeArgument |  TypeArgumentList Comma TypeArgument

TypeArgument: ReferenceType
| Wildcard
;

Wildcard: QUESTIONMARK 
| QUESTIONMARK WildcardBounds

WildcardBounds: EXTENDS ReferenceType
| SUPER ReferenceType
;

// ModuleName: Identifier | ModuleName Dot Identifier
// PackageName: Identifier | PackageName Dot Identifier
TypeName: TypeIdentifier | PackageOrTypeName
ExpressionName: AmbiguousName
MethodName: UnqualifiedMethodIdentifier
PackageOrTypeName: Identifier | PackageOrTypeName Dot Identifier
AmbiguousName: Identifier | AmbiguousName DotId

ContextualKeywords: EXPORTS | OPENS | REQUIRES | USES | MODULE | PERMITS | SEALED | VAR | PROVIDES | TO | WITH | OPEN | RECORD | TRANSITIVE | YIELD ;

TypeIdentifierKeywords: EXPORTS | OPENS | REQUIRES | USES | MODULE | PROVIDES | TO | WITH | OPEN | TRANSITIVE ;

Identifier :  IdentifierChars
TypeIdentifier: IdentifierChars | TypeIdentifierKeywords
UnqualifiedMethodIdentifier : IdentifierChars | ContextualKeywords
Literal : IntegerLiteral | FloatingPointLiteral | BooleanLiteral |CharacterLiteral | NullLiteral

%%
