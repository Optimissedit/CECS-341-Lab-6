`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2021 11:43:54 AM
// Design Name: 
// Module Name: Control
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


module Control(
    input [5:0] Op,
    input [5:0] Func,
    output reg [3:0] ALUCntl,
    output reg RegWrite,
    output reg Regdst,
    output reg [1:0] Branch,
    output reg Memread,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg Jump
    );
    
    always@(*) begin
        // r type
        if (Op == 6'b0) begin
            RegWrite = 1'b1;                //write back to register file
            Regdst   = 1'b1;                //Inst[15:11]write back address
            Branch   = 2'b0;                //No branching performed
            Memread  = 1'b0;                //no read from memory
            MemtoReg = 1'b0;                //write back data comes from alu
            MemWrite = 1'b0;                //no write to memory
            ALUSrc   = 1'b0;                // source b comes from register file 
            Jump = 1'b0;                    // No jump required
            case(Func)
                6'h20: ALUCntl = 4'b1010;    // add signed
                6'h21: ALUCntl = 4'b0010;    // add unsigned        
                6'h22: ALUCntl = 4'b1110;    // subtract signed      
                6'h23: ALUCntl = 4'b0110;    // subtract unsigned          
                6'h24: ALUCntl = 4'b0000;    // and            
                6'h25: ALUCntl = 4'b0001;   // or         
                6'h26: ALUCntl = 4'b0011;   // xor             
                6'h27: ALUCntl = 4'b1100;    // nor
                6'h2A: ALUCntl = 4'b1000;   // set less than		
                6'h2B: ALUCntl = 4'b1001;   // set less than unsigned
                default: ALUCntl = 4'b0000;
            endcase
        end
        
        //I / J type
        else begin
            case(Op)
                6'h08:begin             //addi              
					RegWrite = 1'b1;               
					Regdst   = 1'b0;	  // [20:16]         
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;          
					Jump = 1'b0;          // No jump required      
					ALUCntl = 4'b1010;    // add signed
			    end
				6'h09: begin            //addiu
					RegWrite = 1'b1;               
					Regdst   = 1'b0;	  // [20:16] 
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;     
					Jump = 1'b0;          // No jump required                
					ALUCntl = 4'b0010;    // add unsigned
				end
                6'h0c: begin            //andi
					RegWrite = 1'b1;               
					Regdst   = 1'b0;                //[20-16]
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;   
					Jump = 1'b0;          // No jump required                  
					ALUCntl = 4'b0000;    // and
				end
                6'h0D: begin            //ori
					RegWrite = 1'b1;               
					Regdst   = 1'b0;                //[20-16]
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;   
					Jump = 1'b0;          // No jump required                  
					ALUCntl = 4'b0001;   // or 
				end
			    6'h23: begin             //lw
					RegWrite = 1'b1;               
					Regdst   = 1'b0;                //[20-16]
					Branch   = 2'b0;                
					Memread  = 1'b1;                
					MemtoReg = 1'b1;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;    
					Jump = 1'b0;          // No jump required                 
					ALUCntl = 4'b1010;    // add signed
				end
				6'h2B: begin            //sw
					RegWrite = 1'b0;               
					Regdst   = 1'b0;
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b1;             
					ALUSrc   = 1'b1;    
					Jump = 1'b0;          // No jump required                 
					ALUCntl = 4'b1010;    // add signed
				end
				6'h04: begin            //beq
					RegWrite = 1'b0;               
					Regdst   = 1'b0;
					Branch   = 2'b01;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b1;             
					ALUSrc   = 1'b0;    
					Jump = 1'b0;          // No jump required                 
					ALUCntl = 4'b1110;    // subtract signed
				end
			    6'h05: begin         //bne
					RegWrite = 1'b0;               
					Regdst   = 1'b0;
					Branch   = 2'b10;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b0;      
					Jump = 1'b0;          // No jump required               
					ALUCntl = 4'b1110;    // subtract signed
				end
				6'h0A: begin            //slti
					RegWrite = 1'b1;               
					Regdst   = 1'b0;                //[20-16]
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;      
					Jump = 1'b0;          // No jump required               
					ALUCntl = 4'b1000;   // set less than
				end
				6'h0B: begin            //sltiu
					RegWrite = 1'b1;               
					Regdst   = 1'b0;                //[20-16]
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;       
					Jump = 1'b0;          // No jump required              
					ALUCntl = 4'b1001;   // set less than unsigned
				end
				// JUMP CASE! (J Type) Todo: find control signal values
				6'h02: begin
				    RegWrite = 1'b0;     // not writing to registers
					Regdst   = 1'b0;     //[20-16] not used
					Branch   = 2'b0;     // no branch
					Memread  = 1'b0;     // not reading from mem               
					MemtoReg = 1'b0;     // not loading values to reg
					MemWrite = 1'b0;     // not writing to mem
					ALUSrc   = 1'b0;     // alu not needed
					Jump = 1'b1;          // jump!            
					ALUCntl = 4'b0000;   // and (default, logic not used)
				end
				default:begin    
					RegWrite = 1'b0;               
					Regdst   = 1'b0;                //[20-16]
					Branch   = 2'b0;                
					Memread  = 1'b0;                
					MemtoReg = 1'b0;                
					MemWrite = 1'b0;             
					ALUSrc   = 1'b1;         
					Jump = 1'b0;          // No jump required            
					ALUCntl  = 4'b1010;
				end
			endcase		
		end
    end
endmodule