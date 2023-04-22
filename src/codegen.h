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

	std::string rip, rbp;
    // < variableName , < regName , memoryLocation >>
	std::map<std::string, std::pair<std::string, std::string>> locations;
    
    int timestamp; 

	Registers(void);

    // this function tells whether varName has been assigned a register/memory location
    bool inLocations(std::string varName);

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
    // index for constants for data section 
    int constIndex;


	std::map<int, char> sizeSuffix{{1, 'b'}, {2, 'w'}, {4, 'l'}, {8, 'q'}};
	std::map<std::string, std::string> operToInstrALU {
		{"+", "add"},
		{"-", "sub"},
		{"*", "imul"},
		{"/", "div"},
		{"&", "and"},
		{"|", "or"},
		{"^", "xor"},
        {"&&", "and"},
		{"||", "or"},

	};
	std::map<std::string, std::string> operToInstrSet {
		{"<", "setl"},
		{"<=", "setle"},
		{">", "setg"},
		{">=", "setge"},
		{"==", "sete"},
		{"!=", "setne"}
	};
    std::vector<std::string> pointerRegs = {"%r10" , "%r11" , "%r12"};
    
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
        ,
        {
			{1, "%al"},
			{2, "%ax"},
			{4, "%eax"},
			{8, "%rax"}
		}
        ,
        {
			{1, "%bl"},
			{2, "%bx"},
			{4, "%ebx"},
			{8, "%rbx"}
		}
        ,
        // registers for pointer operations
        {
			{1, "%r10b"},
			{2, "%r10w"},
			{4, "%r10d"},
			{8, "%r10"}
		}
        ,
        {
			{1, "%r11b"},
			{2, "%r11w"},
			{4, "%r11d"},
			{8, "%r11"}
		}
        ,
        {
			{1, "%r12b"},
			{2, "%r12w"},
			{4, "%r12d"},
			{8, "%r12"}
		}

	};

	X86(std::vector<quad> _tacCode);
	void codeGen(void);
	std::vector<std::string> tac2x86(quad instruction);
    std::string getMemLocation(qid var, std::vector<std::string>& code);
	std::string getLoadInstr(std::string address, int width, int regNum); // width = 1,2,4 or 8
	std::string getStoreInstr(std::string address, int width, int regNum); // width = 1,2,4 or 8
	std::string getALUInstr(std::string oper);
    int getPointerReg(void);
};

#endif