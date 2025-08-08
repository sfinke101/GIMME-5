`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2025 08:42:30
// Design Name: 
// Module Name: Accumulator
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

/*
module Accumulator
#(
parameter IN_WIDTH = 15,
parameter SIZE = 20,
parameter signed LIMIT = (1 <<< SIZE-1))(

input                               clk,
input                               rst,
input   signed      [IN_WIDTH-1:0]  IN,

output  reg signed  [SIZE-1:0]        ACCU);

wire signed [SIZE:0] next_accu = ACCU + IN;

always@(posedge clk)
begin
if (rst)
ACCU <= 0;

else if (next_accu > LIMIT)
ACCU <= LIMIT;

else if (next_accu < -LIMIT)
ACCU <= -LIMIT;

else
ACCU <= next_accu;

end
endmodule*/


module Accumulator #(
    parameter signed LIMIT = 26'sd18849555,  // 2^23 - 1)
    parameter IN_WIDTH = 15,
    parameter SIZE     = 26
    )(
    input clk,
    input rst,
    input signed [IN_WIDTH-1:0] IN,
    output reg signed [SIZE-1:0] ACCU
);



    wire signed [SIZE:0] next_accu = ACCU + IN;

    always @(posedge clk) begin
        if (rst)
            ACCU <= 0;
        else if (next_accu > LIMIT)
            ACCU <= LIMIT;
        else if (next_accu < -LIMIT)
            ACCU <= -LIMIT;
        else
            ACCU <= next_accu[SIZE-1:0];  // Truncation
    end
endmodule








/*
(
    parameter IN_WIDTH = 15,
    parameter SIZE     = 20
)(
    input                          clk,
    input                          rst,
    input  signed [IN_WIDTH-1:0]   IN,
    output reg signed [SIZE-1:0]   ACCU
);

    // Sättigungsgrenzen
    localparam signed [SIZE-1:0] LIMIT_POS = {1'b0, {(SIZE-1){1'b1}}};
    localparam signed [SIZE-1:0] LIMIT_NEG = -LIMIT_POS;

    // Vorzeichen-erweiterte Operanden
    wire signed [SIZE:0] accu_ext = {ACCU[SIZE-1], ACCU};
    wire signed [SIZE:0] in_ext   = {{(SIZE+1-IN_WIDTH){IN[IN_WIDTH-1]}}, IN};
    wire signed [SIZE:0] next_accu = accu_ext + in_ext;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ACCU <= 0;
        else if (next_accu > LIMIT_POS)
            ACCU <= LIMIT_POS;
        else if (next_accu < LIMIT_NEG)
            ACCU <= LIMIT_NEG;
        else
            ACCU <= next_accu[SIZE-1:0];
    end
endmodule*/


