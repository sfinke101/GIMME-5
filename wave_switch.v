`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2024 23:56:46
// Design Name: 
// Module Name: wave_switch
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


module wave_switch(
input clk,
input rst,
input [6:0] switch,
input [10:0] sine,
//input [5:0] sine,
input  [10:0] saw,
input [10:0] rect,
input [10:0] triangle,
output [10:0]wave
//output [5:0]wave
    );
    
 reg [10:0] out;
     
always@(posedge clk , posedge rst)
     begin
        if(rst) 
        begin
                out <=sine;
        end
            
        else if (switch < 32) 
        begin
                out<=sine;
        end
        
        else if (switch > 32 && switch < 64 ) 
        begin
                out<=triangle;
        end    
        
        else if (switch > 64 && switch < 96 ) 
        begin
                out<=saw;
        end     
            
        else 
        begin
                out<=rect;
        end
     end    
    
assign wave = out;    
    
    
    
endmodule
