#include "symbol_table.h"

/*
Insert symbol table entry.
PARAM: name -- Lexeme
PARAM: stEntry -- Symbol Table Entry to be inserted
*/
void SymbolTable::insert(const std::string& name, SymbolTableEntry *stEntry)
{
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
}

/*
Print a particular symbol table entry (lexeme: attributes)
PARAM: None
*/
void SymbolTableEntry::print()
{
    std::cout << "Name: " << name << " Type: " << type << '\n';
    std::cout << "Size: " << size << " Dim: " << dimension;
    std::cout << " LoDecl: " << declLine << '\n';
    std::cout << std::hex;
    std::cout << "Address: " << address << '\n';
    std::cout << std::dec;
    std::cout << '\n';
}

/*
Print all entries of a particular tableMap (of a symbol table)
PARAM: scope -- tableMap which contains all symbol table entries
*/
void printScope(const std::unordered_map<std::string, SymbolTableEntry*>& scope)
{
    std::cout << "\n~~~~~ BEGIN PRINTING SCOPE ~~~~~\n";
    for(auto [lexeme, stEntry]: scope)
    {
        std::cout << "Lexeme: " << lexeme << "\n";
        stEntry->print();
    }
    std::cout << "~~~~~ END PRINTING SCOPE ~~~~~\n";
}

/*
Print all symbol tables corresponding to all nested scopes,
starting from the current scope; we move to parent scope by
going to the parent symbol table.
PARAM: Noneg
*/
void SymbolTable::print()
{
    std::cout << "~~~~~~~~~~ BEGIN PRINTING TABLE ~~~~~~~~~~\n\n";
    std::cout << "Open Scopes:\n";
    for(auto symTable = this; symTable != nullptr; symTable = symTable->parentTable)
    {
        printScope(symTable->tableMap);
    }
    std::cout << "\n~~~~~~~~~~ END PRINTING TABLE ~~~~~~~~~~\n";
}
