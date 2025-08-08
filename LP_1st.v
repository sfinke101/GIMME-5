`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2025 11:45:10
// Design Name: 
// Module Name: LP_1st
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


module LP_1st #(
parameter K = 24,
parameter sdm = 20,
parameter sdm2 = 2**sdm)
(
input               clk,
input               rst,
input               AUDIO_IN,
input   [14:0]      CUTOFF_EXP,

output              AUDIO_OUT);

wire signed     [16:0]  CUTOFF;
wire signed     [25:0]  ACCU;
    


//Bitstream Adder
STREAM_SELECTA #(
.WIDTH(17))
LP_SELECTA(
.clk(clk),
.rst(rst),
.select_1(AUDIO_IN),
.select_2(AUDIO_OUT),
.in_1(CUTOFF_EXP),
.out(CUTOFF)); 


//Integration
ACCU_woZ #(
.IN_WIDTH(17),
.SIZE(26))
Accumulator_LP_1st(
.clk(clk),
.rst(rst),
.IN(CUTOFF),
.ACCU(ACCU));

//DIVIDE Integrator
sdmz_v2_final #(.k(18849555), .bits(26))
   sdmz_v2_final_LP(
    .clk(clk),
    .rst(rst),
    .x(ACCU),
    .y(AUDIO_OUT)); 
endmodule
