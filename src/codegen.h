#ifndef CODEGEN_H
#define CODEGEN_H

#include "3ac.h"
#include <map>
#include <string>
#include <vector>
#include <utility>
#include <set>

class Registers
{
public:
    // < regName , < VariableName , lastTimeUsed >>
	std::map<std::string, std::pair<std::string, int>> regs;
    // stores all the argumentRegisters
	std::vector<std::string> argumentRegs;
    // stores the caller saved registers
    std::vector<std::string> callerSaved ;
    // stores the calle saved registers
	std::vector<std::string> calleeSaved ;
    // < RegName, placeHolder for lastByte>
	std::map<std::string, std::string> lastByte;
    
	std::string rip, rbp;
    // < variableName , < regName , memoryLocation >>
	std::map<std::string, std::pair<std::string, std::string>> locations;
    
    int timestamp; 

	Registers(void);

    // selectReg() selects a register to use next based on LRU scheme
    std::string selectReg(void);

	std::vector<std::string> writeBack(std::vector<std::string> writeRegs, bool flush);

    // this function tells whether varName has been assigned a register/memory location
    bool inLocations(std::string varName);

    // this function is to get the register for a variable 
    std::pair<std::string, std::vector<std::string>> getRegister(std::string varName);
};

class X86
{
public:
    // stores the final x86 code
    std::vector<std::string> x86;
    // input 3AC code to be converted to x86
    std::vector<quad> tacCode;
    // Instance of the registers class to generate x86
    Registers registers;
    // to store constants to be added in the data section
    std::vector<std::string> constants;
    // offset to assign temporary a memory address
    int tempoffset;

	std::map<int, char> sizeSuffix{{1, 'b'}, {2, 'w'}, {4, 'l'}, {8, 'q'}};
	std::map<std::string, std::string> operToInstrALU {
		{"+", "add"},
		{"-", "sub"},
		{"*", "imul"},
		{"/", "div"},
		{"&", "and"},
		{"|", "or"},
		{"^", "xor"}
	};
	std::map<std::string, std::string> operToInstrSet {
		{"<", "setl"},
		{"<=", "setle"},
		{">", "setg"},
		{">=", "setge"},
		{"==", "sete"},
		{"!=", "setne"}
	};
	std::vector<std::map<int, std::string>> widthToReg {
		{
			{1, "%cl"},
			{2, "%cx"},
			{4, "%ecx"},
			{8, "%rcx"}
		},
		{
			{1, "%dl"},
			{2, "%dx"},
			{4, "%edx"},
			{8, "%rdx"}
		}
        ,
        {
			{1, "%sil"},
			{2, "%si"},
			{4, "%esi"},
			{8, "%rsi"}
		}

	};

	X86(std::vector<quad> _tacCode);
	void codeGen(void);
	std::vector<std::string> tac2x86(quad instruction);
    std::string getMemLocation(qid var, std::vector<std::string>& code);
	std::string getLoadInstr(std::string address, int width, int regNum); // width = 1,2,4 or 8
	std::string getStoreInstr(std::string address, int width, int regNum); // width = 1,2,4 or 8
	std::string getALUInstr(std::string oper);
};

#endif