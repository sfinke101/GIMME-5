`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2025 12:07:17
// Design Name: 
// Module Name: STREAM_SELECTA
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


module STREAM_SELECTA#(
parameter WIDTH = 16)(
input                                clk,
input                                rst,
input                                select_1,
input                                select_2,
input       signed  [WIDTH-1:0]      in_1,

output  reg signed  [WIDTH-1:0]      out);


always@(posedge clk)
begin
if (rst)        out <= 0;
else if (select_1 && !select_2)     out <=  2 * in_1;
else if (!select_1 && select_2)     out <= -2 * in_1;
else                                out <=      0;
end
endmodule



