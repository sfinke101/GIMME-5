`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2025 16:01:35
// Design Name: 
// Module Name: FILTER_TYPE_SWITCH
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


module FILTER_TYPE_SWITCH(
input               clk,
input               rst,
input       [6:0]   FILTER_TYPE_CC,
input               LP_POLE1,
input               LP_POLE2,
input               LP_POLE3,
input               LP_POLE4,
output              TYPE_SWITCH_AUDIO_OUT
);
    
reg out;
assign TYPE_SWITCH_AUDIO_OUT = out;
     
always@(posedge clk , posedge rst)
     begin
        if(rst) 
        begin
                out <=LP_POLE1;
        end
            
        else if (FILTER_TYPE_CC < 32) 
        begin
                out<=LP_POLE1;
        end
        
        else if (FILTER_TYPE_CC > 32 && FILTER_TYPE_CC < 64 ) 
        begin
                out<=LP_POLE2;
        end    
        
        else if (FILTER_TYPE_CC > 64 && FILTER_TYPE_CC < 96 ) 
        begin
                out<=LP_POLE3;
        end     
            
        else 
        begin
                out<=LP_POLE4;
        end
     end      
endmodule