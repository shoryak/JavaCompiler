#include "symbol_table.h"

/*
Print all entries of a particular tableMap (of a symbol table)
PARAM: scope -- tableMap which contains all symbol table entries
*/
void printScope(const std::unordered_map<std::string, SymbolTableEntry*>& scope)
{
    
    for(auto [lexeme, stEntry]: scope)
    {
        std::cerr << "Lexeme: " << lexeme << "\n";
        stEntry->print();
    }
    
}

/*
Get the lexeme (name) from the Symbol Table Entry
PARAM: None
*/
std::string SymbolTableEntry::getName(void)
{
    return name;
}

/*
Set the type in this Symbol Table Entry
PARAM: type -- type to be set
*/
void SymbolTableEntry::setType(std::string type)
{
    this->type = type;
}

/*
Get the type in this Symbol Table Entry
*/
std::string SymbolTableEntry::getType()
{
    return this->type;
}

/*
Get the declLine in this Symbol Table Entry
*/
int SymbolTableEntry::getDeclLine()
{
    return this->declLine;
}

/*
Get the funcproto in this Symbol Table Entry
*/
funcproto SymbolTableEntry::getFuncProto(){
    return this->functionProto;
}

/*
Set the dimension in this Symbol Table Entry
PARAM: dimension -- dimension to be set
*/
void SymbolTableEntry::setDimension(int32 dimension)
{
    this->dimension = dimension;
}

/*
Print a particular symbol table entry (lexeme: attributes)
PARAM: None
*/
void SymbolTableEntry::print()
{
    std::cerr << "Name: " << name << " Type: " << type << '\n';
    std::cerr << "Size: " << size << " Dim: " << dimension;
    std::cerr << " LoDecl: " << declLine << '\n';
    std::cerr << std::hex;
    std::cerr << "Address: " << address << '\n';
    std::cerr << std::dec;
  
    if(type == "$func"){
        std::cerr << "Number of Arguments "<< functionProto.numArgs<< '\n';
        std::cerr << "Types of Arguments \n";
        int pos = 1;
        for(auto tp : functionProto.argTypes){
            std::cerr<< "Type "<<pos <<"   "<< tp<< '\n';
            pos++;
        }
    }
     std::cerr << '\n';

}

/*
Insert symbol table entry.
PARAM: name -- Lexeme
PARAM: stEntry -- Symbol Table Entry to be inserted
*/
void SymbolTable::insert(std::string name, SymbolTableEntry *stEntry)
{
    assert(stEntry != nullptr);
    tableMap[name] = stEntry;
}

/*
Insert symbol table entry.
PARAM: stEntry -- Symbol Table Entry to be inserted
*/
void SymbolTable::insert(SymbolTableEntry *stEntry)
{
    assert(stEntry);
    std::string name = stEntry->getName();
    while(name.back() == ' '){
        name.pop_back();
    }
    int ind = name.length()-1;
    while(ind>0 &&  name[ind-1]!=' ') {
        ind--;
    }
    tableMap[name.substr(ind , name.length()-ind )] = stEntry;
}

/*
Lookup an entry in the symbol table.
Starting from the current scope (represented by a SymbolTable*),
go up all the parent scopes and search.
PARAM: name -- Lexeme to be searched
*/
SymbolTableEntry* SymbolTable::lookup(const std::string& name)
{
    for(auto symTable = this; symTable != nullptr; symTable = symTable->parentTable)
    {
        // std::cerr<<name<<std::endl;
        // for(auto i : symTable->tableMap){
        //     std::cerr<<i.first<<std::endl;
        // }
        if(symTable->tableMap.find(name) != symTable->tableMap.end())
            return symTable->tableMap[name];
    }
    return nullptr;
}

SymbolTableEntry* SymbolTable::currentScopeLookup(const std::string& name)
{
    auto symTable = this; 
    if(symTable->tableMap.find(name) != symTable->tableMap.end())
        return symTable->tableMap[name];
    
    return nullptr;
}

/*
Set the parent symbol table of the symbol table.
PARAM: parent -- Pointer to Symbol Table to be set as parent
*/
void SymbolTable::setParent(SymbolTable *parent)
{
    parentTable = parent;
    parent->__add_child(this);
}

/*
Get the parent symbol table of the symbol table.
PARAM: None
*/
SymbolTable* SymbolTable::getParent()
{
    return parentTable;
}

/*
Print all symbol tables corresponding to all nested scopes,
starting from the current scope; we move to parent scope by
going to the parent symbol table.
PARAM: Noneg
*/
void SymbolTable::print()
{
    std::cerr << "~~~~~~~~~~ BEGIN PRINTING TABLE ~~~~~~~~~~\n\n";
    std::cerr << "Open Scopes:\n";
    for(auto symTable = this; symTable != nullptr; symTable = symTable->parentTable)
    {
        printScope(symTable->tableMap);
    }
    std::cerr << "\n~~~~~~~~~~ END PRINTING TABLE ~~~~~~~~~~\n";
}

void SymbolTable::__add_child(SymbolTable* symTable)
{
    childTables.push_back(symTable);
}

void SymbolTable::__printAll()
{
    std::cerr << "\n~~~~~ BEGIN PRINTING SCOPE ~~~~~\n";
    printScope(tableMap);
    for(auto childTable: childTables) childTable->__printAll();
    std::cerr << "~~~~~ END PRINTING SCOPE ~~~~~\n";
}