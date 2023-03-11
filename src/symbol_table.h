#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <unordered_map>
#include <string>
#include <iostream>
#include "types.h"

class SymbolTable; // Forward declaration

class SymbolTableEntry {
    // Type of the identifier
    std::string name, type;

    // Identifier size (in bytes),
    // dimension (0 for primitive type, 1 for 1D array etc.)
    // line of declaration
    int32 size, dimension, declLine;

    // Address of the Identifier
    uint64 address;

public:
    SymbolTableEntry(void): name{""}, type{""}, size{-1}, dimension{-1}, declLine{-1}, address{0} {}
    SymbolTableEntry(
        std::string name, std::string type,
        int32 size, int32 dimension, int32 declLine,
        uint64 address
    )
    : name{name}, type{type}, size{size}, dimension{dimension},
    declLine{declLine}, address{address} {}
    void print(void);
};

class SymbolTable {
    // The identifier name is already stored in the map
    // No need for it in the symbol table entry
    std::unordered_map<std::string, SymbolTableEntry*> tableMap;
    SymbolTable *parentTable;

public:
    SymbolTable(void): parentTable{nullptr} {}
    SymbolTable(SymbolTable *parentSymbolTable): parentTable{parentSymbolTable} {}
    void insert(const std::string& name, SymbolTableEntry *stEntry);
    SymbolTableEntry* lookup(const std::string& name);
    void setParent(SymbolTable *parent);
    void print(void);
};

#endif
