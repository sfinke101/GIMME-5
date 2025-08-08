`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2025 14:12:18
// Design Name: 
// Module Name: SVF
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


module SVF(CLK, RST, AUDIO_IN, CUTOFF_CC, RES_CC, AUDIO_OUT);


input               CLK;
input               RST; 
input               AUDIO_IN;
input   [6:0]       CUTOFF_CC;
input   [6:0]       RES_CC;

output              AUDIO_OUT;

// AUDIO_IN -> AUDIO_IN_SCALED -> FB_SUM -> HP -> CUT1 -> BP -> CUT2 -> LP
wire    [14:0]      CUTOFF_EXP;
wire    [10:0]      AUDIO_IN_UPSCALED;
wire    [12:0]      FB_SUM;
wire    [10:0]      FB_SUM_LIMITED;
wire                HP;
wire    [14:0]      CUT1;
wire                BP;
wire    [6:0]       BP_RES;
wire                BP_RES_BIT;
wire    [11:0]      RES_1414;
wire    [14:0]      CUT2;
wire                LP;
wire    [10:0]      LP_UPSCALED;
wire    [20:0]      ACCU_HP;
wire    [20:0]      ACCU_BP;


assign  FB_SUM      = AUDIO_IN_UPSCALED - LP_UPSCALED - RES_1414;
assign  AUDIO_OUT   = BP;

//LIMITER
Limiter #(
.LIMIT(3500),
.BITS(13))
Limiter_FB_SUM(
.clk(CLK),
.rst(RST),
.IN(FB_SUM),
.OUT(FB_SUM_LIMITED));


//MULTIPLEXER AS MULTIPLIER
mux #(.bits(11))
mux_AUDIO_IN_scaler(
.select(AUDIO_IN),
.in1(1000),
.in2(-1000),
.out(AUDIO_IN_UPSCALED));

mux #(.bits(11))
mux_LP_scaler(
.select(LP),
.in1(1000),
.in2(-1000),
.out(LP_UPSCALED));

mux #(.bits(8))
mux_RES_scaler(
.select(BP),
.in1(RES_CC),
.in2(-RES_CC),
.out(BP_RES));

mux #(.bits(12))
mux_RES1414_scaler(
.select(BP_RES_BIT),
.in1(1414),
.in2(-1414),
.out(RES_1414));

mux #(.bits(15))
mux_CUT1(
.select(HP),
.in1(CUTOFF_EXP),
.in2(-CUTOFF_EXP),
.out(CUT1));

mux #(.bits(15))
mux_CUT2(
.select(BP),
.in1(CUTOFF_EXP),
.in2(-CUTOFF_EXP),
.out(CUT2));

//EXPONENTIAL CUTOFF CONVERTER
cutoff_exp_table cutoff_exp_table_svf(
.clk(CLK),
.rst(RST),
.CUTOFF_CC(CUTOFF_CC),
.CUTOFF_EXP(CUTOFF_EXP));

//Integration of HP
Accumulator #(
.IN_WIDTH(15),
.SIZE(20))
Accumulator_HP(
.clk(CLK),
.rst(RST),
.IN(CUT1),
.ACCU(ACCU_HP));

//Integration of BP
Accumulator #(
.IN_WIDTH(15),
.SIZE(20))
Accumulator_BP(
.clk(CLK),
.rst(RST),
.IN(CUT2),
.ACCU(ACCU_BP));

//NOT DELAYED SIGMA DELTA CONVERTER AS DIVIDER
//SDM1_ND #(.k(3500), .bits(13))
sdmz_v2_final #(.k(3500), .bits(13))
   SDM1_ND_HP_SVF(
    .clk(CLK),
    .rst(RST),
    .x(FB_SUM_LIMITED),
    .y(HP));

//SDM1_ND #(.k(128), .bits(8))
sdmz_v2_final #(.k(128), .bits(8))
   SDM1_ND_BP_RES_SVF(
    .clk(CLK),
    .rst(RST),
    .x(BP_RES),
    .y(BP_RES_BIT));

//DELAYED SIGMA DELTA CONVERTER AS DIVIDER
sdmz_v2_final #(.k(2**20), .bits(21))
   sdmz_v2_final_BP_SVF(
    .clk(CLK),
    .rst(RST),
    .x(ACCU_HP),
    .y(BP));

sdmz_v2_final #(.k(2**20), .bits(21))
   sdmz_v2_final_LP_SVF(
    .clk(CLK),
    .rst(RST),
    .x(ACCU_BP),
    .y(LP));




 


endmodule
