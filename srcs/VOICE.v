`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2025 14:02:09
// Design Name: 
// Module Name: VOICE
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



module VOICE(clk,rst,note_on, note_off, note_freq, velocity, pitchbend, CC8, CC9, CC10, CC11, CC12,
CC13, CC14, CC15, CC16,CC17,CC18,CC19,CC20,CC21,CC22,CC23,CC24, CC25,CC26,CC27,CC28,CC29,CC30,CC31,CC32,
CC33,CC34,CC35,CC36,CC37,CC38,CC39,CC112,VOICE_OUT,current_adsr_note);

// COMMON PORTS
input           clk;
input           rst;
input                       note_on;
input                       note_off;
input           [6:0]       note_freq;
input           [6:0]       velocity;
input           [13:0]      pitchbend;

output                      VOICE_OUT;
output          [6:0]       current_adsr_note;

//INDIVIDUAL CC's


input   [6:0] CC8;
input   [6:0] CC9;
input   [6:0] CC10;
input   [6:0] CC11;
input   [6:0] CC12;
input   [6:0] CC13;
input   [6:0] CC14;
input   [6:0] CC15;
input   [6:0] CC16;
input   [6:0] CC17;
input   [6:0] CC18;
input   [6:0] CC19;
input   [6:0] CC20;
input   [6:0] CC21;
input   [6:0] CC22;
input   [6:0] CC23;
input   [6:0] CC24;
input   [6:0] CC25;
input   [6:0] CC26;
input   [6:0] CC27;
input   [6:0] CC28;
input   [6:0] CC29;
input   [6:0] CC30;
input   [6:0] CC31;

input   [6:0] CC32;
input   [6:0] CC33;
input   [6:0] CC34;
input   [6:0] CC35;

input   [6:0] CC36;
input   [6:0] CC37;
input   [6:0] CC38;
input   [6:0] CC39;

input   [6:0] CC112;



wire            OSC_out_1;
wire            OSC_out_2;
wire            OSC_out_3;

wire           [2:0]    ALL_OSC;
wire                    SUM_OSC;

wire           [10:0]   ADSR_Level;
wire signed    [8:0]    ADSR_AMP_OUT;
wire           [6:0]    voice_freq_ADSR;
wire                    FILTER_OUT;

////////////////////////////////////////////wire           [6:0]    FM_OSC1;

/*
wire                    FILTER_OUT1;
wire                    FILTER_OUT2;
wire                    FILTER_OUT3;
wire                    FILTER_OUT4;
wire                    FILTER_OUT5;
wire                    FILTER_OUT6;
wire signed    [7:0]    RES_UPSCALED;
wire signed    [7:0]    FIL_DRIVE_UPSCALED;
wire                    RESONANCE;
wire                    FILTER_DRIVE;*/

assign current_adsr_note = voice_freq_ADSR; 


////VCO 1
VCO VCO_1(
    .clk_top(clk),
    .rst_top(rst),
    .note_on(note_on),
    .note_off(note_off),
    .note_freq(voice_freq_ADSR),
    .velocity(velocity), 
    ////////////////////////////////////////////////////////////////////.FM(FM_OSC1),   
    .COARSE_TUNE_CC(CC8),
    .FINE_TUNE_CC(CC9),
    .WAVE_CC(CC10),
    .SHAPE_CC(CC11),
    .LEVEL_CC(CC15),
    .pitchbend(pitchbend),
    .OSC_Out(OSC_out_1));
    
  
      
/////VCO 2    
VCO VCO_2(
    .clk_top(clk),
    .rst_top(rst),
    .note_on(note_on),
    .note_off(note_off),
    .note_freq(voice_freq_ADSR),
    .velocity(velocity),    
    .COARSE_TUNE_CC(CC16),
    .FINE_TUNE_CC(CC17),
    .WAVE_CC(CC18),
    .SHAPE_CC(CC19),
    .LEVEL_CC(CC23),
    .pitchbend(pitchbend),
    .OSC_Out(OSC_out_2));
        
            
///// VCO 3    
VCO VCO_3(
    .clk_top(clk),
    .rst_top(rst),
    .note_on(note_on),
    .note_off(note_off),
    .note_freq(voice_freq_ADSR),
    .velocity(velocity),    
    .COARSE_TUNE_CC(CC24),
    .FINE_TUNE_CC(CC25),
    .WAVE_CC(CC26),
    .SHAPE_CC(CC27),
    .LEVEL_CC(CC31),
    .pitchbend(pitchbend),
    .OSC_Out(OSC_out_3));

/*    
ATTENUATOR #(.k(127), .bits(7))
ATTENUATOR_FM_OSC2_on_OSC1(
.clk(clk),   
.rst(rst),
.select(OSC_out_2),
.MIDI_IN(CC21),
.ATTENUATOR_OUT(FM_OSC1)); 
 */   
    
    
Adder_VCO Adder_VCO_1 (
.In1(OSC_out_1),
.In2(OSC_out_2),
.In3(OSC_out_3),
.sum_out(ALL_OSC));    
    
    
//DIVIDE OSC SUMMATION    
sdmz_v2_final #(.k(3), .bits(3))
   sdmz_v2_final_ALL_OSC(
    .clk(clk),
    .rst(rst),
    .x(ALL_OSC),    
    .y(SUM_OSC));

/////FILTER
VCF #(.K(12))
VCF_1(
.clk(clk),
.rst(rst),
.AUDIO_IN(SUM_OSC),
.VOICE_FREQ(voice_freq_ADSR),
.CUTOFF_CC(CC34),
.KEYTRACK_CC(CC12),
.RESONANCE_CC(CC35),
.FILTER_DRIVE_CC(CC32),
.INPUT_DRIVE_CC(CC33),
.FILTER_TYPE_CC(CC112),
.AUDIO_OUT(FILTER_OUT));



///////ADSR + Scaler for Volume Envelope ///////////////////
ADSR ADSR_Volume(
    .clk(clk),
    .rst(rst),
    .note_on(note_on),
    .voice_freq(note_freq),
    .Attack(CC36),
    .Decay(CC37),
    .Sustain(CC38),
    .Release(CC39),
    .Level(ADSR_Level),
    .voice_freq_adsr(voice_freq_ADSR));

mux #(.bits(13))
    mux_ADSR(
    .in1(ADSR_Level),
    .in2(-ADSR_Level),
    .select(FILTER_OUT),
    //.select(SUM_OSC),
    .out(ADSR_AMP_OUT));

sdmz_v2_final #(.k(256), .bits(13))
   sdmz_v2_final_ADSR(
    .clk(clk),
    .rst(rst),
    .x(ADSR_AMP_OUT),
    .y(VOICE_OUT));
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
endmodule
