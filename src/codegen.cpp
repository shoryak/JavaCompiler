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

std::string X86::getMemLocation(qid var , bool istemp, vector<string> &code){
    // if(locations.find())
    bool isPointer = false;
    if(var.first[0] == '*'){
        isPointer = true;
    }
    auto entry =  var.second;
    std::cerr<< var.first<<"\n";
    if(entry == NULL){
        return "$" + var.first;
    }
    assert(entry);

    std::string varPrint = var.first + std::to_string(reinterpret_cast<long long>(entry));
    std::cerr<< varPrint<<"\n";

    // memory location already assigned
    if(registers.locations.find(varPrint) != registers.locations.end()){
        return registers.locations[varPrint].second;
    }
    // encountering temporary or variable first time in code
    else{
        if(istemp){
            tempoffset += 8;
            std::string spaceTemp= "\tsub $8, %rsp";
            code.push_back(spaceTemp);
            std::string memLoc = "-" + std::to_string(tempoffset) + "(%rbp)";
            registers.locations[varPrint].second = memLoc;
            return memLoc;
        }
        else{
            int offset = entry->getOffset();
            std::string memLoc = "-" + std::to_string(offset) + "(%rbp)";
            registers.locations[varPrint].second = memLoc;
            return memLoc;
        }
    }
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
        std::string res  = instruction.result.first;
        bool istemp = false;
        if(arg1[0] == '$'){
            istemp = true;
        }
        std::string memarg1 = getMemLocation( instruction.argument1 , istemp , code);
        istemp = false;
        if(arg2[0] == '$'){
            istemp = true;
        }
        std::string memarg2 = getMemLocation( instruction.argument2 , istemp , code);
        istemp = false;
        if(res[0] == '$'){
            istemp = true;
        }
        std::string memres = getMemLocation( instruction.result , istemp , code);
        // move arg1
        std::string movarg1 = "\tmov " + memarg1 + ", reg1";
        std::string movarg2 = "\tmov " + memarg2 + ", reg2";
        std::string addIns = "\tadd reg2, reg1";
        std::string movres = "\tmov reg1," + memres;
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
    else if(oper == ""){

    }
    // functions and methodcalls
	else if(oper[0] == '#')
	{
        std::string funcName = "\n\n" + oper.substr(1,oper.length()) + ":";
        code.push_back(funcName);
		// std::string assignLine = ;
	}
    else if(oper == "BEGINFUNC"){
        std::string pushrbp = "\tpush %rbp";
        std::string bp2sp = "\tmov %rsp,%rbp";
        code.push_back(pushrbp);
        code.push_back(bp2sp);
    }
    else if(oper == "ENDFUNC"){
         std::string sp2bp = "\tmov %rbp,%rsp";
         std::string restorerbp = "\tpop %rbp";
         std::string ret = "\tret";
         code.push_back(sp2bp);
         code.push_back(restorerbp);
         code.push_back(ret);
    }
    else if(oper == "LOCALVARIABLESPACE"){
        std::string comment = "\t# Space for local variables";
        std::string localSpace = "\tsub $"+ instruction.argument1.first + ", %rsp";
        tempoffset= stoi(instruction.argument1.first);
        code.push_back(comment);
        code.push_back(localSpace);
    }
    else if(oper == "pusharg"){
        std::string comment = "\t#PushArg ";
        std::string argSpace = "\tsub $"+ instruction.argument2.first + ", %rsp";
        std::string movArg = "\tmov " + instruction.argument1.first + ", 0(%rsp)";
        code.push_back(comment);
        code.push_back(argSpace);
        code.push_back(movArg);
    }
    else if(oper == "poparg"){
        std::string argPrint = instruction.result.first + std::to_string(reinterpret_cast<long long>(instruction.result.second));
        registers.locations[argPrint].second = instruction.argument1.first+ "(%rbp)";
        std::string comment = "\t#PopArg " + registers.locations[argPrint].second  ;
        code.push_back(comment);
    }
    else if(oper == "pop"){
        std::string comment = "\t#PopStack " + instruction.argument1.first  ;
        std::string popStack = "\tadd $"+ instruction.argument1.first + ", %rsp";
        code.push_back(comment);
        code.push_back(popStack);
    }
    
	return code;
} 
