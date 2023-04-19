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
	std::map<std::string, pair<std::string, int>> regs;
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
	std::map<std::string, pair<std::string, std::string>> locations;
    
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
    std::vector<string> x86;
    // input 3AC code to be converted to x86
    std::vector<quad> tacCode;
    // Instance of the registers class to generate x86
    Registers registers;
    // to store constants to be added in the data section
    std::vector<string> constants;
    // offset to assign temporary a memory address
    int tempoffset;

	X86(std::vector<quad> _tacCode);
	void codeGen(void);
	std::vector<std::string> tac2x86(quad instruction);
    std::string getMemLocation(qid , bool , vector<string>&);
};

#endif