`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2021 12:09:59 PM
// Design Name: 
// Module Name: Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath(
    input clk,
    input reset,
    output reg [31:0] D_out
    );
    wire [31:0] PC_out, PCADD4_out, PCADDSHFT_out, signExt, signShift;
    
    wire [31:0] ADD_mux;
    wire [31:0] ALU_mux;
    wire [31:0] D_mux;
    wire [4:0] RegDst_mux;
    
    wire [31:0] instr;
    wire [31:0] rs;
    wire [31:0] rt;
    wire [31:0] rd_data;
    
    wire [3:0] ALUCntl;
    wire [31:0] ALUout;
    wire [1:0] Branch;
    wire regWrite;
    wire RegDst;
    
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    
    wire Z;
    
    wire BranchSel;
    
    assign signExt = {{16{instr[15]}}, instr[15:0]};
    assign signShift = signExt << 2;
    assign BranchSel = (Branch[0] & Z) | (Branch[1] & ~Z);
    
    assign RegDst_mux = (RegDst) ? instr[15:11] : instr[20:16];
    assign ADD_mux = (BranchSel) ? PCADDSHFT_out : PCADD4_out;
    assign ALU_mux = (ALUSrc) ? signExt : rt;
    assign D_mux = (MemtoReg) ? rd_data : ALUout;
    
    //added for lab6
    wire [31:0] jumpAddress, Jump_mux;
    wire Jump;
    assign jumpAddress = {PCADD4_out[31:28], instr[25:0], 2'b0};
    assign Jump_mux = (Jump) ? jumpAddress : ADD_mux;
    
    always@(posedge clk, posedge reset) begin
        if(reset == 1)
            D_out <= 32'b0;
        else 
            D_out <= D_mux;
    end
    
    PC 
        PC(.clk(clk), .reset(reset), .PC_in(Jump_mux), .PC_out(PC_out));
    
    PCADD 
        PCADD_4(.PC_in0(PC_out), .PC_in1(32'b100), .PC_out(PCADD4_out)),
        PCADD_SHFT(.PC_in0(PCADD4_out), .PC_in1(signShift), .PC_out(PCADDSHFT_out));
        
    Instruction_Memory
        Instruction_Memory(.Addr(PC_out), .Inst_out(instr));
        
    Control
        Control(.Op(instr[31:26]), .Func(instr[5:0]), .ALUCntl(ALUCntl), .RegWrite(regWrite), .Regdst(RegDst), .Branch(Branch), .Memread(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .Jump(Jump));
        
    regfile32
        regfile32(.clk(clk), .reset(reset), .D_En(regWrite), .S_Addr(instr[25:21]), .T_Addr(instr[20:16]), .D_Addr(RegDst_mux), .D(D_mux), .S(rs), .T(rt));
        
    ALU
        ALU(.A(rs), .B(ALU_mux), .ALUCntl(ALUCntl), .ALUout(ALUout), .Z(Z));
        
    DataMem
        DataMem(.clk(clk), .mem_wr(MemWrite), .mem_rd(MemRead), .addr(ALUout), .wr_data(rt), .rd_data(rd_data));
    

endmodule
