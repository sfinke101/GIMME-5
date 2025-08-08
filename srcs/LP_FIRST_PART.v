`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2025 12:12:52
// Design Name: 
// Module Name: LP_FIRST_PART
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


module LP_FIRST_PART#(
parameter K = 24,
parameter sdm = 20,
parameter sdm2 = 2**sdm)
(
input               clk,
input               rst,
input               AUDIO_IN,
input   [14:0]      CUTOFF_EXP,
input               RESONANCE,
input               FILTER_DRIVE,

output              AUDIO_OUT);


wire signed     [19:0]  CUTOFF;
wire signed     [25:0]  ACCU;
   

//Bitstream Adder
RES_STREAM_SELECTA #(
.WIDTH(20))
LP_SELECTA_RES(
.clk(clk),
.rst(rst),
.select_1(AUDIO_IN),
.select_2(AUDIO_OUT),
.select_3(RESONANCE),
.select_4(FILTER_DRIVE),
.in_1(CUTOFF_EXP),
.out(CUTOFF)); 


//Integration
ACCU_woZ #(
.IN_WIDTH(20),
.SIZE(26))
Accumulator_LP_First(
.clk(clk),
.rst(rst),
.IN(CUTOFF),
.ACCU(ACCU));

//DIVIDE Integrator
sdmz_v2_final #(.k(18849555), .bits(26))
   sdmz_v2_final_LP_First(
    .clk(clk),
    .rst(rst),
    .x(ACCU),
    .y(AUDIO_OUT)); 
endmodule
