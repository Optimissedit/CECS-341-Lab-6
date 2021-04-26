`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2020 11:50:29 PM
// Design Name: 
// Module Name: DataMem
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


module DataMem(
    input clk,
    input mem_wr,
    input mem_rd,
    input [31:0] addr,
    input [31:0] wr_data,
    output [31:0] rd_data
    );
    
    reg [7:0] dmem [0:4095];
    
    // write 
    always@(posedge clk) begin
        if(mem_wr) begin
            dmem[addr[11:0] + 2'd3] <= wr_data[7:0];
            dmem[addr[11:0] + 2'd2] <= wr_data[15:8];
            dmem[addr[11:0] + 2'd1] <= wr_data[23:16];
            dmem[addr[11:0] + 2'd0] <= wr_data[31:24];
        end      
    end
    
    //read
    assign rd_data = (mem_rd) ? {   dmem[addr[11:0] + 2'd0],
                                    dmem[addr[11:0] + 2'd1],
                                    dmem[addr[11:0] + 2'd2],
                                    dmem[addr[11:0] + 2'd3] } 
                                    : 32'hz;
                                  
           
endmodule
