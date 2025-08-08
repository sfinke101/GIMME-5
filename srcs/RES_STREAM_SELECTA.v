`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2025 12:14:55
// Design Name: 
// Module Name: RES_STREAM_SELECTA
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


module RES_STREAM_SELECTA#(
parameter WIDTH = 16)(
input                                clk,
input                                rst,
input                                select_1,
input                                select_2,
input                                select_3,
input                                select_4,
input       signed  [WIDTH-1:0]      in_1,

output  reg signed  [WIDTH-1:0]      out);


//Input Gain = 4
//Negative Feedback = 5
/*
always@(posedge clk)
begin
if (rst)        out <= 0;
else if (!select_1  &&  !select_2    &&  !select_3    && !select_4)     out <=   1 * in_1;
else if (!select_1  &&  !select_2    &&  !select_3    &&  select_4)     out <=   3 * in_1;
else if (!select_1  &&  !select_2    &&   select_3    && !select_4)     out <=  -9 * in_1;
else if (!select_1  &&  !select_2    &&   select_3    &&  select_4)     out <=  -7 * in_1;
else if (!select_1  &&   select_2    &&  !select_3    && !select_4)     out <=   -1 * in_1;
else if (!select_1  &&   select_2    &&  !select_3    &&  select_4)     out <=   1 * in_1;
else if (!select_1  &&   select_2    &&   select_3    && !select_4)     out <=  -11 * in_1;
else if (!select_1  &&   select_2    &&   select_3    &&  select_4)     out <=  -9 * in_1;
else if ( select_1  &&  !select_2    &&  !select_3    && !select_4)     out <=   9 * in_1;
else if ( select_1  &&  !select_2    &&  !select_3    &&  select_4)     out <=   11 * in_1;
else if ( select_1  &&  !select_2    &&   select_3    && !select_4)     out <=  -1 * in_1;
else if ( select_1  &&  !select_2    &&   select_3    &&  select_4)     out <=   1 * in_1;
else if ( select_1  &&   select_2    &&  !select_3    && !select_4)     out <=   7 * in_1;
else if ( select_1  &&   select_2    &&  !select_3    &&  select_4)     out <=   9 * in_1;
else if ( select_1  &&   select_2    &&   select_3    && !select_4)     out <=  -3 * in_1;
else if ( select_1  &&   select_2    &&   select_3    &&  select_4)     out <=  -1 * in_1;
else                                out <= 0;
end
*/


//Input Gain = 5
//Negative Feedback = 7
always@(posedge clk)
begin
if (rst)        out <= 0;
else if (!select_1  &&  !select_2    &&  !select_3    && !select_4)     out <=   2 * in_1;
else if (!select_1  &&  !select_2    &&  !select_3    &&  select_4)     out <=   4 * in_1;
else if (!select_1  &&  !select_2    &&   select_3    && !select_4)     out <=  -12 * in_1;
else if (!select_1  &&  !select_2    &&   select_3    &&  select_4)     out <=  -10 * in_1;
else if (!select_1  &&   select_2    &&  !select_3    && !select_4)     out <=   0 * in_1;
else if (!select_1  &&   select_2    &&  !select_3    &&  select_4)     out <=   2 * in_1;
else if (!select_1  &&   select_2    &&   select_3    && !select_4)     out <=  -14 * in_1;
else if (!select_1  &&   select_2    &&   select_3    &&  select_4)     out <=  -12 * in_1;
else if ( select_1  &&  !select_2    &&  !select_3    && !select_4)     out <=   12 * in_1;
else if ( select_1  &&  !select_2    &&  !select_3    &&  select_4)     out <=   14 * in_1;
else if ( select_1  &&  !select_2    &&   select_3    && !select_4)     out <=   -2 * in_1;
else if ( select_1  &&  !select_2    &&   select_3    &&  select_4)     out <=   0 * in_1;
else if ( select_1  &&   select_2    &&  !select_3    && !select_4)     out <=   10 * in_1;
else if ( select_1  &&   select_2    &&  !select_3    &&  select_4)     out <=   12 * in_1;
else if ( select_1  &&   select_2    &&   select_3    && !select_4)     out <=   -4 * in_1;
else if ( select_1  &&   select_2    &&   select_3    &&  select_4)     out <=   -2 * in_1;
else                                out <= 0;
end

/*
//Input Gain = 5
//Positive Feedback = 7
always@(posedge clk)
begin
if (rst)        out <= 0;
else if (!select_1  &&  !select_2    &&  !select_3    && !select_4)     out <=  -12 * in_1;
else if (!select_1  &&  !select_2    &&  !select_3    &&  select_4)     out <=  -10 * in_1;
else if (!select_1  &&  !select_2    &&   select_3    && !select_4)     out <=   2 *  in_1;
else if (!select_1  &&  !select_2    &&   select_3    &&  select_4)     out <=   4 *  in_1;
else if (!select_1  &&   select_2    &&  !select_3    && !select_4)     out <=  -14 * in_1;
else if (!select_1  &&   select_2    &&  !select_3    &&  select_4)     out <=  -12 * in_1;
else if (!select_1  &&   select_2    &&   select_3    && !select_4)     out <=   0 *  in_1;
else if (!select_1  &&   select_2    &&   select_3    &&  select_4)     out <=   2 *  in_1;
else if ( select_1  &&  !select_2    &&  !select_3    && !select_4)     out <=  -2 *  in_1;
else if ( select_1  &&  !select_2    &&  !select_3    &&  select_4)     out <=   0 *  in_1;
else if ( select_1  &&  !select_2    &&   select_3    && !select_4)     out <=   12 * in_1;
else if ( select_1  &&  !select_2    &&   select_3    &&  select_4)     out <=   14 * in_1;
else if ( select_1  &&   select_2    &&  !select_3    && !select_4)     out <=  -4 *  in_1;
else if ( select_1  &&   select_2    &&  !select_3    &&  select_4)     out <=  -2 *  in_1;
else if ( select_1  &&   select_2    &&   select_3    && !select_4)     out <=   10 * in_1;
else if ( select_1  &&   select_2    &&   select_3    &&  select_4)     out <=   12 * in_1;
else                                out <= 0;
end*/



endmodule
