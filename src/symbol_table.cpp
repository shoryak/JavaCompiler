#include "symbol_table.h"

void SymbolTable::insert(const std::string& name, SymbolTableEntry *stEntry)
{
    tableMap[name] = stEntry;
}

SymbolTableEntry* SymbolTable::lookup(const std::string& name)
{
    for(auto symTable = this; symTable != nullptr; symTable = symTable->parentTable)
    {
        if(symTable->tableMap.find(name) != symTable->tableMap.end())
            return symTable->tableMap[name];
    }
    return nullptr;
}

void SymbolTable::setParent(SymbolTable *parent)
{
    parentTable = parent;
}

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
