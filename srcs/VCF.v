`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2025 07:45:30
// Design Name: 
// Module Name: VCF
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


module VCF#(
parameter K = 24)
(
input                         clk,
input                         rst,
input                         AUDIO_IN,
input           [6:0]         VOICE_FREQ,
input           [6:0]         CUTOFF_CC,
input           [6:0]         RESONANCE_CC,
input           [6:0]         FILTER_DRIVE_CC,
input           [6:0]         KEYTRACK_CC,
input           [6:0]         FILTER_TYPE_CC,
input           [6:0]         INPUT_DRIVE_CC,
input           [8:0]         ENVELOPE,
input signed    [10:0]        LFO,

output              AUDIO_OUT);

///Internal Audio
wire                    FILTER_OUT1;
wire                    FILTER_OUT2;
wire                    FILTER_OUT3;
wire                    FILTER_OUT4;
wire signed    [7:0]    RES_UPSCALED;
wire signed    [7:0]    FIL_DRIVE_UPSCALED;
wire signed    [7:0]    INPUT_DRIVE_UPSCALED;
wire                    RESONANCE;
wire                    FILTER_DRIVE;
wire                    INPUT_DRIVE;

wire            [14:0]  CUTOFF_EXP;

//EXPONENTIAL CUTOFF CONVERTER
cutoff_exp_table cutoff_exp_table_LP_First(
.clk(clk),
.rst(rst),
.VOICE_FREQ(VOICE_FREQ),
.CUTOFF_CC(CUTOFF_CC),
.KEYTRACK_CC(KEYTRACK_CC),
.CUTOFF_EXP(CUTOFF_EXP));

//ATTENUABLE PARAMETER/////////////////////////////////////////////
ATTENUATOR ATTENUATOR_INPUT_DRIVE(
.clk(clk),
.rst(rst),
.SELECT(AUDIO_IN),
.MIDI_IN(INPUT_DRIVE_CC),
.ATTENUATOR_OUT(INPUT_DRIVE));

ATTENUATOR ATTENUATOR_RESONANCE(
.clk(clk),
.rst(rst),
.SELECT(FILTER_OUT4),
.MIDI_IN(RESONANCE_CC),
.ATTENUATOR_OUT(RESONANCE));

ATTENUATOR ATTENUATOR_FILTER_DRIVE(
.clk(clk),
.rst(rst),
.SELECT(FILTER_OUT4),
.MIDI_IN(FILTER_DRIVE_CC),
.ATTENUATOR_OUT(FILTER_DRIVE));

//FILTER STRUCTURE///////////////////////////////////////////////////
LP_FIRST_PART LP_P1(
.clk(clk),
.rst(rst),
.AUDIO_IN(INPUT_DRIVE),
.RESONANCE(RESONANCE),
.FILTER_DRIVE(FILTER_DRIVE),
.CUTOFF_EXP(CUTOFF_EXP),
.AUDIO_OUT(FILTER_OUT1)); 

LP_1st LP_P2(
.clk(clk),
.rst(rst),
.AUDIO_IN(FILTER_OUT1),
.CUTOFF_EXP(CUTOFF_EXP),
.AUDIO_OUT(FILTER_OUT2));

LP_1st LP_P3(
.clk(clk),
.rst(rst),
.AUDIO_IN(FILTER_OUT2),
.CUTOFF_EXP(CUTOFF_EXP),
.AUDIO_OUT(FILTER_OUT3));

LP_1st LP_P4(
.clk(clk),
.rst(rst),
.AUDIO_IN(FILTER_OUT3),
.CUTOFF_EXP(CUTOFF_EXP),
.AUDIO_OUT(FILTER_OUT4));

//SWITCH FOR FILTER ORDER
FILTER_TYPE_SWITCH FILTER_TYPE_SWITCH_VOICE(
.clk(clk),
.rst(rst),
.FILTER_TYPE_CC(FILTER_TYPE_CC),
.LP_POLE1(FILTER_OUT1),
.LP_POLE2(FILTER_OUT2),
.LP_POLE3(FILTER_OUT3),
.LP_POLE4(FILTER_OUT4),
.TYPE_SWITCH_AUDIO_OUT(AUDIO_OUT));

endmodule
