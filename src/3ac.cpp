#include "3ac.h"
#include <vector>
#include <string>
#include <map>
#include <fstream>

std::vector<quad> code;

int counter = 0;
int printAC= 0;
std::ofstream tac_file, tac_file1;

std::vector<std::string> split3ac(std::string str , char delim){
    std::vector<std::string> res;
    std::string temp="";
	
    for(auto character: str){
		if(character!=delim){
			temp.push_back(character);
		}
		else {
			res.push_back(temp);
			temp="";
		}
	}
	res.push_back(temp);
	return res;


}
quad generate(qid op, qid arg1, qid arg2, qid res, int idx)
{
    quad qd(op, arg1, arg2, res, idx);
    if(idx == -1) qd.index = code.size();
    // code.push_back(qd);
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
    assert(currSymTable);
    currSymTable->insert(tmp, stEntry);
    counter++;
    return qid(tmp, currSymTable->lookup(tmp));
}

qid newtempstar(std::string type, SymbolTable* currSymTable)
{
    std::string tmp = "*$t" + std::to_string(counter);
    int address = 0, dimension = 0, decLine = 0, size = 0;
    SymbolTableEntry* stEntry = new SymbolTableEntry(tmp, type, size, dimension, decLine, address);
    assert(currSymTable);
    currSymTable->insert(tmp, stEntry);
    counter++;
    return qid(tmp, currSymTable->lookup(tmp));
}

int width(qid operand)
{
    if(operand.first[0] == '*'){
        auto var = operand;
        auto parts = split3ac(var.first,'_');
        std::string varName = split3ac(var.first,'_')[0];

        varName = varName.substr(1, varName.length() -1);
        std::string memSize = split3ac(var.first,'_')[1];
        std::cerr<< varName<<" UUU "<<memSize<<"\n";
        return stoi(memSize);
    }
    else if(operand.first[0] == '$')
    {
        //   std::string type = operand.second->getType();
        //   std::cerr<<  "______________\n"+operand.first<<"\n";
        //   std::cerr<<"type " + type<<"\n";
          return 8; // temporary
    }
    else if(operand.second)
    {
        // variable
        std::string type = operand.second->getType();
        std::map<std::string, int> integralTypeToWidth {
            {"boolean", 1},
            {"byte", 1},
            {"boolean" , 1},
            {"char", 1},
            {"short", 2},
            {"int", 4},
            {"long", 8}
        };
        std::cerr<<  "______________\n"+operand.first<<"\n";
        std::cerr<<"type " + type<<"\n";
        int width = 8; // default for custom types, it's a pointer
        if(integralTypeToWidth.find(type) != integralTypeToWidth.end())
        {
            width = integralTypeToWidth[type];
        }
        return width;
    }
    else return 8; // constant
}

void print3AC1(std::vector<quad> code, std::string fileName)
{
    qid emptyQid = qid("", NULL);

    tac_file1.open(fileName);
    for(auto codeLine: code)
    {   
        
        
        if(codeLine.oper.first == "IfFalse"){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first<<" " << codeLine.argument1.first << " goto " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "IfTrue"){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first << " "<<codeLine.argument1.first << " goto " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "Else"){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first << " "<<codeLine.argument1.first << " goto " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "Ternary")
        {
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first << " "<<codeLine.argument1.first << " goto " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first[0] == '$' && codeLine.oper.first[1] == 'L'){
            tac_file1  <<codeLine.oper.first << codeLine.argument2.first <<":";
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first[0] == '$' && codeLine.oper.first[1] == 'g' && codeLine.oper.first[2] == 'o' && codeLine.oper.first[3] == 't' && codeLine.oper.first[4] == 'o'){
            std::string str;
            int cnt=0;
            for(auto x: codeLine.oper.first){
                if(cnt!=0 && x!='$'){
                    str.push_back(x);
                }
                else cnt++;
            }
            tac_file1<<"     "<<"";
            tac_file1 << ""<<str<< codeLine.argument1.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first[0] == 'C' && codeLine.oper.first[1] == 'A' && codeLine.oper.first[2] == 'S' && codeLine.oper.first[3] == 'T' && codeLine.oper.first[4] == '_'){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.result.first << " = ";
            tac_file1 << codeLine.oper.first<<" "<<codeLine.argument1.first << " " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        // else if(codeLine.oper.first == "CALL" && codeLine.argument1.first != "println"){
        //     tac_file1<<"    "<<" ";
        //     tac_file1 << codeLine.result.first << " = ";
        //     tac_file1 << codeLine.oper.first<<" "<<codeLine.argument1.first <<" "<< codeLine.argument2.first;
        //     tac_file1 << "\n";
        // }
        else if(codeLine.oper.first == "CALL" /*&& codeLine.argument1.first == "println"*/){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first<<" ";
            tac_file1 << codeLine.argument1.first << " " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "push"){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first<<" ";
            tac_file1 << codeLine.argument1.first << " " << codeLine.argument2.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "pop"){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first <<" "<< codeLine.argument1.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first[0] == '#'){
            std::string str;
            int cnt=0;
            for(auto x: codeLine.oper.first){
                if(cnt!=0 && x!='#'){
                    str.push_back(x);
                }
                else cnt++;
            }
           
            tac_file1 << codeLine.argument1.first << ""<<str<< codeLine.argument2.first<<":";
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "[ ]" && codeLine.argument2.first[0]=='$'){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.result.first << " = ";
            tac_file1 << codeLine.argument1.first << " [ " <<codeLine.argument2.first <<" ]";
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "RETURN"){
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.oper.first << " " <<codeLine.argument1.first;
            tac_file1 << "\n";
        }
        else if(codeLine.oper.first == "ret"){
            tac_file1<<"     ret"<<"\n";
        }
        else{
            tac_file1<<"    "<<" ";
            tac_file1 << codeLine.result.first << " = ";
            tac_file1 << codeLine.argument1.first << " "<<codeLine.oper.first << " " <<codeLine.argument2.first;
            tac_file1 << "\n";
        }

    }
    tac_file1<< "\n";
    tac_file1.close();

}

