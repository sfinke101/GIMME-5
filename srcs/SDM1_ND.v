`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2025 13:50:09
// Design Name: 
// Module Name: SDM1_ND
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


module SDM1_ND    
    #(parameter k=1024, parameter bits=12) (
    input clk,
    input rst,
    input signed [bits-1:0] x,
    output reg y
    );
    
    wire signed [bits:0] sum;
    reg signed [bits:0] fbz;    
    
    assign sum = x + fbz;
    
    always@(*)
    begin
    
    if (rst)
        begin
        y = 0;
        end
    else if (sum >= 0)
        begin
        y = 1'b1;
        end
    else
        begin
        y = 1'b0;
        end
    
    end   
    
    
    always@(posedge clk)
    begin
        if(rst) 
            begin
                fbz <=0;
            end
            
        else if (sum >=0) 
            begin
                fbz <=sum-k;
            end 
          
        else 
            begin
                fbz <=sum+k;
            end
     end    
endmodule
