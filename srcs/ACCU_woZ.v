`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2025 15:01:28
// Design Name: 
// Module Name: ACCU_woZ
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


module ACCU_woZ#(
    parameter signed LIMIT = 26'sd18849555,  // 2^23 - 1)
    parameter IN_WIDTH = 15,
    parameter SIZE     = 26
    )(
    input clk,
    input rst,
    input signed [IN_WIDTH-1:0] IN,
    output signed [SIZE-1:0] ACCU
);

    reg  signed [SIZE-1:0]  ACCU_Z;    
    wire signed [SIZE:0]    next_accu = ACCU_Z + (16*IN);

    
    assign ACCU =   (next_accu > LIMIT) ?   LIMIT  :
                    (next_accu < -LIMIT)?   -LIMIT :
                                        next_accu;

    always @(posedge clk) begin
        if (rst)
            ACCU_Z <= 0;
        else
            ACCU_Z <= ACCU ;  // Truncation
    end
endmodule
