#include "3ac.h"
#include <vector>
#include <string>

std::vector<quad> code;

int counter = 0;

void generate(qid op, qid arg1, qid arg2, qid res, int idx)
{
    quad qd(op, arg1, arg2, res, idx);
    if(idx == -1) qd.index = code.size();
    code.push_back(qd);
}

void backpatch(std::vector<int>& list, int target)
{
    for(auto codeid: list)
        code[codeid].index = target;
}

qid newtemp(std::string type, SymbolTable* currSymTable)
{
    std::string tmp = "#V" + std::to_string(counter);
    int address = 0, dimension = 0, decLine = 0, size = 0;
    SymbolTableEntry* stEntry = new SymbolTableEntry(tmp, type, size, dimension, decLine, address);
    currSymTable->insert(tmp, stEntry);
    counter+=1;
    return qid(tmp, currSymTable->lookup(tmp));
}
