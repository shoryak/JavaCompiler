#include "codegen.h"
#include "3ac.h"
#include <map>
#include <string>
#include <vector>
#include <utility>
#include <set>

inline int64_t rnd(int l,int r)
{
	return rand()%(r-l+1)+l;
}

Registers::Registers()
{
	timestamp=0;
	std::vector<string> vec_regs = {"%rbx","%r10","%r11", "%r12", "%r13", "%r14", "%r15"};
	for(auto x: vec_regs)
	{
		regs[x]={"",0};
	}

	argumentRegs = {"%rdi","%rsi","%rdx","%rcx","%r8","%r9"};
	callerSaved = {};
	calleeSaved = {};

	std::vector<string> vecregs = {"%rax","%rbx", "%rcx", "%rdx" , "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" };
	std::vector<string> vals = {"%al", "%bl", "%cl", "%dl", "%r8b", "%r9b", "%r10b", "%r11b", "%r12b", "%r13b", "%r14b", "%r15b" };
	
	for(int i=0; i < vecregs.size(); i++)
	{
		lastByte[vecregs[i]]=vals[i];
	}
}

// selectReg() selects a register to use next based on LRU scheme
std::string Registers::selectReg(void)
{
	int threshold = 1e9+6;
	string reg;
	for(auto tempreg :regs)
	{
		if(tempreg.second.second <= threshold)
		{
			threshold = tempreg.second.second;
			reg = tempreg.first;
		}
	}
	return reg;
}

std::vector<std::string> Registers::writeBack(std::vector<std::string> writeRegs = {}, bool flush = true)
{
	vector<string> instructions;

	// inserting all registers into writeRegisters if nothing is passed
	if(!writeRegs.size()){
		for(auto reg : regs){
			writeRegs.push_back(reg.first); 
		}
	}
	
	for(auto wreg : writeRegs){
		if(regs[wreg].first!=""){
			// loc stores memory location of the variable inside wreg
			std::string loc = locations[regs[wreg].first].second;
			if(loc!=""){
				// write register value in memory location of the variable 
				std::string instruction = "\tmov " + wreg + ",\t" + loc;
				instructions.push_back(instruction);
			}
			if(flush){  
				// remove register from the access of variable
				locations[regs[wreg].first].first = "";
				// reset register  
				regs[wreg] = {"", 0};
			}
		}
	}
	return instructions;
}

// this function tells whether varName has been assigned a register/memory location
bool Registers::inLocations(std::string varName)
{
	for(auto entry : locations){
		if(entry.first == varName)
			return true;
	}
	return false;
}

// this function is to get the register for a variable 
std::pair<std::string, std::vector<std::string>> Registers::getRegister(std::string varName = "")
{
	// generating a random string for later use
	if(varName.size()==0){
		for (int i = 0; i < 8; ++i)
		{
			varName.push_back((char)(rnd(0,25) +'a'));
		}
	}
	bool present=false;

	for(auto entry :locations){
		// if entry there then set the present as true
		if(entry.first == varName){
			present = true;
			break;
		}
	}
	
	// if variable is present in register 
	if(present && locations[varName].first.size()){
		// incrementing the timestamp of the register
		timestamp++;
		regs[locations[varName].first].second = timestamp;
		// as register already had the value of variable hence no instructions required 
		return {locations[varName].first, {}};
	}

	// now the case if no register contains the variables value
	string reg = selectReg();
	// returns the instructions to writeback the register before assigning it to VarName
	std::vector<string> instructionlist = writeBack({reg});

	// assign the selected register to contain varName
	regs[reg]={varName, ++timestamp};
	
	if(inLocations(varName)){
		
		locations[varName].first = reg;
		std::string instruction = "\tmov\t" + locations[varName].second + ", " +  reg;

		// if no memory location of the variable exit 
		if(locations[varName].second=="") {
			exit(1);
		}
		instructionlist.push_back(instruction);

	}
	else{
		locations[varName] = {reg,""};
	}

	// return the register and instructions required to get it 
	return {reg,instructionlist};

}

X86::X86(std::vector<quad> _tacCode)
{
	tacCode = _tacCode;
	Registers *regs = new Registers();
	registers = *regs;
}

void X86::codeGen()
{
	x86.push_back(".globl main");
	x86.push_back("");
	x86.push_back(".bss");
	// for(auto x:sym_tab){
	// 	vector<string> temp = split(x.ff,'-');
	// 	if(temp.size()==2 && temp[0]=="0"){
	// 		if(dynamic_cast<FunctionType*>(x.ss) != NULL || temp[1]=="printf" || temp[1]=="scanf"){
	// 			continue;
	// 		}
	// 		x86.push_back(temp[1]+":");
	// 		x86.push_back("\t.space "+ to_string(x.ss->getSize()));
	// 		r.locs[x.ff] = {"","(" + temp[1] + ")"};
	// 	}
	// }
	
	x86.push_back("");
	x86.push_back(".text");
	x86.push_back("");
	std::cerr << "tacCode Size: " << tacCode.size() << "\n";
	for(auto instruction: tacCode)
	{
		auto code = tac2x86(instruction); 
		for(auto line : code){
			x86.push_back(line);
		}
	}
	

	
	x86.push_back("");
	x86.push_back(".data");
	for(string s: constants){
		x86.push_back(s);
	}

	for(auto ins: x86)
	{
		std::cerr << ins << "\n";
	}
	// cout<<"\n\n\n\n\n\n\nBEGINNING ASM PART\n\n\n\n\n\n\n";
	// ofstream my_function_dump("./bin/output.s");
	
}

std::vector<std::string> X86::tac2x86(quad instruction)
{
	std::vector<std::string> code;
	std::string oper = instruction.oper.first;
    // conditionals --------------------------------------------------------------
	if(oper == "IfFalse")
	{
		// temporary to registers
		std::string tempname = instruction.argument1.first;
		std::string memlocation = registers.locations[tempname].second;
		std::string codeLine = "\tmov reg1," + memlocation;
		// if tempval !=0 , flag set for true else flag variable
		std::string cmpLine = "\tcmp reg1, $0";
		std::string branchLine = "\tjne " + instruction.argument2.first;
		code.push_back(cmpLine);
		code.push_back(branchLine);
	}
	else if(oper == "IfTrue")
	{
		std::string tempname = instruction.argument1.first;
		std::string memlocation = registers.locations[tempname].second;
		std::string codeLine = "\tmov reg1" + memlocation;
	}
	else if(oper == "Else")
	{
		std::string tempname = instruction.argument1.first;
		std::string memlocation = registers.locations[tempname].second;
		std::string codeLine = "\tmov reg1" + memlocation;
	}
    // jmps and labels -------------------------------------------------------
	else if(oper.substr(0, 5) == "$goto")
	{
        std::string jmpLine = "\tjmp " + instruction.argument1.first;
        code.push_back(jmpLine);
	}
    else if(oper.substr(0, 2) == "$L")
	{
        std::string label = oper + ":";
        code.push_back(label);
    }
	else if(oper == "CALL")
	{
		std::string funcLabel = instruction.argument1.first;
		std::string codeLine = "\tcall " + funcLabel;
		code.push_back(codeLine);
	}
    // arithmetic instructions ------------------------------------------
	// TODOs:
	// -- Take care of the actual type (int, long ,short , byte ) of the operands
	// -- Need to use FPU in case of float/double operands? ( we can neglect this)
    // -- need to fetch arguments in registers, compute and store in memory 
    // -- need to assign memorylocation to result if not yet assigned in case of temporary
    // -- need to create the fingerprint with symboltableentry pointer before storing memlocation (not necessary if 
    // we access symbolentry each time for offset !!)
    else if(oper == "+")
	{
        std::string arg1 = instruction.argument1.first;
        std::string arg2 = instruction.argument2.first;
        // move arg1
        std::string movarg1 = "\tmov memory1, reg1";
        std::string movarg2 = "\tmov memory2, reg2";
        std::string addIns = "\tadd reg2, reg1";
        std::string movres = "\tmov reg1, memoryres";
        code.push_back(movarg1);
        code.push_back(movarg2);
        code.push_back(addIns);
        code.push_back(movres);

    }
    else if(oper == "-")
	{

    }
    else if(oper == "*")
	{
        
    }
	else if(oper == "/")
	{

	}
	else if(oper == "%")
	{
		
	}
    // allocmem
    else if(oper == "" && instruction.argument1.first == "$allocmem")
	{
		// ???
    }
	// assignment
	else if(oper == "")
	{

	}
    
	return code;
} 
