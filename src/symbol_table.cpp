#include "symbol_table.h"

using namespace compiler;

/*
Print all entries of a particular tableMap (of a symbol table)
PARAM: scope -- tableMap which contains all symbol table entries
*/
void printScope(const std::unordered_map<std::string, symbolTable::SymbolTableEntry*>& scope)
{
    
    for(auto [lexeme, stEntry]: scope)
    {
        std::cerr << "Lexeme: " << lexeme << "\n";
        stEntry->print();
    }
    
}

/*
Print a particular symbol table entry (lexeme: attributes)
PARAM: None
*/
void symbolTable::Entry::print__()
{
    std::cerr << "Name: " << name_ << " Type: ";
    if(type_ != types::c_NONE_TYPE) std::cerr << type_.printable();
    else
    {
        assert(functionType_.returnType() != c_NONE_TYPE);
        std::cerr << functionType_.printable();
    }
    std::cerr << '\n';
    std::cerr << "Size: " << size_ << " LoDecl: " << declarationLine_ << '\n';
    std::cerr << std::hex;
    std::cerr << "Address: " << address_ << '\n';
    std::cerr << std::dec;
    std::cerr<<"\n";
}

/*
Insert symbol table variable entry.
PARAM: entry -- Symbol Table Variable Entry to be inserted
*/
void symbolTable::Table::insertVariable(symbolTable::Entry *entry)
{
    assert(entry);
    symbolTable::VariableKey key = entry->name;
    this->variableTableMap_[key] = entry;
}

/*
Insert symbol table function entry.
PARAM: entry -- Symbol Table Function Entry to be inserted
*/
void symbolTable::Table::insertFunction(symbolTable::Entry *entry)
{
    assert(entry);
    symbolTable::FunctionKey key(entry->name(), entry->functionType());
    this->functionTableMap_[key] = entry;
}

/*
Lookup a variable entry in the symbol table.
Starting from the current scope (represented by a Table*),
go up all the parent scopes and search.
PARAM: key -- key to be searched (Variable name)
*/
symbolTable::Entry* symbolTable::Table::lookupVariable
(symbolTable::VariableKey key)
{
    for(auto table = this; table != nullptr; table = table->parentTable_)
    {
        if(table->variableTableMap_.find(key) != table->variableTableMap_.end())
            return table->variableTableMap_[key];
    }
    return nullptr;
}

/*
Lookup a function entry in the symbol table.
Starting from the current scope (represented by a Table*),
go up all the parent scopes and search.
PARAM: key -- key to be searched ( pair(func name, func type fingerprint) )
*/
symbolTable::Entry* symbolTable::Table::lookupFunction
(symbolTable::FunctionKey key)
{
    for(auto table = this; table != nullptr; table = table->parentTable_)
    {
        if(table->functionTableMap_.find(key) != table->functionTableMap_.end())
            return table->functionTableMap_[key];
    }
    return nullptr;
}

// symbolTable::Entry* symbolTable::currentScopeLookup(const std::string& name)
// {
//     auto symTable = this; 
//     if(symTable->tableMap.find(name) != symTable->tableMap.end())
//         return symTable->tableMap[name];
    
//     return nullptr;
// }

/*
Set the parent symbol table of the symbol table.
PARAM: parent -- Pointer to Symbol Table to be set as parent
*/
void symbolTable::Table::setParent(symbolTable::Table *parent)
{
    this->parentTable_ = parent;
    parent->add_child__(this);
}

/*
Print all symbol tables corresponding to all nested scopes,
starting from the current scope; we move to parent scope by
going to the parent symbol table.
PARAM: None
*/
void symbolTable::Table::print__()
{
    std::cerr << "~~~~~~~~~~ BEGIN PRINTING TABLE ~~~~~~~~~~\n\n";
    std::cerr << "Open Scopes:\n";
    for(auto table = this; table != nullptr; table = table->parentTable_)
    {
        printScope(table->variableTableMap_);
        printScope(table->functionTableMap_);
    }
    std::cerr << "\n~~~~~~~~~~ END PRINTING TABLE ~~~~~~~~~~\n";
}

void symbolTable::Table::add_child__(SymbolTable* symTable)
{
    this->childTables.push_back(symTable);
}

void SymbolTable::printAll__(void)
{
    std::cerr << "\n~~~~~ BEGIN PRINTING SCOPE ~~~~~\n";
    printScope(variableTableMap_);
    printScope(functionTableMap_);
    for(auto childTable: this->childTables)
        childTable->__printAll();
    std::cerr << "~~~~~ END PRINTING SCOPE ~~~~~\n";
}

void SymbolTableEntry::_addToCSV(std::ofstream& ofs)
{
    ofs << "IDENTIFIER," << name << "," << type << ",";
    ofs <<  dimension << "," << declLine << '\n';
}

void SymbolTable::_csvDumpWithoutHeader(std::ofstream& ofs)
{
    for(auto [lexeme, stEntry]: this->tableMap)
        stEntry->_addToCSV(ofs);
    
    for(auto symTable: this->childTables)
        symTable->_csvDumpWithoutHeader(ofs);
}

void SymbolTable::csvDump(std::ofstream& ofs)
{
    std::string csvColumnNames = "Token,Lexeme,Type,Dimensions,Line of Declaration";
    ofs << csvColumnNames << '\n';
    this->_csvDumpWithoutHeader(ofs);
}