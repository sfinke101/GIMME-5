`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2025 10:35:54
// Design Name: 
// Module Name: Adder_VCO
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


module Adder_VCO(In1, In2, In3, sum_out);

input               In1;
input               In2;
input               In3;

wire signed [1:0]   OSC_1;
wire signed [1:0]   OSC_2;
wire signed [1:0]   OSC_3;

output  [2:0]   sum_out;


assign OSC_1 = In1 ? 2'b01 : -2'b01;
assign OSC_2 = In2 ? 2'b01 : -2'b01;
assign OSC_3 = In3 ? 2'b01 : -2'b01;


assign sum_out = OSC_1 + OSC_2 + OSC_3;


endmodule
