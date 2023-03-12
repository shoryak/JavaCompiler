#include "symbol_table.h"

/*
Print all entries of a particular tableMap (of a symbol table)
PARAM: scope -- tableMap which contains all symbol table entries
*/
void printScope(const std::unordered_map<std::string, SymbolTableEntry*>& scope)
{
    std::cerr << "\n~~~~~ BEGIN PRINTING SCOPE ~~~~~\n";
    for(auto [lexeme, stEntry]: scope)
    {
        std::cerr << "Lexeme: " << lexeme << "\n";
        stEntry->print();
    }
    std::cerr << "~~~~~ END PRINTING SCOPE ~~~~~\n";
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
Lookup an entry in the symbol table.
Starting from the current scope (represented by a SymbolTable*),
go up all the parent scopes and search.
PARAM: name -- Lexeme to be searched
*/
SymbolTableEntry* SymbolTable::lookup(const std::string& name)
{
    for(auto symTable = this; symTable != nullptr; symTable = symTable->parentTable)
    {
        if(symTable->tableMap.find(name) != symTable->tableMap.end())
            return symTable->tableMap[name];
    }
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
    printScope(tableMap);
    for(auto childTable: childTables) childTable->__printAll();
}