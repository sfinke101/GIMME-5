`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2025 13:03:19
// Design Name: 
// Module Name: TRI_MUX
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


module TRI_MUX#(
    parameter bits = 7
) (
    input   signed [2:0]            select,
    input   signed [bits-1:0]       in1,
    input   signed [bits-1:0]       in2,
    output  reg signed [bits-1:0]   out
);

always @(*) begin
    case (select)
        2:    out = in1;
       -2:    out = in2;
        default: out = 0;
    endcase
end

endmodule
