#include "3ac.h"
using namespace std;

vector<quad> code;

int counter = 0;

void add_quad(qid op, qid arg1, qid arg2, qid res, int idx){
    quad qd;
    qd.op = op , qd.arg1 = arg1 , qd.arg2 = arg2 , qd.res = res;
    if(idx == -1) {
        qd.idx = code.size();
    }
    else {
        qd.idx=idx;
    }
    code.push_back(qd);
}

void backpatch(vector<int>& list, int target){
    for(auto codeid : list){
        code[codeid].idx = target;
    }
}

qid newtemp(string type , SymbolTable* currSymTable){
    string tmp = "#V"+to_string(counter);
    int address = 0 , dimension = 0 , decLine = 0 , size = 0;
    SymbolTableEntry* stEntry = new SymbolTableEntry(tmp ,type , size , dimension, decLine, address );
    currSymTable->insert( tmp,stEntry );
    counter+=1;
    return qid(tmp, currSymTable->lookup(tmp));
}