#ifndef CODEGEN_H
#define CODEGEN_H

class Registers
{
public:
    // < regName , < VariableName , lastTimeUsed >>
	std::map<string, pair<string, int>> regs;
    // stores all the argumentRegisters
	std::vector<string> argumentRegs ;
    // stores the caller saved registers
    std::vector<string> callerSaved ;
    // stores the calle saved registers
	std::vector<string> calleeSaved ;
    // < RegName, placeHolder for lastByte>
	std::map<string, string> lastByte;
    
	std::string rip, rbp;
    // < variableName , < regName , memoryLocation >>
	std::map<string, pair<string, string>> locations;
    
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

	X86(std::vector<quad> _tacCode);
	void codeGen(void);
	std::vector<std::string> tac2x86(quad instruction);
};

#endif