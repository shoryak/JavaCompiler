#include "codegen.h"

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
	
	for(auto wreg: writeRegs){
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
    tempoffset = 0;
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
		for(auto line: code)
		{
			x86.push_back(line);
		}
	}
	
	x86.push_back("");
	x86.push_back(".data");
	for(string s: constants)
	{
		x86.push_back(s);
	}

	for(auto ins: x86)
	{
		std::cerr << ins << "\n";
	}
	// cout<<"\n\n\n\n\n\n\nBEGINNING ASM PART\n\n\n\n\n\n\n";
	// ofstream my_function_dump("./bin/output.s");
}

std::string X86::getMemLocation(qid var, std::vector<std::string>&code)
{
	bool istemp = var.first[0] == '$';
    bool isPointer = var.first[0] == '*';

    auto entry =  var.second;
    std::cerr<< var.first<<"\n";
    if(!entry) return "$" + var.first;
    assert(entry);

    std::string varPrint = var.first + std::to_string(reinterpret_cast<long long>(entry));
    std::cerr<< varPrint<<"\n";

    // memory location already assigned
    if(registers.locations.find(varPrint) != registers.locations.end())
        return registers.locations[varPrint].second;
	
    // encountering temporary or variable first time in code
    else
	{
        if(istemp)
		{
            tempoffset += 8;
            std::string spaceTemp= "\tsub $8, %rsp";
            code.push_back(spaceTemp);
            std::string memLoc = "-" + std::to_string(tempoffset) + "(%rbp)";
            registers.locations[varPrint].second = memLoc;
            return memLoc;
        }
        else
		{
            int offset = entry->getOffset();
            std::string memLoc = "-" + std::to_string(offset) + "(%rbp)";
            registers.locations[varPrint].second = memLoc;
            return memLoc;
        }
    }
}

std::string X86::getLoadInstr(std::string location, int width)
{
	assert(sizeSuffix.find(width) != sizeSuffix.end());
	assert(widthToReg.find(width) != widthToReg.end());

	char suf = sizeSuffix[width];
	std::string loadInstr = "\tmov";
	loadInstr.push_back(suf);
	loadInstr += " " + location + " " + widthToReg[width];
	
	return loadInstr;
}

std::string X86::getStoreInstr(std::string location, int width)
{
	assert(sizeSuffix.find(width) != sizeSuffix.end());
	assert(widthToReg.find(width) != widthToReg.end());

	char suf = sizeSuffix[width];
	std::string storeInstr = "\tmov";
	storeInstr.push_back(suf);
	storeInstr += " " + widthToReg[width] + " " + location;
	
	return storeInstr;
}

std::string X86::getALUInstr(std::string location, std::string oper, int width)
{
	assert(sizeSuffix.find(width) != sizeSuffix.end());
	assert(widthToReg.find(width) != widthToReg.end());
	assert(operToInstrALU.find(oper) != operToInstrALU.end());

	char suf = sizeSuffix[width];
	std::string ALUInstr = "\t" + operToInstrALU[oper];
	ALUInstr.push_back(suf);
	ALUInstr += " " + location + " " + widthToReg[width];

	return ALUInstr;
}

std::vector<std::string> X86::tac2x86(quad instruction)
{
	std::vector<std::string> code;
	std::string oper = instruction.oper.first;
	std::set<std::string> ALUOps {
		"+", "-", "*", "/", "%",
		"&", "|", "^", "~" ,
		">>" , "<<", ">>>"
	};
	std::set<std::string> relOps {
		"<", ">", "<=", ">=", "==", "!="
	};
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
    else if(oper.substr(0, 2) == "$L" || oper[0] == '#')
	{
		int labelLength = oper.size();
        std::string label = oper.substr(1, labelLength - 1) + ":";
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
    else if(ALUOps.find(oper) != ALUOps.end())
	{
		assert(instruction.argument1.second);
		int argWidth1 = instruction.argument1.second->getSize();

		assert(instruction.argument2.second);
		int argWidth2 = instruction.argument2.second->getSize();

		int resWidth = instruction.result.second->getSize();
		
		assert(argWidth1 == resWidth && argWidth2 == resWidth);

        std::string memarg1 = getMemLocation(instruction.argument1, code);
        std::string memarg2 = getMemLocation(instruction.argument2, code);
        std::string memres = getMemLocation(instruction.result, code);

        code.push_back(getLoadInstr(memarg1, argWidth1));
        code.push_back(getALUInstr(memarg2, oper, argWidth2));
        code.push_back(getStoreInstr(memres, resWidth));
	}
	else if(relOps.find(oper) != relOps.end())
	{
		assert(instruction.argument1.second);
		int argWidth1 = instruction.argument1.second->getSize();
		assert(instruction.argument2.second);
		int argWidth2 = instruction.argument2.second->getSize();
		assert(instruction.result.second);
		int resWidth = instruction.result.second->getSize();

		assert(argWidth1 == argWidth2);
		assert(sizeSuffix.find(resWidth) != sizeSuffix.end());
		assert(widthToReg.find(resWidth) != widthToReg.end());
		assert(operToInstrSet.find(oper) != operToInstrSet.end());
		char suf = sizeSuffix[resWidth];

		std::string memArg1 = getMemLocation(instruction.argument1, code);
		std::string memArg2 = getMemLocation(instruction.argument2, code);
		std::string memRes = getMemLocation(instruction.result, code);

		code.push_back(getLoadInstr(memArg1, argWidth1));
		std::string compareInstr = "\tcmp";
		compareInstr.push_back(suf);
		compareInstr += " " + widthToReg[argWidth1] + ", " + memArg2;
		code.push_back(compareInstr);
		code.push_back("\t" + operToInstrSet[oper] + " %cl");
		std::string moveToLargeRegInstr = "\tmovzb";
		moveToLargeRegInstr.push_back(sizeSuffix[resWidth]);
		moveToLargeRegInstr += " %cl, " + widthToReg[resWidth];
		code.push_back(moveToLargeRegInstr);
		code.push_back(getStoreInstr(memRes, resWidth));
	}
	else if(oper.substr(0, 5) == "CAST_")
	{
		
	}
    // allocmem
    else if(oper == "" && instruction.argument1.first == "$allocmem")
	{
		std::string bytes = "$" + std::stol(instruction.argument2.first);
		std::string addBytesArgLine = "\tmovq " + bytes + ", %rdi"; // put bytes into %rdi
		std::string heapAllocLine = "\tcall malloc";

		// store allocated address in %rax to result
		std::string assignLine = "\tmovq %rax, memoryloc";

		code.push_back(addBytesArgLine);
		code.push_back(heapAllocLine);
		code.push_back(assignLine);
    }
	// assignment
    else if(oper == "")
	{
		std::string arg = instruction.argument1.first;
		assert(instruction.argument1.second);
		int argWidth = instruction.argument1.second->getSize();

		std::string res = instruction.result.first;
		assert(instruction.result.second);
		int resWidth = instruction.result.second->getSize();

		assert(argWidth == resWidth);

		std::string memarg = getMemLocation(instruction.argument1, code);
		std::string memres = getMemLocation(instruction.result, code);

		code.push_back(getLoadInstr(memarg, argWidth));
		code.push_back(getStoreInstr(memres, resWidth));
    }
    // functions and methodcalls
	else if(oper[0] == '#')
	{
        std::string funcName = "\n\n" + oper.substr(1,oper.length()) + ":";
        code.push_back(funcName);
		// std::string assignLine = ;
	}
    else if(oper == "BEGINFUNC")
	{
        std::string pushrbp = "\tpush %rbp";
        std::string bp2sp = "\tmov %rsp, %rbp";
        code.push_back(pushrbp);
        code.push_back(bp2sp);
    }
    else if(oper == "ENDFUNC")
	{
         std::string sp2bp = "\tmov %rbp, %rsp";
         std::string restorerbp = "\tpop %rbp";
         std::string ret = "\tret";
         code.push_back(sp2bp);
         code.push_back(restorerbp);
         code.push_back(ret);
    }
    else if(oper == "LOCALVARIABLESPACE")
	{
        std::string comment = "\t# Space for local variables";
        std::string localSpace = "\tsub $"+ instruction.argument1.first + ", %rsp";
        tempoffset= stoi(instruction.argument1.first);
        code.push_back(comment);
        code.push_back(localSpace);
    }
    else if(oper == "pusharg")
	{
        std::string comment = "\t#PushArg ";
        std::string argSpace = "\tsub $"+ instruction.argument2.first + ", %rsp";
        std::string movArg = "\tmov " + instruction.argument1.first + ", 0(%rsp)";
        code.push_back(comment);
        code.push_back(argSpace);
        code.push_back(movArg);
    }
    else if(oper == "poparg")
	{
        std::string argPrint = instruction.result.first + std::to_string(reinterpret_cast<long long>(instruction.result.second));
        registers.locations[argPrint].second = instruction.argument1.first+ "(%rbp)";
        std::string comment = "\t#PopArg " + registers.locations[argPrint].second  ;
        code.push_back(comment);
    }
    else if(oper == "pop")
	{
        std::string comment = "\t#PopStack " + instruction.argument1.first  ;
        std::string popStack = "\tadd $"+ instruction.argument1.first + ", %rsp";
        code.push_back(comment);
        code.push_back(popStack);
    }
	else if(oper == ">>")
	{
		std::string tempname1 = instruction.argument1.first;
		std::string memlocation1 = registers.locations[tempname1].second;

		std::string tempname2 = instruction.argument2.first;
		std::string memlocation2 = registers.locations[tempname2].second;

		std::string str0 =  "\tmov %rcx, " + tempname2;
		std::string str1 = std::string() + "\tmov " + "%rax " + memlocation1;
		std::string str2 = std::string() + "\tsar " + "%rax" + ", %cl";

		code.push_back(str0);
		code.push_back(str1);
		code.push_back(str2);
	}
	else if(oper == "<<")
	{
		std::string tempname1 = instruction.argument1.first;
		std::string memlocation1 = registers.locations[tempname1].second;

		std::string tempname2 = instruction.argument2.first;
		std::string memlocation2 = registers.locations[tempname2].second;

		std::string str0 = "\tmov %rcx, " + tempname2;
		std::string str1 = std::string() + "\tmov " + "%rax " + memlocation1;
		std::string str2 = std::string() + "\tshl " + "%rax" + ", %cl";

		code.push_back(str0);
		code.push_back(str1);
		code.push_back(str2);
	}
	else if(oper == ">>>")
	{	
		std::string tempname1 = instruction.argument1.first;
		std::string memlocation1 = registers.locations[tempname1].second;

		std::string tempname2 = instruction.argument2.first;
		std::string memlocation2 = registers.locations[tempname2].second;

		std::string str0 = "\tmov %rcx, " + tempname2;
		std::string str1 = std::string() + "\tmov " + "%rax " + memlocation1;
		std::string str2 = std::string() + "\tshr " + "%rax" + ", %cl";

		code.push_back(str0);
		code.push_back(str1);
		code.push_back(str2);

	}
	else if(oper == "CALL" && )
	{
		std::string str1 = "\tpush %rcx";
		std::string str2 = "\tpush %rax";
		code.push_back(str1);
		code.push_back(str2);
	}
    
	return code;
} 
