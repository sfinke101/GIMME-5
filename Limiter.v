`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2025 13:53:47
// Design Name: 
// Module Name: Limiter
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


module Limiter 
#(
parameter signed    LIMIT = 1000,
parameter           BITS  = 11)(
input                               clk,
input                               rst,
input  signed       [BITS-1:0]      IN,
output reg   signed [BITS-1:0]      OUT
);

always@(posedge clk)
begin
if (rst)
OUT <= 0;

else if (IN > LIMIT)
OUT <= LIMIT;

else if (IN < -LIMIT)
OUT <= -LIMIT;

else
OUT <= IN;

end

endmodule
