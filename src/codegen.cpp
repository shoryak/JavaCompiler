#include "codegen.h"
#include "3ac.h"
#include <fstream>

inline int64_t rnd(int l,int r)
{
	return rand()%(r-l+1)+l;
}

Registers::Registers()
{
	timestamp=0;
	std::vector<std::string> vec_regs = {"%rbx","%r10","%r11", "%r12", "%r13", "%r14", "%r15"};
	for(auto x: vec_regs)
	{
		regs[x]={"",0};
	}

	argumentRegs = {"%rdi","%rsi","%rdx","%rcx","%r8","%r9"};
	callerSaved = {};
	calleeSaved = {};

	std::vector<std::string> vecregs = {"%rax","%rbx", "%rcx", "%rdx" , "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" };
	std::vector<std::string> vals = {"%al", "%bl", "%cl", "%dl", "%r8b", "%r9b", "%r10b", "%r11b", "%r12b", "%r13b", "%r14b", "%r15b" };
	
	for(int i=0; i < vecregs.size(); i++)
	{
		lastByte[vecregs[i]]=vals[i];
	}
}

// selectReg() selects a register to use next based on LRU scheme
std::string Registers::selectReg(void)
{
	int threshold = 1e9+6;
	std::string reg;
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
	std::vector<std::string> instructions;

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
	std::string reg = selectReg();
	// returns the instructions to writeback the register before assigning it to VarName
	std::vector<std::string> instructionlist = writeBack({reg});

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
	return {reg, instructionlist};

}

X86::X86(std::vector<quad> _tacCode)
{
    tempoffset = 0;
    constIndex = 0;
	tacCode = _tacCode;
	Registers *regs = new Registers();
	registers = *regs;
}

void X86::codeGen()
{
	x86.push_back(".globl main");
	x86.push_back("");
	x86.push_back(".bss");
	
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
    std::string print0 = "print0:\n\t .asciz \"\\n\" ";
    std::string print1 = "print1:\n\t .asciz \"%ld\\n\" ";
	std::string trueConst = "true:\n\t .quad 1";
	std::string falseConst = "false:\n\t .quad 0";
    constants.push_back(print0);
    constants.push_back(print1);
    std::string print2 = "print2:\n\t .asciz \"%d\\n\" ";
    constants.push_back(print2);
	constants.push_back(trueConst);
	constants.push_back(falseConst);
	for(std::string s: constants)
		x86.push_back(s);
	
    std::ofstream x86dump("output.s");
    for(auto val: x86)
    	x86dump << val << "\n";

	for(auto ins: x86)
		std::cerr << ins << '\n';
}

std::vector<std::string> split(std::string str , char delim){
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

int X86::getPointerReg(){
    for(int i=0;i<3;i++){
        if(pointerRegsInUse[pointerRegs[i]]==0){
            pointerRegsInUse[pointerRegs[i]]==1;
            return widthToReg.size()-3 + i;
        }
    }
}



std::string X86::getMemLocation(qid var, std::vector<std::string>&code)
{
	bool istemp = var.first[0] == '$';
    bool isPointer = var.first[0] == '*';
    if(isPointer){
        auto entry =  var.second;
        // std::cerr<< var.first<<"\n";
        assert(entry);
        auto parts = split(var.first,'_');
        std::string varName = split(var.first,'_')[0];

        varName = varName.substr(1, varName.length() -1);
        std::string memSize = split(var.first,'_')[1];
        // std::cerr<< varName<<" UUU "<<memSize<<"\n";
        std::string varPrint = varName + std::to_string(reinterpret_cast<long long>(entry));
        // std::cerr<< varPrint<<"\n";
        int pointreg = getPointerReg();
        std::string comment = "\t#fetching pointer " ;
        std::string loadPointer= getLoadInstr(registers.locations[varPrint].second,8,pointreg );
        code.push_back(comment);
        code.push_back(loadPointer);
        std::string memLoc = "0(" + pointerRegs[pointreg+3 - widthToReg.size()] + ")";
        return memLoc;
    }
	

    auto entry =  var.second;
    // std::cerr<< var.first<<"\n";
    if(var.first == "" ) var.first = "0";
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
            std::string comment = "\t#space for "+var.first ;
            std::string spaceTemp= "\tsub $8, %rsp";
            code.push_back(comment);
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

std::string X86::getLoadInstr(std::string location, int width, int regNum)
{
    // std::cerr<<width<<"\n";
	assert(sizeSuffix.find(width) != sizeSuffix.end());
	assert(0 <= regNum && regNum <= 7);
	assert(widthToReg[regNum].find(width) != widthToReg[regNum].end());

	std::string suf; suf.push_back(sizeSuffix[width]);
	std::string loadInstr = "\tmov" + suf + " " + location + ", " + widthToReg[regNum][width];
	return loadInstr;
}

std::string X86::getStoreInstr(std::string location, int width, int regNum)
{
	assert(sizeSuffix.find(width) != sizeSuffix.end());
	assert(0 <= regNum && regNum <= 7);
	assert(widthToReg[regNum].find(width) != widthToReg[regNum].end());

	std::string suf; suf.push_back(sizeSuffix[width]);
	std::string storeInstr = "\tmov" + suf + " " + widthToReg[regNum][width] + ", " + location;
	return storeInstr;
}

std::string X86::getALUInstr(std::string oper)
{

	std::string ALUInstr = "\t" + operToInstrALU[oper] + "q  %rcx, %rdx";
    // if(oper == "-"){
    //     ALUInstr = "\t" + operToInstrALU[oper] + "q  %rdx, %rcx";
    // }
	return ALUInstr;
}

std::vector<std::string> X86::tac2x86(quad instruction)
{
	std::vector<std::string> code;
	std::string oper = instruction.oper.first;
	std::set<std::string> ALUOps {
		"+", "-", "*",
		"&", "|", "^", 
	};
	std::set<std::string> relOps {
		"<", ">", "<=", ">=", "==", "!="
	};
    // conditionals --------------------------------------------------------------
	if(oper == "IfFalse")
	{
		int argWidth = width(instruction.argument1);
		std::string memArg = getMemLocation(instruction.argument1, code);

		int jumpLabelSize = instruction.argument2.first.size();
		std::string jumpLabel = instruction.argument2.first.substr(1, jumpLabelSize-1);

		code.push_back(getLoadInstr(memArg, argWidth, 0));
		std::string zeroReg = "\txorq %rdx, %rdx";
		std::string compareInstr = "\tcmpq %rcx, %rdx";
		std::string branchInstr = "\tje " + jumpLabel;

		code.push_back(zeroReg);
		code.push_back(compareInstr);
		code.push_back(branchInstr);
	}
    // jmps and labels -------------------------------------------------------
	else if(oper == "$goto")
	{
		int jumpLabelLength = instruction.argument1.first.size();
		std::string jumpLabel = instruction.argument1.first.substr(1, jumpLabelLength-1);
        std::string jmpLine = "\tjmp " + jumpLabel;
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
        std::cerr<<oper<<"\n";
		int argWidth1 = width(instruction.argument1);
		int argWidth2 = width(instruction.argument2);
		int resWidth = width(instruction.result);
		
        std::string memArg1 = getMemLocation(instruction.argument1, code);
        std::string memArg2 = getMemLocation(instruction.argument2, code);
        std::string memRes = getMemLocation(instruction.result, code);

        code.push_back(getLoadInstr(memArg2, argWidth2, 0));
		code.push_back(getLoadInstr(memArg1, argWidth1, 1));
        code.push_back(getALUInstr(oper));
        code.push_back(getStoreInstr(memRes, resWidth, 1));
	}

	else if(relOps.find(oper) != relOps.end())
	{
		int argWidth1 = width(instruction.argument1);
		int argWidth2 = width(instruction.argument2);
		int resWidth = width(instruction.result);

		std::string memArg1 = getMemLocation(instruction.argument1, code);
		std::string memArg2 = getMemLocation(instruction.argument2, code);
		std::string memRes = getMemLocation(instruction.result, code);

		assert(operToInstrSet.find(oper) != operToInstrSet.end());

		code.push_back(getLoadInstr(memArg1, argWidth1, 1));
		code.push_back(getLoadInstr(memArg2, argWidth2, 0));
		std::string compareInstr = "\tcmpq %rcx, %rdx";
		code.push_back(compareInstr);
		code.push_back("\t" + operToInstrSet[oper] + " %cl");
		std::string moveToLargeRegInstr = "\tmovzbq %cl, %rcx";
		code.push_back(moveToLargeRegInstr);
		code.push_back(getStoreInstr(memRes, resWidth, 0));
	}
	else if(oper.substr(0, 5) == "CAST_")
	{
        if(oper == "CAST_boolean"){
            // int argWidth = width(instruction.argument1);
            // int resWidth = width(instruction.result);

            // std::string memArg = getMemLocation(instruction.argument1, code);
            // std::string memRes = getMemLocation(instruction.result, code);

            // code.push_back(getLoadInstr(memArg, argWidth, 0));
            // code.push_back(getStoreInstr(memRes, resWidth, 0));
        }
		
		int argWidth = width(instruction.argument1);
		int resWidth = width(instruction.result);

		std::string memArg = getMemLocation(instruction.argument1, code);
		std::string memRes = getMemLocation(instruction.result, code);

		code.push_back(getLoadInstr(memArg, argWidth, 0));
		code.push_back(getStoreInstr(memRes, resWidth, 0));
	}
    else if(oper == "/" || oper == "%"){
        // mov rax, 123456789012345678 ; load dividend into RAX
        // mov rbx, 9876543210 ; load divisor into RBX
        // idiv rbx ; divide RDX:RAX by RBX
        int argWidth1 = width(instruction.argument1);
		int argWidth2 = width(instruction.argument2);
		int resWidth = width(instruction.result);
		
        std::string memArg1 = getMemLocation(instruction.argument1, code);
        std::string memArg2 = getMemLocation(instruction.argument2, code);
        std::string memRes = getMemLocation(instruction.result, code);
        code.push_back("\n\t#Division code");
        code.push_back("\tmov $0 ,%rdx");
        code.push_back(getLoadInstr(memArg1, argWidth1,3));
        code.push_back(getLoadInstr(memArg2, argWidth2,4));
        std::string div = "\tidiv %rbx" ;
        code.push_back(div);
        if(oper == "/"){
            code.push_back(getStoreInstr(memRes, resWidth,3));
        }
        else if(oper == "%"){
            code.push_back(getStoreInstr(memRes, resWidth,1));
        }

    }
    // allocmem
    else if(oper == "" && instruction.argument1.first == "$allocmem")
	{
		std::string bytes = "$" + instruction.argument2.first;
		std::string addBytesArgLine = "\tmovq " + bytes + ", %rdi"; // put bytes into %rdi
		std::string heapAllocLine = "\tcall malloc";

		// store allocated address in %rax to result
		std::string memRes = getMemLocation(instruction.result, code);
		std::string assignLine = "\tmovq %rax, " + memRes;

		code.push_back(addBytesArgLine);
		code.push_back(heapAllocLine);
		code.push_back(assignLine);
    }
	
	// assignment
    else if(oper == "")
	{
		int argWidth = width(instruction.argument1);
		int resWidth = width(instruction.result);

		std::string memArg = getMemLocation(instruction.argument1, code);
		std::string memRes = getMemLocation(instruction.result, code);

		code.push_back(getLoadInstr(memArg, argWidth, 0));
		code.push_back(getStoreInstr(memRes, resWidth, 0));
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
        std::string comment = "\t#local varSpace";
        std::string localSpace = "\tsub $"+ instruction.argument1.first + ", %rsp";
        tempoffset= stoi(instruction.argument1.first);
        code.push_back(comment);
        code.push_back(localSpace);
    }
    else if(oper == "pusharg")
	{
        std::string comment = "\t#PushArg ";
        std::string argSpace = "\tsub $"+ instruction.argument2.first + ", %rsp";
        
        std::string memLoc = getMemLocation(instruction.argument1 , code);
        auto movArgtoreg = getLoadInstr(memLoc , stoi(instruction.argument2.first) , 0);
        auto movRegtolocation = getStoreInstr("0(%rsp)" , stoi(instruction.argument2.first) , 0 );
        code.push_back(comment);
        code.push_back(argSpace);
        code.push_back(movArgtoreg);
        code.push_back(movRegtolocation);
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
		int argWidth1 = width(instruction.argument1);
		int argWidth2 = width(instruction.argument2);
		int resWidth = width(instruction.result);
		
        std::string memArg1 = getMemLocation(instruction.argument1, code);
        std::string memArg2 = getMemLocation(instruction.argument2, code);
        std::string memRes = getMemLocation(instruction.result, code);
		

        code.push_back("\n\t#Shift");
        code.push_back(getLoadInstr(memArg2, 1 ,0));
        code.push_back(getLoadInstr(memArg1, argWidth1,1));
        std::string str2 = std::string() + "\tsar %cl, %rdx" ;
		code.push_back(str2);
        code.push_back(getStoreInstr(memRes, resWidth,1));

		
		
	}
	else if(oper == "<<")
	{
		// std::string tempname1 = instruction.argument1.first;
		// std::string memlocation1 = registers.locations[tempname1].second;

		// std::string tempname2 = instruction.argument2.first;
		// std::string memlocation2 = registers.locations[tempname2].second;

		// std::string str0 = "\tmov %rcx, " + tempname2;
		// std::string str1 = std::string() + "\tmov " + "%rax " + memlocation1;
		

		int argWidth1 = width(instruction.argument1);
		int argWidth2 = width(instruction.argument2);
		int resWidth = width(instruction.result);
		
        std::string memArg1 = getMemLocation(instruction.argument1, code);
        std::string memArg2 = getMemLocation(instruction.argument2, code);
        std::string memRes = getMemLocation(instruction.result, code);
		

        code.push_back("\n\t#Shift");
        code.push_back(getLoadInstr(memArg2, 1 ,0));
        code.push_back(getLoadInstr(memArg1, argWidth1,1));
        std::string str2 = std::string() + "\tsal %cl, %rdx" ;
		code.push_back(str2);
        code.push_back(getStoreInstr(memRes, resWidth,1));

	}
	else if(oper == ">>>")
	{	
		int argWidth1 = width(instruction.argument1);
		int argWidth2 = width(instruction.argument2);
		int resWidth = width(instruction.result);
		
        std::string memArg1 = getMemLocation(instruction.argument1, code);
        std::string memArg2 = getMemLocation(instruction.argument2, code);
        std::string memRes = getMemLocation(instruction.result, code);
		

        code.push_back("\n\t#Shift");
        code.push_back(getLoadInstr(memArg2, 1 ,0));
        code.push_back(getLoadInstr(memArg1, argWidth1,1));
        std::string str2 = std::string() + "\tshr %cl, %rdx" ;
		code.push_back(str2);
        code.push_back(getStoreInstr(memRes, resWidth,1));

	}
	else if(oper == "PRINTCALL")
	{
        std::string comment = "\t#printcall";
		std::string str1 = "\tpush %rcx";
		std::string str2 = "\tpush %rax";
        code.push_back(comment);
		code.push_back(str1);
		code.push_back(str2);
        std::string name = instruction.argument2.first;
        // for print string support 
        if(name[0] == '~')
        {
            std::string format = "format" + std::to_string(++constIndex) + ":\n\t.asciz \"" + name.substr(8, name.length()-1) +"\\n\"";
            constants.push_back(format);
            
            std::string movins = "\tmov $format" + std::to_string(constIndex) +", %rdi";
            std::string clearAl = "\txor %rax, %rax";
            std::string call = "\tcall printf";
            code.push_back(movins);
            code.push_back(clearAl);
            code.push_back(call);

        }
        else 
        {
            if(instruction.argument1.first == "0")
            {
                std::string movins = "\tmov $print0, %rdi";
                std::string clearAl = "\txor %rax, %rax";
                std::string call = "\tcall printf";
                code.push_back(movins);
                code.push_back(clearAl);
                code.push_back(call);
            }
            else if(instruction.argument1.first == "1"){
                std::string printversion = "$print1";
                
                int argWidth = width(instruction.argument2);
                if(argWidth == 4){
                    printversion = "$print2";
                }
                std::string memArg = getMemLocation(instruction.argument2 , code);
            
                std::string movins = "\tmov " + printversion+ ", %rdi";
                std::string clearAl = "\txor %rax, %rax";
                std::string call = "\tcall printf";
                code.push_back(movins);
                code.push_back(getLoadInstr(memArg, argWidth, 2));
                code.push_back(clearAl);
                code.push_back(call);
            } 

            str1 = "\tpop %rax";
            str2 = "\tpop %rcx";
            code.push_back(str1);
            code.push_back(str2);
        }
	}
    
	else if(oper == "RETURN")
	{
        std::string memArg = getMemLocation(instruction.argument1, code);
        int argWidth = width(instruction.argument1);
        code.push_back(getLoadInstr(memArg, argWidth,3));
    }
    
	else if(oper == "RETURNVALUE")
	{
        std::string memArg = getMemLocation(instruction.result, code);
        int argWidth = width(instruction.result);
        code.push_back(getStoreInstr(memArg, argWidth,3));
    }

	else if(oper=="~"){
		std::string memArg = getMemLocation(instruction.argument2, code);
		int argWidth = width(instruction.argument2);
        std::string memRes = getMemLocation(instruction.result,code);
        int resWidth = width(instruction.result);
		code.push_back(getLoadInstr(memArg, argWidth,3));
		std::string str = std::string()+ "\tnot "+"%rax";
		code.push_back(str);
        code.push_back(getStoreInstr(memRes, resWidth,3));
	}

    
	return code;
} 
