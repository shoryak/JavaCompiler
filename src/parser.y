
%{
#include <vector>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cassert>
#include <algorithm>
#include "symbol_table.h"
 #include "codegen.h"
#include "3ac.h"
int lines = 0;
int yyparse();
extern "C"
{        
    extern int linenum;
    int yylex(void);
    int yyerror(const char* s)
    {  
        if(s[0] == 's' && s[1] == 'y'){
              fprintf(stderr, "ERROR: %s  in  line Number %d \n\n", s, linenum);
        }
        else{
        fprintf(stderr, "ERROR: %s \n\n", s);
        }
        exit(1);
        
        return 1;
    }
}
extern FILE *yyin;
extern FILE *yyout;
extern int linenum;


struct field
{
    std::string name;
    std::string type;
    int numDims;
    std::string modifier;
    int offset;
};

SymbolTable *globalSymTable = new SymbolTable;
SymbolTable *currSymTable = globalSymTable;
std::vector<SymbolTableEntry*> stEntryContainer;
int useCurlyForNewScope  = 1;
std::vector<int> curlyScopes;
int labelCounter = 0;
std::string currentClass, currentFuncName ; 
int localOffset, fieldOffset;
std::unordered_map<std::string, SymbolTable*> methodSymbolTable;
std::map<std::string , std::set<std::string > > methodsForClass;
std::map<std::string , std::set<std::string>  > fieldsForClass;
std::map<std::string , field > classFieldData;
std::vector<quad> tacCode;

struct Node
{
/*  Attributes needed for AST generation    */
    char* value;
    std::vector<Node*> children;
    Node* parent;
    int isId;

/*  this stores the expression type for applying appropriate type checking 
    0 -> operator , 1 -> assignment , 2 -> methods , 3 -> classes */
    int exprType = -1;

/*  If the node is the root of some subtree of an expression in the AST
    typeForExpr will store the type of it's subexpression and
    dimsTypeForExpr will storeit's the number of dimensions */
    std::string typeForExpr = "";
    int dimsTypeForExpr = -1;

/*  Attributes needed for semantic analysis.
    All are attributes of the identifier located 
    in the particular non-terminal (e.g. statement) */
    SymbolTable *symTable = nullptr;

/* stores the pointer to the nearest scope symbol table */
    SymbolTable *nearSymbolTable = nullptr;

/*  For a list-type non-terminal (of some individual non-terminal
    which can have a scope) we need to add all entries to the
    list-type non-term's symbol table. So we store the individual
    non-term's entries here   */
    std::vector<SymbolTableEntry*> stEntries;

/*  If we want to carry up the lexeme so that the required symbol table
    entry can be created properly   */
    std::string lexeme = "";

/* field for maintaining original name of the node */
    std::string namelexeme = "";

/*  For non-terminals which contain expressions/variables of a particular type  */
    std::string type = "";

/*  Number of dimensions, only applicable for the Dims non-terminal */
    int numDims = 0;

/*  This will store the line number of the token found during the lexer phase.
    Applicable only for tokens/non-terminals    */
    int lineNumber = -1;

/*  For 3AC generation  */
    qid position;
    vector<quad> code;

/*  List of next instructions which can be jumped to    */
    std::vector<int> nextList;

/*  Store the temporary variable */
    qid node_tmp;    

/*  Constructors    */
    Node(char* value, std::vector<Node*> children)
    : value{value}, children{children}, lineNumber{linenum} , isId{1} {}
    Node(char* value)
    : value{value}, children{std::vector<Node*>()}, lineNumber{linenum} , isId{1} {}
    Node(char* value, std::string lexeme, std::string type)
    : value{value}, lexeme{lexeme}, type{type}, lineNumber{linenum} , namelexeme{lexeme} , typeForExpr{type} , isId{1}  {}

/*  Add a node as a child   */
    void add_child(Node* nd)
    {
        children.push_back(nd);
        nd->parent = this;
    }

/*  Add all children of another node as children    */
    void add_children(Node* nd)
    {
        for(auto& child: nd->children)
        {
            children.push_back(child);
            child->parent = this;
        }
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
        // assert(symTable);
        // for(auto stEntry: stEntries)
        // {
        //     assert(stEntry);
        //     symTable->insert(stEntry->getName(), stEntry);
        // }
    }
};

Node* root;

Node* createNode(const char* value, std::vector<Node*> children)
{
    return new Node(strdup(value), children);
}

Node* createNode(const char* value)
{
    return new Node(strdup(value) , std::string(value) , "");
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

void SymTableCSVDump()
{
    for(auto [file, symTable]: methodSymbolTable)
    {
        std::ofstream ofs;
        ofs.open(file + ".csv");
        symTable->csvDump(ofs);
        ofs.close();
    }
}

void setSymTables(Node* node){
    if(node == NULL) return;
    if(node->symTable == NULL){
        Node* temp = node;
        while(temp!= NULL && temp->symTable== NULL)
        {
            temp = temp->parent;
        }
        if(temp!= NULL)
        {
            node->symTable = temp->symTable;
        }
    }
    int n = node->children.size();
    std::vector<Node*> children = node->children;
    for(int i = 0; i < n; i++)
    {
        setSymTables(children[i]);
    }
}

void setSymTables2(Node* node , SymbolTable* currSymbolTable){
    if(node == NULL) return;
    if(node->symTable == NULL){
        node->nearSymbolTable = currSymbolTable;
    }
    else{
        node->nearSymbolTable = node->symTable;
        currSymbolTable = node->symTable;
    }
    int n = node->children.size();
    std::vector<Node*> children = node->children;
    for(int i = 0; i < n; i++)
    {
        setSymTables2(children[i], currSymbolTable);
    }
}

int setOffset(std::string type){
    // std:cerr<<"Type "<<type<<"\n";
    if(type=="int") return 4;
    else if(type=="short") return 2;
    else if(type=="char"){
        return 2;
    }
    else if(type=="long") return 8;
    else if(type=="float") return 4;
    else if(type=="double") return 8;
    else if(type=="boolean") return 1; // specialcase
    else if(type == "void"){
        return 0;
    }
    else {
        return 8;
    }
    
    
}

template<typename T>
bool presentInList(const std::vector<T> list, T element)
{
    return std::find(list.begin(), list.end(), element) != list.end();
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
void typecheck(Node *node);

int setTypeCheckType(std::string type)
{
    // 0->char , 1-> numerical , 2-> boolean , 3->String , 4-> null , 5 -> other
    if(type=="int" || type== "float" || type=="short" || type == "long" || type == "double")
        return 1;
    else if(type == "char") return 1; // char and numerical type are compatible 
    else if(type == "String") return 3;
    else if(type == "boolean") return 2;
    else if (type == "null") return 4;
    else return 5;
}

int setTypeCheckType1(std::string type)
{
    // if(type=="byte" || type=="short" || type=="char" || type=="int" || type=="long" || type == "float" || type == "double"){
    //     return 0;
    // }
    if(type=="short" || type=="char") return 2;
    // else if(type=="char"){
    //     return 3;
    // }
    else if(type=="int") return 3;
    else if(type=="long") return 4;
    else if(type=="float") return 5;
    else if(type=="double") return 6;
    else if(type=="boolean") return 7;
    else {
        return 8;
    }
}

void declarationTypeCheck(Node* node){
    if(node->children.size()==0 && node->value[0] == 'I' && node->value[1]=='d' && node->parent->parent->namelexeme != "." &&  node->parent->parent->namelexeme != "VariableDeclaratorId" && node->parent->parent->namelexeme!= "UnqualifiedClassInstanceCreationExpression" && node->parent->parent->namelexeme != "MethodInvocation" && node->parent->parent->namelexeme != "MethodDeclarator" )
    {
        auto stEntry = currSymTable->lookup(node->namelexeme);
        if(!stEntry){
             std::string err = "Undeclared Variable " + node->namelexeme +" on line " + std::to_string(node->lineNumber);
            yyerror(err.c_str()); 
        }
    }
    for(auto child : node->children)
    {
        if(node->namelexeme == "." && child->namelexeme == "." ) continue;
        declarationTypeCheck(child);
    }
}


void methodTypeCheck(Node* node)
{
    
    // iterating over children to find methodInvocation if exist
    for(int i = 0; i < node->children.size(); i++)
    {
        methodTypeCheck(node->children[i]);
    }

    if(node->namelexeme == "MethodInvocation"){
        int nArgs = 0;
        std::string methodName;
        std::vector<std::string> args; 
        if(node->children[0]->namelexeme ==  "Identifier")
        {
            methodName = node->children[0]->children[0]->namelexeme;
        }

        if(node->children[0]->namelexeme == ".")
        {
            Node* dot = node->children[0];
            methodName = node->children[0]->children[1]->children[0]->namelexeme;
            if(node->children[0]->children[0]->namelexeme == "."){
                if(dot->children[1]->children[0]->namelexeme == "println" ||dot->children[1]->children[0]->namelexeme == "print"  && dot->children[0]->children[1]->children[0]->namelexeme == "out" && dot->children[0]->children[0]->children[0]->namelexeme == "System"){
                    
                }
                else{
                    // error chain of invocations 
                    std::string s = "Chain of calls in line number " + std::to_string(node->children[0]->children[1]->children[0]->lineNumber);
                    yyerror(s.c_str());
                }
               
            }
            else{
                
                auto obj = node->children[0]->children[0]->children[0]->namelexeme;
                auto stEntry = node->nearSymbolTable->lookup(obj);
                if(!stEntry){
                    std::string s = "Undeclared Object " + obj+ " in line number " + std::to_string(node->children[0]->children[0]->children[0]->lineNumber);
                    yyerror(s.c_str());
                }
                else{
                    auto className = node->nearSymbolTable->lookup(obj)->getType();
                    // std::cerr<<className<<"a\n";
                    // std::cerr<<methodName<<"a\n";
                    node->typeForExpr = className;
                    if(methodsForClass[className].find(methodName) == methodsForClass[className].end()){
                        std::string s = "Undeclared function for class " + className + " in line number " + std::to_string(node->lineNumber);
                        yyerror(s.c_str());
                    }
                }
            }
        }
        
        else if (methodName == "println" || methodName == "print" ){
            return;
        }
        else{
        for(auto child : node->children)
        {
            if(child->namelexeme == "Arguments")
            {
                nArgs = child->children.size();
                for(auto arg : child->children)
                {
                    Node* leaf = arg;
                    while(leaf->children.size())
                        leaf = leaf->children[0];
                    
                    // std::cerr<<leaf->namelexeme<<"\n";
                    if(leaf->value[0] == 'I' && leaf->value[1] == 'd' ){
                        auto entry  = node->nearSymbolTable->lookup(leaf->namelexeme);
                        args.push_back(entry->getType());
                        
                        // methodName += "_" + entry->getType() + "_" + std::to_string(entry->getDimension());
                    }
        
                    else if(leaf->value[0] == 'L' && leaf->value[1] == 'i' ){
                        // methodName += "_" + leaf->type + "_" + std::to_string(leaf->numDims);
                        args.push_back(leaf->type);
                        // std::cerr<<leaf->value[0]<<" "<< leaf->value[1]<<" "<<leaf->namelexeme <<"\n";
                    }
                }
            }
        }
        // std::cerr<<methodName<<" Methodname\n";
        SymbolTable* ST = node->nearSymbolTable;
        
        SymbolTableEntry* stEntry = ST->lookup(methodName);
        
       
        // std::cerr<<stEntry->getName()<<"\n";
        // node->nearSymbolTable->print();
        stEntry->print();
        if(stEntry)
        {
            
            funcproto fp = stEntry->getFuncProto();
            if(node->children[0]->namelexeme!= "."){
                node->typeForExpr = fp.returnType;
            }
            if(nArgs !=  fp.numArgs)
            {
                // std::cerr<<nArgs<<" "<<fp.numArgs<<"\n"; 
            //    std::string err = "Incorrect number of Arguments in " + methodName +" Invoked on line " + std::to_string(node->lineNumber);
            //     yyerror(err.c_str()); 
            }
            else
            {
                int indArg=0;
                std::vector<std::string > types;
                for(int i=0;i<args.size(); i++){
                    auto argEntry = node->nearSymbolTable->lookup(args[i]);
                    if(argEntry == nullptr){
                        // error
                    }
                    else{
                        types.push_back(argEntry->getType());
                    }
                }
                for(int i =0; i<args.size();i++){
                    
                    if(setTypeCheckType1( args[i] ) > setTypeCheckType1 (fp.argTypes[i])){
                        std::string s = "Incorrrect Type in argument in line  " + std::to_string(node->lineNumber);
                        yyerror(s.c_str()); 
                    }
                }
            }
        }
        else
        {
            std::string err = "Undeclared function " + methodName +" Invoked on line " + std::to_string(node->lineNumber);
            yyerror(err.c_str());
        }
        // std::cerr<<methodName<<" "<<node->typeForExpr<<"\n";
        }
    }
    

}


void createST(Node* node)
{
    // setting nearest scope symbol table for the node for typechecking 
    node->nearSymbolTable = currSymTable;

    int newScope = 0;
    std::string nodeName = node->namelexeme;

    if(nodeName == "{")
    {
        if(useCurlyForNewScope)
        {
            startScope();
            curlyScopes.push_back(1);
        }
        else
        {
            useCurlyForNewScope=1;
            curlyScopes.push_back(0);
        }
        
    }

    else if(nodeName == "}")
    {
        if(curlyScopes.back()) endScope();
        curlyScopes.pop_back();
    }

    else if(nodeName == "class")
    {
        fieldOffset = 0;
        int n = node->children.size();
        std::vector<Node*> children = node->children;
        std::string name;
        assert(n >= 2);
        if(node->children[0]->namelexeme == "ModifierList")
        {
            for(auto y: node->children[0]->children)
            {
                if(name != "") name += " ";
                name += y->namelexeme;
            }
        }
        if(name != "") name += " ";
        name += children[n-2]->namelexeme;
        currentClass = children[n-2]->namelexeme;
        auto alreadDeclared = currSymTable->lookup(children[n-2]->namelexeme);
        if(alreadDeclared)
        {
            std::string s = "Redeclaration of class in line number " + std::to_string(node->children[n-2]->lineNumber);
            yyerror(s.c_str());
        }
        SymbolTableEntry* stEntry = new SymbolTableEntry( name, "class" , -1 , -1 , node->children[n-2]->lineNumber , 0 );
        currSymTable->insert(stEntry);

        // 3AC 
        node->position = qid(nodeName, stEntry);
        node->nextList.clear();
        currentClass = children[n-2]->namelexeme;
    }

    else if(nodeName == "MethodDeclaration")
    {
        int decLine = 0;
        localOffset  = 0;
        std::vector<Node*> children = node->children;
        std::string name = "";        //modifiers_returntype_functionname
        struct funcproto fproto;
        fproto.returnDim = 0;
        std::string type;
        for(auto x: children)
        {
            if(x->namelexeme == "ModifierList")
            {
                for(auto y: x->children)
                {
                    if(name!="")name+=" "+ std::string(y->namelexeme);
                    else  name+=std::string(y->namelexeme);
                }
            }
            else if(x->namelexeme == "MethodHeader")
            {   
                // std::cerr<<"MethodHeader"<<" "<<std::string(x->children[0]->namelexeme)<<"\n";
                if(name != "") name += " ";                
                name += std::string(x->children[0]->namelexeme);

                decLine = (x->children[0]->lineNumber);
                fproto.returnType = x->children[0]->namelexeme;
                name += " " + std::string(x->children[1]->children[0]->children[0]->namelexeme);
                methodsForClass[currentClass].insert(x->children[1]->children[0]->children[0]->namelexeme);
                for(auto y: x->children)
                {
                    if(y->namelexeme == "MethodDeclarator")
                    {
                        Node* temp = nullptr;
                        currentFuncName = y->children[0]->children[0]->namelexeme;
                        for(auto k : y->children)
                        {
                            if(k->namelexeme == "FormalParameterList")
                            {
                                temp = k;
                                break;
                            }
                        }
                        if(temp == nullptr) break;
                        for(auto z: temp->children)
                        {
                            std::string nameParam;
                            std::string typeParam;
                            int nDimsParam = 0;
                            for(auto x: z->children)
                            {
                                if(x->namelexeme == "final")
                                    nameParam += x->namelexeme;
                                else if(x->namelexeme == "VariableDeclaratorId")
                                {
                                    for(auto child: x->children)
                                    {
                                        if(child->namelexeme == "Identifier")
                                        {
                                            if(name != "") name += " ";
                                            nameParam += child->children[0]->namelexeme;
                                        }
                                        if(child->namelexeme == "[ ]")
                                            nDimsParam++;
                                    }
                                }
                                else
                                {
                                    if(x->namelexeme == "UnannArrayType")
                                    {
                                        typeParam  = x->children[0]->namelexeme;
                                        type += "_" + x->children[0]->namelexeme;
                                        nDimsParam += x->children.size()-1;
                                        type += "_" + std::to_string(nDimsParam);
                                    }
                                    else {
                                        
                                        typeParam +=  x->namelexeme;
                                        type += "_" + x->namelexeme;
                                        type += "_" + std::to_string(nDimsParam);
                                    }
                                }
                            }
                            fproto.numArgs++;
                          
                            fproto.argTypes.push_back(typeParam);
                            fproto.argDims.push_back(nDimsParam);
                        }
                    }
                    if(y->namelexeme == "UnannArrayType"){
                        fproto.returnDim = y->children[1]->children.size();
        
                    }
                }
            }
        }
        while(name.size() && name.back()==' '){
            name.pop_back();
        }
        if(currSymTable->lookup(name+type)){
            // std::cerr<<name+type<<"\n";
            yyerror("Redeclaration of function");
              
            // error;
        }
        // std::cerr<<"sizeofLocals "<<name<<" "<<localOffset<<" "<< fproto.argTypes.size()<<"\n";
        SymbolTableEntry* stEntry = new SymbolTableEntry(name, fproto.returnType, -1, -1, decLine, 0, fproto , localOffset);
        node->lineNumber = decLine;
        currSymTable->insert(stEntry);
        // std::cerr<<currentClass<<"a\n";
        // std::cerr<<currentFuncName<<"a\n";
        methodsForClass[currentClass].insert(currentFuncName);
        newScope = 1;
        useCurlyForNewScope = 0;

        // methodSymbolTable[currentClass + "." + currentFuncName] = node->nearSymbolTable;

        // 3AC
        node->position = qid(nodeName, stEntry);
        node->nextList.clear();
    }

    else if(nodeName == "FormalParameter" )
    {
        std::vector<Node*> children = node->children;
        std::string name = "";
        std::string type = "";
        int nDims = -0;
        int decLine = -1;
        for(auto x: children)
        {
            if(x->namelexeme == "final")
            {
                name+= x->namelexeme;
            }
            else if(x->namelexeme == "VariableDeclaratorId")
            {
                for(auto y: x->children)
                {
                   if(y->namelexeme == "Identifier")
                   {
                       if(name!="") name+= " ";
                       name+= y->children[0]->namelexeme;
                       decLine = y->children[0]->lineNumber;
                   }
                   if(y->namelexeme == "[ ]")
                   {
                       nDims++;
                   }
                }
            }
            else
            {
                if(x->namelexeme == "UnannArrayType")
                {
                    type  = x->children[0]->namelexeme;
                    nDims += x->children.size()-1;
                }
                else type += x->namelexeme;
            }
        }
        SymbolTableEntry* stEntry = new SymbolTableEntry(name , type , -1 , nDims , decLine , 0 );
        currSymTable->insert(stEntry);

        // 3AC
        node->position = qid(nodeName, stEntry);
        node->nextList.clear();
    }

    else if(nodeName == "FieldDeclaration")
    {
        std::vector<Node*> children = node->children;
        std::string name = "";
        std::string type = "";
        int oldfieldOffset = fieldOffset;
        std::string modifier = "private";
        int nDimsType = 0;
        int decLine =- 1;
        Node* list = nullptr;
        for(auto x: children)
        {
            if(x->namelexeme == "ModifierList")
            {
                std::vector<std::string> modifierList;
                for(auto modifierNode: x->children)
                {
                    std::string modifier = modifierNode->namelexeme;
                    if(std::find(modifierList.begin(), modifierList.end(), modifier) != modifierList.end())
                        yyerror((std::string("Repeated modifier: ") + modifier + std::string(" on line ") + std::to_string(modifierNode->lineNumber)).c_str());
                    modifierList.push_back(modifier);
                }
                if(presentInList<std::string>(modifierList, "public") && presentInList<std::string>(modifierList, "private"))
                {
                    std::string errorMessage = "Illegal combination of modifiers: public and private on line ";
                    errorMessage += std::to_string(x->children[0]->lineNumber);
                    yyerror(errorMessage.c_str());
                }
                if(presentInList<std::string>(modifierList, "public"))
                    modifier = "public";

                for(auto y: x->children)
                {
                    if(name != "") name += " " + std::string(y->namelexeme);
                    else name+=std::string(y->namelexeme);
                }
            }
            else if(x->namelexeme == "Variables")
            {
                list = x;
            }
            else if(x->namelexeme != ";")
            {
                if(x->namelexeme == "UnannArrayType")
                {
                    type += x->children[0]->namelexeme;
                    nDimsType = x->children[1]->children.size();
                }
                else type += x->namelexeme;
                std::string fieldType = type;
                if(nDimsType > 0) fieldType = "arr";
                fieldOffset += setOffset(fieldType);
            }
        }
        assert(list);
        for(auto y: list->children)
        {
            if(name != "") name += " ";
            if(y->namelexeme == "=")
            {
                declarationTypeCheck(y->children[1]);
                int nDims = nDimsType;
                for(auto child : y->children[0]->children){
                    if(child->namelexeme == "Dims"){
                        nDims += child->children.size();
                        break;
                    }
                }
                auto alreadDeclared = currSymTable->currentScopeLookup(y->children[0]->children[0]->children[0]->namelexeme);
                if(alreadDeclared)
                {
                    std::string s = "Redeclaration of " + y->children[0]->children[0]->children[0]->namelexeme + " in line number " + std::to_string(y->children[0]->children[0]->children[0]->lineNumber);
                    yyerror(s.c_str());
                }
                std::vector<std::string> axisWidths(nDims);
                SymbolTableEntry* stEntry = new SymbolTableEntry(name + y->children[0]->children[0]->children[0]->namelexeme, type, -1, nDims, y->children[0]->children[0]->children[0]->lineNumber, oldfieldOffset, axisWidths);
                std::string fieldData;
                field fieldStructData; 
                fieldData += y->children[0]->children[0]->children[0]->namelexeme;
                fieldStructData.name = y->children[0]->children[0]->children[0]->namelexeme;
                fieldStructData.type = type;
                fieldStructData.numDims = nDims;
                fieldStructData.modifier = modifier;
                fieldStructData.offset = oldfieldOffset;
                fieldsForClass[currentClass].insert(fieldData);
                classFieldData[currentClass +"_" + fieldData] = fieldStructData;
                // std::cerr << "Inserting: " << currentClass + "_" + fieldData << '\n';
                currSymTable->insert(stEntry);

                //3 AC
                y->position = qid(y->children[0]->children[0]->children[0]->namelexeme, stEntry);
                y->nextList.clear();
            }
            else
            {
                int nDims = nDimsType;
                for(auto child : y->children){
                    if(child->namelexeme == "Dims"){
                        nDims += child->children.size();
                        break;
                    }
                }
                auto alreadDeclared = currSymTable->currentScopeLookup(y->children[0]->children[0]->namelexeme);
                if(alreadDeclared)
                {
                    std::string s = "Redeclaration of " + y->children[0]->children[0]->namelexeme + " in line number " + std::to_string(y->children[0]->children[0]->lineNumber);
                    yyerror(s.c_str());
                }
                std::vector<std::string> axisWidths(nDims);
                SymbolTableEntry* stEntry = new SymbolTableEntry( name + y->children[0]->children[0]->namelexeme, type, -1, nDims, y->children[0]->children[0]->lineNumber, 0, axisWidths);
                std::string fieldData;
                field fieldStructData; 
                fieldData += y->children[0]->children[0]->namelexeme;
                fieldStructData.name = fieldData;
                fieldStructData.type = type;
                fieldStructData.numDims = nDims;
                fieldStructData.modifier = modifier;
                fieldStructData.offset = oldfieldOffset;
                fieldsForClass[currentClass].insert(fieldData);
                classFieldData[currentClass +"_" + fieldData] = fieldStructData;
                // std::cerr << "Inserting: " << currentClass + "_" + fieldData << '\n';
                currSymTable->insert(stEntry);
                //3 AC
                y->position = qid( y->children[0]->children[0]->namelexeme, stEntry);
            }
        }
    }

    else if(nodeName == "LocalVariableDeclaration")
    {
        std::string type;
        std::string name;
        int decLine = node->children[0]->lineNumber;
        int nDims = 0;
        Node* list = nullptr;
        std::vector<std::string> axisWidths;
        for(auto child: node->children)
        {
            if(child->namelexeme == "VariableModifier")
                name+=std::string(child->children[0]->namelexeme);
            else if(child->namelexeme == "Variables")
                list = child;
            else if(child->namelexeme != ";")
                type = child->namelexeme;
        }
        if(list)
        {
            for(auto y: list->children)
            {
                if(name != "") name += " ";
                if(y->namelexeme == "=")
                {
                    declarationTypeCheck(y->children[1]);
                    for(auto child : y->children[0]->children){
                        if(child->namelexeme == "Dims"){
                            nDims += child->children.size();
                        }
                    }
                    auto alreadyDeclared = currSymTable->currentScopeLookup(y->children[0]->children[0]->children[0]->namelexeme);
                    if(alreadyDeclared)
                    {
                        std::string s = "Redeclaration of " + y->children[0]->children[0]->children[0]->namelexeme + " in line number " + std::to_string(y->children[0]->children[0]->children[0]->lineNumber);
                        yyerror(s.c_str());
                    }
                    if(y->children[1]->namelexeme == "ArrayCreationExpression"){
                        Node* dimEx ;
                        for(auto child : y->children[1]->children){
                            if(child->namelexeme == "DimExprs"){
                                dimEx = child;
                            }
                        }
                        if(dimEx){
                            for(auto child : dimEx->children){
                                Node* leaf = child;
                                while(leaf->children.size()){
                                    leaf = leaf->children[0];
                                }
                                axisWidths.push_back(leaf->namelexeme);
                            }
                            

                        }
                    }
                    // Problematic to create symbol table entry here for cases like int x = x+1;
                    std::string typeForOffset = type;
                    if(nDims > 0){
                        typeForOffset = "pointer";
                    }
                    localOffset += setOffset(typeForOffset);
                    // std::cerr<<"Lexeme "<<y->children[0]->children[0]->children[0]->namelexeme<<"\n";
                    // std::cerr<<"localOffset "<<localOffset<<"\n";
                    SymbolTableEntry* stEntry = new SymbolTableEntry(name + y->children[0]->children[0]->children[0]->namelexeme, type, -1, nDims, y->children[0]->children[0]->children[0]->lineNumber, localOffset, axisWidths);
                    currSymTable->insert(stEntry);

                    //3 AC
                    y->position = qid(y->children[0]->children[0]->children[0]->namelexeme, stEntry);
                    y->nextList.clear();
                }
                else
                {   
                    for(auto child : y->children){
                        if(child->namelexeme == "Dims"){
                            nDims += child->children.size();
                        }
                    }
                    auto alreadDeclared = currSymTable->currentScopeLookup(y->children[0]->children[0]->namelexeme);
                    if(alreadDeclared)
                    {
                        std::string s = "Redeclaration of " + y->children[0]->children[0]->namelexeme + " in line number " + std::to_string(y->children[0]->children[0]->lineNumber);
                        yyerror(s.c_str());
                    }
                    
                    // code for calculating offset of local variable in function
                    std::string typeForOffset = type;
                    if(nDims > 0){
                        typeForOffset = "pointer";
                    }
                    localOffset += setOffset(typeForOffset);

                    // std::cerr<<"Lexeme "<<y->children[0]->children[0]->namelexeme<<"\n";
                    // std::cerr<<"localOffset "<<localOffset<<"\n";
                    SymbolTableEntry* stEntry = new SymbolTableEntry(name + y->children[0]->children[0]->namelexeme, type, -1, nDims, y->children[0]->children[0]->lineNumber, localOffset);
                    currSymTable->insert(stEntry);

                    //3 AC
                    y->position = qid(y->children[0]->children[0]->namelexeme, stEntry);
                    //y->tmp_node = newtemp( y->children[0]->children[0]->namelexeme, y->nearSymbolTable);
                    y->nextList.clear();
                }
            }
        }
    }
    
    else if(nodeName == "ConstructorDeclaration")
    {
        int n = node->children.size();
        std::vector<Node*> children = node->children;
        std::string name = "";
        std::string constructorEntry = "";
        std::string type = "";
        funcproto fproto;
        int nDims = 0;
        int decLine = -1;
        Node* list = nullptr;
        assert(n >= 2);
        for(auto x: children){
            if(x->namelexeme == "ModifierList"){
                for(auto y:x->children){
                    if(name!="")name+=" "+ std::string(y->namelexeme);
                    else  name+=std::string(y->namelexeme);
                }
            }
            else if(x->namelexeme == "ConstructorDeclarator"){
                if(name!="") name+=" ";
                name+=  std::string(x->children[0]->children[0]->namelexeme);
                constructorEntry += std::string(x->children[0]->children[0]->namelexeme);
                currentFuncName = x->children[0]->children[0]->namelexeme;
                decLine = (x->children[0]->children[0]->lineNumber);
                if(x->children.size() > 1 && x->children[1]->namelexeme == "FormalParameterList"){
                    auto temp = x->children[1];
                    for(auto z: temp->children)
                        {
                            std::string nameParam;
                            std::string typeParam;
                            int nDimsParam = 0;
                            for(auto x: z->children)
                            {
                                if(x->namelexeme == "final")
                                    nameParam += x->namelexeme;
                                else if(x->namelexeme == "VariableDeclaratorId")
                                {
                                    for(auto child: x->children)
                                    {
                                        if(child->namelexeme == "Identifier")
                                        {
                                            if(name != "") name += " ";
                                            nameParam += child->children[0]->namelexeme;
                                        }
                                        if(child->namelexeme == "[ ]")
                                            nDimsParam++;
                                    }
                                }
                                else
                                {
                                    if(x->namelexeme == "UnannArrayType")
                                    {
                                        typeParam  = x->children[0]->namelexeme;
                                        type += "_" + x->children[0]->namelexeme;
                                        nDimsParam += x->children.size()-1;
                                        type += "_" + std::to_string(nDimsParam);
                                    }
                                    else {
                                        
                                        typeParam +=  x->namelexeme;
                                        type += "_" + x->namelexeme;
                                        type += "_" + std::to_string(nDimsParam);
                                    }
                                }
                            }
                            fproto.numArgs++;
                            
                            fproto.argTypes.push_back(typeParam);
                            fproto.argDims.push_back(nDimsParam);
                }
            }
        }
        }
      while(name.size() && name.back()==' '){
            name.pop_back();
        }
       
        if(currSymTable->lookup(name+type) !=NULL){
            auto entry  = currSymTable->lookup(name+type);

            //  std::cerr<<name+type<<" "<< entry->getName()<< "\n";
            //   std::cerr<<name+type<<" "<< entry->getType()<< "\n";
            yyerror("Redeclaration of function");
           
            // error;
        }
        // std::cerr<<"XYZ "<<fproto.numArgs<<" "<<currentFuncName<<"\n";
        SymbolTableEntry* stEntry = new SymbolTableEntry(currentFuncName, currentClass, -1, -1, decLine, 0, fproto);
        currSymTable->insert(stEntry);

        //3 AC
        node->position = qid(nodeName, stEntry);
        node->nextList.clear();
        useCurlyForNewScope = 0;
        newScope=1;
    
    }

    else if(nodeName == "Identifier" && node->parent->namelexeme != "VariableDeclaratorId" && node->parent->namelexeme!= "UnqualifiedClassInstanceCreationExpression" && node->parent->namelexeme != "MethodInvocation" && node->parent->namelexeme != "MethodDeclarator" && node->parent->namelexeme!= "."){
        auto stEntry = currSymTable->lookup(node->children[0]->namelexeme);
        if(!stEntry){
             std::string err = "Undeclared Variable " + node->children[0]->namelexeme +" on line " + std::to_string(node->children[0]->lineNumber);
            yyerror(err.c_str());
        }
        else{
            node->typeForExpr = stEntry->getType();
            node->numDims = stEntry->getDimension();
        }
    }
    
    else if(nodeName == "VariableDeclaratorId"){
        for(auto child : node->children){
                        if(child->namelexeme == "Dims"){
                            node->numDims = child->children.size();
            }
        }
    }
    
    else if(nodeName == "ArrayCreationExpression"){
        node->typeForExpr = node->children[1]->lexeme;
        node->numDims = node->children[2]->children.size();
    }

    if(nodeName == "For")
    {
        newScope = 1;
        useCurlyForNewScope= 0;
    }

    if(newScope) {
        startScope();
        if(nodeName == "MethodDeclaration" || nodeName == "ConstructorDeclaration"){
        methodSymbolTable[currentClass + "." + currentFuncName] = currSymTable;
        }
    }

    int n = node->children.size();
    std::vector<Node*> children = node->children;

    for(int i = 0; i < n; i++) {
        // if(node->namelexeme == "." && children[i]->namelexeme == "." ) continue;
        createST(children[i]);
    }

    if(newScope)
    {
        endScope();
        newScope=0;
    }
    if(n == 0)
    {
        if(node->value[0] == 'I' && node->value[1] == 'd'){
            auto stEntry = currSymTable->lookup(node->namelexeme);
            // assert(stEntry);
            if(stEntry)
            {
                node->typeForExpr = stEntry->getType();
            }
        }
    }
    else if(n == 1)
    {
        // if only one child carry the type and number of dimensions
        node->typeForExpr = node->children[0]->typeForExpr;
        node->position = node->children[0]->position;
     
    }
    if(nodeName == "class") {
        methodTypeCheck(node);
        assert((int)node->children.size() >= 2);
        std::string className = node->children[(int)node->children.size() - 2]->namelexeme;
        auto classEntry = currSymTable->lookup(className);
        classEntry->setSize(fieldOffset); // fieldOffset is now the total class size
    }
    
    else if(nodeName == "=") {


        if(node->children[1]->namelexeme != "Ternary" && node->children[1]->typeForExpr != ""  ){
           
        typecheck(node);
        }
    }
    
    else if(nodeName == "+")
    {
        typecheck(node);
    }

    else if(nodeName == "*" || nodeName == "/" || nodeName == "%" || nodeName=="%=" || nodeName == "-"  || nodeName=="&" ||nodeName=="=" || nodeName=="^" || nodeName=="^="  || nodeName=="|" ||  nodeName=="|=" || nodeName=="+=" || nodeName=="-=" || nodeName=="*=" || nodeName=="/=" || nodeName=="&=" )
    {
        typecheck(node);
    }
    else if(nodeName == "<" || nodeName == ">" || nodeName == "<=" || nodeName == ">=" || nodeName== "==" || nodeName=="!=" || nodeName=="||" || nodeName=="&&" ){
        typecheck(node);
        node->typeForExpr = "boolean";
    }
    else if(nodeName == "<<" || nodeName == ">>" || nodeName == ">>>")
    {
        typecheck(node);
        node->typeForExpr = node->children[0]->typeForExpr;
    }

    else if(nodeName == "CastExpression")
    {
        typecheck(node);
        node->typeForExpr = node->children[0]->typeForExpr;
    }

    else if(nodeName=="PreDecrementExpression" || nodeName=="PreIncrementExpression"){
        typecheck(node);
        node->typeForExpr = node->children[1]->typeForExpr;
        
    }
    else if(nodeName=="PostDecrementExpression" || nodeName=="PostIncrementExpression"){
        typecheck(node);
        node->typeForExpr = node->children[0]->typeForExpr;
        
    }
    else if(nodeName == "VariableDeclaratorId"){
        node->typeForExpr = node->children[0]->typeForExpr;
    }
     else if(nodeName == "[ ]"){
        int nc = 0;
        Node* leaf = node;
        if(node->parent->namelexeme != "Dims"){
            while(leaf->children.size()){
                
                if(leaf->namelexeme == "."){
                    break;
                }
                nc++;
                   
                
                leaf = leaf->children[0];
                
            }
            if(leaf->namelexeme == "."){
                auto stEntry = leaf->children[0]->children[0]->nearSymbolTable->lookup(leaf->children[0]->children[0]->namelexeme);
                if(!stEntry){
                    std::string s = "Undeclared Object " +  leaf->children[0]->children[0]->namelexeme + " in line number " + std::to_string(node->lineNumber);
                    yyerror(s.c_str());
                }
                auto curClass = stEntry->getType();
                auto fieldName = leaf->children[1]->children[0]->namelexeme;
                if(fieldsForClass[curClass].find(fieldName) == fieldsForClass[curClass].end()){
                    std::string s = "Undeclared field for class " + curClass + " in line number " + std::to_string(node->lineNumber);
                    yyerror(s.c_str());
                }
                std::string cfield = curClass + "_" +fieldName;
                auto fData = classFieldData[cfield];
                node->typeForExpr = fData.type;
                node->numDims = fData.numDims - nc;
            }
            else{
                auto entry = leaf->nearSymbolTable->lookup(leaf->namelexeme);
                if(!entry){
                    std::string s = "Undeclared Object " +  leaf->namelexeme + " in line number " + std::to_string(node->lineNumber);
                    yyerror(s.c_str());
                }
                node->typeForExpr = entry->getType();
                node->numDims =  entry->getDimension() - nc + 1;
            }
        }
    }

    else if(nodeName == "ArrayInitializer")
    {
        node->numDims = node->children[0]->numDims;
        assert(((int)node->children.size()) >= 1);
        node->typeForExpr = node->children[0]->typeForExpr;
    
        // node->typeForExpr = node->children[1]->typeForExpr;
    }
    else if(nodeName == "VariableInitializerList")
    {
        // incomplete
        typecheck(node);
        node->numDims = node->children[0]->numDims + 1;
        node->typeForExpr = node->children[0]->typeForExpr;
    }
    
    else if(nodeName == "MethodDeclaration")
    {
        std::string funcName;
        for(auto methodDeclChildNode: node->children)
        {
            if(methodDeclChildNode->namelexeme == "MethodHeader")
                for(auto methodHeaderChildNode: methodDeclChildNode->children)
                {
                    if(methodHeaderChildNode->namelexeme == "MethodDeclarator")
                    {
                        funcName = methodHeaderChildNode->children[0]->children[0]->namelexeme;
                    }
                    
                }
        }
        auto funcEntry = currSymTable->lookup(funcName);
        assert(funcEntry);
        funcEntry->setSizeofLocals(localOffset);
    }

    else if(nodeName == "." && node->parent->namelexeme != "MethodInvocation")
    {
        auto leftFieldPrefixNode = node->children[0], rightFieldNode = node->children[1];
        std::string rightField = rightFieldNode->children[0]->namelexeme;
        std::string fieldClass = leftFieldPrefixNode->typeForExpr;
        std::string key = fieldClass + "_" + rightField;
        
        // std::cerr << key << '\n';
        if(classFieldData.find(key) == classFieldData.end() && fieldClass != "$package" )
        {
            // std::cerr<<key<<"\n";
            std::string errorMessage = std::string("Member ") + rightField + " of class " + fieldClass + " not found on line " + std::to_string(rightFieldNode->children[0]->lineNumber);
            yyerror(errorMessage.c_str());
        }
        field fieldStructData = classFieldData[key];
        // std::cerr << "Modifier: " << fieldStructData.modifier << '\n';
        if(fieldStructData.modifier == "private" && currentClass != fieldClass)
        {
            std::string errorMessage = rightField + " has private access in " + fieldClass + " in line " + std::to_string(rightFieldNode->lineNumber);
        }
        if(fieldClass == "$package") node->typeForExpr = "$package";
        else node->typeForExpr = fieldStructData.type;
    }

    else if(node->children.size() == 0 && node->value[0] == 'L' && node->value[1] == 'i'){
        node->typeForExpr = node->type;
    }
    else if(nodeName == "."){
        node->typeForExpr = node->children[1]->typeForExpr;
    }
    
    
    if(node->children.size() == 0 && node->value[0] == 'K'){
        if(node->namelexeme == "this"){
           
        node->typeForExpr = currentClass;
        }
    }
    
    
}

void codeInsert(Node* node, std::vector<quad> & code ){
    node->code.insert(node->code.end() , code.begin(), code.end());
    code.clear();
}

qid emptyQid("", NULL);
void unary3AC(Node* node, std::string op)
{
    node->node_tmp = newtemp(node->typeForExpr, node->nearSymbolTable);
    quad instruction = generate(qid(op, NULL), emptyQid, node->children[0]->node_tmp, node->node_tmp, -1);
    // codeInsert(node,node->code);
    node->code.push_back(instruction);
    // print3AC(node->code);
}

void binary3AC(Node* node, std::string op)
{
    if(node->children.size() <2){
        unary3AC(node, op);
        return;
    }
    codeInsert(node, node->children[0]->code);
    codeInsert(node, node->children[1]->code);
    // std::cerr<< node->namelexeme <<" "<< node->typeForExpr <<" "<< node->children[0]->typeForExpr << " "<< node->children[1]->typeForExpr << "\n";
    qid left = node->children[0]->node_tmp;
    qid right  = node->children[1]->node_tmp;
    bool flag = node->children[0]->typeForExpr != "";
    flag = flag && (node->children[1]->typeForExpr != "");
    flag = flag && (node->typeForExpr != "");
    int castChild = -1;
    std::string greaterType = node->children[0]->typeForExpr;
    if(node->children[0]->typeForExpr != node->children[1]->typeForExpr  && flag){
        
        if(setTypeCheckType1(node->children[0]->typeForExpr) > setTypeCheckType1(node->children[1]->typeForExpr) ){
            greaterType = node->children[0]->typeForExpr;
            castChild = 1;
        }
        else{
            greaterType = node->children[1]->typeForExpr;
            castChild = 0;
        }
        auto tempCastChild = newtemp(greaterType, node->nearSymbolTable);
        quad castInstruction = generate(qid("CAST_"+ greaterType, NULL), node->children[castChild]->node_tmp, emptyQid, tempCastChild, -1);
        node->code.push_back(castInstruction);
        if(castChild == 0){
            left = tempCastChild;
        }
        else{
            right = tempCastChild;
        }
    }
    node->node_tmp = newtemp(node->typeForExpr, node->nearSymbolTable);
    if(greaterType != node->typeForExpr && flag ){
        auto tempCastResult = newtemp(greaterType , node->nearSymbolTable);
        quad instruction = generate(qid(op, NULL), left, right, tempCastResult, -1);
        node->code.push_back(instruction);
        quad castInstruction = generate(qid("CAST_" + node->typeForExpr, NULL), tempCastResult, emptyQid, node->node_tmp, -1);
        node->code.push_back(castInstruction);
        
    }
    else{
        quad instruction = generate(qid(op, NULL), left, right, node->node_tmp, -1);
        node->code.push_back(instruction);
    }
    // print3AC(node->code);
}



void preOperation3AC(Node* node, std::string oper)
{
    Node *operandNode = node->children[1];
    qid tempVar = newtemp(operandNode->typeForExpr, node->nearSymbolTable);
    quad I1 = generate(qid(oper, NULL), operandNode->node_tmp, qid("1", NULL), tempVar, -1);
    quad I2 = generate(emptyQid, tempVar, emptyQid, operandNode->node_tmp, -1);
    node->node_tmp = operandNode->node_tmp;
    node->code.push_back(I1);
    node->code.push_back(I2);
}

void postOperation3AC(Node* node, std::string oper)
{
    Node *operandNode = node->children[0];
    qid tempVar0 = newtemp(operandNode->typeForExpr, node->nearSymbolTable);
    qid tempVar1 = newtemp(operandNode->typeForExpr, node->nearSymbolTable);
    quad I1 = generate(emptyQid, operandNode->node_tmp, emptyQid, tempVar0, -1);
    quad I2 = generate(qid(oper, NULL), operandNode->node_tmp, qid("1", NULL), tempVar1, -1);
    quad I3 = generate(emptyQid, tempVar1, emptyQid, operandNode->node_tmp, -1);
    node->node_tmp = tempVar0;
    node->code.push_back(I1);
    node->code.push_back(I2);
    node->code.push_back(I3);
}

bool presentInOpList(const std::vector<std::string>& operators, const std::string& oper)
{
    return std::find(operators.begin(), operators.end(), oper) != operators.end();
}



void three_AC(Node *node){
    std::string nodeName = node->namelexeme;
    // std::cerr<<nodeName<<"__START__ \n\n";

    std::vector<std::string> arithmeticOpsBinary{"+", "-", "*", "/", "%"};
    std::vector<std::string> arithmeticOpsUnary;
    std::vector<std::string> bitwiseOpsBinary{"&", "|", "^", "<<", ">>", ">>>"};
    std::vector<std::string> bitwiseOpsUnary{"~"};
    std::vector<std::string> logicalOpsBinary{"&&", "||"};
    std::vector<std::string> logicalOpsUnary{"!"};
    std::vector<std::string> relationalOpsBinary{"==", "!=", ">", "<", ">=", "<="};

    std::vector<std::string> opsBinary, opsUnary;
    std::vector<std::vector<std::string>> opsBinaryAll{arithmeticOpsBinary, bitwiseOpsBinary, logicalOpsBinary, relationalOpsBinary};
    std::vector<std::vector<std::string>> opsUnaryAll{arithmeticOpsUnary, bitwiseOpsUnary, logicalOpsUnary};
    std::vector<std::string> operAndAssign{"+=", "-=", "*=", "/=", "&="};

    for(auto opsList: opsBinaryAll)
        opsBinary.insert(opsBinary.end(), opsList.begin(), opsList.end());
    for(auto opsList: opsUnaryAll)
        opsUnary.insert(opsUnary.end(), opsList.begin(), opsList.end());

    for(auto child : node->children)
        three_AC(child);

    if(node->children.size()== 1 || node->namelexeme == "VariableDeclaratorId"){

        node->node_tmp = node->children[0]->node_tmp;
        // node->code = node->children[0]->code;
    }

    if(nodeName == "Block" && node->children.size()>1){
        
        node->node_tmp = node->children[1]->node_tmp;
        // node->code = node->children[1]->code; 
        
    }
    if(nodeName == "UnqualifiedClassInstanceCreationExpression"){
        Node* mi;
        for(auto child : node->children){
            if(child->namelexeme == "MethodInvocation"){
                mi = child;
            }
        }
        if(mi){
            node->node_tmp = mi->node_tmp;
        }
    }
    

        
    if(nodeName == "="){
        assert(node->nearSymbolTable);
       
        // if(node->children[1]->namelexeme  == "UnqualifiedClassInstanceCreationExpression" ){
        //     return;
        // }
        codeInsert(node, node->children[0]->code);
        codeInsert(node, node->children[1]->code);
        node->node_tmp = newtemp(node->children[0]->typeForExpr, node->nearSymbolTable);
        
        if(node->children[0]->typeForExpr !=node->children[1]->typeForExpr && node->children[0]->typeForExpr != "" && node->children[1]->namelexeme != "UnqualifiedClassInstanceCreationExpression" ){
            auto tempcastright = newtemp(node->children[0]->typeForExpr, node->nearSymbolTable);
            quad castInstruction = generate(qid("CAST_" + node->children[0]->typeForExpr, NULL), node->children[1]->node_tmp, emptyQid, tempcastright, -1);
            node->code.push_back(castInstruction);
            node->children[1]->node_tmp= tempcastright;
        }
        quad tempassign = generate(emptyQid, node->children[1]->node_tmp, emptyQid, node->node_tmp, -1);
        if(node->children[0]->namelexeme == "."){
            node->children[0]->node_tmp.first = "*" + node->children[0]->node_tmp.first;
        }
        quad exp = generate(emptyQid, node->node_tmp, emptyQid, node->children[0]->node_tmp, -1);        
        node->code.push_back(tempassign);
        node->code.push_back(exp);
        // print3AC(node->code);
    }
    
    else if(presentInOpList(opsBinary, nodeName))
        binary3AC(node, nodeName);
    
    else if(presentInOpList(opsUnary, nodeName))
        unary3AC(node, nodeName);

    

    else if(presentInOpList(operAndAssign, nodeName))
    {
        std::string oper;
        oper.push_back(nodeName[0]);
        node->node_tmp = newtemp(node->children[0]->typeForExpr, node->nearSymbolTable);
        generate(qid(oper, NULL), node->children[0]->node_tmp, node->children[1]->node_tmp, node->node_tmp, -1);
        //node->children[0]->node_tmp = newtemp(node->children[0]->children[0]->typeForExpr, node->nearSymbolTable);
        generate(emptyQid, node->node_tmp, emptyQid, node->children[0]->node_tmp, -1);
    } 
    
    else if(nodeName == "PreIncrementExpression")
        preOperation3AC(node, "+");
    else if(nodeName == "PreDecrementExpression")
        preOperation3AC(node, "-");
    else if(nodeName == "PostIncrementExpression")
        postOperation3AC(node, "+");
    else if(nodeName == "PostDecrementExpression")
        postOperation3AC(node, "-");
    
    else if(nodeName == "IfThenStatement"){
        Node* condition = node->children[0];
        Node*  thenNode = node->children[1];
        labelCounter++;
        std::string label = "$L" + std::to_string(labelCounter);
        quad ifThenQuad = generate(qid("IfFalse", NULL),  condition->node_tmp , qid(label, NULL), emptyQid  , -1);
        node->code = condition->code; 
        
        node->code.push_back(ifThenQuad);
        // std::cerr<<thenNode->namelexeme<< "HURRAY \n";
        // std::cerr<<condition->namelexeme<< "HURRAY \n";
        // print3AC1(thenNode->code);
        codeInsert(node, thenNode->code);
        node->code.push_back(generate(qid(label, NULL), emptyQid , emptyQid, emptyQid  , -1));

        // print3AC1(node->code);
    }

    else if(nodeName == "IfThenElseStatement" || nodeName == "IfThenElseStatementNoShortIf"){
        Node* condition = node->children[0];
        Node*  thenNode = node->children[1];
        Node* elseNode = node->children[2];
        labelCounter++;
        std::string l1 = "$L" + std::to_string(labelCounter);
        labelCounter++;
        std::string l2 = "$L" + std::to_string(labelCounter);
        labelCounter++;
        std::string l3 = "$L" + std::to_string(labelCounter);
        
        quad ifThenQuad = generate(qid("IfTrue", NULL),  condition->node_tmp , qid(l1, NULL), emptyQid  , -1);
        quad elseQuad = generate(qid("Else", NULL),  emptyQid, qid(l2, NULL), emptyQid  , -1);
        quad L1 = generate(qid(l1, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad L2 = generate(qid(l2, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad L3 = generate(qid(l3, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad gotol3 = generate(qid( "$goto " + l3, NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code = condition->code;
        node->code.push_back(ifThenQuad);
        node->code.push_back(elseQuad);
        node->code.push_back(L1);
        codeInsert(node, thenNode->code);
        node->code.push_back(gotol3);
        node->code.push_back(L2);
        codeInsert(node, elseNode->code);
        node->code.push_back(L3);
        
    }

    else if(nodeName == "Ternary"){
        Node* condition = node->children[0];
        Node*  thenNode = node->children[1];
        Node* elseNode = node->children[2];
        labelCounter++;
        std::string l1 = "$L" + std::to_string(labelCounter);
        labelCounter++;
        std::string l2 = "$L" + std::to_string(labelCounter);
        labelCounter++;
        std::string l3 = "$L" + std::to_string(labelCounter);
        
        quad ifThenQuad = generate(qid("IfTrue", NULL),  condition->node_tmp , qid(l1, NULL), emptyQid  , -1);
        quad elseQuad = generate(qid("Else", NULL),  emptyQid, qid(l2, NULL), emptyQid  , -1);
        quad L1 = generate(qid(l1, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad L2 = generate(qid(l2, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad L3 = generate(qid(l3, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad gotol3 = generate(qid( "$goto " + l3, NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code = condition->code;
        node->code.push_back(ifThenQuad);
        node->code.push_back(elseQuad);
        node->code.push_back(L1);
        codeInsert(node, thenNode->code);
        node->code.push_back(gotol3);
        node->code.push_back(L2);
        codeInsert(node, elseNode->code);
        node->code.push_back(L3);
        // print3AC(node->code);
    }

    

    else if(nodeName == "For"){
        Node* ForInit, *ForExpression , *ForUpdate , *ForBody;
        for(auto child : node->children){
                if(child->namelexeme == "ForInit"){
                    ForInit = child;
                } 
                if(child->namelexeme == "ForExpression"){
                    ForExpression = child;
                } 
                if(child->namelexeme == "ForUpdate"){
                    ForUpdate = child;
                } 
                if(child->namelexeme == "Block" || child->namelexeme == "="){
                    ForBody = child;
                } 
               
        }
        if(ForInit){
            codeInsert(node, ForInit->code);
        }
        labelCounter++;
        std::string beginFor = "$L" + std::to_string(labelCounter);
        labelCounter++;
        std::string endFor = "$L" + std::to_string(labelCounter);
        quad beginFOR = generate(qid(beginFor, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad endFOR = generate(qid(endFor, NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code.push_back(beginFOR);
        if(ForExpression){
            codeInsert(node, ForExpression->code);
            quad ifThenQuad = generate(qid("IfFalse", NULL),  ForExpression->node_tmp , qid(endFor, NULL), emptyQid  , -1);
            node->code.push_back(ifThenQuad);
            // print3AC(node->code);
        }
        if(ForBody){
             codeInsert(node, ForBody->code);
        }
        if(ForUpdate){
             codeInsert(node, ForUpdate->code);
        }
        quad gotoBeginFor = generate(qid( "$goto " + beginFor, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad gotoEndFor = generate(qid( "$goto " + endFor, NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code.push_back(gotoBeginFor);
        node->code.push_back(endFOR);
        for(int ind = 0; ind < node->code.size() ; ind++){
            if(node->code[ind].oper.first == "BREAK"){
                node->code[ind] = gotoEndFor;
            }
            if(node->code[ind].oper.first == "CONTINUE"){
                node->code[ind] = gotoBeginFor;
            }
        }
        // print3AC(node->code);
        // print3AC1(node->code);

        
    }
    else if(nodeName == "While"){
        Node* WhileExpression = NULL ,* WhileBody = NULL;
        for(auto child : node->children){
            if(child->namelexeme == "WhileExpression"){
                WhileExpression  = child;
            }
            if(child->namelexeme == "WhileBody" || child->namelexeme == "="){
                WhileBody  = child;
            }
        } 
        labelCounter++;
        std::string beginWhile = "$L" + std::to_string(labelCounter);
        labelCounter++;
        std::string endWhile = "$L" + std::to_string(labelCounter);
        quad whileBegin = generate(qid(beginWhile, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad whileEnd = generate(qid(endWhile, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad gotoBeginWhile = generate(qid( "$goto " + beginWhile, NULL), emptyQid, emptyQid, emptyQid, -1);
        quad gotoEndWhile = generate(qid( "$goto " + endWhile, NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code.push_back(whileBegin);
        if(WhileExpression){
            codeInsert(node, WhileExpression->code);
            quad ifThenQuad = generate(qid("IfFalse", NULL),  WhileExpression->node_tmp , qid(endWhile, NULL), emptyQid  , -1);
            node->code.push_back(ifThenQuad);
        }
        if(WhileBody){
            codeInsert(node, WhileBody->code);
        }
        node->code.push_back(gotoBeginWhile);
        node->code.push_back(whileEnd);

        for(int ind = 0; ind < node->code.size() ; ind++){
            if(node->code[ind].oper.first == "BREAK"){
                node->code[ind] = gotoEndWhile;
            }
            if(node->code[ind].oper.first == "CONTINUE"){
                node->code[ind] = gotoBeginWhile;
            }
        }
        // print3AC(node->code);
    }
    else if(nodeName == "[ ]" && node->children.size() >0){
        Node* leaf = node;
        int disleaf= 0;
        while(leaf->children.size()){
            leaf= leaf->children[0];
            disleaf++;
        }
        // std::cerr<<leaf->namelexeme<<"\n";
        auto stEntry = leaf->nearSymbolTable->lookup(leaf->namelexeme);
        if(stEntry){
            int offset;
            std::string type = stEntry->getType();
            auto axisWidths = stEntry->getAxisWidths();
            int axisNo = disleaf - 2;
            if(axisNo < axisWidths.size() - 1){
                offset = setOffset(type);
                std::string width = "dim";
                if(axisWidths.size()>axisNo){
                    width = axisWidths[axisNo];
                }
                auto t1 = newtemp("Dim_" + std::to_string(axisNo) , node->nearSymbolTable );
                auto t2 = newtemp("Offset" , node->nearSymbolTable );
                auto final = newtemp("dereference" , node->nearSymbolTable );
                node->node_tmp = final;
                quad I1 = generate(qid("*",NULL) , qid(std::to_string(offset),NULL), qid(width,NULL), t1 , -1);
                quad I2 = generate(qid("*",NULL) , t1 , node->children[1]->node_tmp, t2, -1);
                std::string getid = "";
                int cntgetid=0;
                // if(node->children.size() > 1  && node->children[1]->namelexeme[0] == 'L' && node->children[1]->namelexeme[1] =='i') {
                //     for(auto x : node->children[1]->namelexeme){
                //         if(cntgetid < 8) getid.push_back(x);
                //         cntgetid++;
                //     }
                // }
                quad I3 = generate(qid("[ ]" + getid , NULL) , qid(leaf->namelexeme , NULL) ,  t2, final, -1);
                codeInsert(node, node->children[0]->code);
                node->code.push_back(I1);
                node->code.push_back(I2);
                node->code.push_back(I3);
                // print3AC(node->code);
            }
            else{
                offset = setOffset(type);
        
              
                auto t1 = newtemp("Offset" , node->nearSymbolTable );
                auto final = newtemp("dereference" , node->nearSymbolTable );
                node->node_tmp = final;
                quad I1 = generate(qid("*",NULL) , qid(std::to_string(offset),NULL), node->children[1]->node_tmp, t1 , -1);
                quad I2 = generate(qid("[ ]" , NULL) , node->children[0]->node_tmp ,  t1, final, -1);
                codeInsert(node, node->children[0]->code);
                node->code.push_back(I1);
                node->code.push_back(I2);
                // print3AC(node->code);
              
            }
            
        }
    }
    else if(nodeName == "MethodInvocation")
    {
        Node* Arguments = nullptr;
        for(auto child: node->children)
        {
            if(child->namelexeme == "Arguments")
                Arguments = child;
        }

        // Constructor Invocation
        if(node->parent->namelexeme == "UnqualifiedClassInstanceCreationExpression"){            
            for(auto codechild : node->children)
            {
                codeInsert(node, codechild->code);
            }
                
            // name of the class for which we are calling the constructor
            std::string className = node->parent->parent->parent->parent->children[0]->namelexeme;

            // temporary for object created
            auto objTemp = newtemp("size", node->nearSymbolTable);
            
            // allocmem for object 
            auto classEntry = globalSymTable->lookup(className);
            int objSize = classEntry->getSize();
            
            quad allocMem = generate(emptyQid, qid("$allocmem", NULL), qid(std::to_string(objSize), NULL), objTemp, -1);
            node->code.push_back(allocMem);

            // get function type signature
            auto consEntry = methodSymbolTable[className + "." + className]->lookup(className);
            assert(consEntry);
            auto functionPrototype = consEntry->getFuncProto();

            int totalPopSize = 0;

            if(Arguments)
            {
                assert(functionPrototype.argTypes.size() == Arguments->children.size());
                assert(functionPrototype.argDims.size() == Arguments->children.size());
                int argNum = 0;
                for(auto child: Arguments->children)
                {
                    quad I1 = generate(qid("push", NULL), child->node_tmp, emptyQid, emptyQid, -1);
                    node->code.push_back(I1);

                    std::string argType = functionPrototype.argTypes[argNum];
                    int argDim = functionPrototype.argDims[argNum];
                    
                    totalPopSize += (argDim > 0 ? 8: setOffset(argType));

                    argNum++;
                }
            }

            // Constructor is never static
            quad I1 = generate(qid("push", NULL), objTemp, emptyQid, emptyQid, -1);
            node->code.push_back(I1);
            totalPopSize += 8;

            // no space for return value for constructor
            
            // space for return address for ret
            // quad returnAddSpace = generate(qid("-", NULL), qid("$sp", NULL), qid("8", NULL), qid("$sp", NULL) , -1);
            // node->code.push_back(returnAddSpace);
            // totalPopSize += 8;

            quad I2 = generate(qid("CALL", NULL), qid(node->children[0]->children[0]->namelexeme, NULL), emptyQid, node->node_tmp, -1);
            node->code.push_back(I2);

            // no retrieving return value from frame

            quad I3 = generate(qid("pop", NULL), qid(std::to_string(totalPopSize), NULL), emptyQid, emptyQid, -1);
            node->code.push_back(I3);

            node->node_tmp = objTemp;
        }

        else if(node->children[0]->namelexeme == ".")
        {
            Node* dot = node->children[0];
            if(dot->children[0]->namelexeme == ".")
            {
                if(dot->children[1]->children[0]->namelexeme == "println" && dot->children[0]->children[1]->children[0]->namelexeme == "out" && dot->children[0]->children[0]->children[0]->namelexeme == "System")
                {
                    // handle System.out.println

                    int totalPopSize = 0;

                    if(Arguments->children.size() > 1)
                    {
                        //error incorrect number of arguments in println
                        std::string s = "Incorrect number of arguments in println " + std::to_string(node->children[0]->children[1]->children[0]->lineNumber);
                        yyerror(s.c_str());
                    }
                    else
                    {
                        for(auto codechild : node->children)
                            codeInsert(node, codechild->code);

                        if(Arguments)
                        {
                            auto argumentNode = Arguments->children[0];
                            quad I1 = generate(qid("push", NULL) , argumentNode->node_tmp, emptyQid, emptyQid, -1);
                            node->code.push_back(I1);
                            totalPopSize += 8;
                        }

                        quad I2 = generate(qid("CALL", NULL), qid("println", NULL), emptyQid, emptyQid, -1);
                        node->code.push_back(I2);

                        quad I3 = generate(qid("pop", NULL), qid(std::to_string(totalPopSize), NULL), emptyQid, emptyQid, -1);
                        node->code.push_back(I3);
                    }
                }
                else
                {
                    // error chain of invocations 
                    std::string s = "Chain of calls in line number " + std::to_string(node->children[0]->children[1]->children[0]->lineNumber);
                    yyerror(s.c_str());
                }
            }
            else
            {
                // handle obj.funcName()

                for(auto codechild: node->children)
                    codeInsert(node, codechild->code);
                
                std::string objName = dot->children[0]->children[0]->namelexeme;
                std::string funcName = dot->children[1]->children[0]->namelexeme;
                std::string objClassName;
                if(objName == "this")
                {
                    auto classNode = node;
                    while(classNode->namelexeme != "class") classNode = classNode->parent;
                    int classNameID=0;
                    if(classNode->children[0]->namelexeme == "ModifierList") classNameID=1;
                    objClassName = classNode->children[classNameID]->namelexeme;
                }
                else
                {
                    auto objEntry = node->nearSymbolTable->lookup(objName);
                    assert(objEntry);
                    objClassName = objEntry->getType();
                }
                auto funcEntry = methodSymbolTable[objClassName + "." + funcName]->lookup(funcName);
                assert(funcEntry);
                auto functionPrototype = funcEntry->getFuncProto();

                int totalPopSize = 0;                

                if(Arguments)
                {
                    // std::cerr<<functionPrototype.argTypes.size()<<" "<<Arguments->children.size()<<"\n";
                    assert(functionPrototype.argTypes.size() == Arguments->children.size());
                    assert(functionPrototype.argDims.size() == Arguments->children.size());
                    int argNum = 0;
                    for(auto child: Arguments->children)
                    {
                        quad I1 = generate(qid("push", NULL), child->node_tmp, emptyQid, emptyQid, -1);
                        node->code.push_back(I1);

                        std::string argType = functionPrototype.argTypes[argNum];
                        int argDim = functionPrototype.argDims[argNum];

                        totalPopSize += (argDim > 0 ? 8: setOffset(argType));

                        argNum++;
                    }
                }

                // obj.func() is never static
                quad I1 = generate(qid("push", NULL), dot->children[0]->node_tmp, emptyQid, emptyQid, -1);
                node->code.push_back(I1);
                totalPopSize += 8;

                std::cerr << "RETURN VALUE TYPE of " << funcName << " IS " << functionPrototype.returnType << '\n';
                std::cerr << "RETURN VALUE DIMENSION of " << funcName << " IS " << functionPrototype.returnDim << '\n';
                int returnValSize = (functionPrototype.returnDim > 0 ? 8: setOffset(functionPrototype.returnType));
                std::cerr << "RETURN VALUE SIZE of " << funcName << " IS " << returnValSize << '\n';

                // space for return value 
                // quad returnValSpace = generate(qid("-",NULL) , qid("$sp", NULL) , qid(std::to_string(returnValSize), NULL), qid("$sp", NULL) , -1);
                // node->code.push_back(returnValSpace);
                // totalPopSize += returnValSize;

                // space for return address for ret
                // quad returnAddSpace = generate(qid("-",NULL) , qid("$sp", NULL) , qid("8", NULL), qid("$sp", NULL) , -1);
                // node->code.push_back(returnAddSpace);
                // totalPopSize += 8;

                // calling function
                node->node_tmp = newtemp(node->children[0]->typeForExpr, node->nearSymbolTable);
                quad I2 = generate(qid("CALL", NULL), dot->children[1]->node_tmp, emptyQid, emptyQid, -1);
                node->code.push_back(I2);

                // retrieving return value from frame
                quad returnVal = generate(qid("RETURNVALUE", NULL), qid("", NULL), qid("", NULL), node->node_tmp, -1);
                node->code.push_back(returnVal);

                // pop everything to restore stack after function call
                quad I3 = generate(qid("pop", NULL), qid(std::to_string(totalPopSize), NULL), emptyQid, emptyQid, -1);
                node->code.push_back(I3);
            }
        }

        else
        {
            // handle func()

            int totalPopSize = 0;

            node->node_tmp = newtemp("returnValue", node->nearSymbolTable);
            for(auto codechild: node->children)
                codeInsert(node, codechild->code);
            
            std::string funcName = node->children[0]->children[0]->namelexeme;
            auto classNode = node;
            while(classNode->namelexeme != "class") classNode = classNode->parent;
            int classNameID=0;
            if(classNode->children[0]->namelexeme == "ModifierList") classNameID=1;
            std::string className = classNode->children[classNameID]->namelexeme;
            auto funcEntry = methodSymbolTable[className + "." + funcName]->lookup(funcName);
            assert(funcEntry);
            auto functionPrototype = funcEntry->getFuncProto();

            int isStatic = 0;
            std::string fullFuncName = funcEntry->getName();
            std::string tempStr="";
            for(int i=0; i < fullFuncName.size(); i++)
            {
                if(fullFuncName[i] != ' ')
                    tempStr.push_back(fullFuncName[i]);
                else
                {
                    if(tempStr == "static")
                    {
                        isStatic = 1;
                        break;
                    }
                    tempStr = "";
                }
            }
            std::cerr << "FUNCTION " << fullFuncName << " IS STATIC? " << isStatic << '\n';

            if(Arguments)
            {
                assert(functionPrototype.argTypes.size() == Arguments->children.size());
                assert(functionPrototype.argDims.size() == Arguments->children.size());
                int argNum = 0;
                for(auto child: Arguments->children)
                {
                    quad I1 = generate(qid("push", NULL), child->node_tmp, emptyQid, emptyQid, -1);
                    node->code.push_back(I1);

                    std::string argType = functionPrototype.argTypes[argNum];
                    int argDim = functionPrototype.argDims[argNum];

                    totalPopSize += (argDim > 0 ? 8: setOffset(argType));

                    argNum++; 
                }
            }

            // Pass first object address as first argument if non-static
            if(!isStatic)
            {
                quad I1 = generate(qid("push", NULL), qid("this", NULL), emptyQid, emptyQid, -1);
                node->code.push_back(I1);
                totalPopSize += 8;
            }

            int returnValSize = (functionPrototype.returnDim > 0 ? 8: setOffset(functionPrototype.returnType));

            // space for return value 
            // quad returnValSpace = generate(qid("-", NULL), qid("$sp", NULL), qid(std::to_string(returnValSize), NULL), qid("$sp", NULL), -1);
            // node->code.push_back(returnValSpace);
            // totalPopSize += returnValSize;

            // space for return address for ret
            // quad returnAddSpace = generate(qid("-", NULL), qid("$sp", NULL), qid("8", NULL), qid("$sp", NULL) , -1);
            // node->code.push_back(returnAddSpace);
            // totalPopSize += 8;

            quad I2 = generate(qid("CALL", NULL), qid(node->children[0]->children[0]->namelexeme, NULL), emptyQid, node->node_tmp, -1);
            node->code.push_back(I2);

            // retrieving return value from frame
            quad returnVal = generate(qid("RETURNVALUE", NULL), qid("", NULL), qid("", NULL), node->node_tmp, -1);
            node->code.push_back(returnVal);

            // pop everything to restore stack after function call
            quad I3 = generate(qid("pop", NULL), qid(std::to_string(totalPopSize), NULL), emptyQid, emptyQid, -1);
            node->code.push_back(I3);
        }
    }

    else if(nodeName == "." && node->parent->namelexeme != "MethodInvocation" && node->parent->namelexeme != "." )
    {
        // handle field access
        if(node->children[0]->namelexeme != "."){
            Node* leftleaf = node;
            Node* fieldNameNode = node->children[1];
            while(leftleaf->children.size()){
                leftleaf = leftleaf->children[0];
            }
            while(fieldNameNode->children.size()){
                fieldNameNode = fieldNameNode->children[0];
            }
            std::string objname = leftleaf->namelexeme;
            node->node_tmp = newtemp("dot", node->nearSymbolTable);
            quad I1 = generate(qid("", NULL), qid(objname, NULL), emptyQid,node->node_tmp, -1);
            string temp = "";
            for(auto ch : node->node_tmp.first){
                if(ch!='*'){
                    temp.push_back(ch);
                }
            }

            std::string objClassName;
            if(objname == "this")
            {
                auto classNode = node;
                while(classNode->namelexeme != "class") classNode = classNode->parent;
                int classNameID=0;
                if(classNode->children[0]->namelexeme == "ModifierList") classNameID=1;
                objClassName = classNode->children[classNameID]->namelexeme;
            }
            else
            {
                auto objEntry = node->nearSymbolTable->lookup(objname);
                assert(objEntry);
                objClassName = objEntry->getType();
            }
            std::string fieldName = fieldNameNode->namelexeme;
            auto fieldStructData = classFieldData[objClassName + "_" + fieldName];
            int offset = fieldStructData.offset;

            quad I2 = generate(qid("+",NULL), qid(temp,NULL), qid(std::to_string(offset), NULL), qid(temp,NULL),-1);
            node->code.push_back(I1);
            node->code.push_back(I2);
            // print3AC1(node->code);

        }
    }
    else if(nodeName == "MethodDeclaration" || nodeName == "ConstructorDeclaration"){
        Node* header = nullptr, *block = nullptr,  *declarator = nullptr, *FormalParameterList = nullptr;
        for(auto child: node->children)
        {
            if(child->namelexeme == "MethodHeader")
                header = child;
            if(child->namelexeme == "ConstructorDeclarator")
                declarator = child;
            if(child->namelexeme == "Block")
                block = child;
        }
        if(header)
            for(auto child: header->children)
            {
                if(child->namelexeme == "MethodDeclarator")
                    declarator = child;
            }
        for(auto child: declarator->children)
        {
            if(child->namelexeme == "FormalParameterList")
                FormalParameterList = child;
        }

        // label
        std::string funcName = declarator->children[0]->children[0]->namelexeme;
        auto funcLabel = quad(qid("#" + funcName, NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code.push_back(funcLabel);

        Node *classNode = node->parent->parent->parent;
        std::string className = classNode->children[(int)classNode->children.size()-2]->namelexeme;
        auto classSymbolTable = methodSymbolTable[className + "." + funcName];
        auto funcEntry = classSymbolTable->lookup(funcName);

        
        // beginFunc statement
        quad BeginFunc = generate(qid("BEGINFUNC",NULL) , emptyQid , emptyQid, emptyQid , -1);
        node->code.push_back(BeginFunc);


        // push current base base pointer
        // quad storeBasePointer = generate(qid("push",NULL) , qid("$bp", NULL) , emptyQid, emptyQid , -1);
        // node->code.push_back(storeBasePointer);

        // move $bp to current $sp
        // quad base2stack = generate(qid("",NULL) , qid("$sp", NULL) , emptyQid, qid("$bp", NULL) , -1);
        // node->code.push_back(base2stack);


        std::string nameStr = funcEntry->getName();
        int isStatic = 0;
        std::string tempStr="";
        for(int i=0; i < nameStr.size(); i++)
        {
            if(nameStr[i] != ' ')
            {
                tempStr.push_back(nameStr[i]);
            }
            else{
                if(tempStr=="static"){
                    isStatic = 1;
                    break;
                }
                tempStr="";
            }
        }

        // removing the space for return value and return address manually created 
        // int rv_initial = 8;
        // if(header) rv_initial += setOffset(header->children[0]->namelexeme);
        int rv_initial = 8;

        if(!isStatic)
        {
            quad I1 =  generate(qid("MOVE-8", NULL) , qid("%"+ std::to_string(rv_initial) +"(rbp)",NULL), emptyQid, qid("this",NULL) , -1);
            node->code.push_back(I1);

        }

        if(FormalParameterList)
        {
            // std::cerr<<FormalParameterList->value<<"\n";
            int paramNumber = FormalParameterList->children.size();
            std::vector<std::string> paramNames; 
            std::vector<SymbolTableEntry*> entries;
            for(auto param  : FormalParameterList->children){
                auto Id = param->children.back();
                paramNames.push_back(Id->children[0]->children[0]->namelexeme);
                entries.push_back(param->nearSymbolTable->lookup(paramNames.back()));
                entries.back()->print();
            }
            
            int rv_= 8;
            // if(header) rv_ += setOffset(header->children[0]->namelexeme);
            if(!isStatic) rv_ +=8;
            for(int i = paramNumber - 1; i >= 0; i--)
            {
                std::vector<Node*>formalParam = FormalParameterList->children[i]->children;
                std::string type1 = "";
      
                for(auto x: formalParam)
                {
                    if(x->namelexeme == "final")
                    {
                        
                    }
                    else if(x->namelexeme == "VariableDeclaratorId")
                    {
                        
                    }
                    else 
                    {
                        if(x->namelexeme == "UnannArrayType")
                        {
                            type1  = x->children[0]->namelexeme;
                        }
                        else type1 = x->namelexeme;
                        
                    }
                }

                quad I1 =  generate(qid("MOVE-" + std::to_string(setOffset(type1)) , NULL) , qid("%"+ std::to_string(rv_) +"(rbp)",NULL) , emptyQid, qid(paramNames[i], entries[i])  , -1);
                // std::cerr<<"___ "<<type1<<" "<<rv_<<"\n";
                rv_ += setOffset(type1);
                // std::cerr<<"___ "<<type1<<" "<<rv_<<"\n";
                // quad I2 = generate(emptyQid , t1, emptyQid , qid(paramNames[i], entries[i]) , -1 );
                node->code.push_back(I1);
                // node->code.push_back(I2);
            }
        }

        // give space for local variables which can be accessed from their offsets in stored in symbol table
        int sizeofLocals = funcEntry->getSizeofLocals();
        quad localSpace = generate(qid("-",NULL) , qid("$sp", NULL) , qid(std::to_string(sizeofLocals), NULL), qid("$sp", NULL) , -1);
        node->code.push_back(localSpace);

        // give space for saved registers (num_of_callee_saved_registers assumed 9)
        quad calleeRegisterSpace = generate(qid("PUSHCALLEEREGS",NULL) , emptyQid , emptyQid , emptyQid , -1);
        node->code.push_back(calleeRegisterSpace);
        
        codeInsert(node, block->code);
        
        // restore saved registers (num_of_callee_saved_registers assumed 9)
        calleeRegisterSpace = generate(qid("POPCALLEEREGS",NULL) , emptyQid , emptyQid , emptyQid , -1);
        node->code.push_back(calleeRegisterSpace);

        // ENDFUNCTION EPILOGUE
        quad EndFunc = generate(qid("ENDFUNC",NULL) , emptyQid , emptyQid, emptyQid , -1);
        node->code.push_back(EndFunc);

        // popping local variables and saved registers and temporaries off the stack
        // quad stack2base = generate(qid("",NULL) , qid("$bp", NULL) , emptyQid, qid("$sp", NULL) , -1);
        // node->code.push_back(stack2base);

        // restore the base pointer 
        // quad restoreBase = generate(qid("",NULL) , qid("*($sp)", NULL) , emptyQid, qid("$bp", NULL) , -1);
        // node->code.push_back(restoreBase);

        // pop $bp

        // quad popBasePointer = generate(qid("pop",NULL) , qid("8", NULL) , emptyQid, emptyQid , -1);
        // node->code.push_back(popBasePointer);

        // ret instruction
        // quad ret = generate(qid("ret",NULL) , qid("", NULL) , emptyQid, emptyQid , -1);
        // node->code.push_back(ret);

        // Dump 3AC code into file
        std::string fileName = className + "." + funcName + ".3ac";
        // std::cerr << fileName << ' ' << node->code.size() << ' ' << '\n';
        print3AC1(node->code, fileName);
        for(auto ins : node->code){
            tacCode.push_back(ins);
        }
        node->code.clear();


    }
    else if(nodeName == "ArrayCreationExpression"){
        int offset = setOffset(node->typeForExpr);
        std::vector<std::string> axisWidths;
        Node* dimEx ;
        for(auto child : node->children){
            if(child->namelexeme == "DimExprs"){
                dimEx = child;
            }
        }
        if(dimEx){
            for(auto child : dimEx->children){
                Node* leaf = child;
                while(leaf->children.size()){
                    leaf = leaf->children[0];
                }
                axisWidths.push_back(leaf->namelexeme);
            }
            

        }
        node->node_tmp = newtemp("size",node->nearSymbolTable);
        quad I1 = generate(emptyQid , qid(std::to_string(offset) , NULL), emptyQid , node->node_tmp , -1);
        node->code.push_back(I1);
        for(auto width : axisWidths){
            quad I1 = generate(qid("*",NULL), qid(width , NULL), node->node_tmp , node->node_tmp , -1);
            node->code.push_back(I1);
        }
        auto x = newtemp("final" , node->nearSymbolTable);
        I1 =  generate(emptyQid, qid("$allocmem", NULL), node->node_tmp, x, -1);
        node->node_tmp = x;
        node->code.push_back(I1);
    }
    else if(nodeName == "ReturnStatement"){
        codeInsert(node , node->children[0]->code);
        quad I1 = generate(qid("RETURN", NULL) , node->children[0]->node_tmp , emptyQid, qid("%rax",NULL) ,-1);
        node->code.push_back(I1);
    }
    else if(nodeName == "CastExpression"){
        Node* left = node->children[0];
        auto tempcastleft = newtemp(left->typeForExpr, node->nearSymbolTable);
        quad castInstruction = generate(qid("CAST_"+ left->typeForExpr, NULL), node->children[1]->node_tmp, emptyQid, tempcastleft, -1);
        node->code.push_back(castInstruction);
        node->node_tmp = tempcastleft;
    }
    else if(nodeName == "BREAK"){
       quad Instruction = generate(qid("BREAK", NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code.push_back(Instruction); 
    }
    else if(nodeName == "ContinueStatement"){
        
       quad Instruction = generate(qid("CONTINUE", NULL), emptyQid, emptyQid, emptyQid, -1);
        node->code.push_back(Instruction); 
    
    }

    // else if(node->children.size() == 0 && node->parent->namelexeme == "Identifier"   && node->parent->parent->namelexeme != "MethodInvocation" && node->parent->parent->namelexeme != "UnqualifiedClassInstanceCreationExpression" && node->parent->parent->namelexeme != "LocalVariableDeclaration" && node->parent->parent->namelexeme != "MethodDeclarator" && node->parent->parent->namelexeme!= "." && node->parent->parent->namelexeme != "class"){
        
    //     auto t1 = newtemp(node->typeForExpr , node->nearSymbolTable );
    //     node->node_tmp = t1;
    //     quad I1 = generate(emptyQid , qid(node->namelexeme, NULL), emptyQid , t1, -1);
    //     node->code.push_back(I1);
    //     // print3AC(node->code);
    // }
    // else if(node->children.size()==0 && node->value[0]=='L'){
      
    //     auto t1 = newtemp(node->typeForExpr , node->nearSymbolTable );
    //     node->node_tmp = t1;
    //     quad I1 = generate(emptyQid , qid(node->namelexeme, NULL), emptyQid , t1, -1);
    //     node->code.push_back(I1);
    //     // print3AC(node->code);
    // }
    else if(node->children.size() ==0 && (node->value[0] == 'I' || node->value[0] =='L')){
        if(node->value[0]=='I'){
        auto entry = node->nearSymbolTable->lookup(node->namelexeme);
        std::string type = "";
        if(entry){
        type = entry->getType();
        type += "-";
        }
        node->node_tmp = qid( node->namelexeme  , entry);
        if(entry != NULL){
        entry->print();
        }
        else{
            std::cerr<< node->namelexeme<<"\n";
        }
        }
        else{
             node->node_tmp = qid(node->namelexeme , NULL);
        }
    }
    
    
    else{
        // std::cerr<<nodeName<<"__nodename__\n";
        
        for(auto child : node->children){
          
            // std::cerr<<child->namelexeme<<" child " <<child->code.size()<<"\n";

            codeInsert(node, child->code);
        }
        if(nodeName == "Then"){
    
            // std::cerr<<node->namelexeme<<" child " <<node->code.size()<<"\n";
            // print3AC1(child->code);
        }
       
    }




    
    
    // std::cerr<<nodeName<<"__END__ \n\n";

    


}

void typecheck(Node *node)
{
    std::string nodeName = node->namelexeme;
    std::set<std::string> primitiveTypes{"int", "char", "short", "long", "float", "double", "boolean", "String"};
    // if(nodeName == "=")
    // {
    //     assert((int)(node->children.size()) >= 2);
    //     Node *leftHandSide = node->children[0];
    //     Node *rightHandSide = node->children[1];
    //     if(setTypeCheckType( leftHandSide->typeForExpr) != setTypeCheckType(rightHandSide->typeForExpr))
    //     {
    //         // yyerror(("Types "+leftHandSide->typeForExpr + " does not match with " + rightHandSide->typeForExpr + " in line number " + std::to_string(node->lineNumber).c_str()));
            
    //         std::string s = "Types "+leftHandSide->typeForExpr + " does not match with " + rightHandSide->typeForExpr + " in line number " + std::to_string(node->lineNumber);
    //          yyerror(s.c_str());

    //     }
    // }

    if(nodeName=="=" || nodeName == "+"  || nodeName == "*" || nodeName == "/" || nodeName == "%" || nodeName == "-" || nodeName == "<" || nodeName == ">" || nodeName == "<=" || nodeName == ">=" || nodeName== "==" || nodeName=="!=" || nodeName=="&" ||nodeName=="|" || nodeName==":" || nodeName=="^" || nodeName=="||" || nodeName=="&&" || nodeName=="+=" || nodeName=="-=" || nodeName=="*=" || nodeName=="/=" || nodeName=="&=" || nodeName=="|=" || nodeName=="^=" ||nodeName=="%=" ){
        if(node->children.size() < 2) return;
        Node *leftHandSide = node->children[0];
        Node *rightHandSide = node->children[1];
        // std::cerr<<nodeName <<" "<<leftHandSide->typeForExpr <<" "<<rightHandSide->typeForExpr<< "\n";
        if(leftHandSide->typeForExpr=="" || rightHandSide->typeForExpr ==""){
            return;
        }
        if(nodeName == "="){
            node->typeForExpr = leftHandSide->typeForExpr;
        }

        if(leftHandSide->numDims !=  rightHandSide->numDims){
            std::string s = "Number of dimensions does not match on leftHandSide  and rightHandSide "  + nodeName +  " in line number " + std::to_string(node->lineNumber);
            yyerror(s.c_str());
        }

        if(nodeName == "+" && (leftHandSide->typeForExpr == "String" || rightHandSide->typeForExpr == "String") && leftHandSide->numDims == 0)
        {
            std::string otherType = (leftHandSide->typeForExpr == "String") ? rightHandSide->typeForExpr: leftHandSide->typeForExpr;
            if(primitiveTypes.find(otherType) == primitiveTypes.end())
            {
                std::string errorMessage = "Type mismatch: " + leftHandSide->typeForExpr + " and " + rightHandSide->typeForExpr + " does not match under " + nodeName + " in line number " + std::to_string(node->lineNumber);
                yyerror(errorMessage.c_str());
            }
        }

        else if(setTypeCheckType1( rightHandSide->typeForExpr)==8 && setTypeCheckType1( leftHandSide->typeForExpr)!=8){
           std::string s = "1 Type Mismatch: "+leftHandSide->typeForExpr + " and " + rightHandSide->typeForExpr + " does not match under " + nodeName +  " in line number " + std::to_string(node->lineNumber);
            yyerror(s.c_str());
        }
        else if(setTypeCheckType1( leftHandSide->typeForExpr)==8 && setTypeCheckType1( rightHandSide->typeForExpr)!=8){
            std::string s = "2 Type Mismatch: "+leftHandSide->typeForExpr + " and " + rightHandSide->typeForExpr + " does not match under " + nodeName +  " in line number " + std::to_string(node->lineNumber);
            yyerror(s.c_str());
        }
        else if(setTypeCheckType1( leftHandSide->typeForExpr)!=8 && setTypeCheckType1( rightHandSide->typeForExpr)!=8){
            if(setTypeCheckType1( leftHandSide->typeForExpr)< setTypeCheckType1( rightHandSide->typeForExpr)){
                // leftHandSide->typeForExpr = rightHandSide->typeForExpr;
                if(nodeName != "=" ) node->typeForExpr = rightHandSide->typeForExpr;
                else {
                    std::string s = "2 Type Mismatch "+leftHandSide->typeForExpr + " and " + rightHandSide->typeForExpr + " does not match under " + nodeName +  " in line number " + std::to_string(node->lineNumber);
                    yyerror(s.c_str());
                }
            }
            else if(setTypeCheckType1( leftHandSide->typeForExpr) > setTypeCheckType1( rightHandSide->typeForExpr)){
                // rightHandSide->typeForExpr = leftHandSide->typeForExpr;
                if(nodeName != "=" ) node->typeForExpr = leftHandSide->typeForExpr;
            }
            else {

                if(rightHandSide->typeForExpr == "boolean" || leftHandSide->typeForExpr =="boolean"){
                    // std::cerr<<" abc "<<nodeName<<"\n";
                    
                    
                    if((nodeName!= "||") && (nodeName!="&&") && (nodeName!= "!") && (nodeName != "<") && (nodeName != ">") && (nodeName != "<=") && (nodeName != ">=") && (nodeName!= "!=")  && (nodeName!= "=")){
                        std::string s = "3 Type Mismatch "+leftHandSide->typeForExpr + " and " + rightHandSide->typeForExpr + " does not match under " + nodeName +  " in line number " + std::to_string(node->lineNumber);
                        yyerror(s.c_str());
                    }
                }
                else if(setTypeCheckType1(leftHandSide->typeForExpr)!=8){
                    node->typeForExpr = leftHandSide->typeForExpr;
                }
                
                // if both are at same level , then no change in conversion 
                // short or char are taken at same level so no interchange
            }
            
            // std::cerr<<" abc "<<nodeName<<  " "<< node->typeForExpr<< "\n";
        }
        else{
            // for other data types
        }
    }

    else if(nodeName == ">>" || nodeName == "<<" || nodeName == ">>>")
    {
        auto leftHandSide = node->children[0], rightHandSide = node->children[1];
        if(setTypeCheckType1(leftHandSide->typeForExpr) > 4 || setTypeCheckType1(rightHandSide->typeForExpr) > 4)
        {
            std::string errorMessage = "Type mismatch: both operands must be of integral types";
            yyerror(errorMessage.c_str());
        }
    }

    else if(nodeName == "PreDecrementExpression" || nodeName=="PreIncrementExpression"){

        assert((int)(node->children.size()) >= 2);
        Node *leftHandSide=node->children[1]->children[0];
        if(setTypeCheckType1(leftHandSide->typeForExpr)>=8){
            std::string s = "Type Mismatch "+leftHandSide->typeForExpr + " does not match under " + nodeName +  " in line number " + std::to_string(node->lineNumber);
            yyerror(s.c_str());
        }
        else{
            node->typeForExpr = leftHandSide->typeForExpr;
        }
    }
    else if(nodeName == "PostDecrementExpression" || nodeName=="PostIncrementExpression"){

        assert((int)(node->children.size()) >= 2);
        Node *leftHandSide=node->children[0]->children[0];
        if(setTypeCheckType1(leftHandSide->typeForExpr)>=8){
            std::string s = "Type Mismatch "+leftHandSide->typeForExpr + " does not match under " + nodeName +  " in line number " + std::to_string(node->lineNumber);
            yyerror(s.c_str());
        }
        else{
            node->typeForExpr = leftHandSide->typeForExpr;
        }
    }

    // else if(nodeName == "+"  || nodeName == "*" || nodeName == "/" || nodeName == "%" || nodeName == "-")
    // {
    //     assert((int)(node->children.size()) >= 2);
    //     Node *leftHandSide = node->children[0];
    //     Node *rightHandSide = node->children[1];
    //     if(setTypeCheckType( leftHandSide->typeForExpr) != setTypeCheckType(rightHandSide->typeForExpr))
    //     {
    //         // yyerror(("Types "+leftHandSide->typeForExpr + " does not match with " + rightHandSide->typeForExpr + " in line number " + std::to_string(node->lineNumber).c_str()));
    //         std::string s = "Type "+leftHandSide->typeForExpr + " does not match with " + rightHandSide->typeForExpr + " in line number " + std::to_string(node->lineNumber);
    //         yyerror(s.c_str());

    //     }
    // }

    else if(nodeName == "VariableInitializerList")
    {
        for(auto listMem: node->children)
        {
            
        }
    }
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
                        auto stEntry = new SymbolTableEntry("println", "$func" , 0 , 0 , 0 , 0);
                        currSymTable->insert(stEntry);
                        stEntry = new SymbolTableEntry("System", "$package" , 0 , 0 , 0 , 0);
                        currSymTable->insert(stEntry);
                        stEntry = new SymbolTableEntry("out", "$package" , 0 , 0 , 0 , 0);
                        currSymTable->insert(stEntry);
                        createST(root);
                        // SymTableCSVDump();
                        // globalSymTable->__printAll();
                        three_AC(root);
                        // globalSymTable = $$->symTable;
                        X86* x86 = new X86(tacCode);
                        x86->codeGen();
                        // print3AC();
                        
                    }
                    ;

OrdinaryCompilationUnit:    TopLevelClassOrInterfaceDeclarationList
                            ;

TopLevelClassOrInterfaceDeclarationList:    TopLevelClassOrInterfaceDeclaration
                                            {
                                                std::vector<Node*> v{$1};
                                                $$ = createNode("JAVA-PROGRAM", v);

                                                $$->allocate_symtable();
                                                assert($1->symTable);
                                                $1->symTable->setParent($$->symTable);
                                                assert((int)($1->stEntries.size()) == 1);
                                                $$->add_entries($1->stEntries);
                                            }
                                            | TopLevelClassOrInterfaceDeclarationList TopLevelClassOrInterfaceDeclaration
                                            {
                                                $$ = $1;
                                                $$->add_child($2);

                                                assert($2->symTable);
                                                $2->symTable->setParent($$->symTable);
                                                // assert((int)($1->stEntries.size()) == 1);
                                                $$->add_entries($2->stEntries);
                                            }
                                            ;

TopLevelClassOrInterfaceDeclaration:    ClassDeclaration 
                                        ;

ClassDeclaration:   NormalClassDeclaration
                    ;

NormalClassDeclaration: CLASS TypeIdentifier ClassBody
                        {
                            
                            $$ = createNode("class");
                            $$->add_child($2);
                            $$->add_child($3);

                            $$->symTable = $3->symTable;
                            auto stEntry = new SymbolTableEntry($2->lexeme, $1->type, -1, 0, $2->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        | ModifierList CLASS TypeIdentifier ClassBody
                        {
                            $$ = createNode("class");
                            $$->add_child($1);
                            $$->add_child($3);
                            $$->add_child($4);

                            $$->symTable = $4->symTable;
                            auto stEntry = new SymbolTableEntry($3->lexeme, $2->type, -1, 0, $3->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
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

ClassBody:  LeftCurlyBrace ClassBodyDeclarationList RightCurlyBrace
            {
                $$ = createNode("ClassBody");
                $$->add_child($1);
                $$->add_child($2);
                $$->add_child($3);

                $$->symTable = $2->symTable;
            }
            | LeftCurlyBrace RightCurlyBrace
            {
                $$ = createNode("ClassBody");
                $$->add_child($1);
                $$->add_child($2);

                $$->allocate_symtable();
            }
            ;

ClassBodyDeclarationList:   ClassBodyDeclaration
                            {
                                $$ = createNode("ClassBody");
                                $$->add_child($1);

                                $$->allocate_symtable();
                                if($1->symTable)
                                    $1->symTable->setParent($$->symTable);
                                $$->add_entries($1->stEntries);
                            }
                            | ClassBodyDeclarationList ClassBodyDeclaration
                            {
                                $$ = $1;
                                $$->add_child($2);

                                if($2->symTable)
                                    $2->symTable->setParent($$->symTable);
                                $$->add_entries($2->stEntries);
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
                        $$->add_child($1);
                        $$->add_child($2);
                        $$->add_child($3);
                        $$->add_child($4);

                        $$->stEntries = $3->stEntries;
                        for(auto stEntry: $$->stEntries)
                        {
                            assert(stEntry);
                            stEntry->setType($2->type);
                        }
                    }
                    | UnannType VariableDeclaratorList Semicolon
                    {
                        $$ = createNode("FieldDeclaration");
                        $$->add_child($1);
                        $$->add_child($2);
                        $$->add_child($3);

                        $$->stEntries = $2->stEntries;
                        for(auto stEntry: $$->stEntries)
                        {
                            assert(stEntry);
                            stEntry->setType($1->type);
                            stEntry->setDimension($1->numDims);
                        }
                    }
                    ;

VariableDeclaratorList: VariableDeclarator
                        {
                            $$ = createNode("Variables");
                            $$->add_child($1);
                        }
                        | VariableDeclaratorList Comma VariableDeclarator
                        {
                            $$ = $1;
                            $$->add_child($3);

                            assert((int)($3->stEntries.size()) == 1);
                            $$->stEntries.push_back($3->stEntries[0]);
                        }
                        ;

VariableDeclarator: VariableDeclaratorId ASSIGN VariableInitializer
                    {
                        $$ = createNode("=");
                        $$->add_child($1);
                        $$->add_child($3);

                        $$->stEntries = $1->stEntries;
                    }
                    | VariableDeclaratorId
                    ;

VariableDeclaratorId:   Identifier Dims
                        {
                            $$ = createNode("VariableDeclaratorId");
                            $$->add_child($1);
                            $$->add_child($2);

                            auto stEntry = new SymbolTableEntry($1->lexeme, "", -1, $2->numDims, $1->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        | Identifier
                        {
                            $$ = createNode("VariableDeclaratorId");
                            $$->add_child($1);

                            auto stEntry = new SymbolTableEntry($1->lexeme, "", -1, 0, $1->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        ;

VariableInitializer:    Expression
                        | ArrayInitializer
                        ;

UnannType:  UnannPrimitiveType {
                
            }
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
                        $$->add_child($1);
                        $$->add_child($2);
                        $$->add_child($3);

                        $$->symTable = $3->symTable;
                        auto stEntry = new SymbolTableEntry($2->lexeme, "$func", -1, 0, $2->lineNumber, 0);
                        $$->stEntries.push_back(stEntry);


                    }
                    | MethodHeader MethodBody
                    {
                        $$ = createNode("MethodDeclaration");
                        $$->add_child($1);
                        $$->add_child($2);

                        $$->symTable = $2->symTable;
                        auto stEntry = new SymbolTableEntry($1->lexeme, "$func", -1, -1, $1->lineNumber, 0);
                        $$->stEntries.push_back(stEntry);
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
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                    }
                    | Identifier LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);
                        $$->add_child($5);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis FormalParameterList RightParenthesis
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);

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
                        $$->add_child($5);
                        $$->add_child($7);

                        $$->lexeme = $1->lexeme;
                        $$->lineNumber = $1->lineNumber;
                    }
                    | Identifier LeftParenthesis FormalParameterList RightParenthesis Dims
                    {
                        $$ = createNode("MethodDeclarator");
                        $$->add_child($1);
                        $$->add_child($3);
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

FormalParameter:    VariableModifier UnannType VariableDeclaratorId
                    {
                        $$ = createNode("FormalParameter");
                        $$->add_child($1);
                        $$->add_child($2);
                        $$->add_child($3);
                    }
                    | UnannType VariableDeclaratorId {
                        $$ = createNode("FormalParameter");
                        $$->add_child($1);
                        $$->add_child($2);
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
                        | VariableModifier UnannType ellipsis Identifier
                        ;



VariableModifier:   FINAL {
                        $$ = createNode("VariableModifier");
                        $$->add_child($1);
                    }   
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

                        $$->symTable = $2->symTable;
                    }
                    ;

ConstructorDeclaration: ConstructorDeclarator ConstructorBody
                        {
                            $$ = createNode("ConstructorDeclaration");
                            $$->add_child($1);
                            $$->add_child($2);

                            $$->symTable = $2->symTable;
                            $$->stEntries = $1->stEntries;
                        }
                        | ModifierList ConstructorDeclarator ConstructorBody
                        {
                            $$ = createNode("ConstructorDeclaration");
                            $$->add_child($1);
                            $$->add_child($2);
                            $$->add_child($3);

                            $$->symTable = $3->symTable;
                            $$->stEntries = $2->stEntries;
                        }
                        ;

ConstructorDeclarator:  SimpleTypeName LeftParenthesis RightParenthesis
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child(createNode("()"));

                            auto stEntry = new SymbolTableEntry($1->lexeme, "$func", -1, 0, $1->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        | SimpleTypeName LeftParenthesis ReceiverParameter Comma RightParenthesis
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child($1);
                            $$->add_child($3);

                            auto stEntry = new SymbolTableEntry($1->lexeme, "$func", -1, 0, $1->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        | SimpleTypeName LeftParenthesis FormalParameterList RightParenthesis
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child($1);
                            $$->add_child($3);

                            auto stEntry = new SymbolTableEntry($1->lexeme, "$func", -1, 0, $1->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        | SimpleTypeName LeftParenthesis ReceiverParameter Comma FormalParameterList RightParenthesis
                        {
                            $$ = createNode("ConstructorDeclarator");
                            $$->add_child($1);
                            $$->add_child($3);
                            $$->add_child($5);

                            auto stEntry = new SymbolTableEntry($1->lexeme, "$func", -1, 0, $1->lineNumber, 0);
                            $$->stEntries.push_back(stEntry);
                        }
                        ;

SimpleTypeName: TypeIdentifier
                {
                    $$ = createNode("Identifier");
                    $$->add_child($1);
                }
                ;

ConstructorBody:    LeftCurlyBrace  RightCurlyBrace
                    {
                       $$ = createNode("{ }");
                       $$->allocate_symtable();
                    }
                    | LeftCurlyBrace  ExplicitConstructorInvocation RightCurlyBrace
                    {
                        $$ = createNode("ConstructorBody");
                        $$->add_child($2);

                        $$->allocate_symtable();
                    }
                    | LeftCurlyBrace BlockStatements RightCurlyBrace
                    {
                        $$ = $2;
                    }
                    | LeftCurlyBrace ExplicitConstructorInvocation BlockStatements RightCurlyBrace
                    {
                        $$ = createNode("ConstructorBody");
                        $$->add_child($2);
                        $$->add_child($3);

                        $$->symTable = $3->symTable;
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
                                    $$->add_child($3);
                                    $$->add_child($5);
                                }
                                | TypeArguments THIS LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp = createNode("GenericClassName");
                                    temp->add_child($1);
                                    temp->add_child($2);
                                    $$->add_child(temp);
                                    $$->add_child($4);
                                    $$->add_child($6);
                                }
                                | TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    Node *temp = createNode("GenericClassName");
                                    temp->add_child($1);
                                    temp->add_child($2);
                                    $$->add_child(temp);
                                    $$->add_child($4);
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
                                    $$->add_child($3);
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
                                    $$->add_child($6);
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
                                    $$->add_child($5);
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
                                    $$->add_child($5);
                                    $$->add_child($7);
                                }
                                | Primary Dot TypeArguments SUPER LeftParenthesis ArgumentList RightParenthesis Semicolon
                                {
                                    $$ = createNode("ExplicitConstructorInvocation");
                                    $2 = createNode(".");
                                    $2->add_child($1);
                                    $2->add_child($4);
                                    $$->add_child($2);
                                    $$->add_child($6);
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

Block:  LeftCurlyBrace BlockStatements RightCurlyBrace
        {
            $$ = createNode("Block");
            $$->add_child($1);
            $$->add_child($2);
            $$->add_child($3);

            $$->symTable = $2->symTable;
        }
        | LeftCurlyBrace RightCurlyBrace
        {
            $$ = createNode("Block");
            $$->add_child($1);
            $$->add_child($2);
            $$->allocate_symtable();

            $$->symTable = $2->symTable;
        }
        ;

BlockStatements:    BlockStatements BlockStatement
                    {
                        $$ = $1;
                        $$->add_child($2);
                        if($2->symTable)
                            $2->symTable->setParent($$->symTable);
                        $$->add_entries($2->stEntries);
                    }
                    | BlockStatement
                    {
                        $$ = createNode("Block");
                        $$->add_child($1);
                        
                        $$->allocate_symtable();
                        if($1->symTable)
                            $1->symTable->setParent($$->symTable);
                        $$->add_entries($1->stEntries);
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

                                $$->stEntries = $2->stEntries;
                                for(auto stEntry: $$->stEntries)
                                {
                                    assert(stEntry);
                                    stEntry->setType($1->type);
                                }
                            }
                            | VariableModifier LocalVariableType VariableDeclaratorList
                            {
                                $$ = createNode("LocalVariableDeclaration");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_child($3);

                                $$->stEntries = $3->stEntries;
                                for(auto stEntry: $$->stEntries)
                                {
                                    assert(stEntry);
                                    stEntry->setType($2->type);
                                }
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

                        $$->symTable = $3->symTable;
                        $$->stEntries = $3->stEntries;
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
                    Node* temp = createNode("WhileExpression");
                    temp->add_child($3);
                    $$->add_child(temp);
                    temp = createNode("WhileBody");
                    temp->add_child($5);
                    $$->add_child(temp);

                    $$->symTable = $5->symTable; 
                }

WhileStatementNoShortIf:    WHILE LeftParenthesis Expression RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("While");
                                Node* temp = createNode("WhileExpression");
                                temp->add_child($3);
                                $$->add_child(temp);
                                temp = createNode("WhileBody");
                                temp->add_child($5);
                                $$->add_child(temp);

                                $$->symTable = $5->symTable; 
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
                        $$->add_child($3);
                        $$->add_child($4);
                        $$->add_child($6);

                        $$->symTable = $6->symTable; 
                    }
                    | FOR LeftParenthesis ForInit Semicolon  Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        Node* temp = createNode("ForInit");
                        temp->add_child($3);
                        $$->add_child(temp);
                        $$->add_child($4);
                        $$->add_child($5);
                        $$->add_child($7);

                        $$->symTable = $7->symTable;
                        $$->add_entries($3->stEntries); 
                    }
                    | FOR LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->add_child($3);
                        $$->add_child($4);
                        Node* temp = createNode("ForUpdate");
                        temp->add_child($5);
                        $$->add_child(temp);
                        
                        $$->add_child($7);

                        $$->symTable = $7->symTable; 
                    }
                    | FOR LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                
                        Node* temp = createNode("ForInit");
                        temp->add_child($3);
                        $$->add_child(temp);
                        
                       
                        $$->add_child($4);
                        $$->add_child($5);
                        temp = createNode("ForUpdate");
                        temp->add_child($6);
                        $$->add_child(temp);
                        
                        $$->add_child($8);

                        $$->symTable = $8->symTable; 
                        $$->add_entries($3->stEntries);
                    }
                    | FOR LeftParenthesis  Semicolon Expression Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->add_child($3);
                        Node* temp = createNode("ForExpression");
                        temp->add_child($4);
                        $$->add_child(temp);
                        $$->add_child($5);
                        $$->add_child($7);

                        $$->symTable = $7->symTable; 
                    }
                    | FOR LeftParenthesis ForInit Semicolon Expression Semicolon  RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        Node* temp = createNode("ForInit");
                        temp->add_child($3);
                        $$->add_child(temp);

                        $$->add_child($4);
                        
                        temp = createNode("ForExpression");
                        temp->add_child($3);
                        $$->add_child(temp);

                        $$->add_child($6);
                        $$->add_child($8);

                        $$->symTable = $8->symTable;
                        $$->add_entries($3->stEntries); 
                    }
                    | FOR LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        $$->add_child($3);
                        Node* temp = createNode("ForExpression");
                        temp->add_child($4);
                        $$->add_child(temp);
                        $$->add_child($5);
                        temp = createNode("ForUpdate");
                        temp->add_child($6);
                        $$->add_child(temp);
                        $$->add_child($8);

                        $$->symTable = $8->symTable; 
                    }
                    | FOR LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis Statement
                    {
                        $$ = createNode("For");
                        Node* temp = createNode("ForInit");
                        temp->add_child($3);
                        $$->add_child(temp);

                        $$->add_child($4);
                        temp = createNode("ForExpression");
                        temp->add_child($5);
                        $$->add_child(temp);
                        
                        $$->add_child($6);
                        
                        temp = createNode("ForUpdate");
                        temp->add_child($7);
                        $$->add_child(temp);

                        $$->add_child($9);
                        
                        $$->symTable = $9->symTable;
                        $$->add_entries($3->stEntries);
                    }
                    ;

BasicForStatementNoShortIf: FOR LeftParenthesis  Semicolon  Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->add_child($3);
                                $$->add_child($4);
                                $$->add_child($6);

                                $$->symTable = $6->symTable;
                            }
                            | FOR LeftParenthesis ForInit Semicolon  Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                Node* temp = createNode("ForInit");
                                temp->add_child($3);
                                $$->add_child(temp);
                                $$->add_child($4);
                                $$->add_child($5);
                                $$->add_child($7);

                                $$->symTable = $3->symTable;
                            }
                            | FOR LeftParenthesis  Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->add_child($3);
                                
                                Node* temp = createNode("ForExpression");
                                temp->add_child($4);
                                $$->add_child(temp);
                                
                              
                                $$->add_child($5);
                                $$->add_child($7);

                                $$->symTable = $7->symTable;

                            }
                            | FOR LeftParenthesis ForInit Semicolon Expression Semicolon RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                Node* temp = createNode("ForInit");
                                temp->add_child($3);
                                $$->add_child(temp);
                                $$->add_child($3);
                                temp = createNode("ForExpression");
                                temp->add_child($5);
                                $$->add_child(temp);
                            
                                $$->add_child($8);
                                $$->symTable = $8->symTable;
                                $$->add_entries($3->stEntries);
                            }
                            | FOR LeftParenthesis  Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->add_child($3);
                                $$->add_child($4);
                                Node* temp = createNode("ForUpdate");
                                temp->add_child($5);
                                $$->add_child(temp);
                           
                                $$->add_child($7);

                                $$->symTable = $7->symTable;
                            }
                            | FOR LeftParenthesis ForInit Semicolon  Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                Node* temp = createNode("ForInit");
                                temp->add_child($3);
                                $$->add_child(temp);
                                
                                $$->add_child($4);
                                $$->add_child($5);

                                temp = createNode("ForUpdate");
                                temp->add_child($6);
                                $$->add_child(temp);
                                
                                $$->add_child($8);

                                $$->symTable = $8->symTable;
                                $$->add_entries($3->stEntries);
                            }
                            | FOR LeftParenthesis  Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                $$->add_child($3);
                                 Node* temp = createNode("ForExpression");
                                temp->add_child($4);
                                $$->add_child(temp);
                                $$->add_child($5);

                                temp = createNode("ForUpdate");
                                temp->add_child($6);
                                $$->add_child(temp);
                               
                                $$->add_child($8);

                                $$->symTable = $8->symTable;
                            }
                            | FOR LeftParenthesis ForInit Semicolon Expression Semicolon ForUpdate RightParenthesis StatementNoShortIf
                            {
                                $$ = createNode("For");
                                Node* temp = createNode("ForInit");
                                temp->add_child($3);
                                $$->add_child(temp);
                                
                                $$->add_child($4);

                                temp = createNode("ForExpression");
                                temp->add_child($5);
                                $$->add_child(temp);
                                
                                $$->add_child($6);
                                temp = createNode("ForUpdate");
                                temp->add_child($7);
                                $$->add_child(temp);
                                
                                $$->add_child($9);

                                $$->symTable = $9->symTable;
                                $$->add_entries($3->stEntries);
                            }
                            ;

ForInit:    StatementExpressionList
            | LocalVariableDeclaration
            ;

ForUpdate:  StatementExpressionList
            ;

StatementExpressionList:    StatementExpression{
                                $$ = createNode("StatementExpressionList");
                                $$->add_child($1);

                                $$->allocate_symtable();
                                if($1->symTable)
                                    $1->symTable->setParent($$->symTable);
                                $$->add_entries($1->stEntries);
                            }
                            | StatementExpressionList Comma StatementExpression
                            {
                                $$ = $1;
                                $$->add_child($3);

                                if($3->symTable)
                                    $3->symTable->setParent($$->symTable);
                                $$->add_entries($3->stEntries);
                            }
                            ;

EnhancedForStatement:   FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis Statement
                        {
                            $$ = createNode("For");
                            $$->add_child($3);
                            $$->add_child($5);
                            $$->add_child($7);

                            $$->symTable = $7->symTable;
                            $$->add_entries($3->stEntries);
                        }
                        ;

EnhancedForStatementNoShortIf:  FOR LeftParenthesis LocalVariableDeclaration COLON Expression RightParenthesis StatementNoShortIf
                                {
                                    $$ = createNode("For");
                                    $$->add_child($3);
                                    $$->add_child($5);
                                    $$->add_child($7);

                                    $$->symTable = $7->symTable;
                                    $$->add_entries($3->stEntries);
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
                        $$ = createNode("ContinueStatement");
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
                                                Node* temp = createNode("MethodInvocation");
                                                $$->add_child($1);
                                                temp->add_child($2);
                                                $$->add_child(temp);

                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                Node* temp = createNode("MethodInvocation");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                temp->add_child($3);
                                                $$->add_child(temp);
                                            }
                                            | NEW ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                Node* temp = createNode("MethodInvocation");
                                                $$->add_child($1);
                                                temp->add_child($2);
                                                temp->add_child($4);
                                                $$->add_child(temp);
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                Node* temp = createNode("MethodInvocation");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                temp->add_child($3);
                                                temp->add_child($5);
                                                $$->add_child(temp);
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
                                                $$->add_child($4);
                                            }
                                            | NEW TypeArguments ClassOrInterfaceTypeToInstantiate LeftParenthesis ArgumentList RightParenthesis ClassBody
                                            {
                                                $$ = createNode("UnqualifiedClassInstanceCreationExpression");
                                                $$->add_child($1);
                                                $$->add_child($2);
                                                $$->add_child($3);
                                                $$->add_child($5);
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
                    $$ = createNode(".");
                    $$->add_child($1);
                    $$->add_child($3);

                }
                | SUPER Dot Identifier
                {
                    $$ = createNode(".");
                    $$->add_child($1);
                    $$->add_child($3);
                }
                | TypeName Dot SUPER Dot Identifier
                {
                    $$ = createNode(".");
                    $$->add_child($5);
                    $2->add_child($1);
                    $2->add_child($3);
                    $$->add_child($2);
                    

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
                        $$->add_child($3);
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
                        $$->add_child($5);

                        $$->stEntries = $1->stEntries;
                    }
                    | TypeName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_child($6);

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
                        $$->add_child($5);
                    }
                    | ExpressionName Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_child($6);
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
                        $$->add_child($5);
                    }
                    | Primary Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_child($6);
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
                        $$->add_child($5);
                    }
                    | SUPER Dot TypeArguments Identifier LeftParenthesis ArgumentList RightParenthesis
                    {
                        $$ = createNode("MethodInvocation");
                        $2->add_child($1);
                        $2->add_child($4);
                        $$->add_child($2);
                        $$->add_child($6);
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
                        $$->add_child($7);

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
                        $$->add_child($8);
                        
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
                                $$->add_child($3);

                            }
                            | NEW UnannClassOrInterfaceType DimExprs
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_child($3);
                            }
                            | NEW PrimitiveType DimExprs Dims
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_child($3);
                            }
                            | NEW UnannClassOrInterfaceType DimExprs Dims
                            {
                                $$ = createNode("ArrayCreationExpression");
                                $$->add_child($1);
                                $$->add_child($2);
                                $$->add_child($3);
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
                $$->exprType = 1;
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
                                $$->exprType = 0;
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            ;

ConditionalAndExpression:   InclusiveOrExpression
                            | ConditionalAndExpression AND InclusiveOrExpression
                            {
                                $$ = createNode("&&");
                                $$->exprType = 0;
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            ;

InclusiveOrExpression:  ExclusiveOrExpression
                        | InclusiveOrExpression BITOR ExclusiveOrExpression
                        {
                            $$ = createNode("|");
                            $$->exprType = 0;
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        ;

ExclusiveOrExpression:  AndExpression
                        | ExclusiveOrExpression CARET AndExpression
                        {
                            $$ = createNode("^");
                            $$->exprType = 0;
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        ;

AndExpression:  EqualityExpression
                | AndExpression BITAND EqualityExpression
                {
                    $$ = createNode("&");
                    $$->exprType = 0;
                    $$->add_child($1);
                    $$->add_child($3);
                }
                ;

EqualityExpression: RelationalExpression
                    | EqualityExpression EQUAL RelationalExpression
                    {
                        $$ = createNode("==");
                        $$->exprType = 0;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | EqualityExpression NOTEQUAL RelationalExpression
                    {
                        $$ = createNode("!=");
                        $$->exprType = 0;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

RelationalExpression:   ShiftExpression
                        | RelationalExpression LT ShiftExpression
                        {
                            $$ = createNode("<");
                            $$->exprType = 0;
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression GT ShiftExpression
                        {
                            $$ = createNode(">");
                            $$->exprType = 0;
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression LE ShiftExpression
                        {
                            $$ = createNode("<=");
                            $$->exprType = 0;
                            $$->add_child($1);
                            $$->add_child($3);
                        }
                        | RelationalExpression GE ShiftExpression
                        {
                            $$ = createNode(">=");
                            $$->exprType = 0;
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
                        $$->exprType = 0;
                        $$->add_child($1); 
                        $$->add_child($3);
                    }
                    | ShiftExpression RSHIFT AdditiveExpression
                    {
                        $$ = createNode(">>");
                        $$->exprType = 0;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | ShiftExpression URSHIFT AdditiveExpression
                    {
                        $$ = createNode(">>>");
                        $$->exprType = 0;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

AdditiveExpression: MultiplicativeExpression
                    | AdditiveExpression ADD MultiplicativeExpression
                    {
                        $$ = createNode("+");
                        $$->exprType = 0;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    | AdditiveExpression SUB MultiplicativeExpression
                    {
                        $$ = createNode("-");
                        $$->exprType = 0;
                        $$->add_child($1);
                        $$->add_child($3);
                    }
                    ;

MultiplicativeExpression:   UnaryExpression
                            | MultiplicativeExpression MUL UnaryExpression
                            {
                                $$ = createNode("*");
                                $$->exprType = 0;
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            | MultiplicativeExpression DIV UnaryExpression
                            {
                                $$ = createNode("/");
                                $$->exprType = 0;
                                $$->add_child($1);
                                $$->add_child($3);
                            }
                            | MultiplicativeExpression MOD UnaryExpression
                            {
                                $$ = createNode("%");
                                $$->exprType = 0;
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
                            $$->exprType = 0;
                            $$->add_child($1);
                            $$->add_child($2);
                        }
                        ;

PreDecrementExpression: DEC UnaryExpression
                        {
                            $$ = createNode("PreDecrementExpression");
                            $$->exprType = 0;
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
            $$ = createNode("Dims");
            $$->add_child(createNode("[ ]"));

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
                    $$->add_child($2);
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
            {
                    $$ = createNode("Identifier");
                    $$->add_child($1);
            }
            ;

TypeIdentifier: IdentifierChars
                {
                }
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
