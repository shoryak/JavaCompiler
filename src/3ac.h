#ifndef THREE_AC_H
#define THREE_AC_H
#include<bits/stdc++.h>
#include"symbol_table.h"
using namespace std;

typedef std::pair <std::string , SymbolTableEntry*> qid;

typedef struct Quadruple{
    qid op;
    qid arg1;
    qid arg2;
    qid res;
    int idx;
}quad;


void add_quad(qid, qid , qid , qid , int );
void backpatch(vector<int>& , int);
qid newtemp(string );

#endif

