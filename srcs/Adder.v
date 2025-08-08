`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2024 08:59:49
// Design Name: 
// Module Name: Adder
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


module Adder(In1, In2, In3, In4, In5, sum_out);

input           In1;
input           In2;
input           In3;
input           In4;
input           In5;


output [3:0]    sum_out;


wire signed [1:0]   Voice_1;
wire signed [1:0]   Voice_2;
wire signed [1:0]   Voice_3;
wire signed [1:0]   Voice_4;
wire signed [1:0]   Voice_5;




assign Voice_1 = In1 ? 2'b01 : -2'b01;
assign Voice_2 = In2 ? 2'b01 : -2'b01;
assign Voice_3 = In3 ? 2'b01 : -2'b01;
assign Voice_4 = In4 ? 2'b01 : -2'b01;
assign Voice_5 = In5 ? 2'b01 : -2'b01;



assign sum_out = In1 + In2 + In3 + In4 + In5;
//assign sum_out = Voice_1 + Voice_2 + Voice_3 + Voice_4 + Voice_5;

endmodule
