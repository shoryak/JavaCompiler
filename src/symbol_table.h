#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <unordered_map>
#include <string>
#include <vector>
#include <iostream>
#include <cassert>
#include "types.h"

class SymbolTable; // Forward declaration

// structure of function prototype for storing number and types of args
struct funcproto{
    int32 numArgs;
    std::vector<std::string> argTypes;
    std::vector<int> argSizes;
    std::vector<int> argDims;

    funcproto(){
        numArgs=0;
    }
};

class SymbolTableEntry {
    // Type of the identifier
    std::string name, type;

    // Identifier size (in bytes),
    // dimension (0 for primitive type, 1 for 1D array etc.)
    // line of declaration
    int32 size, dimension, declLine;

    // Address of the Identifier
    uint64 address;

    // stores number and types of arguments for functions/constructor methods
    funcproto functionProto;

public:
    SymbolTableEntry(void): name{""},type{""}, size{-1}, dimension{-1}, declLine{-1}, address{0} {}
    SymbolTableEntry(
        std::string name, std::string type,
        int32 size, int32 dimension, int32 declLine,
        uint64 address
    )
    : name{name}, type{type}, size{size}, dimension{dimension},
    declLine{declLine}, address{address} {}
    SymbolTableEntry(
        std::string name, std::string type,
        int32 size, int32 dimension, int32 declLine,
        uint64 address , funcproto functionProto
    )
    : name{name}, type{type}, size{size}, dimension{dimension},
    declLine{declLine}, address{address}, functionProto{functionProto} {}
    std::string getName(void);
    void setType(std::string type);
    void setDimension(int32 dimension);
    void print(void);
};

class SymbolTable {
    // The identifier name is already stored in the map
    // No need for it in the symbol table entry
    std::unordered_map<std::string, SymbolTableEntry*> tableMap;
    SymbolTable *parentTable;
    std::vector<SymbolTable*> childTables;

public:
    SymbolTable(void): parentTable{nullptr} {}
    SymbolTable(SymbolTable *parentSymbolTable): parentTable{parentSymbolTable}
    {
        parentSymbolTable->__add_child(this);
    }
    void insert(std::string name, SymbolTableEntry *stEntry);
    void insert(SymbolTableEntry *stEntry);
    SymbolTableEntry* lookup(const std::string& name);
    void setParent(SymbolTable *parent);
    SymbolTable* getParent(void);
    void print(void);
    void __add_child(SymbolTable* symTable);
    void __printAll(void);
};

#endif
