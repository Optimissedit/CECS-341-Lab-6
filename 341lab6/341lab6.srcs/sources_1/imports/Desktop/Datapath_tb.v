`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2021 12:06:49 PM
// Design Name: 
// Module Name: Datapath_tb
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


module Datapath_tb();
    
    // Declare inputs to UUT (reg)
    reg clk;
    reg reset;
    
    // Declare output of UUT (as wires)
    wire [31:0] D_out;
    
    // Testbench specific value
    integer i;
     
    Datapath uut(.clk(clk), .reset(reset), .D_out(D_out));
    
    // Clock logic
    always
        #10 clk = ~clk;
    
    // Task to dump values of registers after operations
    task Dump_DataMem; begin
        $timeformat(-9, 1, " ns", 9);
        // Loop to display dout after each instruction
        $display("Initial Values:");
        for(i = 0; i < 21; i = i + 4) begin
            @(posedge clk)
            $display("t=%t  address[%0d]:    %h%h%h%h", $time, i, uut.DataMem.dmem[i], uut.DataMem.dmem[i+1], uut.DataMem.dmem[i+2], uut.DataMem.dmem[i+3]);
            end
        $display("Final Values:");
        for(i = 24; i < 45; i = i + 4) begin
            @(posedge clk)
            $display("t=%t  address[%0d]:    %h%h%h%h", $time, i, uut.DataMem.dmem[i], uut.DataMem.dmem[i+1], uut.DataMem.dmem[i+2], uut.DataMem.dmem[i+3]);
            end
        end
    endtask
    
    initial begin
        clk = 0; reset = 1; #20;
        $readmemh("imem.dat", uut.Instruction_Memory.imem);
        $readmemh("DataMem.dat", uut.DataMem.dmem);
        reset = 0; #600;
        Dump_DataMem;
        $finish;
    end
    
endmodule