`define XIAO_RV 	0321 // my birthday :)

`define RISC_ISA 	32
`define	PC_RST_ADDR 	32'h0000_0000

// basic coding for opcode(only use 5 bits)
`define OPCODE_TYPE_R_CALC	5'b01100
`define	OPCODE_TYPE_I_CALC	5'b00100 
`define	OPCODE_TYPE_I_LOAD	5'b00000 
`define OPCODE_TYPE_I_ENV	5'b11100 // inst: ecall & ebreak
`define OPCODE_TYPE_S		5'b01000
`define OPCODE_TYPE_B		5'b11000
`define OPCODE_TYPE_J		5'b11011 // inst: jaL
`define OPCODE_TYPE_U		5'b0x101 // inst: lui & auipc

// special coding for opcode(only use 5 bits)
`define OPCODE_JAL		5'b11011
`define OPCODE_JALR		5'b11001
`define OPCODE_LUI		5'b01101
`define OPCODE_AUIPC		5'b00101
`define OPCODE_FENCE		5'b00011 

// alu control signal decode
`define ALU_NONE 	4'b0000
`define ALU_ADD	 	4'b0001
`define ALU_SUB		4'b0010
`define	ALU_XOR		4'b0011
`define	ALU_OR		4'b0100
`define	ALU_AND		4'b0101
`define ALU_SLL		4'b0110
`define	ALU_SRL		4'b0111
`define	ALU_SRA		4'b1000
`define	ALU_SLT		4'b1001
`define	ALU_SLTU	4'b1010
