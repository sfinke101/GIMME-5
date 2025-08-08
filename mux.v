`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2024 10:31:27
// Design Name: 
// Module Name: mux
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


module mux #(
    parameter bits = 7
) (
    input                       select,
    input   signed [bits-1:0]   in1,
    input   signed [bits-1:0]   in2,
    output  signed [bits-1:0]   out
);

assign out = select ? in1 : in2;

endmodule

