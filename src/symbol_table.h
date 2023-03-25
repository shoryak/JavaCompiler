#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <unordered_map>
#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <cassert>
#include "custom_types.h"
#include "types.h"

using namespace compiler;
namespace compiler::symbolTable
{
    class Entry
    {
    protected:
    /*  Identifier name (e.g. Variable name, function name) */
        std::string name_;
    
    /*  Booleans for modifiers: whether the identifier
        is Public/Private, Static/non-static    */
        bool bIsPublic_ = false, bIsStatic_ = false;

    /*  Identifier size (in bytes),
        Line of declaration  */
        int32 size_ = 0, declarationLine_ = -1;

    /*  Address of the Identifier   */
        uint64 address_ = 0;

    public:
    /*  Constructors    */
        Entry(void) {}

        Entry
        (
            std::string name,
            bool bIsPublic, bool bIsStatic,
            int32 size, int32 declarationLine,
            uint64 address
        ):
        name_{name}, size_{size},
        bIsPublic_{bIsPublic}, bIsStatic_{bIsStatic},
        declarationLine_{declarationLine}, address_{address} {}

        std::string name(void)
        {
            return this->name_;
        }

        int declarationLine(void)
        {
            return this->declarationLine_;
        }

    /*  Return type of the Entry:
        Variable type in the case of a variable,
        Function return type in the case of a function  */
        virtual types::Type returnType(void);

        void print__(void);
    
        void addToCSV(std::ofstream& ofs);
    };
    void addToCSV(Entry*);

    class VariableEntry: public Entry
    {
    protected:
    /*  Type of the Variable Symbol Table Entry */
        types::Type type_;

    public:
    /*  Constructors    */
        VariableEntry(void): Entry(void) {}
        VariableEntry
        (
            std::string name, types::Type type,
            bool bIsPublic, bool bIsStatic,
            int32 size, int32 declarationLine,
            uint64 address
        ):
        Entry(name, bIsPublic, bIsStatic, size, declarationLine, address),
        type_{type} {}

        types::Type type(void)
        {
            return this->type_;
        }

    /*  Return type of the Entry: Variable's type   */
        types::Type returnType(void) override
        {
            return this->type_;
        }
    };

    class FunctionEntry: public Entry
    {
    protected:
    /*  The type fingerprint of the Function Symbol Table Entry */
        types::FunctionType functionType_;
    
    public:
    /*  Constructors    */
        FunctionEntry(void): Entry(void) {}
        FunctionEntry
        (
            std::string name, types::FunctionType functionType,
            bool bIsPublic, bool bIsStatic,
            int32 size, int32 declarationLine,
            uint64 address
        ):
        Entry(name, bIsPublic, bIsStatic, size, declarationLine, address),
        functionType_{functionType} {}

        types::FunctionType functionType(void)
        {
            return this->functionType_;
        }

    /*  Return type of the Entry: Function's return type  */
        types::Type returnType(void) override
        {
            return this->functionType_->returnType();
        }
    }

    using VariableKey = std::string;
    using FunctionKey = std::pair<std::string, types::FunctionType>;
    class Table {
        /*  The actual map which maps names to Symbol Table Entries */
        std::unordered_map<VariableKey, Entry*> variableTableMap_;
        std::unordered_map<FunctionKey, Entry*> functionTableMap_;

        /*  The parent Symbol Table (i.e. one scope above)  */
        Table *parentTable_;

        /*  Children Symbol Tables (i.e. scopes inside current scope)   */
        std::vector<Table*> childTables_;

    public:
    /*  Constructors */
        Table(void): parentTable_{nullptr} {}
        Table(Table *parentTable): parentTable_{parentTable}
        {
            parentTable->__add_child(this);
        }

    /*  Insert Symbol Table Entry into Symbol Table */
        void insertVariable(Entry *entry);
        void insertFunction(Entry *entry);

    /*  Lookup Symbol Table Entry from Symbol Table
        using the proper key    */
        Entry* lookupVariable(VariableKey key);
        Entry* lookupFunction(FunctionKey key);

        /*  */
        Entry* currentScopeLookup(const std::string& name);

        /*  Set the parent of the Symbol Table to the required Symbol Table */
        void setParent(Table *parent);

        /*  Parent Symbol Table of the current Symbol Table */
        Table* parentTable(void);
        {
            return this->parentTable_;
        }

        void print__(void);
        void add_child__(SymbolTable* symTable);
        void printAll__(void);
        
        void csvDumpWithoutHeader(std::ofstream& ofs);

        /*  Dump all Symbol Table Entries of the whole scope
            (including all nested scopes inside) in CSV format  */
        void csvDump(std::ofstream& ofs);
    };
}

#endif
