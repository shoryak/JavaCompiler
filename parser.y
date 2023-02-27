%{
#include<bits/stdc++.h>

using namespace std;

int lines = 0;
int yyparse();
extern "C"
{        
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
T parser_string(string str)
{
    stringstream ss;
    ss << str;
    T result("");
    ss >> result;
    return result;
}

struct Node
{
    char* val;
    vector<Node*> children;
    char* data;
};

Node* root;

Node* createNode(char* value, vector<Node*> children)
{
    Node* temp= new Node();
    temp->val = value;
    temp->children = children;
    return temp;
}

Node* createNode(char* value)
{
    Node* temp = new Node();
    temp->val = value;
    return temp;
}

int buildTree(Node* node, int parentno, int co)
{
    if(node == NULL) return co;
    int nodeno = co++;
    printf(" node%d [label=\"%s\"]\n", nodeno, node->val);
    if(parentno >= 0)
        printf(" node%d -> node%d\n", parentno, nodeno);    
    int n = node->children.size();
    vector<Node*> children = node->children;
    for(int i = 0; i < n; i++)
    {
        co = buildTree(children[i],nodeno,co);
    }
    return co;
}

void list_concat(vector<Node*>& s, const vector<Node*>& t) {
    for(auto mem: t)
    {
        s.push_back(mem);
    
    }
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
    int buildTree(Node*, int parentno , int co);
    void list_concat(vector<Node*>& s, const vector<Node*>& t);
}

%union {
    Node* node;
    char* str;
    int num;
    float float_val;
    char sym;
}


%token<node> ABSTRACT CONTINUE FOR NEW SWITCH ASSERT DEFAULT IF PACKAGE SYNCHRONIZED BOOLEAN DO GOTO PRIVATE THIS BREAK DOUBLE IMPLEMENTS PROTECTED THROW BYTE ELSE IMPORT PUBLIC THROWS CASE ENUM INSTANCEOF RETURN TRANSIENT CATCH EXTENDS INT SHORT TRY CHAR FINAL INTERFACE STATIC VOID CLASS FINALLY LONG STRICTFP VOLATILE CONST FLOAT NATIVE SUPER WHILE UNDERSCORE
%token<node> EXPORTS OPENS REQUIRES USES MODULE PERMITS SEALED VAR PROVIDES TO WITH OPEN RECORD TRANSITIVE YIELD
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
%type<node> WhileStatementNoShortIf ForStatement ModifierList Modifier StatementNoShortIf 

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
%type<node> Literal ClassOrInterfaceTypeToInstantiate

%type<str> ContextualKeywords TypeIdentifierKeywords

%start CompilationUnit

%%

CompilationUnit:    OrdinaryCompilationUnit
                    {
                        root= $$; buildTree(root,-1,0);
                    }
                    ;

OrdinaryCompilationUnit:    TopLevelClassOrInterfaceDeclarationList
                            ;

TopLevelClassOrInterfaceDeclarationList:    TopLevelClassOrInterfaceDeclaration
                                            {
                                                vector<Node*> v;
                                                v.push_back($1);
                                                $$ = createNode("JAVA-PROGRAM" , v);
                                            }
                                            | TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration
                                            {
                                                $$ = $1;
                                                $$->children.push_back($2);
                                            }
                                            ;

TopLevelClassOrInterfaceDeclaration:    ClassDeclaration
                                        ;

ClassDeclaration:   NormalClassDeclaration
                    ;

NormalClassDeclaration: CLASS TypeIdentifier ClassBody
                        {
                            vector<Node*> v;
                            v.push_back($2);
                            v.push_back($3);
                            $$ = createNode("class" , v);
                        }
                        | ModifierList CLASS TypeIdentifier ClassBody
                        {
                            vector<Node*> v;
                            list_concat(v, $1->children);
                            // for(auto child: $1->children)
                            // {
                            //     v.push_back(child);
                            // }
                            v.push_back($3);
                            v.push_back($4);
                            $$ = createNode("class" , v);
                        }
                        ;

Modifier:   PUBLIC
            | PRIVATE
            | STATIC
            ;

ModifierList:   ModifierList Modifier
                {
                    $$ = $1;
                    $$->children.push_back($2);
                }
                | Modifier
                {
                    $$ = createNode("ModifierList");
                    $$->children.push_back($1);
                }
                ;

ClassBody:  LeftCurlyBrace ClassBodyDeclarationList RightCurlyBrace
            {
                $$ = $2;
            }
            | LeftCurlyBrace RightCurlyBrace
            {
                $$ = createNode("ClassBody");
            }
            ;

ClassBodyDeclarationList:   ClassBodyDeclaration
                            {
                                vector<Node*> v;
                                v.push_back($1);
                                $$ = createNode("ClassBody", v);
                            }
                            | ClassBodyDeclarationList ClassBodyDeclaration
                            {
                                $$ = $1;
                                $$->children.push_back($2);
                            }
                            ;

ClassBodyDeclaration:   ClassMemberDeclaration
                        | InstanceInitializer
                        | StaticInitializer
                        | ConstructorDeclaration
                        ;

ClassMemberDeclaration: FieldDeclaration
                        | MethodDeclaration
                        | ClassDeclaration
                        | Semicolon
                        ;

FieldDeclaration:   ModifierList UnannType VariableDeclaratorList Semicolon
                    {
                        $$ = createNode("FieldDeclaration");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                    }
                    | UnannType VariableDeclaratorList Semicolon
                    {
                        $$ = createNode("FieldDeclaration");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                    }
                    ;

VariableDeclaratorList: VariableDeclarator
                        {
                            $$ = createNode("Variables");
                            $$->children.push_back($1);
                        }
                        | VariableDeclaratorList Comma VariableDeclarator
                        {
                            $$ = $1;
                            $$->children.push_back($3);
                        }
                        ;

VariableDeclarator: VariableDeclaratorId ASSIGN VariableInitializer
                    {
                        $$ = createNode("=" );
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | VariableDeclaratorId
                    ;

VariableDeclaratorId:   Identifier Dims
                        {
                            $$ = $1;
                        }
                        | Identifier
                        ;

VariableInitializer:    Expression
                        | ArrayInitializer
                        ;

UnannType:  UnannPrimitiveType
            | UnannReferenceType
            ;

UnannPrimitiveType: NumericType
                    | BOOLEAN
                    ;

UnannReferenceType: UnannClassOrInterfaceType
                    | TypeIdentifier
                    | UnannArrayType
                    ;

UnannClassOrInterfaceType:  UnannClassType
                            ;

UnannClassType: TypeIdentifier TypeArguments {
                    $$ = createNode("UnnanClassType");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
}
| UnannClassOrInterfaceType Dot TypeIdentifier TypeArguments {
                    $$ = createNode("UnnanClassType");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                    $$->children.push_back($3);
                    $$->children.push_back($4);
                }
| UnannClassOrInterfaceType Dot TypeIdentifier {
                    $$ = createNode("UnnanClassType");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                    $$->children.push_back($3);
}
;

UnannArrayType: UnannPrimitiveType Dims
                { 
                    $$ = createNode("UnannArrayType");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                }
                | UnannClassOrInterfaceType Dims {
                    $$ = createNode("UnannArrayType");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                }
                | TypeIdentifier Dims {
                    $$ = createNode("UnannArrayType");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                }
                ;

MethodDeclaration:  ModifierList MethodHeader MethodBody
                    {
                        vector<Node*> v;
                        for(auto child: $1->children)
                            v.push_back(child);
                        v.push_back($2);
                        v.push_back($3);
                        $$ = createNode("MethodDeclaration" , v);
                    }
                    | MethodHeader MethodBody
                    {
                        vector<Node*> v;
                        v.push_back($1);
                        v.push_back($2);
                        $$ = createNode("MethodDeclaration" , v);
                    }
                    ;

MethodHeader:   UnannType MethodDeclarator
                {
                    $$ = createNode("MethodHeader");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                }
                | VOID MethodDeclarator
                {
                    $$ = createNode("MethodHeader");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
                }
                ;

MethodDeclarator:   Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis 
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = $1;
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        list_concat($$->children, $5->children);
                    }
                    | Identifier LeftParenthesis FormalParameterList RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        list_concat($$->children, $3->children);
                        
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($6);
                    }
                    | Identifier LeftParenthesis RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        $$->children.push_back($4);
      
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        list_concat($$->children, $5->children);
                        $$->children.push_back($7);
                    }
                    | Identifier LeftParenthesis FormalParameterList RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->children.push_back($1);
                        list_concat($$->children, $3->children);
                        $$->children.push_back($5);
                    }
                    ;

ReceiverParameter:  UnannType THIS
                    {
                        $$ = createNode("ReceiverParameter");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                    }
                    | UnannType Identifier Dot THIS
                    {
                        $$ = createNode("ReceiverParameter");
                        $$->children.push_back($1);
                        $3->children.push_back($2);
                        $3->children.push_back($4);
                        $$->children.push_back($3);
                    }
                    ;

FormalParameterList:    FormalParameterList Comma FormalParameter
                        {
                            $$ = $1;
                            $$->children.push_back($3);
                        }
                        | FormalParameter
                        {
                            $$ = createNode("FormalParameterList");
                            $$->children.push_back($1);
                        }
                        ;

FormalParameter:    VariableModifierList UnannType VariableDeclaratorId
                    {                  
                        vector<Node*> v;
                        for(auto child: $1->children)
                            v.push_back(child);
                        v.push_back($2);
                        v.push_back($3);
                        $$ = createNode("FormalParameter" , v);
                    }
                    | UnannType VariableDeclaratorId {
                        $$ = createNode("FormalParameter");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                    }
                    | VariableArityParameter
                    ;

VariableArityParameter: UnannType ellipsis Identifier
                        {
                            $$ = createNode("VariableArityParameter");
                            $$->children.push_back($1);
                            $$->children.push_back($2);
                            $$->children.push_back($3);
                        }
                        | VariableModifierList UnannType ellipsis Identifier
                        ;

VariableModifierList:   VariableModifier
                        {
                            $$ = createNode("VariableModifierList");
                            $$->children.push_back($1);
                        }
                        | VariableModifierList VariableModifier{
                            $$ = $1;
                            $$->children.push_back($2);
                        }   
                        ;

VariableModifier:   FINAL
                    ;

MethodBody: Block
            | Semicolon
            ;

InstanceInitializer:    Block
                        ;

StaticInitializer:  STATIC Block
                    {
                        $$ = createNode("StaticInitializer");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                    }
                    ;

ConstructorDeclaration: ConstructorDeclarator ConstructorBody
                        {
                            $$ = createNode("ConstructorDeclaration");
                            $$->children.push_back($1);
                            $$->children.push_back($2);
                        }
                        | ModifierList ConstructorDeclarator ConstructorBody
                        {
                            $$ = createNode("ConstructorDeclaration");
                            $$->children.push_back($1);
                            $$->children.push_back($2);
                            $$->children.push_back($3);
                        }
                        ;

ConstructorDeclarator:  SimpleTypeName LeftParenthesis  RightParenthesis
                        {
                            $$ = $1;
                        }
                        | SimpleTypeName LeftParenthesis ReceiverParameter Comma RightParenthesis
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | SimpleTypeName LeftParenthesis  FormalParameterList RightParenthesis 
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | SimpleTypeName LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis{
                            $$ = createNode("ConstructorDeclarator");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                            $$->children.push_back($5);
                        }
;

SimpleTypeName: TypeIdentifier
                ;

ConstructorBody:    LeftCurlyBrace  RightCurlyBrace
                    {
                       $$ =  createNode("ConstructorBody");
                    }
                    | LeftCurlyBrace ExplicitConstructorInvocation RightCurlyBrace
                    {
                        $$ = createNode("ConstructorBody");
                        $$->children.push_back($2);
                    }
                    | LeftCurlyBrace  BlockStatements RightCurlyBrace
                    {
                        $$ = createNode("ConstructorBody");
                        $$->children.push_back($2);
                    }
                    | LeftCurlyBrace ExplicitConstructorInvocation BlockStatements RightCurlyBrace
                    {
                        $$ = createNode("ConstructorBody");
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                    }
                    ;

ExplicitConstructorInvocation:  THIS LeftParenthesis RightParenthesis Semicolon {
                                $$ = $1;
                            }
                                | TypeArguments THIS LeftParenthesis RightParenthesis Semicolon {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->children.push_back($1);
                                    $$->children.push_back($2);                                    
                                }
                                | THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->children.push_back($1);
                                    list_concat($$->children, $3->children);
                                }
                                | TypeArguments THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->children.push_back($1);
                                    $$->children.push_back($2);
                                    list_concat($$->children, $4->children);
                                }
                                | TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->children.push_back($1);
                                    $$->children.push_back($2);
                                    list_concat($$->children, $4->children);
                                }
                                | SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->children.push_back($1);
                                }
                                | SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->children.push_back($1);
                                    list_concat($$->children, $3->children);
                                }
                                | TypeArguments SUPER LeftParenthesis  RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    
                                }
                                | ExpressionName Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                | ExpressionName Dot TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
                                | ExpressionName Dot SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                | ExpressionName Dot SUPER LeftParenthesis RightParenthesis Semicolon
                                | Primary Dot  SUPER LeftParenthesis RightParenthesis Semicolon
                                | Primary Dot TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
                                | Primary Dot  SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                | Primary Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                ;

ArrayInitializer:   LeftCurlyBrace  Comma RightCurlyBrace
                    {
                        $$ = createNode("ArrayInitializer");
                        $$->children.push_back($2);
                    }
                    | LeftCurlyBrace  RightCurlyBrace
                    {
                        $$=createNode("ArrayInitializer");
                    }
                    | LeftCurlyBrace VariableInitializerList Comma RightCurlyBrace
                    {
                        $$=createNode("ArrayInitializer");
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                    }
                    | LeftCurlyBrace VariableInitializerList RightCurlyBrace
                    {
                        $$=createNode("ArrayInitializer");
                        $$->children.push_back($2);
                    }
                    ;

VariableInitializerList:    VariableInitializer
                            {
                                $$ = createNode("VariableInitializerList");
                                $$->children.push_back($1);
                            }
                            | VariableInitializerList Comma VariableInitializer
                            {
                                $$= $1;
                                $$->children.push_back($3);
                            }
                            ;

Block:  LeftCurlyBrace BlockStatements RightCurlyBrace
        {
            $$ = $2;
        }
        | LeftCurlyBrace RightCurlyBrace
        {
            $$ = createNode("Block");
        }
        ;

BlockStatements:    BlockStatements BlockStatement
                    {
                        $$ = $1;
                        $$->children.push_back($2);
                    }
                    | BlockStatement
                    {
                        $$ = createNode("Block");
                        $$->children.push_back($1);
                    }
                    ;

BlockStatement: LocalClassOrInterfaceDeclaration
                | LocalVariableDeclarationStatement
                | Statement
                ;
    
LocalClassOrInterfaceDeclaration:   ClassDeclaration
                                    ;

LocalVariableDeclarationStatement:  LocalVariableDeclaration Semicolon {
                        $$ = $1;
}
                                    ;

LocalVariableDeclaration:   LocalVariableType
                            | VariableModifierList LocalVariableType
                            {
                                $$ = createNode("LocalVariableDeclaration");
                                $$->children.push_back($1);
                                $$->children.push_back($2);
                            }
                            | LocalVariableType VariableDeclaratorList
                            {
                                $$ = createNode("LocalVariableDeclaration");
                                $$->children.push_back($1);
                                $$->children.push_back($2);
                            }
                            | VariableModifierList LocalVariableType VariableDeclaratorList
                            {
                                $$ = createNode("LocalVariableDeclaration");
                                $$->children.push_back($1);
                                $$->children.push_back($2);
                                $$->children.push_back($3);
                            }
                            ;

LocalVariableType:  UnannType
                    | VAR
                    ;

Statement:  StatementWithoutTrailingSubstatement
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

StatementWithoutTrailingSubstatement:   Block
                                        | EmptyStatement
                                        | ExpressionStatement
                                        | AssertStatement
                                        | BreakStatement
                                        | ContinueStatement
                                        | ReturnStatement
                                        | YieldStatement
                                        ;

EmptyStatement: Semicolon
                ;

LabeledStatement:   Identifier COLON Statement
                    {
                        $$ =createNode("LabeledStatement");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                    }
                    ;

ExpressionStatement:    StatementExpression Semicolon
                        {
                            $$  = $1;
                        }
                        ;

StatementExpression:    Assignment
                        {
                            $$ = $1;
                        }
                        | PreIncrementExpression
                        | PreDecrementExpression
                        | PostIncrementExpression
                        | PostDecrementExpression
                        | MethodInvocation
                        | ClassInstanceCreationExpression
                        ;

IfThenStatement:    IF LeftParenthesis Expression RightParenthesis Statement
                    {
                        $$ = createNode("IfThenStatement");
                        $$->children.push_back($3);
                        $$->children.push_back($5);
                    }
                    ;

IfThenElseStatement:    IF LeftParenthesis Expression RightParenthesis StatementNoShortIf ELSE Statement
                        {
                            $$ = createNode("IfThenElseStatement");
                            $$->children.push_back($3);
                            $$->children.push_back($5);
                            $$->children.push_back($7);
                        }
                        ;

IfThenElseStatementNoShortIf:   IF LeftParenthesis Expression RightParenthesis StatementNoShortIf ELSE StatementNoShortIf
                                {
                                    $$ = createNode("IfThenElseStatementNoShortIf");
                                    $$->children.push_back($3);
                                    $$->children.push_back($5);
                                    $$->children.push_back($7);
                                }
                                ;

AssertStatement:    ASSERT Expression Semicolon
                    {
                        $$ = createNode("Assert");
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                    }
                    | ASSERT Expression COLON Expression Semicolon
                    {
                        $$ = createNode("Assert");
                        $$->children.push_back($2);
                        $$->children.push_back($4);
                    }
                    ;

WhileStatement: WHILE LeftParenthesis Expression RightParenthesis Statement
                {
                    $$ = createNode("While");
                    $$->children.push_back($3);
                    $$->children.push_back($5);
                }

WhileStatementNoShortIf:    WHILE LeftParenthesis Expression RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("While");
                                $$->children.push_back($3);
                                $$->children.push_back($5);
                            }
                            ;

ForStatement:   BasicForStatement
                | EnhancedForStatement
                ;

ForStatementNoShortIf:  BasicForStatementNoShortIf
                        | EnhancedForStatementNoShortIf
                        ;

BasicForStatement:  FOR LeftParenthesis  Semicolon  Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($6);
                    }
                    | FOR LeftParenthesis ForInit Semicolon  Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($7);
                    }
                    | FOR LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($5);
                        $$->children.push_back($7);
                    }
                    | FOR LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($3);
                        $$->children.push_back($6);
                        $$->children.push_back($8);
                    }
                    | FOR LeftParenthesis  Semicolon Expression Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($4);
                        $$->children.push_back($7);
                    }
                    | FOR LeftParenthesis ForInit Semicolon Expression Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($3);
                        $$->children.push_back($5);
                        $$->children.push_back($8);
                    }
                    | FOR LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($4);
                        $$->children.push_back($6);
                        $$->children.push_back($8);
                    }
                    | FOR LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->children.push_back($3);
                        $$->children.push_back($5);
                        $$->children.push_back($7);
                        $$->children.push_back($9);
                    }
                    ;

BasicForStatementNoShortIf: FOR LeftParenthesis  Semicolon  Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($6);
                            }
                            | FOR LeftParenthesis ForInit Semicolon  Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($7);
                            }
                            | FOR LeftParenthesis  Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($4);
                                $$->children.push_back($7);
                            }
                            | FOR LeftParenthesis ForInit Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($3);
                                $$->children.push_back($5);
                                $$->children.push_back($8);
                            }
                            | FOR LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($5);
                                $$->children.push_back($7);
                            }
                            | FOR LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($3);
                                $$->children.push_back($6);
                                $$->children.push_back($8);
                            }
                            | FOR LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($4);
                                $$->children.push_back($6);
                                $$->children.push_back($8);
                            }
                            | FOR LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->children.push_back($3);
                                $$->children.push_back($5);
                                $$->children.push_back($7);
                                $$->children.push_back($9);
                            }
                            ;

ForInit:    StatementExpressionList
            | LocalVariableDeclaration
            ;

ForUpdate:  StatementExpressionList
            ;

StatementExpressionList:    StatementExpression{
                                $$ = createNode("StatementExpressionList");
                                $$->children.push_back($1);
                            }
                            | StatementExpressionList Comma StatementExpression
                            {
                                $$ = $1;
                                $$->children.push_back($3);
                            }
                            ;

EnhancedForStatement:   FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement
                        {
                            $$ = createNode("For");
                            $$->children.push_back($3);
                            $$->children.push_back($5);
                            $$->children.push_back($7);
                        }
                        ;

EnhancedForStatementNoShortIf:  FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf
                                {
                                    $$ = createNode("For");
                                    $$->children.push_back($3);
                                    $$->children.push_back($5);
                                    $$->children.push_back($7);
                                }
                                ;

BreakStatement: BREAK Identifier Semicolon 
                {
                        $$ = createNode("BREAK");
                        $$->children.push_back($2);

                }
                | BREAK Semicolon
                {
                        $$ = createNode("BREAK");
                        $$->children.push_back($2);
                }
                ;

YieldStatement: YIELD Expression Semicolon
                {
                    $$ = $1;
                    $$->children.push_back($2);
                }
                ;

ContinueStatement:  CONTINUE Semicolon
                    | CONTINUE Identifier Semicolon
                    {
                        $$ = $1;
                        $$->children.push_back($2);
                    }
                    ;

ReturnStatement:    RETURN Semicolon
                    | RETURN Expression Semicolon
                    {
                        $$ = $1;
                        $$->children.push_back($2);
                    }
                    ;

Pattern:    TypePattern
            ;

TypePattern:    LocalVariableDeclaration
                ;

Primary:    PrimaryNoNewArray 
            {
                $$ = $1;
            }
            | ArrayCreationExpression
            ;

PrimaryNoNewArray:  Literal
                    {
                        $$ = $1;
                    }
                    | ClassLiteral
                    | THIS
                    | TypeName Dot THIS
                    {
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$ = $2;
                    }
                    | LeftParenthesis Expression RightParenthesis
                    {
                        $$ = $2;
                    }
                    | ClassInstanceCreationExpression
                    | FieldAccess
                    | ArrayAccess
                    | MethodInvocation
                    | MethodReference
                    ;

ClassLiteral:   TypeName Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
}
                | NumericType  Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                }
                | BOOLEAN  Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                }
                | VOID Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                }
                | TypeName LeftRightSquareList Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($2);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                }
                | NumericType LeftRightSquareList Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                }
                | BOOLEAN LeftRightSquareList Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                }
                ;

LeftRightSquareList:    LeftSquareBracket RightSquareBracket
                        | LeftRightSquareList LeftSquareBracket RightSquareBracket
                        ;

ClassInstanceCreationExpression:    UnqualifiedClassInstanceCreationExpression
                                    | ExpressionName Dot UnqualifiedClassInstanceCreationExpression
                                    {
                                        $$ = createNode("ClassInstanceCreationExpression");
                                        $2->children.push_back($1);
                                        $2->children.push_back($3);
                                        $$->children.push_back($2);
                                    }
                                    | Primary Dot UnqualifiedClassInstanceCreationExpression {
                                        $$ = createNode("ClassInstanceCreationExpression");
                                        $2->children.push_back($1);
                                        $2->children.push_back($3);
                                        $$->children.push_back($2);
                                    }
                                    
                                    ;

UnqualifiedClassInstanceCreationExpression: NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis
                                            {
                                                $$ = $2;
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis
                                            {
                                                $$ = $3;
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis
                                            {
                                                $$ = $2;
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis
                                            {
                                                $$ = $3;
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis ClassBody
                                            {
                                                $$ = $2;
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis ClassBody
                                            {
                                                $$ = $3;
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
                                            {
                                                $$ = $2;
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
                                            {
                                                $$ = $2;
                                            }
                                            ;

ClassOrInterfaceTypeToInstantiate:  Identifier
                                    | ClassOrInterfaceTypeToInstantiate Dot Identifier
                                    {
                                        
                                        $2->children.push_back($1);
                                        $2->children.push_back($3);
                                        $$ = $2;
                                    }
                                    | ClassOrInterfaceTypeToInstantiate Dot Identifier TypeArgumentsOrDiamond
                                    {
                                        $2->children.push_back($1);
                                        $2->children.push_back($3);
                                        $$ = $2;
                                    }
                                    ;

TypeArgumentsOrDiamond: TypeArguments
                        ;

FieldAccess:    Primary Dot Identifier
                {
                    $2->children.push_back($1);
                    $2->children.push_back($3);
                    $$ = $2;
                }
                | SUPER Dot Identifier
                {
                    $2->children.push_back($1);
                    $2->children.push_back($3);
                    $$ = $2;
                }
                | TypeName Dot SUPER Dot Identifier
                {
                    $2->children.push_back($1);
                    $2->children.push_back($3);
                    $4->children.push_back($2);
                    $4->children.push_back($5);
                    $$ = $4;

                }
                ;

ArrayAccess:    ExpressionName LeftSquareBracket Expression RightSquareBracket {
                        $$ = createNode("ArrayAccess");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
}     
                | PrimaryNoNewArray LeftSquareBracket Expression RightSquareBracket{
                        $$ = createNode("ArrayAccess");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                }
                ;

MethodInvocation:   Identifier LeftParenthesis  RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $$->children.push_back($1);
                    }
                    | Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }

                    | TypeName Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);;
                    }
                  | TypeName Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                    }
                    | TypeName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    | TypeName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                        $$->children.push_back($6);
                    }
                    
                    | ExpressionName Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                    }
                    | ExpressionName Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                    }
                    | ExpressionName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    | ExpressionName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    
                    | Primary Dot Identifier LeftParenthesis RightParenthesis {
                                            
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                    
                    }
                    | Primary Dot TypeArguments Identifier LeftParenthesis RightParenthesis{
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                    }
                    | Primary Dot Identifier LeftParenthesis ArgumentList RightParenthesis {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    | Primary Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis{
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    
                    | SUPER Dot Identifier LeftParenthesis RightParenthesis {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);          
   
                    
                    }
                    | SUPER Dot TypeArguments Identifier LeftParenthesis RightParenthesis{
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                    }
                    | SUPER Dot Identifier LeftParenthesis ArgumentList RightParenthesis {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    | SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis{
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($4);
                        $$->children.push_back($2);
                        $$->children.push_back($5);
                    }
                    
                    | TypeName Dot SUPER Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $4->children.push_back($2);
                        $4->children.push_back($5);
                        $$->children.push_back($4);
                    }
                    | TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $4->children.push_back($2);
                        $4->children.push_back($6);
                        $$->children.push_back($4);
                    }
                    | TypeName Dot SUPER Dot Identifier LeftParenthesis ArgumentList RightParenthesis 
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $4->children.push_back($2);
                        $4->children.push_back($5);
                        $$->children.push_back($4);
                        $$->children.push_back($7);     
                    }
                    | TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $4->children.push_back($2);
                        $4->children.push_back($6);
                        $$->children.push_back($4);
                        $$->children.push_back($8); 
                    }
                    ;

ArgumentList:   Expression
                {
                    $$ = createNode("Arguments");
                    $$->children.push_back($1);
                }
                | ArgumentList Comma Expression
                {
                    $$ = $1;
                    $$->children.push_back($3);
                }
                ;

MethodReference:    ExpressionName Scope Identifier {
                        $$ = createNode("::");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }

                    | ExpressionName Scope TypeArguments Identifier{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                    }
                    | Primary Scope Identifier{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | Primary Scope TypeArguments{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }

                    | UnannReferenceType Scope Identifier{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | UnannReferenceType Scope TypeArguments Identifier{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                    }
                    
                    | SUPER Scope Identifier{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | SUPER Scope TypeArguments Identifier{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                    }
                    
                    | TypeName Dot SUPER Scope Identifier{
                        $$ = $4;
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                         $$->children.push_back($5);
                    }
                    | TypeName Dot SUPER Scope TypeArguments Identifier{
                        $$ = $4;
                        $2->children.push_back($1);
                        $2->children.push_back($3);
                        $$->children.push_back($2);
                         $$->children.push_back($5);
                        $$->children.push_back($6);
                    }
                    
                    | UnannClassType Scope NEW{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | UnannClassType Scope TypeArguments NEW{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                        $$->children.push_back($4);
                    }
                    | ArrayType Scope NEW{
                        $$ = $2;
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    ;

ArrayCreationExpression:    NEW PrimitiveType DimExprs
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->children.push_back($2);
                            }
                            | NEW UnannClassOrInterfaceType DimExprs
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->children.push_back($2);
                            }
                            | NEW PrimitiveType DimExprs Dims
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->children.push_back($2);
                            }
                            | NEW UnannClassOrInterfaceType DimExprs Dims
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->children.push_back($2);
                            }
                            ;

DimExprs:   DimExprList
            ;

DimExprList:    DimExpr
                | DimExprList DimExpr
                ;

DimExpr:    LeftSquareBracket Expression RightSquareBracket {
    $$=createNode("DimExpr");
    $$->children.push_back($2);
}
            ;

Expression: AssignmentExpression
            ;

AssignmentExpression:   ConditionalExpression
                        | Assignment
                        ;

Assignment: LeftHandSide AssignmentOperator Expression
            {
                $$ = createNode($2->val);
                $$->children.push_back($1);
                $$->children.push_back($3);
            }
            ;

LeftHandSide:   ExpressionName
                | FieldAccess
                | ArrayAccess
                ;

AssignmentOperator: ASSIGN
                    | MUL_ASSIGN
                    | DIV_ASSIGN
                    | MOD_ASSIGN
                    | ADD_ASSIGN
                    | SUB_ASSIGN
                    | LSHIFT_ASSIGN
                    | RSHIFT_ASSIGN
                    | URSHIFT_ASSIGN
                    | AND_ASSIGN
                    | XOR_ASSIGN
                    | OR_ASSIGN
                    ;

ConditionalExpression:  ConditionalOrExpression
                        | ConditionalOrExpression QUESTIONMARK Expression COLON ConditionalExpression
                        {
                            $$ = createNode("Ternary");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                            $$->children.push_back($5);
                        }
                        ;

ConditionalOrExpression:    ConditionalAndExpression
                            | ConditionalOrExpression OR ConditionalAndExpression
                            {
                                $$ = createNode("||");
                                $$->children.push_back($1);
                                $$->children.push_back($3);
                            }
                            ;

ConditionalAndExpression:   InclusiveOrExpression
                            | ConditionalAndExpression AND InclusiveOrExpression
                            {
                                $$ = createNode("&&");
                                $$->children.push_back($1);
                                $$->children.push_back($3);
                            }
                            ;

InclusiveOrExpression:  ExclusiveOrExpression
                        | InclusiveOrExpression BITOR ExclusiveOrExpression
                        {
                            $$ = createNode("|");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        ;

ExclusiveOrExpression:  AndExpression
                        | ExclusiveOrExpression CARET AndExpression
                        {
                            $$ = createNode("^");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        ;

AndExpression:  EqualityExpression
                | AndExpression BITAND EqualityExpression
                {
                    $$ = createNode("&");
                    $$->children.push_back($1);
                    $$->children.push_back($3);
                }
                ;

EqualityExpression: RelationalExpression
                    | EqualityExpression EQUAL RelationalExpression
                    {
                        $$ = createNode("==");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | EqualityExpression NOTEQUAL RelationalExpression
                    {
                        $$ = createNode("!=");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    ;

RelationalExpression:   ShiftExpression
                        | RelationalExpression LT ShiftExpression
                        {
                            $$ = createNode("<");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | RelationalExpression GT ShiftExpression
                        {
                            $$ = createNode(">");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | RelationalExpression LE ShiftExpression
                        {
                            $$ = createNode("<=");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | RelationalExpression GE ShiftExpression
                        {
                            $$ = createNode(">=");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | InstanceofExpression
                        ;

InstanceofExpression:   RelationalExpression INSTANCEOF UnannReferenceType
                        {
                            $$ = createNode("instanceof");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        | RelationalExpression INSTANCEOF Pattern
                        {
                            $$ = createNode("instanceof");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                        }
                        ;

ShiftExpression:    AdditiveExpression
                    | ShiftExpression LSHIFT AdditiveExpression
                    {
                        $$ = createNode("<<");
                        $$->children.push_back($1); 
                        $$->children.push_back($3);
                    }
                    | ShiftExpression RSHIFT AdditiveExpression
                    {
                        $$ = createNode(">>");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | ShiftExpression URSHIFT AdditiveExpression
                    {
                        $$ = createNode(">>>");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    ;

AdditiveExpression: MultiplicativeExpression
                    | AdditiveExpression ADD MultiplicativeExpression
                    {
                        $$ = createNode("+");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    | AdditiveExpression SUB MultiplicativeExpression
                    {
                        $$ = createNode("-");
                        $$->children.push_back($1);
                        $$->children.push_back($3);
                    }
                    ;

MultiplicativeExpression:   UnaryExpression
                            | MultiplicativeExpression MUL UnaryExpression
                            {
                                $$ = createNode("*");
                                $$->children.push_back($1);
                                $$->children.push_back($3);
                            }
                            | MultiplicativeExpression DIV UnaryExpression
                            {
                                $$ = createNode("/");
                                $$->children.push_back($1);
                                $$->children.push_back($3);
                            }
                            | MultiplicativeExpression MOD UnaryExpression
                            {
                                $$ = createNode("%");
                                $$->children.push_back($1);
                                $$->children.push_back($3);
                            }
                            ;

UnaryExpression:    PreIncrementExpression
                    | PreDecrementExpression
                    | ADD UnaryExpression
                    {
                        $1->children.push_back($2);
                        $$ = $1;
                    }
                    | SUB UnaryExpression
                    {
                        $1->children.push_back($2);
                        $$ = $1;
                    }
                    | UnaryExpressionNotPlusMinus
                    ;

PreIncrementExpression: INC UnaryExpression
                        {
                            $$ = createNode("PreIncrementExpression");
                            $$->children.push_back($1);
                            $$->children.push_back($2);
                        }
                        ;

PreDecrementExpression: DEC UnaryExpression
                        {
                            $$ = createNode("PreDecrementExpression");
                            $$->children.push_back($1);
                            $$->children.push_back($2);
                        }
                        ;

UnaryExpressionNotPlusMinus:    PostfixExpression
                                | TILDE UnaryExpression
                                {
                                    $1->children.push_back($2);
                                    $$ = $1;
                                }
                                | EXCLAMATION UnaryExpression
                                {
                                    $1->children.push_back($2);
                                    $$ = $1;
                                }
                                | CastExpression
                                ;

PostfixExpression:  Primary
                    | ExpressionName
                    | PostIncrementExpression
                    | PostDecrementExpression
                    ;

PostIncrementExpression:    PostfixExpression INC
                            {
                                $$ = createNode("PostIncrementExpression");
                                $$->children.push_back($1);
                                $$->children.push_back($2);
                            }
                            ;

PostDecrementExpression:    PostfixExpression DEC
                            {
                                $$ = createNode("PostDecrementExpression");
                                $$->children.push_back($1);
                                $$->children.push_back($2);
                            }
                            ;

CastExpression: LeftParenthesis PrimitiveType RightParenthesis UnaryExpression
                {
                    $$ = createNode("CastExpression");
                    $$->children.push_back($2);
                    $$->children.push_back($4);
                }
                | LeftParenthesis UnannReferenceType  RightParenthesis UnaryExpressionNotPlusMinus
                {
                    $$ = createNode("CastExpression");
                    $$->children.push_back($2);
                    $$->children.push_back($4);
                }
                ;

ConstantExpression: Expression
                    ;

Type:   PrimitiveType
        | UnannReferenceType
        ;

PrimitiveType:  NumericType
                | BOOLEAN
                ;

NumericType:    IntegralType
                | FloatingPointType
                ;

IntegralType:   BYTE
                | SHORT
                | INT
                | LONG
                | CHAR
                ;

FloatingPointType:  FLOAT
                    | DOUBLE
                    ;

ArrayType:  UnannArrayType
            ;

Dims:   LeftSquareBracket RightSquareBracket
        | LeftSquareBracket RightSquareBracket LeftRightSquareList
        ;

TypeBound:  EXTENDS UnannClassOrInterfaceType {
                    $$ = createNode("TypeBound");
                    $$->children.push_back($1);
                    $$->children.push_back($2);
}
            ;

TypeArguments:  LT TypeArgumentList GT {
                    $$ = $2;
                }
                ;

TypeArgumentList:   TypeArgumentList Comma TypeArgument
                    {
                        $$ = $1;
                        $$->children.push_back($3);
                    }
                    | TypeArgument {
                        $$ = createNode("TypeArgumentList");
                        $$->children.push_back($1);
                    }
                    ;

TypeArgument:   UnannReferenceType
                | Wildcard
                ;

Wildcard:   QUESTIONMARK
            | QUESTIONMARK WildcardBounds {
                $$=createNode("Wildcard");
                $$->children.push_back($1);
                $$->children.push_back($2);


            }
            ;

WildcardBounds: EXTENDS UnannReferenceType {
                $$=createNode("WildcardBounds");
                $$->children.push_back($1);
                $$->children.push_back($2);
}
                | SUPER UnannReferenceType {
                               
                $$=createNode("WildcardBounds");;
                $$->children.push_back($1);
                $$->children.push_back($2);
                }
                ;

ContextualKeywords: EXPORTS
                    | OPENS
                    | REQUIRES
                    | USES
                    | MODULE
                    | PERMITS
                    | SEALED
                    | VAR
                    | PROVIDES
                    | TO
                    | WITH
                    | OPEN
                    | RECORD
                    | TRANSITIVE
                    | YIELD
                    ;

TypeIdentifierKeywords: EXPORTS
                        | OPENS
                        | REQUIRES
                        | USES
                        | MODULE
                        | PROVIDES
                        | TO
                        | WITH
                        | OPEN
                        | TRANSITIVE
                        ;

Identifier: IdentifierChars
            ;

TypeIdentifier: IdentifierChars
                | TypeIdentifierKeywords
                ;

ExpressionName: Identifier
                | ExpressionName Dot Identifier
                {
                    $$ = createNode(".");
                    $$->children.push_back($1);
                    $$->children.push_back($3);
                }
                ;

TypeName:   TypeIdentifier
            ;

Literal:    IntegerLiteral
            | FloatingPointLiteral
            | BooleanLiteral
            | CharacterLiteral
            | NullLiteral
            | StringLiteral
            ;

%%
