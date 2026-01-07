#include <iostream>
#include <vector>

#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcpu.h"

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vcpu* top;

void step_and_dump_wave(){
  	top->eval();
	contextp->timeInc(1);
	tfp->dump(contextp->time());
}
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new Vcpu;
	contextp->traceEverOn(true);
	top->trace(tfp, 0);
	tfp->open("dump.vcd");
}

void sim_exit(){
  	step_and_dump_wave();
  	tfp->close();
}

using namespace std;

bool ebreak_triggered = false;
extern "C" {
	void ebreak_handler();
}

void ebreak_handler(){
	cout<< "Ebreak executed, Simulation will stop." << endl;
	ebreak_triggered = true;
}

class Memory{
	private:
		vector<uint32_t> memory;
	public:
		Memory(size_t size) : memory( size/4 , 0) {} // size stands for total Bytes num

		void write(uint32_t addr, uint32_t data){
			size_t index = (addr - 0x80000000) >> 2;
			if(index < memory.size()){
				memory[index] = data;
			} else {
				cerr << "Error: Write Mem failed" << endl;
			}
		}

		uint32_t read(uint32_t addr){
			size_t index = (addr - 0x80000000) >> 2;
			if(index < memory.size()){
				return memory[index];
			} else {
				cerr << "Error: Read Mem Failed" << endl;
				return 0;
			}
		
		
		}

		void load_program(const vector<uint32_t>& program,uint32_t start_addr){
			for(size_t i = 0;i < program.size(); i++){
				write(start_addr + i * 4,program[i]);
			}
		}

};

static vector<uint32_t> program = {
	0x00100093, // addi x1, x0, 1
	0x00208113, // addi x2, x1, 2
	0x00100073  //ebreak
};
int main() {
	sim_init();
	
	Memory mem(4 * 1024 * 1024);// 4MB memory
	mem.load_program(program,0x80000000);

  	top->clk = 0; 
	top->rst = 1;
  	for(int i = 0;i < 500;i++){
		//generate clk and reset
		if(i == 10) top->rst = 0;
  		top->clk = !top->clk;
		
		//read mem at the pulse edge
		//if(top->clk == 1 && top->rst == 0){
		//	top->inst_mem = mem.read(top->pc);
	//	}
	
		//dump wave
		step_and_dump_wave();
		
		//check whether ebreak occur
		/*
		 * if(top->inst_mem == 0x00100073 && top->rst == 0){
			cout << "ebreak detected, stopping sim." << endl;
			break;
		}
		*/
		if(ebreak_triggered){
			break;
		}
 	}
    
  	sim_exit();
}

