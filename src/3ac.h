#ifndef THREE_AC_H
#define THREE_AC_H
#include <bits/stdc++.h>
#include "symbol_table.h"
using namespace std;

typedef std::pair <std::string, SymbolTableEntry*> qid;

typedef struct Quadruple
{
    qid oper, argument1, argument2, result;
    int index;
public:
    Quadruple(qid op, qid arg1, qid arg2, qid res, int idx)
    :oper{op}, argument1{arg1}, argument2{arg2}, result{res}, index{idx} {}
} quad;


quad generate(qid oper, qid arg1, qid arg2, qid res, int idx);
void backpatch(std::vector<int>&, int);
qid newtemp(std::string , SymbolTable* );
qid newtempstar(std::string , SymbolTable* );
void print3AC();
void print3AC(std::vector<quad>);
void print3AC1(std::vector<quad>);

#endif
