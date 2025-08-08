`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2024 19:02:38
// Design Name: 
// Module Name: rect
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


module rect(
input clk,
input rst,
input [10:0] pwm,
input  [10:0] saw_in,
output [10:0] rect_out
    );
    
 reg [10:0] flag;
    
    always@(posedge clk , posedge rst)
     begin
        if(rst) 
        begin
                flag <=0;
        end
            
        else if (saw_in < pwm) 
        begin
                flag<=2047;
        end
          
        else 
        begin
                flag<=0;
        end
     end
    
assign rect_out = flag;
endmodule
