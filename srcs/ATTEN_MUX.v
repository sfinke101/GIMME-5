`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2025 11:40:01
// Design Name: 
// Module Name: ATTEN_MUX
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


module ATTEN_MUX#(
    parameter bits = 7
) (
    input                       select,
    input          [bits-1:0]   in1,
    output  signed [bits:0]     out
);

assign out = select ? in1 : -in1;

endmodule
