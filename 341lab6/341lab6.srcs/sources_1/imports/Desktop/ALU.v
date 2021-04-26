`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Sam Blawski
// 
// Create Date: 02/22/2021 10:24:57 AM
// Design Name: ALU
// Module Name: ALU
// Project Name: Lab 3
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUCntl,
    output reg [31:0] ALUout,
    output reg C,
    output reg V,
    output Z,
    output reg N
    );
    
    reg signed [31:0] A_s, B_s;
    assign Z = (ALUout == 32'b0) ? 1'b1 : 1'b0;
    
    always@(*) begin
        A_s = A;
        B_s = B;
        case(ALUCntl)
        // AND
        4'b0000: begin
                    {V, C, ALUout} = {2'bx, (A & B)};
                    N = ALUout[31];
                 end
        // OR
        4'b0001: begin
                    {V, C, ALUout} = {2'bx, (A | B)};
                    N = ALUout[31];
                 end
        // XOR
        4'b0011: begin
                    {V, C, ALUout} = {2'bx, (A ^ B)};
                    N = ALUout[31];
                 end
		// ADD SIGNED
        4'b1010: begin
                    {C, ALUout} = A_s + B_s;
                    if((A_s[31] & B_s[31] & ~ALUout[31]) || (~A_s[31] & ~B_s[31] & ALUout[31]))
                        V = 1'b1;
                    else
                        V = 1'b0;
                    N = ALUout[31];
                 end
        // SUBTRACT SIGNED
        4'b1110: begin
                    {C, ALUout} = A_s - B_s;
                    if((A_s[31] & ~B_s[31] & ~ALUout[31]) || (~A_s[31] & B_s[31] & ALUout[31]))
                        V = 1'b1;
                    else
                        V = 1'b0;
                    N = ALUout[31];
                 end
        // ADD UNSIGNED
        4'b0010: begin
                    {C, ALUout} = A + B;
                    V = C;
                    N = 1'b0;
                 end
        // SUBTRACT UNSIGNED
        4'b0110: begin
                    {C, ALUout} = A - B;
                    V = C;
                    N = ALUout[31];
                 end
        // NOR
        4'b1100: begin
                    {V, C, ALUout} = {2'bx, (~(A | B))};
                    N = ALUout[31];
                 end
        // NOT
        4'b0111: begin
                    {V, C, ALUout} = {2'bx, ~A};
                    N = ALUout[31];
                 end
        // SHIFT LEFT LOGICAL
        4'b1101: begin
                    C = A[31];
                    {V, ALUout} = {1'bx, (A << 1)};
                    N = ALUout[31];
                 end
        // SET LESS THAN
        4'b1000: begin
                    {C, V} = 2'bx;
                    ALUout = (A_s < B_s) ? 32'b1 : 32'b0;
                    N = 1'b0;
                 end
        // SET LESS THAN UNSIGNED
        4'b1001: begin
                    {C, V} = 2'bx;
                    ALUout = (A < B) ? 32'b1 : 32'b0;
                    N = 1'b0;
                 end
        // DEFAULT
        default: begin
                    {C, V, N} = 3'bx;
                    ALUout = 32'bx;
		          end
        endcase
    end

endmodule
