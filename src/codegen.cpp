#include "codegen.h"
#include "3ac.h"
#include <map>
#include <string>
#include<vector>
#include<utility>
#include<set>


inline int64_t rnd(int l,int r)
{
	return rand()%(r-l+1)+l;
}


class Registers{
public:
    // < regName , < VariableName , lastTimeUsed >>
	std::map<string, pair<string, int>> regs;
    // stores all the argumentRegisters
	std::vector<string> argumentRegs ;
    // stores the caller saved registers
    std::vector<string> callerSaved ;
    // stores the calle saved registers
	std::vector<string> calleeSaved ;
    // < RegName, placeHolder for lastByte > 
	std::map<string, string> lastByte;
    
	std::string rip,rbp;
    // < variableName , < regName , memoryLocation >>
	std::map<string, pair<string, string>> locations; 
    
    int timestamp; 

	Registers(){
		timestamp=0;
		std::vector<string> vec_regs = {"%rbx","%r10","%r11", "%r12", "%r13", "%r14", "%r15"};
		for(auto x: vec_regs){
			regs[x]={"",0};
		}

		argumentRegs = {"%rdi","%rsi","%rdx","%rcx","%r8","%r9"};
        callerSaved = {};
        calleeSaved = {};

		std::vector<string> vecregs = {"%rax","%rbx", "%rcx", "%rdx" , "%r8", "%r9", "%r10", "%r11", "%r12", "%r13", "%r14", "%r15" };
		std::vector<string> vals = {"%al", "%bl", "%cl", "%dl", "%r8b", "%r9b", "%r10b", "%r11b", "%r12b", "%r13b", "%r14b", "%r15b" };
		
		for(int i=0;i<vecregs.size();i++){
			lastByte[vecregs[i]]=vals[i];
		}
	}
    // selectReg() selects a register to use next based on LRU scheme
    string selectReg(){
		int threshold =1e9+6;
		string reg;
		for(auto tempreg :regs){
			if(tempreg.second.second <= threshold){
				//threshold=t.second.second;
				reg = tempreg.first;
			}
		}
		
		return reg;
	}

	vector<string> writeBack(vector<string> writeRegs={}, bool flush= true){
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
    bool inLocations(std::string varName){
		for(auto entry : locations){
			if(entry.first == varName)
				return true;
		}
		return false;
	}

    // this function is to get the register for a variable 
    pair<string, vector<string>> getRegister(string varName=""){
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

};


class X86 {
    public:
    // stores the final x86 code
    std::vector<string> x86;
    // input 3AC code to be converted to x86
    std::vector<quad> tacCode;
    // Instance of the registers class to generate x86
    Registers registers;
    // to store constants to be added in the data section
    std::vector<string> constants;

    X86(vector<quad> _tacCode){
		tacCode = _tacCode;
		Registers * regs = new Registers();
		registers =*regs;
	}

    void codeGen(){

		x86.push_back(".global main");
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
		
	
		
		x86.push_back("");
		x86.push_back(".data");
		for(string s:constants)
			x86.push_back(s);

		cout<<"\n\n\n\n\n\n\nBEGINNING ASM PART\n\n\n\n\n\n\n";
		ofstream my_function_dump("./bin/output.s");

		

	}
};

