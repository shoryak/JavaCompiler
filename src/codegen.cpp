#include "codegen.h"
#include "3ac.h"
#include <fstream>

std::string g_currentFunction;
std::set<std::string> pointerRegsInUse;
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

	std::vector<std::string> vecregs = {"%rax","%rbx", "%rcx", "%rdx" , "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" };
	std::vector<std::string> vals = {"%al", "%bl", "%cl", "%dl", "%r8b", "%r9b", "%r10b", "%r11b", "%r12b", "%r13b", "%r14b", "%r15b" };
	
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
	// std::cerr << "tacCode Size: " << tacCode.size() << "\n";
	for(auto instruction: tacCode)
	{
		auto code = tac2x86(instruction);
        // std::cerr<< pointerRegsInUse.size()<<"\n";
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
    std::string print3 = "print3:\n\t .asciz \"\" ";
    std::string print4 = "print4:\n\t .asciz \"%ld\" ";
    std::string print5 = "print5:\n\t .asciz \"%d\" ";
    constants.push_back(print3);
    constants.push_back(print4);
    constants.push_back(print5);
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
        if(pointerRegsInUse.find(pointerRegs[i]) == pointerRegsInUse.end()){
            pointerRegsInUse.insert(pointerRegs[i]);
            return widthToReg.size()-3 + i;
        }
    }
    return -1;
}



std::string X86::getMemLocation(qid var, std::vector<std::string>&code)
{
    if(var.first == "this"){
        return "16(%rbp)";
    }
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
        std::cerr<< pointreg<<"\n";
        assert(pointreg>=0);
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
    if(!entry) {

          std::cerr<< var.first<<" XXXX \n";
        return "$" + var.first;
    }
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
            std::string comment = "\t#space for " + var.first;
            std::string spaceTemp= "\tsubq $8, %rsp";
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
	std::string loadInstr;
	if(suf == "q" || location[0] == '$')
	{
		loadInstr = "\tmovq " + location + ", " + widthToReg[regNum][8];
	}
	else loadInstr = "\tmovs" + suf + "q " + location + ", " + widthToReg[regNum][8];
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
		"&", "|", "^", "&&" , "||" ,
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

		std::string descriptor = "\t#IfFalse " + instruction.argument1.first + " goto " + jumpLabel;
		code.push_back(descriptor);
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
		std::string descriptor = "\t#goto " + jumpLabel;
		code.push_back(descriptor);
        code.push_back(jmpLine);
	}
    else if(oper.substr(0, 2) == "$L" || oper[0] == '#')
	{
		int labelLength = oper.size();
		std::string labelName = oper.substr(1, labelLength - 1);
        std::string label = labelName + ":";
		if(oper[0] == '#') g_currentFunction = labelName;
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

		std::string descriptor = "\t#" + instruction.result.first + " = " + instruction.argument1.first + " " + oper + " " + instruction.argument2.first;

		code.push_back(descriptor);
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

		std::string descriptor = "\t#" + instruction.result.first + " = " + instruction.argument1.first + " " + oper + " " + instruction.argument2.first;

		code.push_back(descriptor);
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
        if(oper == "CAST_boolean")
		{
			int argWidth = width(instruction.argument1);
			int resWidth = width(instruction.result);

			std::string memArg = getMemLocation(instruction.argument1, code);
			std::string memRes = getMemLocation(instruction.result, code);

			std::string descriptor = "\t#" + instruction.result.first + " = " + oper + " " + instruction.argument1.first;

			code.push_back(descriptor);
			code.push_back(getLoadInstr(memArg, argWidth, 0));
			code.push_back("\tcmpq $0, %rcx");
			code.push_back("\tsetnz %cl");
			code.push_back("\tmovzbq %cl, %rcx");
			code.push_back(getStoreInstr(memRes, resWidth, 0));
        }
		else
		{
			int argWidth = width(instruction.argument1);
			int resWidth = width(instruction.result);

			std::string memArg = getMemLocation(instruction.argument1, code);
			std::string memRes = getMemLocation(instruction.result, code);
			std::string descriptor = "\t#" + instruction.result.first + " = " + oper + " " + instruction.argument1.first;

			code.push_back(descriptor);
			code.push_back(getLoadInstr(memArg, argWidth, 0));
			code.push_back(getStoreInstr(memRes, resWidth, 0));
		}
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
        std::string bytes = getMemLocation(instruction.argument2, code);
        // if(instruction.argument2.first[0] != '$' && instruction.argument2.first[0] != '*'){
		//     bytes = getMemLocation
        // }
		std::string addBytesArgLine = "\tmovq " + bytes + ", %rdi"; // put bytes into %rdi
		std::string heapAllocLine = "\tcall malloc";

		// store allocated address in %rax to result
		std::string memRes = getMemLocation(instruction.result, code);
		std::string descriptor = "\t#" + instruction.result.first + "= allocmem " + bytes;
		std::string assignLine = "\tmovq %rax, " + memRes;

		code.push_back(descriptor);
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
		std::string descriptor = "\t#" + instruction.result.first + " = " + instruction.argument1.first;

		code.push_back(descriptor);
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
		 if(g_currentFunction == "main") code.push_back("\txorq %rax, %rax"); // return code 0 for main by default
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
        registers.locations[argPrint].second = instruction.argument1.first + "(%rbp)";
        std::string comment = "\t#PopArg " + registers.locations[argPrint].second + " " + instruction.result.first ;
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
    else if(oper == "PRINTCALL1")
	{
        std::string comment = "\t#printcall1";
		std::string str1 = "\tpush %rcx";
		std::string str2 = "\tpush %rax";
        code.push_back(comment);
		code.push_back(str1);
		code.push_back(str2);
        std::string name = instruction.argument2.first;
        // for print string support 
        if(name[0] == '~')
        {
            std::string format = "format" + std::to_string(++constIndex) + ":\n\t.asciz \"" + name.substr(8, name.length()-1) +"\"";
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
                std::string movins = "\tmov $print3, %rdi";
                std::string clearAl = "\txor %rax, %rax";
                std::string call = "\tcall printf";
                code.push_back(movins);
                code.push_back(clearAl);
                code.push_back(call);
            }
            else if(instruction.argument1.first == "1"){
                std::string printversion = "$print4";
                
                int argWidth = width(instruction.argument2);
                if(argWidth == 4){
                    printversion = "$print5";
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
        code.push_back(getLoadInstr(memArg, argWidth, 3));
        std::string sp2bp = "\tmov %rbp, %rsp";
         std::string restorerbp = "\tpop %rbp";
         code.push_back(sp2bp);
         code.push_back(restorerbp);
        code.push_back("\tret");
    }
    
	else if(oper == "RETURNVALUE")
	{
        std::string memArg = getMemLocation(instruction.result, code);
        int argWidth = width(instruction.result);
        code.push_back(getStoreInstr(memArg, argWidth, 3));
    }

	else if(oper=="~"   ){
		std::string memArg = getMemLocation(instruction.argument2, code);
		int argWidth = width(instruction.argument2);
        std::string memRes = getMemLocation(instruction.result,code);
        int resWidth = width(instruction.result);
		code.push_back(getLoadInstr(memArg, argWidth,3));
		std::string str = std::string()+ "\tnot "+"%rax";
		code.push_back(str);
        code.push_back(getStoreInstr(memRes, resWidth,3));
	}
    else if(oper == "!"){
        std::string memArg = getMemLocation(instruction.argument2, code);
        std::string resArg = getMemLocation(instruction.result ,code);
        std::cerr<< instruction.argument2.first<<"\n";
        code.push_back("\t#! "+instruction.argument2.first);
        code.push_back("\txorq %rax, %rax");
        int argWidth = width(instruction.argument2);
        int resWidth = width(instruction.result);
        code.push_back(getLoadInstr(memArg, argWidth , 3));
        code.push_back("\tcmp $0, %rax");
        code.push_back("\tsete %al");
        code.push_back(getStoreInstr(resArg, resWidth , 3));

    }
    // std::cerr<<pointerRegsInUse.size()<<" size\n";
    pointerRegsInUse.clear();
    
	return code;
} 
