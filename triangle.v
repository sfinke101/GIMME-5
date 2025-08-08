`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 19:26:48
// Design Name: 
// Module Name: triangle
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


module triangle(
input clk,
input rst,
input [10:0] waveshape_tri,
input  [10:0] saw_in,
output [10:0] tri_out
    );
    
 reg [10:0] triangle;
    
    always@(posedge clk , posedge rst)
     begin
        if(rst) 
        begin
                triangle <=0;
        end
            
        else if (saw_in < waveshape_tri) 
        begin
                triangle <= saw_in + saw_in;
        end
          
        else 
        begin
                triangle <= 4095 - saw_in - saw_in;
        end
     end

assign tri_out = triangle;

endmodule
