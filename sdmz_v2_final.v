`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2024 18:56:43
// Design Name: 
// Module Name: sdmz_v2_final
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


module sdmz_v2_final
    #(parameter k=1024, parameter bits=12) (
    input clk,
    input rst,
    input signed [bits-1:0] x,
    output reg y
    );
    
    wire signed [bits:0] sum ;
    reg signed [bits:0] fbz ;

   assign sum = x + fbz;
      
    always@(posedge clk)
    begin
        if(rst) 
            begin
                fbz <=0;
                y   <=0;
            end
            
        else if (sum >=0) 
            begin
                y<=1'b1;
                fbz<=sum-k;
            end 
          
        else 
            begin
                y<=1'b0;
                fbz<=sum+k;
            end
     end
     
endmodule

