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


%type<str> Identifier
%token<str> Abstract Continue For New Switch Assert Default If Package Synchronized Boolean Do Goto Private This Break Double Implements Protected Throw Byte Else Import Public Throws_key Case Enum Instanceof Return Transient Catch Extends Int Short Try Char Final Interface Static Void Class Finally Long Strictfp Volatile Const Float Native Super While Underscore Permits Var Yield
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
%type<str> CommaTypeNameList ClassBodyDeclaration ClassMemberDeclaration FieldDeclaraFieldModifierList VariableDeclaratorList
%type<str> CommaVariableDeclaratorList VariableDeclarator VariableDeclaratorId VariableInitializer UnannType UnannPrimitiveType UnannReferenceType
%type<str> UnannClassOrInterfaceType UnannClassType UnannTypeVariable UnannArrayType MethodDeclaration MethodModifierList
%type<str> MethodModifier MethodHeader Result MethodDeclarator ReceiverParameter FormalParameterList CommaFormalParameterList FormalParameter
%type<str> VariableArityParameter VariableModifierList VariableModifier Throws ExceptionTypeList CommaExceptionTypeList ExceptionType MethodBody
%type<str> InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorModifierList ConstructorModifier ConstructorDeclarator
%type<str> SimpleTypeName ConstructorBody ExplicitConstructorInvocation ArrayInitializer VariableInitializerList CommaVariableInitializerList
%type<str> Block BlockStatements BlockStatementList BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration
%type<str> LocalVariableType Statement ForStatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement
%type<str> ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement
%type<str> WhileStatementNoShortIf ForStatement ModifierList

%type<str> BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate StatementExpressionList CommaStatementExpressionList EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement 
%type<str> BitOrClassTypeList 
%type<str> Pattern TypePattern Primary PrimaryNoNewArray ClassLiteral LeftRightSquareList ClassInstanceCreationExpression
%type<str> DotIdentifierList TypeArgumentsOrDiamond FieldAccess ArrayAccess MethodInvocation ArgumentList CommaExpressionList MethodReference
%type<str> ArrayCreationExpression DimExprs DimExprList DimExpr Expression AssignmentExpression Assignment LeftHandSide AssignmentOperator ConditionalExpression
%type<str> ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression InstanceofExpression
%type<str> ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression PreIncrementExpression PreDecrementExpression
%type<str> UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression ConstantExpression Type PrimitiveType
%type<str> NumericType IntegralType FloatingPointType ReferenceType ClassOrInterfaceType ClassType TypeVariable ArrayType
%type<str> Dims  TypeParameter TypeBound TypeArguments TypeArgumentList CommaTypeArgumentList TypeArgument Wildcard WildcardBounds TypeName
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

NormalClassDeclaration :  Class TypeIdentifier ClassExtends  ClassPermits ClassBody
| ModifierList Class TypeIdentifier  ClassExtends  ClassPermits ClassBody
| Class TypeIdentifier  ClassExtends   ClassBody
| ModifierList Class TypeIdentifier  ClassExtends   ClassBody
| Class TypeIdentifier    ClassPermits ClassBody
| ModifierList Class TypeIdentifier    ClassPermits ClassBody
| Class TypeIdentifier     ClassBody
| ModifierList Class TypeIdentifier     ClassBody
| Class TypeIdentifier TypeParameters ClassExtends  ClassPermits ClassBody
| ModifierList Class TypeIdentifier TypeParameters ClassExtends  ClassPermits ClassBody
| Class TypeIdentifier TypeParameters ClassExtends   ClassBody
| ModifierList Class TypeIdentifier TypeParameters ClassExtends   ClassBody
| Class TypeIdentifier TypeParameters   ClassPermits ClassBody
| ModifierList Class TypeIdentifier TypeParameters   ClassPermits ClassBody
| Class TypeIdentifier TypeParameters    ClassBody
| ModifierList Class TypeIdentifier TypeParameters    ClassBody
;


Modifier : Public | Private | Static  


ModifierList : ModifierList Modifier | Modifier

TypeParameters: LT TypeParameterList GT
;

TypeParameterList: TypeParameter CommaTypeParameterList | TypeParameter

CommaTypeParameterList : Comma TypeParameter
    | Comma TypeParameter CommaTypeParameterList



ClassExtends: Extends ClassType;






ClassPermits: Permits TypeName CommaTypeNameList | Permits TypeName

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
| Boolean
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
| Void MethodDeclarator 
|  Void MethodDeclarator Throws
;



MethodDeclarator: Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis 
| Identifier LeftParenthesis RightParenthesis 
| Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis 
| Identifier LeftParenthesis FormalParameterList RightParenthesis 
| Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis Dims
| Identifier LeftParenthesis RightParenthesis Dims
| Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis Dims
| Identifier LeftParenthesis FormalParameterList RightParenthesis Dims

ReceiverParameter: UnannType  This
| UnannType Identifier Dot This


FormalParameterList: FormalParameter CommaFormalParameterList | FormalParameter

CommaFormalParameterList : Comma FormalParameter | CommaFormalParameterList Comma FormalParameter

FormalParameter: VariableModifierList UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableArityParameter
;

VariableArityParameter:  UnannType  ellipsis Identifier
| VariableModifierList UnannType  ellipsis Identifier

VariableModifierList : VariableModifier| VariableModifierList VariableModifier 

VariableModifier: Final

Throws: Throws_key ExceptionTypeList

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

StaticInitializer: Static Block
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


ExplicitConstructorInvocation:  This LeftParenthesis RightParenthesis Semicolon
| TypeArguments This LeftParenthesis RightParenthesis Semicolon
| This LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments This LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments Super LeftParenthesis ArgumentList RightParenthesis Semicolon
| Super LeftParenthesis RightParenthesis Semicolon
| Super LeftParenthesis ArgumentList RightParenthesis Semicolon
| TypeArguments Super LeftParenthesis  RightParenthesis Semicolon    
| ExpressionName Dot TypeArguments Super LeftParenthesis ArgumentList RightParenthesis Semicolon
| ExpressionName Dot TypeArguments Super LeftParenthesis RightParenthesis Semicolon
| ExpressionName Dot Super LeftParenthesis ArgumentList RightParenthesis Semicolon
| ExpressionName Dot Super LeftParenthesis RightParenthesis Semicolon     
| Primary Dot  Super LeftParenthesis RightParenthesis Semicolon
| Primary Dot TypeArguments Super LeftParenthesis RightParenthesis Semicolon
| Primary Dot  Super LeftParenthesis ArgumentList RightParenthesis Semicolon
| Primary Dot TypeArguments Super LeftParenthesis ArgumentList RightParenthesis Semicolon
;


ArrayInitializer: LeftParenthesis  Comma RightParenthesis 
| LeftParenthesis  RightParenthesis
| LeftParenthesis VariableInitializerList Comma RightParenthesis 
| LeftParenthesis VariableInitializerList  RightParenthesis


VariableInitializerList: VariableInitializer | VariableInitializer CommaVariableInitializerList

CommaVariableInitializerList :  Comma VariableInitializer | CommaVariableInitializerList Comma VariableInitializer


Block: LeftCurlyBrace BlockStatements RightCurlyBrace
|  LeftCurlyBrace RightCurlyBrace

BlockStatements: BlockStatements BlockStatement | BlockStatement;

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



LocalVariableType: UnannType | Var

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

IfThenStatement: If LeftParenthesis Expression RightParenthesis Statement

IfThenElseStatement: If LeftParenthesis Expression RightParenthesis StatementNoShortIf Else Statement

IfThenElseStatementNoShortIf: If LeftParenthesis Expression RightParenthesis StatementNoShortIf Else StatementNoShortIf

AssertStatement: Assert Expression Semicolon
| Assert Expression COLON Expression Semicolon


WhileStatement: While LeftParenthesis Expression RightParenthesis Statement

WhileStatementNoShortIf: While LeftParenthesis Expression RightParenthesis StatementNoShortIf

ForStatement: BasicForStatement
| EnhancedForStatement
;

ForStatementNoShortIf: BasicForStatementNoShortIf
| EnhancedForStatementNoShortIf
;

BasicForStatement: For LeftParenthesis  Semicolon  Semicolon  RightParenthesis Statement
| For LeftParenthesis ForInit Semicolon  Semicolon  RightParenthesis Statement
| For LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis Statement
| For LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis Statement
| For LeftParenthesis  Semicolon Expression Semicolon  RightParenthesis Statement
| For LeftParenthesis ForInit Semicolon Expression Semicolon  RightParenthesis Statement
| For LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
| For LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis Statement



BasicForStatementNoShortIf: For LeftParenthesis  Semicolon  Semicolon RightParenthesis StatementNoShortIf
| For LeftParenthesis ForInit Semicolon  Semicolon RightParenthesis StatementNoShortIf
| For LeftParenthesis  Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
| For LeftParenthesis ForInit Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
| For LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
| For LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
| For LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
| For LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf


ForInit: StatementExpressionList
| LocalVariableDeclaration
;

ForUpdate: StatementExpressionList

StatementExpressionList: StatementExpression  | StatementExpression CommaStatementExpressionList

CommaStatementExpressionList : Comma StatementExpression
| CommaStatementExpressionList Comma StatementExpression 
;

EnhancedForStatement: For LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement

EnhancedForStatementNoShortIf: For LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf

BreakStatement: Break Identifier Semicolon
| Break  Semicolon

YieldStatement: Yield Expression Semicolon

ContinueStatement: Continue Semicolon
| Continue Identifier Semicolon

ReturnStatement: Return Semicolon
| Return Expression Semicolon

ThrowStatement: Throw Expression Semicolon

BitOrClassTypeList : BITOR ClassType
| BitOrClassTypeList BITOR ClassType


Pattern: TypePattern 

TypePattern: LocalVariableDeclaration



Primary: PrimaryNoNewArray | ArrayCreationExpression

PrimaryNoNewArray: Literal | ClassLiteral | This
| TypeName Dot This
| LeftParenthesis Expression RightParenthesis
| ClassInstanceCreationExpression
| FieldAccess
| ArrayAccess
| MethodInvocation
| MethodReference
;

ClassLiteral: TypeName  Dot Class
| NumericType  Dot Class
| Boolean  Dot Class
| Void Dot Class
| TypeName LeftRightSquareList Dot Class
| NumericType LeftRightSquareList Dot Class
| Boolean LeftRightSquareList Dot Class
;

LeftRightSquareList:  LeftSquareBracket RightSquareBracket | LeftRightSquareList LeftSquareBracket RightSquareBracket

ClassInstanceCreationExpression: UnqualifiedClassInstanceCreationExpression
| ExpressionName Dot UnqualifiedClassInstanceCreationExpression
| Primary Dot UnqualifiedClassInstanceCreationExpression
;

UnqualifiedClassInstanceCreationExpression: New  ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis 
| New TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis 
| New  ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| New TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| New  ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
| New TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
| New  ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
| New TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody



ClassOrInterfaceTypeToInstantiate: Identifier
| Identifier DotIdentifierList
|  Identifier DotIdentifierList TypeArgumentsOrDiamond

DotIdentifierList : Dot Identifier | DotIdentifierList Dot Identifier

TypeArgumentsOrDiamond: TypeArguments
;

FieldAccess: Primary Dot Identifier
| Super Dot Identifier
| TypeName Dot Super Dot Identifier
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

| Super Dot  Identifier LeftParenthesis  RightParenthesis
| Super Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| Super Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| Super Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| TypeName Dot Super Dot  Identifier LeftParenthesis  RightParenthesis
| TypeName Dot Super Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot Super Dot  Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot Super Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
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

| Super Scope Identifier
|  Super Scope TypeArguments Identifier

| TypeName Dot Super Scope Identifier
|  TypeName Dot Super Scope TypeArguments Identifier

| ClassType Scope  New
| ClassType Scope TypeArguments New
| ArrayType Scope New
;



ArrayCreationExpression: New PrimitiveType DimExprs 
| New ClassOrInterfaceType DimExprs 
| New PrimitiveType DimExprs Dims
| New ClassOrInterfaceType DimExprs Dims
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


InstanceofExpression: RelationalExpression Instanceof ReferenceType
| RelationalExpression Instanceof Pattern
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
|  Boolean
;



NumericType: IntegralType
| FloatingPointType
;

IntegralType:  Byte | Short | Int | Long | Char

FloatingPointType:  Float | Double

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




TypeBound: Extends TypeVariable
    | Extends ClassOrInterfaceType 
;



TypeArguments: LT TypeArgumentList GT


TypeArgumentList: TypeArgument CommaTypeArgumentList | TypeArgument

CommaTypeArgumentList :  Comma TypeArgument |  TypeArgumentList Comma TypeArgument

TypeArgument: ReferenceType
| Wildcard
;

Wildcard: QUESTIONMARK 
| QUESTIONMARK WildcardBounds

WildcardBounds: Extends ReferenceType
| Super ReferenceType
;

// ModuleName: Identifier | ModuleName Dot Identifier
// PackageName: Identifier | PackageName Dot Identifier
TypeName: TypeIdentifier | PackageOrTypeName
ExpressionName: Identifier | AmbiguousName Dot Identifier
MethodName: UnqualifiedMethodIdentifier
PackageOrTypeName: Identifier | PackageOrTypeName Dot Identifier
AmbiguousName: Identifier | AmbiguousName Dot Identifier

Identifier :  IdentifierChars
TypeIdentifier : IdentifierChars 
UnqualifiedMethodIdentifier : IdentifierChars 
Literal : IntegerLiteral | FloatingPointLiteral | BooleanLiteral |CharacterLiteral | NullLiteral


%%
