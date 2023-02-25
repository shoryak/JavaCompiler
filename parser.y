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


%token<node> Abstract Continue For New Switch Assert Default If Package Synchronized Boolean Do Goto Private This Break Double Implements Protected Throw Byte Else Import Public Throws_key Case Enum Instanceof Return Transient Catch Extends Int Short Try Char Final Interface Static Void Class Finally Long Strictfp Volatile Const Float Native Super While Underscore Permits Var Yield
%token<node> CharacterLiteral 
%token<node> BooleanLiteral
%token<node> IntegerLiteral
%token<node> FloatingPointLiteral 
%token<node> StringLiteral
%token<node> TextBlock 
%token<node> NullLiteral
%token<node> LeftParenthesis  RightParenthesis  LeftCurlyBrace RightCurlyBrace LeftSquareBracket  RightSquareBracket
%token<node> Semicolon Comma  Dot  AtSign 
%token<node> Scope ellipsis 
%token<node> ASSIGN GT LT EXCLAMATION TILDE QUESTIONMARK COLON ARROW EQUAL GE LE NOTEQUAL AND OR INC DEC ADD SUB MUL DIV BITAND BITOR CARET MOD LSHIFT RSHIFT URSHIFT ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN MOD_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN URSHIFT_ASSIGN 
%token<node> IdentifierChars

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

%start CompilationUnit

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

NormalClassDeclaration : Class TypeIdentifier     ClassBody{
    vector<Node*> v;
    v.push_back($2);
    v.push_back($3);
    $$ = createNode("class" , v);
}
| ModifierList Class TypeIdentifier     ClassBody{
    vector<Node*> v;
    for(auto i : $1->children){
        v.push_back(i);
    }
    v.push_back($3);
    v.push_back($4);
    $$ = createNode("class" , v);

}
;


Modifier : Public | Private | Static  


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
| Boolean
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
| Void MethodDeclarator {$$ = $2; }
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


FormalParameterList: FormalParameterList Comma FormalParameter | FormalParameter

FormalParameter: VariableModifierList UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableArityParameter
;

VariableArityParameter:  UnannType  ellipsis Identifier
| VariableModifierList UnannType  ellipsis Identifier

VariableModifierList : VariableModifier| VariableModifierList VariableModifier 

VariableModifier: Final

MethodBody: Block
| Semicolon
;

InstanceInitializer: Block
;

StaticInitializer: Static Block
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

StatementExpressionList: StatementExpression  | StatementExpressionList Comma StatementExpression


EnhancedForStatement: For LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement

EnhancedForStatementNoShortIf: For LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf

BreakStatement: Break Identifier Semicolon
| Break  Semicolon

YieldStatement: Yield Expression Semicolon

ContinueStatement: Continue Semicolon
| Continue Identifier Semicolon

ReturnStatement: Return Semicolon
| Return Expression Semicolon


Pattern: TypePattern 

TypePattern: LocalVariableDeclaration



Primary: PrimaryNoNewArray  {$$ = $1;}
| ArrayCreationExpression

PrimaryNoNewArray: Literal {$$ = $1;}
| ClassLiteral | This
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


ArgumentList: Expression | ArgumentList Comma Expression
;

MethodReference: ExpressionName Scope Identifier
|  ExpressionName Scope TypeArguments Identifier
| Primary Scope Identifier
|  Primary Scope TypeArguments 

| UnannReferenceType Scope Identifier
|  UnannReferenceType Scope TypeArguments Identifier

| Super Scope Identifier
|  Super Scope TypeArguments Identifier

| TypeName Dot Super Scope Identifier
|  TypeName Dot Super Scope TypeArguments Identifier

| UnannClassType Scope  New
| UnannClassType Scope TypeArguments New
| ArrayType Scope New
;



ArrayCreationExpression: New PrimitiveType DimExprs 
| New UnannClassOrInterfaceType DimExprs 
| New PrimitiveType DimExprs Dims
| New UnannClassOrInterfaceType DimExprs Dims
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


InstanceofExpression: RelationalExpression Instanceof UnannReferenceType
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
| LeftParenthesis UnannReferenceType  RightParenthesis UnaryExpressionNotPlusMinus
;

ConstantExpression: Expression


Type: PrimitiveType
| UnannReferenceType
;


PrimitiveType:  NumericType
|  Boolean
;



NumericType: IntegralType
| FloatingPointType
;

IntegralType:  Byte | Short | Int | Long | Char

FloatingPointType:  Float | Double



ArrayType: UnannArrayType
;

Dims: LeftSquareBracket RightSquareBracket 
| LeftSquareBracket RightSquareBracket LeftRightSquareList




TypeBound: Extends UnannClassOrInterfaceType 
;



TypeArguments: LT TypeArgumentList GT


TypeArgumentList: TypeArgumentList Comma TypeArgument | TypeArgument

TypeArgument: UnannReferenceType
| Wildcard
;

Wildcard: QUESTIONMARK 
| QUESTIONMARK WildcardBounds

WildcardBounds: Extends UnannReferenceType
| Super UnannReferenceType
;

// ModuleName: Identifier | ModuleName Dot Identifier
// PackageName: Identifier | PackageName Dot Identifier
TypeName: TypeIdentifier 
ExpressionName: Identifier | ExpressionName Dot Identifier
MethodName: Identifier
// PackageOrTypeName: Identifier | PackageOrTypeName Dot Identifier
// AmbiguousName: Identifier | AmbiguousName Dot Identifier

Identifier :  IdentifierChars 
TypeIdentifier : Identifier 
// UnqualifiedMethodIdentifier : IdentifierChars 
Literal : IntegerLiteral  {printf("%s\n", $$->val);}
| FloatingPointLiteral | BooleanLiteral |CharacterLiteral | NullLiteral| StringLiteral


%%
