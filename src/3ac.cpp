#include "3ac.h"
#include <vector>
#include <string>
#include<fstream>

std::vector<quad> code;

int counter = 0;

quad generate(qid op, qid arg1, qid arg2, qid res, int idx)
{
    quad qd(op, arg1, arg2, res, idx);
    if(idx == -1) qd.index = code.size();
    code.push_back(qd);
    return qd;
}

void backpatch(std::vector<int>& list, int target)
{
    for(auto codeid: list)
        code[codeid].index = target;
}

qid newtemp(std::string type, SymbolTable* currSymTable)
{
    std::string tmp = "$t" + std::to_string(counter);
    int address = 0, dimension = 0, decLine = 0, size = 0;
    SymbolTableEntry* stEntry = new SymbolTableEntry(tmp, type, size, dimension, decLine, address);
    currSymTable->insert(tmp, stEntry);
    counter+=1;
    return qid(tmp, currSymTable->lookup(tmp));
}

void print3AC(){
    qid emptyQid = qid("", NULL);
    std::ofstream tac_file;
    tac_file.open("intermediate_3ac.csv");
    for(int i=0;i<code.size(); i++){
        tac_file<<code[i].oper.first<<","<<code[i].argument1.first<<","<<code[i].argument2.first<<","<<code[i].result.first<<","<<code[i].index<<","<<i<<endl;
    }
    tac_file.close();
    tac_file.open("intermediate_3ac.txt");
    for(auto codeLine: code)
    {
        tac_file << codeLine.result.first << " = ";
        tac_file << codeLine.argument1.first << codeLine.oper.first << codeLine.argument2.first;
        tac_file << '\n';
    }
    tac_file.close();
}

void print3AC(std::vector<quad> code){
    qid emptyQid = qid("", NULL);
    std::ofstream tac_file;
    tac_file.open("intermediate_3ac.csv");
    for(int i=0;i<code.size(); i++){
        tac_file<<code[i].oper.first<<","<<code[i].argument1.first<<","<<code[i].argument2.first<<","<<code[i].result.first<<","<<code[i].index<<","<<i<<endl;
    }
    tac_file.close();
    tac_file.open("intermediate_3ac.txt");
    for(auto codeLine: code)
    {
        tac_file << codeLine.result.first << " = ";
        tac_file << codeLine.argument1.first << codeLine.oper.first << codeLine.argument2.first;
        tac_file << '\n';
    }
    tac_file.close();
}

