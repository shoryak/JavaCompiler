
%{
#include <vector>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cassert>
#include <stack>
#include "symbol_table.h"

int lines = 0;
int yyparse();
extern "C"
{        
    extern int linenum;
    int yylex(void);
    int yyerror(const char* s)
    {
        fprintf(stderr, "ERROR: %s Line Number: %d\n", s, linenum);
        exit(1);
        return 1;
    }
}
extern FILE *yyin;
extern FILE *yyout;
extern int linenum;

SymbolTable *globalSymTable = new SymbolTable;
SymbolTable *currSymTable = globalSymTable;
std::vector<SymbolTableEntry*> stEntryContainer;


struct Node
{
/*  Attributes needed for AST generation    */
    char* value;
    std::vector<Node*> children;

/*  Attributes needed for semantic analysis.
    All are attributes of the identifier located 
    in the particular non-terminal (e.g. statement) */
    SymbolTable *symTable = nullptr;

/*  For a list-type non-terminal (of some individual non-terminal
    which can have a scope) we need to add all entries to the
    list-type non-term's symbol table. So we store the individual
    non-term's entries here   */
    std::vector<SymbolTableEntry*> stEntries;

/*  If we want to carry up the lexeme so that the required symbol table
    entry can be created properly   */
    std::string lexeme = "";

/*  For non-terminals which contain expressions/variables of a particular type  */
    std::string type = "";

/*  Number of dimensions, only applicable for the Dims non-terminal */
    int numDims = 0;

/*  This will store the line number of the token found during the lexer phase.
    Applicable only for tokens/non-terminals    */
    int lineNumber = -1;

/*  Constructors    */
    Node(char* value, std::vector<Node*> children)
    : value{value}, children{children}, lineNumber{linenum} {}
    Node(char* value)
    : value{value}, children{std::vector<Node*>()}, lineNumber{linenum} {}
    Node(char* value, std::string lexeme, std::string type)
    : value{value}, lexeme{lexeme}, type{type}, lineNumber{linenum} {}

/*  Add a node as a child   */
    void add_child(Node* nd)
    {
        children.push_back(nd);
    }

/*  Add all children of another node as children    */
    void add_children(Node* nd)
    {
        for(auto& child: nd->children)
            children.push_back(child);
    }

/*  Allocate memory for the symbol table.
    Note: this isn't done by default as tokens will use up too much memory  */
    void allocate_symtable()
    {
        symTable = new SymbolTable;
    }

/*  Add a Symbol Table Entry into the Symbol Table  */
    void add_entry(SymbolTableEntry* stEntry)
    {
        assert(symTable);
        assert(stEntry);
        symTable->insert(stEntry->getName(), stEntry);
    }

/*  Add multiple Symbol Table Entries into the Symbol Table */
    void add_entries(std::vector<SymbolTableEntry*> stEntries)
    {
        assert(symTable);
        for(auto stEntry: stEntries)
        {
            assert(stEntry);
            symTable->insert(stEntry->getName(), stEntry);
        }
    }
};

Node* root;

Node* createNode(const char* value, std::vector<Node*> children)
{
    return new Node(strdup(value), children);
}

Node* createNode(const char* value)
{
    return new Node(strdup(value));
}

Node* createNode(const char* value, std::string lexeme, std::string type)
{
    return new Node(strdup(value), lexeme, type);
}

int buildTree(Node* node, int parentno, int co)
{
    if(node == NULL) return co;
    int nodeno = co++;
    printf(" node%d [label=\"%s\"]\n", nodeno, node->value);
    if(parentno >= 0)
        printf(" node%d -> node%d\n", parentno, nodeno);    
    int n = node->children.size();
    std::vector<Node*> children = node->children;
    for(int i = 0; i < n; i++)
    {
        co = buildTree(children[i], nodeno, co);
    }
    return co;
}

void startScope()
{
    auto newSymTable = new SymbolTable;
    newSymTable->setParent(currSymTable);
    currSymTable = newSymTable;
}

void endScope()
{
    auto parentSymTable = currSymTable->getParent();
    assert(parentSymTable);
    currSymTable = parentSymTable;
}




%}

%code requires {
    #include <vector>
    #include <cstdio>
    #include <cstring>
    struct Node;
    Node* createNode(const char* value, std::vector<Node*> children);
    Node* createNode(const char* value);
    Node* createNode(const char* value, std::string lexeme, std::string type);
    int buildTree(Node*, int parentno , int co);
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
%type<node> ClassDeclaration  ClassBody
%type<node> TypeIdentifier 
%type<node> RelationalExpression 
%type<node> TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration NormalClassDeclaration 
%type<node> ClassBodyDeclaration ClassBodyDeclarationList ClassMemberDeclaration FieldDeclaration VariableDeclaratorList
%type<node> VariableDeclarator VariableDeclaratorId VariableInitializer UnannType UnannPrimitiveType UnannReferenceType
%type<node> UnannClassOrInterfaceType UnannClassType UnannArrayType MethodDeclaration
%type<node> MethodHeader MethodDeclarator ReceiverParameter FormalParameterList  FormalParameter
%type<node> VariableArityParameter VariableModifierList VariableModifier MethodBody
%type<node> InstanceInitializer StaticInitializer ConstructorDeclaration ConstructorDeclarator
%type<node> SimpleTypeName ConstructorBody ExplicitConstructorInvocation ArrayInitializer VariableInitializerList 
%type<node> Block BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration
%type<node> LocalVariableType Statement ForStatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement
%type<node> ExpressionStatement StatementExpression IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement WhileStatement
%type<node> WhileStatementNoShortIf ForStatement ModifierList Modifier StatementNoShortIf 

%type<node> BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate StatementExpressionList  EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement 
%type<node> Pattern TypePattern Primary PrimaryNoNewArray ClassLiteral LeftRightSquareList ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression
%type<node> Identifier
%type<node> TypeArgumentsOrDiamond FieldAccess ArrayAccess MethodInvocation ArgumentList  MethodReference
%type<node> ArrayCreationExpression DimExprs DimExprList DimExpr Expression AssignmentExpression Assignment LeftHandSide AssignmentOperator ConditionalExpression
%type<node> ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression InstanceofExpression
%type<node> ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression PreIncrementExpression PreDecrementExpression
%type<node> UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression ConstantExpression Type PrimitiveType
%type<node> NumericType IntegralType FloatingPointType ArrayType
%type<node> Dims  TypeBound TypeArguments TypeArgumentList  TypeArgument Wildcard WildcardBounds TypeName
%type<node> ExpressionName
%type<node> Literal ClassOrInterfaceTypeToInstantiate
%type<node> ContextualKeywords TypeIdentifierKeywords

%start CompilationUnit

%%

CompilationUnit:    OrdinaryCompilationUnit
                    {
                        root = $$;
                        printf("digraph G {\n");
                        buildTree(root, -1, 0);
                        printf("}\n");
                        globalSymTable->__printAll();
                    }
                    ;

OrdinaryCompilationUnit:    TopLevelClassOrInterfaceDeclarationList
                            ;

TopLevelClassOrInterfaceDeclarationList:    TopLevelClassOrInterfaceDeclaration
                                            {
                                                std::vector<Node*> v{$1};
                                                $$ = createNode("JAVA-PROGRAM", v);
                                            }
                                            | TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration
                                            {
                                                $$ = $1;
                                                $$->add_child($2);
                                            }
                                            ;

TopLevelClassOrInterfaceDeclaration:    ClassDeclaration 
                                        ;

ClassDeclaration:   NormalClassDeclaration
                    ;

NormalClassDeclaration: CLASS  TypeIdentifier ClassBody
                        {
                            std::vector<Node*> v{$2, $3};
                            $$ = createNode("class" , v);

                            auto stEntry = new SymbolTableEntry($3->lexeme, " ", -1, 0, $3->lineNumber, 0);
                            currSymTable->insert(stEntry);
                          
                        }
                        | ModifierList CLASS  TypeIdentifier ClassBody
                        {
                            $$ = createNode("class");
                            $$->add_children($1);
                            $$->add_child($3);
                            $$->add_child($4);

                            auto stEntry = new SymbolTableEntry($4->lexeme, " ", -1, 0, $4->lineNumber, 0);
                            currSymTable->insert(stEntry);
                            
                        }
                        ;

Modifier:   PUBLIC
            | PRIVATE
            | STATIC
            ;

ModifierList:   ModifierList Modifier
                {
                    $$ = $1;
                    $$->add_child($2);
                }
                | Modifier
                {
                    $$ = createNode("ModifierList");
                    $$->add_child($1);
                }
                ;

ClassBody:  LeftCurlyBrace { startScope(); } ClassBodyDeclarationList RightCurlyBrace { endScope(); }
            {
                $$ = $3;
            }
            | LeftCurlyBrace { startScope(); }  RightCurlyBrace { endScope(); }
            {
                $$ = createNode("ClassBody");
                $$->add_child(createNode("{}"));
            }
            ;

ClassBodyDeclarationList:   ClassBodyDeclaration
                            {
                                $$ = createNode("ClassBody");
                                $$->add_child($1);
                            }
                            | ClassBodyDeclarationList ClassBodyDeclaration
                            {
                                $$ = $1;
                                $$->add_child($2);
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

FieldDeclaration:   ModifierList UnannType  VariableDeclaratorList Semicolon
                    {
                        $$ = createNode("FieldDeclaration");
                        $$->add_children($1);
                        $$->add_child($2);
                        $$->add_child($3);
                        $$->add_child($4);
                    }
                    | UnannType VariableDeclaratorList Semicolon
                    {
                        $$ = createNode("FieldDeclaration");
                        $$->add_child($1);
                        $$->add_child($2);
                        $$->add_child($3);
                    }
                    ;

VariableDeclaratorList: VariableDeclarator
                        | VariableDeclaratorList Comma VariableDeclarator
                        {
                            if(strcmp($1->value, "Variables") == 0)
                            {
                                $$ = $1;
                                $$->add_child($3);
                            }
                            else
                            {
                                $$ = createNode("Variables");
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                        }
                        ;

VariableDeclarator: VariableDeclaratorId ASSIGN VariableInitializer
                    {
                        $$ = createNode("=");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | VariableDeclaratorId
                    ;

VariableDeclaratorId:   Identifier Dims
                        {
                            $$ = createNode("VariableDeclaratorId");
                            $$->add_child($1);
                            $$->add_child($2);

                            auto stEntry = new SymbolTableEntry($1->lexeme, "", -1, $2->numDims, $1->lineNumber, 0);
                            stEntryContainer.push_back(stEntry);
                        }
                        | Identifier
                        {
                            $$ = $1;

                            auto stEntry = new SymbolTableEntry($1->lexeme, "", -1, 0, $1->lineNumber, 0);
                            stEntryContainer.push_back(stEntry);
                        }
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

UnannClassType: TypeIdentifier TypeArguments
                {
                    $$ = createNode("UnnanClassType");
                    $$->add_child($1);
                    $$->add_child($2);

                    $$->type = $1->type;
                }
                | UnannClassOrInterfaceType Dot TypeIdentifier TypeArguments
                {
                    $$ = createNode(".");
                    $$->add_child($1);
                    Node* temp = createNode("UnannClassType");
                    temp->add_child($3);
                    temp->add_child($4);
                    $$->add_child(temp);

                    $$->type = $1->type + "." + $3->type;
                }
                | UnannClassOrInterfaceType Dot TypeIdentifier
                {
                    $$ = createNode(".");
                    $$->add_child($1);
                    $$->add_child($3);

                    $$->type = $1->type + "." + $3->type;
                }
                ;

UnannArrayType: UnannPrimitiveType Dims
                { 
                    $$ = createNode("UnannArrayType");
                    $$->add_child($1);
                    $$->add_child($2);

                    $$->type = $1->type;
                    $$->numDims = $2->numDims;
                }
                | UnannClassOrInterfaceType Dims
                {
                    $$ = createNode("UnannArrayType");
                    $$->add_child($1);
                    $$->add_child($2);

                    $$->type = $1->type;
                    $$->numDims = $2->numDims;
                }
                | TypeIdentifier Dims
                {
                    $$ = createNode("UnannArrayType");
                    $$->add_child($1);
                    $$->add_child($2);

                    $$->type = $1->type;
                    $$->numDims = $2->numDims;
                }
                ;

MethodDeclaration:  ModifierList MethodHeader MethodBody 
                    {
                        $$ = createNode("MethodDeclaration");
                        $$->add_children($1);
                        $$->add_child($2);
                        $$->add_child($3);

                        auto stEntry = new SymbolTableEntry($3->lexeme, "$func", -1, 0, $3->lineNumber, 0);
                        currSymTable->insert(stEntry);
                    }
                    |  MethodHeader MethodBody 
                    {
                        $$ = createNode("MethodDeclaration");
                        $$->add_child($1);
                        $$->add_child($2);

                        auto stEntry = new SymbolTableEntry($2->lexeme, "$func", -1, -1, $2->lineNumber, 0);
                        currSymTable->insert(stEntry);
                    }
                    ;

MethodHeader:   UnannType MethodDeclarator
                {
                    $$ = createNode("MethodHeader");
                    $$->add_child($1);
                    $$->add_child($2);

                    $$->lexeme = $2->lexeme;
                    $$->lineNumber = $2->lineNumber;
                }
                | VOID MethodDeclarator
                {
                    $$ = createNode("MethodHeader");
                    $$->add_child($1);
                    $$->add_child($2);

                    $$->lexeme = $2->lexeme;
                    $$->lineNumber = $2->lineNumber;
                }
                ;

MethodDeclarator:   Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = $1;
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_children($5);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis FormalParameterList RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_children($3);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($6);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($4);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_children($5);
                        $$->add_child($7);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis FormalParameterList RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_children($3);
                        $$->add_child($5);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    ;

ReceiverParameter:  UnannType THIS
                    {
                        $$ = createNode("ReceiverParameter");
                        $$->add_child($1);
                        $$->add_child($2);
                    }
                    | UnannType Identifier Dot THIS
                    {
                        $$ = createNode("ReceiverParameter");
                        $$->add_child($1);
                        Node *temp = createNode(".");
                        temp->add_child($2);
                        temp->add_child($4);
                        $$->add_child(temp);
                    }
                    ;

FormalParameterList:    FormalParameterList Comma FormalParameter
                        {
                            $$ = $1;
                            $$->add_child($3);
                        }
                        | FormalParameter
                        {
                            $$ = createNode("FormalParameterList");
                            $$->add_child($1);
                        }
                        ;

FormalParameter:    VariableModifierList UnannType VariableDeclaratorId
                    {
                        $$ = createNode("FormalParameter");
                        $$->add_children($1);
                        $$->add_child($2);
                        $$->add_child($3);

                        for(auto& stEntry: stEntryContainer)
                        {
                            assert(stEntry);
                            stEntry->setType($2->type);
                            currSymTable->insert(stEntry);
                        }
                        stEntryContainer.clear();
                    }
                    | UnannType VariableDeclaratorId {
                        $$ = createNode("FormalParameter");
                        $$->add_child($1);
                        $$->add_child($2);

                        for(auto& stEntry: stEntryContainer)
                        {
                            assert(stEntry);
                            stEntry->setType($2->type);
                            currSymTable->insert(stEntry);
                        }
                        stEntryContainer.clear();
                    }
                    | VariableArityParameter
                    ;

VariableArityParameter: UnannType ellipsis Identifier
                        {
                            $$ = createNode("VariableArityParameter");
                            $$->add_child($1);
                            $$->add_child($2);
                            $$->add_child($3);
                        }
                        | VariableModifierList UnannType ellipsis Identifier
                        ;

VariableModifierList:   VariableModifier
                        {
                            $$ = createNode("VariableModifierList");
                            $$->add_child($1);
                        }
                        | VariableModifierList VariableModifier
                        {
                            $$ = $1;
                            $$->add_child($2);
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
                        $$->add_child($1);
                        $$->add_child($2);
                    }
                    ;

ConstructorDeclaration: { startScope(); } ConstructorDeclarator ConstructorBody { endScope(); }
                        {
                            $$ = createNode("ConstructorDeclaration");
                            $$->add_child($2);
                            $$->add_child($3);

                            auto stEntry = new SymbolTableEntry($2->lexeme, "$func", -1, 0, $2->lineNumber, 0);
                            currSymTable->insert(stEntry);
                        }
                        | ModifierList { startScope(); } ConstructorDeclarator ConstructorBody { endScope(); }
                        {
                            $$ = createNode("ConstructorDeclaration");
                            $$->add_children($1);
                            $$->add_child($3);
                            $$->add_child($4);

                            auto stEntry = new SymbolTableEntry($3->lexeme, "$func", -1, 0, $3->lineNumber, 0);
                            currSymTable->insert(stEntry);
                        }
                        ;

ConstructorDeclarator:  SimpleTypeName LeftParenthesis RightParenthesis 
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child(createNode("()"));

                            $$->lexeme = $1->lexeme;
                            $$->lineNumber = $1->lineNumber;
                        }
                        | SimpleTypeName LeftParenthesis ReceiverParameter Comma RightParenthesis 
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child($1);
                            $$->add_child($3);

                            $$->lexeme = $1->lexeme;
                            $$->lineNumber = $1->lineNumber;
                        }
                        | SimpleTypeName LeftParenthesis FormalParameterList RightParenthesis
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child($1);
                            $$->add_children($3);

                            $$->lexeme = $1->lexeme;
                            $$->lineNumber = $1->lineNumber;
                        }
                        | SimpleTypeName LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis 
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child($1);
                            $$->add_child($3);
                            $$->add_children($5);

                            $$->lexeme = $1->lexeme;
                            $$->lineNumber = $1->lineNumber;
                        }
                        ;

SimpleTypeName: TypeIdentifier
                ;

ConstructorBody:    LeftCurlyBrace { startScope(); }  RightCurlyBrace { endScope(); }
                    {
                       $$ = createNode("{ }");
                    }
                    | LeftCurlyBrace { startScope(); } ExplicitConstructorInvocation RightCurlyBrace { endScope(); }
                    {
                        $$ = createNode("ConstructorBody");
                        $$->add_child($3);
                    }
                    | LeftCurlyBrace { startScope(); } BlockStatements RightCurlyBrace { endScope(); }
                    {
                        $$ = $3;
                    }
                    | LeftCurlyBrace { startScope(); } ExplicitConstructorInvocation BlockStatements RightCurlyBrace { endScope(); }
                    {
                        $$ = createNode("ConstructorBody");
                        $$->add_child($3);
                        $$->add_children($4);
                    }
                    ;

ExplicitConstructorInvocation:  THIS LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->add_child($1);
                                    $$->add_child(createNode("()"));
                                    $$->add_child($4);
                                }
                                | TypeArguments THIS LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp = createNode("GenericClassName");
                                    temp->add_child($1);
                                    temp->add_child($2);
                                    $$->add_child(temp);
                                    $$->add_child(createNode("()"));
                                    $$->add_child($5);                                  
                                }
                                | THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->add_child($1);
                                    $$->add_children($3);
                                    $$->add_child($5);
                                }
                                | TypeArguments THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp = createNode("GenericClassName");
                                    temp->add_child($1);
                                    temp->add_child($2);
                                    $$->add_child(temp);
                                    $$->add_children($4);
                                    $$->add_child($6);
                                }
                                | TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp = createNode("GenericClassName");
                                    temp->add_child($1);
                                    temp->add_child($2);
                                    $$->add_child(temp);
                                    $$->add_children($4);
                                    $$->add_child($6);
                                }
                                | SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->add_child($1);
                                    $$->add_child(createNode("()"));
                                    $$->add_child($4);
                                }
                                | SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $$->add_child($1);
                                    $$->add_children($3);
                                    $$->add_child($5);
                                }
                                | TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp = createNode("GenericClassName");
                                    temp->add_child($1);
                                    temp->add_child($2);
                                    $$->add_child(temp);
                                    $$->add_child($5);
                                }
                                | ExpressionName Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp1 = createNode(".");
                                    Node *temp2 = createNode("GenericClassName");
                                    temp2->add_child($3);
                                    temp2->add_child($4);
                                    temp1->add_child($1);
                                    temp1->add_child(temp2);
                                    $$->add_child(temp1);
                                    $$->add_children($6);
                                    $$->add_child($8);
                                }
                                | ExpressionName Dot TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2->add_child($1);
                                    $2->add_child($4);
                                    $$->add_child($2);
                                    $$->add_child($7);
                                }
                                | ExpressionName Dot SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($3);
                                    $$->add_child($2);
                                    $$->add_children($5);
                                    $$->add_child($7);
                                }
                                | ExpressionName Dot SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($3);
                                    $$->add_child($2);
                                    $$->add_child($6);
                                }
                                | Primary Dot  SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($3);
                                    $$->add_child($2);
                                    $$->add_child($6);
                                }
                                | Primary Dot TypeArguments SUPER LeftParenthesis RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($4);
                                    $$->add_child($2);
                                    $$->add_child($7);
                                }
                                | Primary Dot  SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($3);
                                    $$->add_child($2);
                                    $$->add_children($5);
                                    $$->add_child($7);
                                }
                                | Primary Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($4);
                                    $$->add_child($2);
                                    $$->add_children($6);
                                    $$->add_child($8);
                                }
                                ;

ArrayInitializer:   LeftCurlyBrace Comma RightCurlyBrace
                    {
                        $$ = createNode("ArrayInitializer");
                        $$->add_child($2);
                    }
                    | LeftCurlyBrace RightCurlyBrace
                    {
                        $$=createNode("ArrayInitializer");
                    }
                    | LeftCurlyBrace VariableInitializerList Comma RightCurlyBrace
                    {
                        $$=createNode("ArrayInitializer");
                        $$->add_child($2);
                        $$->add_child($3);
                    }
                    | LeftCurlyBrace VariableInitializerList RightCurlyBrace
                    {
                        $$=createNode("ArrayInitializer");
                        $$->add_child($2);
                    }
                    ;

VariableInitializerList:    VariableInitializer
                            {
                                $$ = createNode("VariableInitializerList");
                                $$->add_child($1);
                            }
                            | VariableInitializerList Comma VariableInitializer
                            {
                                $$ = $1;
                                $$->add_child($3);
                            }
                            ;

Block:  LeftCurlyBrace { startScope(); } BlockStatements RightCurlyBrace { endScope(); }
        {
            $$ = $3;
        }
        | LeftCurlyBrace { startScope(); } RightCurlyBrace { endScope(); }
        {
            $$ = createNode("Block");
        }
        ;

BlockStatements:    BlockStatements BlockStatement
                    {
                        $$ = $1;
                        $$->add_child($2);
                    }
                    | BlockStatement
                    {
                        $$ = createNode("Block");
                        $$->add_child($1);
                    }
                    ;

BlockStatement: LocalClassOrInterfaceDeclaration
                | LocalVariableDeclarationStatement
                | Statement
                ;
    
LocalClassOrInterfaceDeclaration:   ClassDeclaration
                                    ;

LocalVariableDeclarationStatement:  LocalVariableDeclaration Semicolon
                                    {
                                        $$ = $1;
                                        $$->add_child($2);
                                    }
                                    ;

LocalVariableDeclaration:   LocalVariableType VariableDeclaratorList
                            {
                                $$ = createNode("LocalVariableDeclaration");
                                $$->add_child($1);
                                $$->add_child($2);

                                for(auto& stEntry: stEntryContainer)
                                {
                                    assert(stEntry);
                                    stEntry->setType($1->type);
                                    currSymTable->insert(stEntry);
                                }
                                stEntryContainer.clear();
                            }
                            | VariableModifierList LocalVariableType VariableDeclaratorList
                            {
                                $$ = createNode("LocalVariableDeclaration");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_child($3);

                                for(auto& stEntry: stEntryContainer)
                                {
                                    assert(stEntry);
                                    stEntry->setType($1->type);
                                    currSymTable->insert(stEntry);
                                }
                                stEntryContainer.clear();
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
                        $$ = createNode("LabeledStatement");
                        $$->add_child($1);
                        $$->add_child($2);
                        $$->add_child($3);
                    }
                    ;

ExpressionStatement:    StatementExpression Semicolon
                        {
                            $$ = $1;
                            $$->add_child($2);
                        }
                        ;

StatementExpression:    Assignment
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
                        $1 = createNode("If");
                        $1->add_child($3);
                        $$->add_child($1);
                        Node *temp = createNode("Then");
                        temp->add_child($5);
                        $$->add_child(temp);
                    }
                    ;

IfThenElseStatement:    IF LeftParenthesis Expression RightParenthesis StatementNoShortIf ELSE Statement
                        {
                            $$ = createNode("IfThenElseStatement");
                            $1 = createNode("If");
                            $1->add_child($3);
                            $$->add_child($1);
                            Node *temp = createNode("Then");
                            temp->add_child($5);
                            $$->add_child(temp);
                            $6 = createNode("Else");
                            $6->add_child($7);
                            $$->add_child($6);
                        }
                        ;

IfThenElseStatementNoShortIf:   IF LeftParenthesis Expression RightParenthesis StatementNoShortIf ELSE StatementNoShortIf
                                {
                                    $$ = createNode("IfThenElseStatementNoShortIf");
                                    $1 = createNode("If");
                                    $1->add_child($3);
                                    $$->add_child($1);
                                    Node *temp = createNode("Then");
                                    temp->add_child($5);
                                    $$->add_child(temp);
                                    $6 = createNode("Else");
                                    $6->add_child($7);
                                    $$->add_child($6);
                                }
                                ;

AssertStatement:    ASSERT Expression Semicolon
                    {
                        $$ = createNode("Assert");
                        $$->add_child($2);
                        $$->add_child($3);
                    }
                    | ASSERT Expression COLON Expression Semicolon
                    {
                        $$ = createNode("Assert");
                        $$->add_child($2);
                        $$->add_child($4);
                        $$->add_child($5);
                    }
                    ;

WhileStatement: WHILE LeftParenthesis Expression RightParenthesis Statement
                {
                    $$ = createNode("While");
                    $$->add_child($3);
                    $$->add_child($5);
                }

WhileStatementNoShortIf:    WHILE LeftParenthesis Expression RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("While");
                                $$->add_child($3);
                                $$->add_child($5);
                            }
                            ;

ForStatement:   BasicForStatement
                | EnhancedForStatement
                ;

ForStatementNoShortIf:  BasicForStatementNoShortIf
                        | EnhancedForStatementNoShortIf
                        ;

BasicForStatement:  FOR { startScope(); } LeftParenthesis  Semicolon  Semicolon  RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($7);
                    }
                    | FOR { startScope(); } LeftParenthesis ForInit Semicolon  Semicolon  RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($8);
                    }
                    | FOR { startScope(); } LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($8);
                    }
                    | FOR { startScope(); } LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($7);
                        $$->add_child($9);
                    }
                    | FOR { startScope(); } LeftParenthesis  Semicolon Expression Semicolon  RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($8);
                    }
                    | FOR { startScope(); } LeftParenthesis ForInit Semicolon Expression Semicolon  RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($7);
                        $$->add_child($9);
                    }
                    | FOR { startScope(); } LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($3);
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($8);
                    }
                    | FOR { startScope(); } LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis Statement { endScope(); }
                    {
                        $$ = createNode("For");
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($6);
                        $$->add_child($7);
                        $$->add_child($8);
                        $$->add_child($10);
                    }
                    ;

BasicForStatementNoShortIf: FOR { startScope(); } LeftParenthesis  Semicolon  Semicolon RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($7);
                            }
                            | FOR { startScope(); } LeftParenthesis ForInit Semicolon  Semicolon RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($6);
                                $$->add_child($8);
                            }
                            | FOR { startScope(); } LeftParenthesis  Semicolon Expression Semicolon RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($6);
                                $$->add_child($8);

                            }
                            | FOR { startScope(); } LeftParenthesis ForInit Semicolon Expression Semicolon RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($6);
                                $$->add_child($9);

                            }
                            | FOR { startScope(); } LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($6);
                                $$->add_child($8);

                            }
                            | FOR { startScope(); } LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($6);
                                $$->add_child($7);
                                $$->add_child($9);

                            }
                            | FOR { startScope(); } LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($6);
                                $$->add_child($7);
                                $$->add_child($9);

                            }
                            | FOR { startScope(); } LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf { endScope(); }
                            {
                                $$ = createNode("For");
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($6);
                                $$->add_child($7);
                                $$->add_child($8);
                                $$->add_child($10);
  
                            }
                            ;

ForInit:    StatementExpressionList
            | LocalVariableDeclaration
            ;

ForUpdate:  StatementExpressionList
            ;

StatementExpressionList:    StatementExpression
                            {
                                $$ = createNode("StatementExpressionList");
                                $$->add_child($1);
                            }
                            | StatementExpressionList Comma StatementExpression
                            {
                                $$ = $1;
                                $$->add_child($3);
                            }
                            ;

EnhancedForStatement:   FOR { startScope(); } LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement { endScope(); }
                        {
                            $$ = createNode("For");
                            $$->add_child($4);
                            $$->add_child($6);
                            $$->add_child($8);
                        }
                        ;

EnhancedForStatementNoShortIf:  FOR { startScope(); } LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf { endScope(); }
                                {
                                    $$ = createNode("For");
                                    $$->add_child($4);
                                    $$->add_child($6);
                                    $$->add_child($8);
                                }
                                ;

BreakStatement: BREAK Identifier Semicolon 
                {
                    $$ = createNode("BREAK");
                    $$->add_child($2);
                    $$->add_child($3);

                }
                | BREAK Semicolon
                {
                    $$ = createNode("BREAK");
                    $$->add_child($2);
                }
                ;

YieldStatement: YIELD Expression Semicolon
                {
                    $$ = $1;
                    $$->add_child($2);
                }
                ;

ContinueStatement:  CONTINUE Semicolon 
                    {  
                        $$ = createNode("ContinueStatemnet");
                        $$->add_child($1);
                        $$->add_child($2);
                    }
                    | CONTINUE Identifier Semicolon
                    {
                        $$ = $1;
                        $$->add_child($2);
                        $$->add_child($3);
                    }
                    ;

ReturnStatement:    RETURN Semicolon
                    {  
                        $$ = createNode("ReturnStatement");
                        $$->add_child($1);
                        $$->add_child($2);
                    }
                    | RETURN Expression Semicolon
                    {
                        $$ = createNode("ReturnStatement");
                        $1->add_child($2);
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

Pattern:    TypePattern
            ;

TypePattern:    LocalVariableDeclaration
                ;

Primary:    PrimaryNoNewArray 
            | ArrayCreationExpression
            ;

PrimaryNoNewArray:  Literal
                    | ClassLiteral
                    | THIS
                    | TypeName Dot THIS
                    {
                        $2->add_child($1);
                        $2->add_child($3);
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
                    $$->add_child($1);
                    $$->add_child($2);
                    $$->add_child($3);
                }
                | NumericType  Dot CLASS {
                    $$ = createNode("ClassLiteral");
                    $$->add_child($1);
                    $$->add_child($2);
                    $$->add_child($3);
                }
                | BOOLEAN  Dot CLASS {
                    $$ = createNode("ClassLiteral");
                    $$->add_child($1);
                    $$->add_child($2);
                    $$->add_child($3);
                }
                | VOID Dot CLASS {
                    $$ = createNode("ClassLiteral");
                    $$->add_child($1);
                    $$->add_child($2);
                    $$->add_child($3);
                }
                | TypeName LeftRightSquareList Dot CLASS {
                    $$ = createNode("ClassLiteral");
                    $$->add_child($1);
                    $$->add_child($2);
                    $$->add_child($3);
                    $$->add_child($4);
                }
                | NumericType LeftRightSquareList Dot CLASS {
                    $$ = createNode("ClassLiteral");
                    $$->add_child($1);
                    $$->add_child($3);
                    $$->add_child($4);
                }
                | BOOLEAN LeftRightSquareList Dot CLASS {
                        $$ = createNode("ClassLiteral");
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($4);
                }
                ;

ClassInstanceCreationExpression:    UnqualifiedClassInstanceCreationExpression
                                    | ExpressionName Dot UnqualifiedClassInstanceCreationExpression
                                    {
                                        $$ = createNode("ClassInstanceCreationExpression");
                                        $2->add_child($1);
                                        $2->add_child($3);
                                        $$->add_child($2);
                                    }
                                    | Primary Dot UnqualifiedClassInstanceCreationExpression {
                                        $$ = createNode("ClassInstanceCreationExpression");
                                        $2->add_child($1);
                                        $2->add_child($3);
                                        $$->add_child($2);
                                    }
                                    ;

UnqualifiedClassInstanceCreationExpression: NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);


                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_child($3);
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_children($4);
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_child($3);
                                                $$->add_children($5);
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis ClassBody
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_child($5);
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis ClassBody
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_child($3);
                                                $$->add_child($6);
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_children($4);
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_child($3);
                                                $$->add_children($5);
                                                $$->add_child($7);
                                            }
                                            ;

ClassOrInterfaceTypeToInstantiate:  Identifier
                                    | ClassOrInterfaceTypeToInstantiate Dot Identifier
                                    {
                                        
                                        $2->add_child($1);
                                        $2->add_child($3);
                                        $$ = $2;
                                    }
                                    | ClassOrInterfaceTypeToInstantiate Dot Identifier TypeArgumentsOrDiamond
                                    {
                                        $2->add_child($1);
                                        $2->add_child($3);
                                        $$ = $2;
                                    }
                                    ;

TypeArgumentsOrDiamond: TypeArguments
                        ;

FieldAccess:    Primary Dot Identifier
                {
                    $2->add_child($1);
                    $2->add_child($3);
                    $$ = $2;
                }
                | SUPER Dot Identifier
                {
                    $2->add_child($1);
                    $2->add_child($3);
                    $$ = $2;
                }
                | TypeName Dot SUPER Dot Identifier
                {
                    $2->add_child($1);
                    $2->add_child($3);
                    $4->add_child($2);
                    $4->add_child($5);
                    $$ = $4;

                    $$->stEntries = $1->stEntries;

                }
                ;

ArrayAccess:    ExpressionName LeftSquareBracket Expression RightSquareBracket
                {
                    $$ = createNode("[ ]");
                    $$->add_child($1);
                    $$->add_child($3);
                }
                | PrimaryNoNewArray LeftSquareBracket Expression RightSquareBracket
                {
                    $$ = createNode("[ ]");
                    $$->add_child($1);
                    $$->add_child($3);
                }
                ;

MethodInvocation:   Identifier LeftParenthesis  RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $$->add_child($1);
                    }
                    | Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $$->add_child($1);
                        $$->add_children($3);
                    }
                    | TypeName Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);

                        $$->stEntries = $1->stEntries;

                    }
                    | TypeName Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);

                        $$->stEntries = $1->stEntries;
                    }
                    | TypeName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                        $$->add_children($5);

                        $$->stEntries = $1->stEntries;
                    }
                    | TypeName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_children($6);

                        $$->stEntries = $1->stEntries;
                    }
                    | ExpressionName Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);

                    }
                    | ExpressionName Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                    }
                    | ExpressionName Dot Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                        $$->add_children($5);
                    }
                    | ExpressionName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_children($6);
                    }
                    | Primary Dot Identifier LeftParenthesis RightParenthesis
                    {
                                            
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                    
                    }
                    | Primary Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                    }
                    | Primary Dot Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                        $$->add_children($5);
                    }
                    | Primary Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_children($6);
                    }
                    | SUPER Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                    }
                    | SUPER Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                    }
                    | SUPER Dot Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                        $$->add_children($5);
                    }
                    | SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_children($6);
                    }
                    | TypeName Dot SUPER Dot Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $4->add_child($2);
                        $4->add_child($5);
                        $$->add_child($4);

                        $$->stEntries = $1->stEntries;
                    }
                    | TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $4->add_child($2);
                        $4->add_child($6);
                        $$->add_child($4);

                        $$->stEntries = $1->stEntries;
                    }
                    | TypeName Dot SUPER Dot Identifier LeftParenthesis ArgumentList RightParenthesis 
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $4->add_child($2);
                        $4->add_child($5);
                        $$->add_child($4);
                        $$->add_children($7);

                        $$->stEntries = $1->stEntries;
                    }
                    | TypeName Dot SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($3);
                        $4->add_child($2);
                        $4->add_child($6);
                        $$->add_child($4);
                        $$->add_children($8);
                        
                        $$->stEntries = $1->stEntries;

                    }
                    ;

ArgumentList:   Expression
                {
                    $$ = createNode("Arguments");
                    $$->add_child($1);
                }
                | ArgumentList Comma Expression
                {
                    $$ = $1;
                    $$->add_child($3);
                }
                ;

MethodReference:    ExpressionName Scope Identifier
                    {
                        $$ = createNode("::");
                        $$->add_child($1);
                        $$->add_child($3);
                    }

                    | ExpressionName Scope TypeArguments Identifier
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($4);
                    }
                    | Primary Scope Identifier
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | Primary Scope TypeArguments
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                    }

                    | UnannReferenceType Scope Identifier
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | UnannReferenceType Scope TypeArguments Identifier
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($4);
                    }
                    
                    | SUPER Scope Identifier
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | SUPER Scope TypeArguments Identifier
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($4);
                    }
                    | TypeName Dot SUPER Scope Identifier
                    {
                        $$ = $4;
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                         $$->add_child($5);
                    }
                    | TypeName Dot SUPER Scope TypeArguments Identifier
                    {
                        $$ = $4;
                        $2->add_child($1);
                        $2->add_child($3);
                        $$->add_child($2);
                         $$->add_child($5);
                        $$->add_child($6);
                    }
                    | UnannClassType Scope NEW
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | UnannClassType Scope TypeArguments NEW
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($4);
                    }
                    | ArrayType Scope NEW
                    {
                        $$ = $2;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

ArrayCreationExpression:    NEW PrimitiveType DimExprs
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_children($3);

                            }
                            | NEW UnannClassOrInterfaceType DimExprs
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_children($3);
                            }
                            | NEW PrimitiveType DimExprs Dims
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_children($3);
                            }
                            | NEW UnannClassOrInterfaceType DimExprs Dims
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_children($3);
                            }
                            ;

DimExprs:   DimExprList
            ;

DimExprList:    DimExpr{
                    $$ = createNode("DimExprs");
                    $$->add_child($1);
                }
                | DimExprList DimExpr {
                    $$= $1;
                    $$->add_child($2);
                }
                ;

DimExpr:    LeftSquareBracket Expression RightSquareBracket
            {
                $$=createNode("DimExpr");
                $$->add_child($2);
            }
            ;

Expression: AssignmentExpression
            ;

AssignmentExpression:   ConditionalExpression
                        | Assignment
                        ;

Assignment: LeftHandSide AssignmentOperator Expression
            {
                $$ = createNode($2->value);
                $$->add_child($1);
                $$->add_child($3);
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
                            $$->add_child($1);
                            $$->add_child($3);
                            $$->add_child($5);
                        }
                        ;

ConditionalOrExpression:    ConditionalAndExpression
                            | ConditionalOrExpression OR ConditionalAndExpression
                            {
                                $$ = createNode("||");
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            ;

ConditionalAndExpression:   InclusiveOrExpression
                            | ConditionalAndExpression AND InclusiveOrExpression
                            {
                                $$ = createNode("&&");
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            ;

InclusiveOrExpression:  ExclusiveOrExpression
                        | InclusiveOrExpression BITOR ExclusiveOrExpression
                        {
                            $$ = createNode("|");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        ;

ExclusiveOrExpression:  AndExpression
                        | ExclusiveOrExpression CARET AndExpression
                        {
                            $$ = createNode("^");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        ;

AndExpression:  EqualityExpression
                | AndExpression BITAND EqualityExpression
                {
                    $$ = createNode("&");
                    $$->add_child($1);
                    $$->add_child($3);
                }
                ;

EqualityExpression: RelationalExpression
                    | EqualityExpression EQUAL RelationalExpression
                    {
                        $$ = createNode("==");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | EqualityExpression NOTEQUAL RelationalExpression
                    {
                        $$ = createNode("!=");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

RelationalExpression:   ShiftExpression
                        | RelationalExpression LT ShiftExpression
                        {
                            $$ = createNode("<");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression GT ShiftExpression
                        {
                            $$ = createNode(">");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression LE ShiftExpression
                        {
                            $$ = createNode("<=");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression GE ShiftExpression
                        {
                            $$ = createNode(">=");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | InstanceofExpression
                        ;

InstanceofExpression:   RelationalExpression INSTANCEOF UnannReferenceType
                        {
                            $$ = createNode("instanceof");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression INSTANCEOF Pattern
                        {
                            $$ = createNode("instanceof");
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        ;

ShiftExpression:    AdditiveExpression
                    | ShiftExpression LSHIFT AdditiveExpression
                    {
                        $$ = createNode("<<");
                        $$->add_child($1); 
                        $$->add_child($3);
                    }
                    | ShiftExpression RSHIFT AdditiveExpression
                    {
                        $$ = createNode(">>");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | ShiftExpression URSHIFT AdditiveExpression
                    {
                        $$ = createNode(">>>");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

AdditiveExpression: MultiplicativeExpression
                    | AdditiveExpression ADD MultiplicativeExpression
                    {
                        $$ = createNode("+");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | AdditiveExpression SUB MultiplicativeExpression
                    {
                        $$ = createNode("-");
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

MultiplicativeExpression:   UnaryExpression
                            | MultiplicativeExpression MUL UnaryExpression
                            {
                                $$ = createNode("*");
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            | MultiplicativeExpression DIV UnaryExpression
                            {
                                $$ = createNode("/");
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            | MultiplicativeExpression MOD UnaryExpression
                            {
                                $$ = createNode("%");
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            ;

UnaryExpression:    PreIncrementExpression
                    | PreDecrementExpression
                    | ADD UnaryExpression
                    {
                        $1->add_child($2);
                        $$ = $1;
                    }
                    | SUB UnaryExpression
                    {
                        $1->add_child($2);
                        $$ = $1;
                    }
                    | UnaryExpressionNotPlusMinus
                    ;

PreIncrementExpression: INC UnaryExpression
                        {
                            $$ = createNode("PreIncrementExpression");
                            $$->add_child($1);
                            $$->add_child($2);
                        }
                        ;

PreDecrementExpression: DEC UnaryExpression
                        {
                            $$ = createNode("PreDecrementExpression");
                            $$->add_child($1);
                            $$->add_child($2);
                        }
                        ;

UnaryExpressionNotPlusMinus:    PostfixExpression
                                | TILDE UnaryExpression
                                {
                                    $1->add_child($2);
                                    $$ = $1;
                                }
                                | EXCLAMATION UnaryExpression
                                {
                                    $1->add_child($2);
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
                                $$->add_child($1);
                                $$->add_child($2);
                            }
                            ;

PostDecrementExpression:    PostfixExpression DEC
                            {
                                $$ = createNode("PostDecrementExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                            }
                            ;

CastExpression: LeftParenthesis PrimitiveType RightParenthesis UnaryExpression
                {
                    $$ = createNode("CastExpression");
                    $$->add_child($2);
                    $$->add_child($4);
                }
                | LeftParenthesis UnannReferenceType  RightParenthesis UnaryExpressionNotPlusMinus
                {
                    $$ = createNode("CastExpression");
                    $$->add_child($2);
                    $$->add_child($4);
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
        {
            $$ = createNode("[ ]");

            $$->numDims = 1;
        }
        | Dims LeftSquareBracket RightSquareBracket 
        {
            if(strcmp($1->value, "Dims") == 0)
            {
                $$ = $1;
                $$->add_child(createNode("[ ]"));

                $$->numDims = $1->numDims + 1;
            }
            else
            {
                $$ = createNode("Dims");
                $$->add_child($1);
                $$->add_child(createNode("[ ]"));

                $$->numDims = $1->numDims + 1;
                assert($$->numDims == 2);
            }
        }
        ;

LeftRightSquareList:    LeftSquareBracket RightSquareBracket
                        | LeftRightSquareList LeftSquareBracket RightSquareBracket
                        ;

TypeBound:  EXTENDS UnannClassOrInterfaceType
            {
                $$ = createNode("TypeBound");
                $$->add_child($1);
                $$->add_child($2);
            }
            ;

TypeArguments:  LT TypeArgumentList GT {
                    $$ = createNode("TypeArguments");
                    $$->add_child($1);
                    $$->add_children($2);
                    $$->add_child($3);
                }
                ;

TypeArgumentList:   TypeArgumentList Comma TypeArgument
                    {
                        $$ = $1;
                        $$->add_child($3);
                    }
                    | TypeArgument {
                        $$ = createNode("TypeArgumentList");
                        $$->add_child($1);
                    }
                    ;

TypeArgument:   UnannReferenceType
                | Wildcard
                ;

Wildcard:   QUESTIONMARK
            | QUESTIONMARK WildcardBounds {
                $$=createNode("Wildcard");
                $$->add_child($1);
                $$->add_child($2);


            }
            ;

WildcardBounds: EXTENDS UnannReferenceType
                {
                    $$=createNode("WildcardBounds");
                    $$->add_child($1);
                    $$->add_child($2);
                }
                | SUPER UnannReferenceType
                {
                    $$=createNode("WildcardBounds");;
                    $$->add_child($1);
                    $$->add_child($2);
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
                    $$->add_child($1);
                    $$->add_child($3);
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
