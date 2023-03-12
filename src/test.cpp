#include "symbol_table.h"

int main()
{
    SymbolTable *st = new SymbolTable[3];
    st[0].insert("x", new SymbolTableEntry);
    st[1].setParent(&st[0]);
    st[1].insert("y", new SymbolTableEntry);
    st[1].insert("z", new SymbolTableEntry);
    st[2].setParent(&st[0]);
    st[2].insert("w", new SymbolTableEntry);
    st[0].__printAll();
    delete[] st;
    return 0;
}