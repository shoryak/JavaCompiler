%{
#include<bits/stdc++.h>
using namespace std;
int lines=0;
int yyparse();
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
struct Node{
        char* val;
        vector<Node*> children;
        char* data;
    };

    Node* root;
    Node* createNode(char* value, vector<Node*> children)
    {
        Node* temp= new Node();
        temp->val=value;
        temp->children=children;
        return temp;
    }
    Node* createNode(char* value)
    {
        Node* temp= new Node();
        temp->val=value;
        return temp;
    }
   

    int buildTree(Node* node, int parentno, int co) 
    {
        if(node==NULL)
        return co;

        int nodeno=co++;
        printf(" node%d [label=\"%s\"]\n",nodeno,node->val);
        if(parentno>=0) 
            printf(" node%d -> node%d\n",parentno,nodeno);
        
        int n=node->children.size();
        vector<Node*> children=node->children;
        for(int i=0;i<n;i++)
        {
            co=buildTree(children[i],nodeno,co);
        }
        return co;
    }
%}

%code requires {
    #include <bits/stdc++.h>
    #include <string>
    #include <vector>
    #include <cstdio>

    struct Node;
    using namespace std;
    Node* createNode(char* value, vector<Node*> children);
    Node* createNode(char* value);
    int buildTree(Node* , int parentno , int co);
}

%union {
    Node* node;
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

%type<node> CompilationUnit  OrdinaryCompilationUnit  
%type<node> ClassDeclaration  ClassBody ClassExtends  ClassModifier ClassModifierList ClassPermits
%type<node> TypeIdentifier 
%type<node> ThrowStatement RelationalExpression 
%type<node> TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration NormalClassDeclaration 
%type<node>  ClassBodyDeclaration  ClassBodyDeclarationList ClassMemberDeclaration FieldDeclaraFieldModifierList FieldDeclaration VariableDeclaratorList
%type<node>  VariableDeclarator VariableDeclaratorId VariableInitializer UnannType UnannPrimitiveType UnannReferenceType
%type<node> UnannClassOrInterfaceType UnannClassType UnannTypeVariable UnannArrayType MethodDeclaration MethodModifierList
%type<node> MethodModifier MethodHeader Result MethodDeclarator ReceiverParameter FormalParameterList  FormalParameter
%type<node> VariableArityParameter VariableModifierList VariableModifier Throws ExceptionTypeList ExceptionType MethodBody
%type<node> InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorModifierList ConstructorModifier ConstructorDeclarator
%type<node> SimpleTypeName ConstructorBody ExplicitConstructorInvocation ArrayInitializer VariableInitializerList 
%type<node> Block BlockStatements BlockStatementList BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration
%type<node> LocalVariableType Statement ForStatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement
%type<node> ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement
%type<node> WhileStatementNoShortIf ForStatement ModifierList Modifier

%type<node> BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate StatementExpressionList  EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement 
%type<node> BitOrClassTypeList 
%type<node> Pattern TypePattern Primary PrimaryNoNewArray ClassLiteral LeftRightSquareList ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression
%type<node> Identifier AmbiguousName
%type<node> DotIdentifierList TypeArgumentsOrDiamond FieldAccess ArrayAccess MethodInvocation ArgumentList  MethodReference
%type<node> ArrayCreationExpression DimExprs DimExprList DimExpr Expression AssignmentExpression Assignment LeftHandSide AssignmentOperator ConditionalExpression
%type<node> ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression InstanceofExpression
%type<node> ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression PreIncrementExpression PreDecrementExpression
%type<node> UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression ConstantExpression Type PrimitiveType
%type<node> NumericType IntegralType FloatingPointType ReferenceType ClassOrInterfaceType ClassType TypeVariable ArrayType
%type<node> Dims  TypeBound TypeArguments TypeArgumentList  TypeArgument Wildcard WildcardBounds TypeName PackageOrTypeName
%type<node> ExpressionName MethodName   UnqualifiedMethodIdentifier 
%type<node> Literal

%type<str> ContextualKeywords TypeIdentifierKeywords

%start MethodInvocation

%%

CompilationUnit: OrdinaryCompilationUnit { cout<<"abcd"<<endl; root= $$; buildTree(root,-1,0);}
;

OrdinaryCompilationUnit: TopLevelClassOrInterfaceDeclarationList 
;

TopLevelClassOrInterfaceDeclarationList: TopLevelClassOrInterfaceDeclaration
{
    vector<Node*> v;
    v.push_back($1);
    $$ = createNode("JAVA-PROGRAM" , v);
}
| TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration {
    $$ = $1;
    $$->children.push_back($2);
}
;



TopLevelClassOrInterfaceDeclaration: ClassDeclaration
;

ClassDeclaration: NormalClassDeclaration
;

NormalClassDeclaration : CLASS TypeIdentifier     ClassBody{
    vector<Node*> v;
    v.push_back($2);
    v.push_back($3);
    $$ = createNode("class" , v);
}
| ModifierList CLASS TypeIdentifier     ClassBody{
    vector<Node*> v;
    for(auto i : $1->children){
        v.push_back(i);
    }
    v.push_back($3);
    v.push_back($4);
    $$ = createNode("class" , v);

}
;


Modifier : PUBLIC | PRIVATE | STATIC  


ModifierList : ModifierList Modifier  { $$ = $1 , $$->children.push_back($2);}
| Modifier {
    $$ = createNode("ModifierList");
    $$->children.push_back($1);
} 





ClassBody: LeftCurlyBrace ClassBodyDeclarationList RightCurlyBrace  { $$ = $2;}
| LeftCurlyBrace  RightCurlyBrace { $$ = createNode("ClassBody");}
;

ClassBodyDeclarationList : ClassBodyDeclaration{
    vector<Node*> v;
    v.push_back($1);
    $$ = createNode("ClassBody" , v);
}
| ClassBodyDeclarationList ClassBodyDeclaration{
    $$ = $1;
    $$->children.push_back($2);
}
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


VariableDeclaratorList: VariableDeclarator{
    $$ = createNode("Variables");
    $$->children.push_back($1);
} 
| VariableDeclaratorList Comma VariableDeclarator{
    $$ = $1;
    $$->children.push_back($3);
}


VariableDeclarator: VariableDeclaratorId ASSIGN VariableInitializer {
    $$ = createNode("=" );
    $$->children.push_back($1);
    $$->children.push_back($3);
}
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
| TypeIdentifier
| UnannArrayType
;

UnannClassOrInterfaceType: UnannClassType
;

UnannClassType: TypeIdentifier TypeArguments
| UnannClassOrInterfaceType Dot TypeIdentifier TypeArguments
| UnannClassOrInterfaceType Dot TypeIdentifier 
;



UnannArrayType: UnannPrimitiveType Dims
| UnannClassOrInterfaceType Dims
| TypeIdentifier Dims
;


MethodDeclaration: ModifierList MethodHeader MethodBody {
    vector<Node*> v;
    for(auto child : $1->children){
        v.push_back(child);
    }
    v.push_back($3);
    $$ = createNode($2->val , v);
}
|  MethodHeader MethodBody



MethodHeader:UnannType MethodDeclarator {$$ = $2;}
| VOID MethodDeclarator {$$ = $2; }
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


FormalParameterList: FormalParameterList Comma FormalParameter | FormalParameter

FormalParameter: VariableModifierList UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableArityParameter
;

VariableArityParameter:  UnannType  ellipsis Identifier
| VariableModifierList UnannType  ellipsis Identifier

VariableModifierList : VariableModifier| VariableModifierList VariableModifier 

VariableModifier: FINAL

MethodBody: Block
| Semicolon
;

InstanceInitializer: Block
;

StaticInitializer: STATIC Block
;

ConstructorDeclaration: ConstructorDeclarator ConstructorBody
| ModifierList ConstructorDeclarator ConstructorBody
;



ConstructorDeclarator:  SimpleTypeName LeftParenthesis  RightParenthesis
| SimpleTypeName LeftParenthesis ReceiverParameter Comma RightParenthesis
| SimpleTypeName LeftParenthesis  FormalParameterList RightParenthesis
| SimpleTypeName LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
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


VariableInitializerList: VariableInitializer | VariableInitializerList Comma VariableInitializerList


Block: LeftCurlyBrace BlockStatements RightCurlyBrace { $$ = $2;}
|  LeftCurlyBrace RightCurlyBrace { $$ = createNode("Block");}

BlockStatements: BlockStatements BlockStatement {
    $$ = $1;
    $$->children.push_back($2);
}
| BlockStatement{
    $$ = createNode("Block");
    $$->children.push_back($1);
}

BlockStatement: LocalClassOrInterfaceDeclaration
| LocalVariableDeclarationStatement
| Statement { }
;
LocalClassOrInterfaceDeclaration: ClassDeclaration
;


LocalVariableDeclarationStatement: LocalVariableDeclaration Semicolon

LocalVariableDeclaration: LocalVariableType 
| VariableModifierList LocalVariableType 
| LocalVariableType VariableDeclaratorList {
    $$ = $2;
}
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
| YieldStatement
;

EmptyStatement: Semicolon

LabeledStatement: Identifier COLON Statement

ExpressionStatement: StatementExpression Semicolon {}

StatementExpression: Assignment { $$ = $1;}
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

StatementExpressionList: StatementExpression  | StatementExpressionList Comma StatementExpression


EnhancedForStatement: FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement

EnhancedForStatementNoShortIf: FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf

BreakStatement: BREAK Identifier Semicolon
| BREAK  Semicolon

YieldStatement: YIELD Expression Semicolon

ContinueStatement: CONTINUE Semicolon
| CONTINUE Identifier Semicolon

ReturnStatement: RETURN Semicolon
| RETURN Expression Semicolon


Pattern: TypePattern 

TypePattern: LocalVariableDeclaration



Primary: PrimaryNoNewArray  {$$ = $1;}
| ArrayCreationExpression

PrimaryNoNewArray: Literal {$$ = $1;}
| ClassLiteral | THIS
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
| NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis 
| NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis  RightParenthesis ClassBody
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

MethodInvocation: MethodName LeftParenthesis  RightParenthesis
| MethodName LeftParenthesis ArgumentList RightParenthesis

| TypeName Dot Identifier LeftParenthesis  RightParenthesis
| TypeName Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| ExpressionName Dot Identifier LeftParenthesis RightParenthesis
| ExpressionName Dot TypeArguments Identifier LeftParenthesis RightParenthesis
| ExpressionName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
| ExpressionName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| Primary Dot Identifier LeftParenthesis  RightParenthesis
| Primary Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| Primary Dot Identifier LeftParenthesis ArgumentList RightParenthesis
| Primary Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis

| SUPER Dot Identifier LeftParenthesis  RightParenthesis
| SUPER Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| SUPER Dot Identifier LeftParenthesis ArgumentList RightParenthesis
| SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis


| TypeName Dot SUPER Dot Identifier LeftParenthesis  RightParenthesis
| TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis  RightParenthesis
| TypeName Dot SUPER Dot Identifier LeftParenthesis ArgumentList RightParenthesis
| TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
;


ArgumentList: Expression | ArgumentList Comma Expression
;

MethodReference: ExpressionName Scope Identifier
|  ExpressionName Scope TypeArguments Identifier
| Primary Scope Identifier
|  Primary Scope TypeArguments 

| UnannReferenceType Scope Identifier
|  UnannReferenceType Scope TypeArguments Identifier

| SUPER Scope Identifier
|  SUPER Scope TypeArguments Identifier

| TypeName Dot SUPER Scope Identifier
|  TypeName Dot SUPER Scope TypeArguments Identifier

| UnannClassType Scope NEW
| UnannClassType Scope TypeArguments NEW
| ArrayType Scope NEW
;



ArrayCreationExpression: NEW PrimitiveType DimExprs 
| NEW UnannClassOrInterfaceType DimExprs 
| NEW PrimitiveType DimExprs Dims
| NEW UnannClassOrInterfaceType DimExprs Dims
;


DimExprs:  DimExprList

DimExprList : DimExpr | DimExprList DimExpr

DimExpr: LeftSquareBracket Expression RightSquareBracket

Expression: AssignmentExpression { cout<<"_______"<<endl;
    // printf("%s\n", $$->val);
}
;


AssignmentExpression: ConditionalExpression { }
| Assignment
;


Assignment: LeftHandSide AssignmentOperator Expression {
    $$ = createNode("=");
    $$->children.push_back($1);
    $$->children.push_back($2);

}

LeftHandSide: ExpressionName
| FieldAccess
| ArrayAccess
;


AssignmentOperator: ASSIGN | MUL_ASSIGN  | DIV_ASSIGN |  MOD_ASSIGN | ADD_ASSIGN | SUB_ASSIGN | LSHIFT_ASSIGN | RSHIFT_ASSIGN | URSHIFT_ASSIGN | AND_ASSIGN | XOR_ASSIGN | OR_ASSIGN

ConditionalExpression: ConditionalOrExpression { }
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
| LeftParenthesis UnannReferenceType  RightParenthesis UnaryExpressionNotPlusMinus
;

ConstantExpression: Expression


Type: PrimitiveType
| UnannReferenceType
;


PrimitiveType:  NumericType
|  BOOLEAN
;



NumericType: IntegralType
| FloatingPointType
;

IntegralType:  BYTE | SHORT | INT | LONG | CHAR

FloatingPointType:  FLOAT | DOUBLE



ArrayType: UnannArrayType
;

Dims: LeftSquareBracket RightSquareBracket 
| LeftSquareBracket RightSquareBracket LeftRightSquareList




TypeBound: EXTENDS UnannClassOrInterfaceType 
;



TypeArguments: LT TypeArgumentList GT


TypeArgumentList: TypeArgumentList Comma TypeArgument | TypeArgument

TypeArgument: UnannReferenceType
| Wildcard
;

Wildcard: QUESTIONMARK 
| QUESTIONMARK WildcardBounds

WildcardBounds: EXTENDS UnannReferenceType
| SUPER UnannReferenceType
;

// ModuleName: Identifier | ModuleName Dot Identifier
// PackageName: Identifier | PackageName Dot Identifier
ContextualKeywords: EXPORTS | OPENS | REQUIRES | USES | MODULE | PERMITS | SEALED | VAR | PROVIDES | TO | WITH | OPEN | RECORD | TRANSITIVE | YIELD ;

TypeIdentifierKeywords: EXPORTS | OPENS | REQUIRES | USES | MODULE | PROVIDES | TO | WITH | OPEN | TRANSITIVE ;

Identifier :  IdentifierChars
TypeIdentifier: IdentifierChars | TypeIdentifierKeywords
MethodName: IdentifierChars | ContextualKeywords

Literal : IntegerLiteral  {printf("%s\n", $$->val);}
| FloatingPointLiteral | BooleanLiteral |CharacterLiteral | NullLiteral| StringLiteral

%%
