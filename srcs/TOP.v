`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2024 13:20:46
// Design Name: 
// Module Name: TOP
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


module TOP(Out_R_scale, clk_top, rst_top, pio26, pio37, pio36, ld1);

input                       clk_top;
input                       rst_top;
input                       pio26;          /// Stecker In
input                       pio37;          /// MIDI In A
input                       pio36;          /// MIDI In B            

output                      ld1;            /// LED Feedback for plugged Audio Jack
output                      Out_R_scale;    /// Output Oscillator



//// MIDI Signals A
wire                        fertig_A;
wire                        note_on_A;
wire                        note_off_A;
wire             [6:0]      note_freq_A;
wire             [6:0]      velocity_A;
wire             [6:0]      CC8_A;
wire             [6:0]      CC9_A;
wire             [6:0]      CC10_A;
wire             [6:0]      CC11_A;
wire             [6:0]      CC12_A;
wire             [6:0]      CC13_A;
wire             [6:0]      CC14_A;
wire             [6:0]      CC15_A;
wire             [6:0]      CC16_A;
wire             [6:0]      CC17_A;
wire             [6:0]      CC18_A;
wire             [6:0]      CC19_A;
wire             [6:0]      CC20_A;
wire             [6:0]      CC21_A;
wire             [6:0]      CC22_A;
wire             [6:0]      CC23_A;
wire             [6:0]      CC24_A;
wire             [6:0]      CC25_A;
wire             [6:0]      CC26_A;
wire             [6:0]      CC27_A;
wire             [6:0]      CC28_A;
wire             [6:0]      CC29_A;
wire             [6:0]      CC30_A;
wire             [6:0]      CC31_A;
wire             [6:0]      CC32_A;
wire             [6:0]      CC33_A;
wire             [6:0]      CC34_A;
wire             [6:0]      CC35_A;
wire             [6:0]      CC36_A;
wire             [6:0]      CC37_A;
wire             [6:0]      CC38_A;
wire             [6:0]      CC39_A;
wire             [6:0]      CC112_A;
wire             [7:0]      midi1_A;
wire             [7:0]      midi2_A;
wire             [7:0]      midi3_A;
wire             [13:0]     pitchbend_A;



//// MIDI Signals B
wire                        fertig_B;
wire                        note_on_B;
wire                        note_off_B;
wire             [6:0]      note_freq_B;
wire             [6:0]      velocity_B;
wire             [6:0]      CC8_B;
wire             [6:0]      CC9_B;
wire             [6:0]      CC10_B;
wire             [6:0]      CC11_B;
wire             [6:0]      CC12_B;
wire             [6:0]      CC13_B;
wire             [6:0]      CC14_B;
wire             [6:0]      CC15_B;
wire             [6:0]      CC16_B;
wire             [6:0]      CC17_B;
wire             [6:0]      CC18_B;
wire             [6:0]      CC19_B;
wire             [6:0]      CC20_B;
wire             [6:0]      CC21_B;
wire             [6:0]      CC22_B;
wire             [6:0]      CC23_B;
wire             [6:0]      CC24_B;
wire             [6:0]      CC25_B;
wire             [6:0]      CC26_B;
wire             [6:0]      CC27_B;
wire             [6:0]      CC28_B;
wire             [6:0]      CC29_B;
wire             [6:0]      CC30_B;
wire             [6:0]      CC31_B;
wire             [6:0]      CC32_B;
wire             [6:0]      CC33_B;
wire             [6:0]      CC34_B;
wire             [6:0]      CC35_B;
wire             [6:0]      CC36_B;
wire             [6:0]      CC37_B;
wire             [6:0]      CC38_B;
wire             [6:0]      CC39_B;
wire             [7:0]      midi1_B;
wire             [7:0]      midi2_B;
wire             [7:0]      midi3_B;
wire             [13:0]     pitchbend_B;



////// VOICE ALLOCATION
wire             [6:0]      freq_voice          [0:4];
wire                        note_on_voice       [0:4]; 
wire             [6:0]      current_freq_voice  [0:4];



////// OSCILLATORS ADUIO
wire                        VOICE_OUT_1;
wire                        VOICE_OUT_2;
wire                        VOICE_OUT_3;
wire                        VOICE_OUT_4;
wire                        VOICE_OUT_5;
wire             [2:0]      adder_mixer_out;


assign stecker_in = pio26;
assign ld1 = ~stecker_in;


//////////MIDI IN A
midi midi_A(
    .clk(clk_top),
    .midi_in(pio37),
    .fertig(fertig_A),
    .midi1(midi1_A),
    .midi2(midi2_A),
    .midi3(midi3_A));
    
midi_auswert midi_auswert_A(
    .clk(clk_top),
    .fertig_midi(fertig_A),    
    .midi1(midi1_A),
    .midi2(midi2_A),
    .midi3(midi3_A),    
    .note_on(note_on_A),
    .note_off(note_off_A),
    .note_freq(note_freq_A),
    .velocity(velocity_A),    
    .contrl_8(CC8_A),
    .contrl_9(CC9_A),
    .contrl_10(CC10_A),
    .contrl_11(CC11_A),
    .contrl_12(CC12_A),
    .contrl_13(CC13_A),
    .contrl_14(CC14_A),
    .contrl_15(CC15_A),
    .contrl_16(CC16_A),
    .contrl_17(CC17_A),
    .contrl_18(CC18_A),
    .contrl_19(CC19_A),
    .contrl_20(CC20_A),
    .contrl_21(CC21_A),
    .contrl_22(CC22_A),
    .contrl_23(CC23_A),
    .contrl_24(CC24_A),
    .contrl_25(CC25_A),
    .contrl_26(CC26_A),
    .contrl_27(CC27_A),
    .contrl_28(CC28_A),
    .contrl_29(CC29_A),
    .contrl_30(CC30_A),
    .contrl_31(CC31_A),
    .contrl_32(CC32_A),
    .contrl_33(CC33_A),
    .contrl_34(CC34_A),
    .contrl_35(CC35_A),
    .contrl_36(CC36_A),
    .contrl_37(CC37_A),
    .contrl_38(CC38_A),
    .contrl_39(CC39_A),
    .contrl_112(CC112_A),
    .pitchbend(pitchbend_A));






//////////MIDI IN B
midi midi_B(
    .clk(clk_top),
    .midi_in(pio36),
    .fertig(fertig_B),
    .midi1(midi1_B),
    .midi2(midi2_B),
    .midi3(midi3_B));
    
midi_auswert midi_auswert_B(
    .clk(clk_top),
    .fertig_midi(fertig_B),    
    .midi1(midi1_B),
    .midi2(midi2_B),
    .midi3(midi3_B),    
    .note_on(note_on_B),
    .note_off(note_off_B),
    .note_freq(note_freq_B),
    .velocity(velocity_B),    
    .contrl_8(CC8_B),
    .contrl_9(CC9_B),
    .contrl_10(CC10_B),
    .contrl_11(CC11_B),
    .contrl_12(CC12_B),
    .contrl_13(CC13_B),
    .contrl_14(CC14_B),
    .contrl_15(CC15_B),
    .contrl_16(CC16_B),
    .contrl_17(CC17_B),
    .contrl_18(CC18_B),
    .contrl_19(CC19_B),
    .contrl_20(CC20_B),
    .contrl_21(CC21_B),
    .contrl_22(CC22_B),
    .contrl_23(CC23_B),
    .contrl_24(CC24_B),
    .contrl_25(CC25_B),
    .contrl_26(CC26_B),
    .contrl_27(CC27_B),
    .contrl_28(CC28_B),
    .contrl_29(CC29_B),
    .contrl_30(CC30_B),
    .contrl_31(CC31_B),
    .contrl_32(CC32_B),
    .contrl_33(CC33_B),
    .contrl_34(CC34_B),
    .contrl_35(CC35_B),
    .contrl_36(CC36_B),
    .contrl_37(CC37_B),
    .contrl_38(CC38_B),
    .contrl_39(CC39_B),
    .pitchbend(pitchbend_B));


///////////// VOICES
VOICE VOICE_1(
    .clk(clk_top),
    .rst(rst_top),
    .note_on(note_on_voice[0]),
    .note_off(note_off_B),
    .note_freq(freq_voice[0]),
    .velocity(velocity_B),    
    .CC8(CC8_A),
    .CC9(CC9_A),
    .CC10(CC10_A),
    .CC11(CC11_A),
    .CC12(CC12_A),
    .CC13(CC13_A),
    .CC14(CC14_A),
    .CC15(CC15_A),
    .CC16(CC16_A),
    .CC17(CC17_A),
    .CC18(CC18_A),
    .CC19(CC19_A),
    .CC20(CC20_A),
    .CC21(CC21_A),
    .CC22(CC22_A),
    .CC23(CC23_A),
    .CC24(CC24_A),
    .CC25(CC25_A),
    .CC26(CC26_A),
    .CC27(CC27_A),
    .CC28(CC28_A),
    .CC29(CC29_A),
    .CC30(CC30_A),
    .CC31(CC31_A),
    .CC32(CC32_A),
    .CC33(CC33_A),
    .CC34(CC34_A),
    .CC35(CC35_A),
    .CC36(CC36_A),
    .CC37(CC37_A),
    .CC38(CC38_A),
    .CC39(CC39_A),
    .CC112(CC112_A),
    .pitchbend(pitchbend_B),
    .VOICE_OUT(VOICE_OUT_1),
    .current_adsr_note(current_freq_voice[0]));
    
VOICE VOICE_2(
    .clk(clk_top),
    .rst(rst_top),
    .note_on(note_on_voice[1]),
    .note_off(note_off_B),
    .note_freq(freq_voice[1]),
    .velocity(velocity_B),    
    .CC8(CC8_A),
    .CC9(CC9_A),
    .CC10(CC10_A),
    .CC11(CC11_A),
    .CC12(CC12_A),
    .CC13(CC13_A),
    .CC14(CC14_A),
    .CC15(CC15_A),
    .CC16(CC16_A),
    .CC17(CC17_A),
    .CC18(CC18_A),
    .CC19(CC19_A),
    .CC20(CC20_A),
    .CC21(CC21_A),
    .CC22(CC22_A),
    .CC23(CC23_A),
    .CC24(CC24_A),
    .CC25(CC25_A),
    .CC26(CC26_A),
    .CC27(CC27_A),
    .CC28(CC28_A),
    .CC29(CC29_A),
    .CC30(CC30_A),
    .CC31(CC31_A),
    .CC32(CC32_A),
    .CC33(CC33_A),
    .CC34(CC34_A),
    .CC35(CC35_A),
    .CC36(CC36_A),
    .CC37(CC37_A),
    .CC38(CC38_A),
    .CC39(CC39_A),
    .CC112(CC112_A),
    .pitchbend(pitchbend_B),
    .VOICE_OUT(VOICE_OUT_2),
    .current_adsr_note(current_freq_voice[1]));
    
VOICE VOICE_3(
    .clk(clk_top),
    .rst(rst_top),
    .note_on(note_on_voice[2]),
    .note_off(note_off_B),
    .note_freq(freq_voice[2]),
    .velocity(velocity_B),    
    .CC8(CC8_A),
    .CC9(CC9_A),
    .CC10(CC10_A),
    .CC11(CC11_A),
    .CC12(CC12_A),
    .CC13(CC13_A),
    .CC14(CC14_A),
    .CC15(CC15_A),
    .CC16(CC16_A),
    .CC17(CC17_A),
    .CC18(CC18_A),
    .CC19(CC19_A),
    .CC20(CC20_A),
    .CC21(CC21_A),
    .CC22(CC22_A),
    .CC23(CC23_A),
    .CC24(CC24_A),
    .CC25(CC25_A),
    .CC26(CC26_A),
    .CC27(CC27_A),
    .CC28(CC28_A),
    .CC29(CC29_A),
    .CC30(CC30_A),
    .CC31(CC31_A),
    .CC32(CC32_A),
    .CC33(CC33_A),
    .CC34(CC34_A),
    .CC35(CC35_A),
    .CC36(CC36_A),
    .CC37(CC37_A),
    .CC38(CC38_A),
    .CC39(CC39_A),
    .CC112(CC112_A),
    .pitchbend(pitchbend_B),
    .VOICE_OUT(VOICE_OUT_3),
    .current_adsr_note(current_freq_voice[2]));
    
VOICE VOICE_4(
    .clk(clk_top),
    .rst(rst_top),
    .note_on(note_on_voice[3]),
    .note_off(note_off_B),
    .note_freq(freq_voice[3]),
    .velocity(velocity_B),    
    .CC8(CC8_A),
    .CC9(CC9_A),
    .CC10(CC10_A),
    .CC11(CC11_A),
    .CC12(CC12_A),
    .CC13(CC13_A),
    .CC14(CC14_A),
    .CC15(CC15_A),
    .CC16(CC16_A),
    .CC17(CC17_A),
    .CC18(CC18_A),
    .CC19(CC19_A),
    .CC20(CC20_A),
    .CC21(CC21_A),
    .CC22(CC22_A),
    .CC23(CC23_A),
    .CC24(CC24_A),
    .CC25(CC25_A),
    .CC26(CC26_A),
    .CC27(CC27_A),
    .CC28(CC28_A),
    .CC29(CC29_A),
    .CC30(CC30_A),
    .CC31(CC31_A),
    .CC32(CC32_A),
    .CC33(CC33_A),
    .CC34(CC34_A),
    .CC35(CC35_A),
    .CC36(CC36_A),
    .CC37(CC37_A),
    .CC38(CC38_A),
    .CC39(CC39_A),
    .CC112(CC112_A),
    .pitchbend(pitchbend_B),
    .VOICE_OUT(VOICE_OUT_4),
    .current_adsr_note(current_freq_voice[3]));
    
VOICE VOICE_5(
    .clk(clk_top),
    .rst(rst_top),
    .note_on(note_on_voice[4]),
    .note_off(note_off_B),
    .note_freq(freq_voice[4]),
    .velocity(velocity_B),    
    .CC8(CC8_A),
    .CC9(CC9_A),
    .CC10(CC10_A),
    .CC11(CC11_A),
    .CC12(CC12_A),
    .CC13(CC13_A),
    .CC14(CC14_A),
    .CC15(CC15_A),
    .CC16(CC16_A),
    .CC17(CC17_A),
    .CC18(CC18_A),
    .CC19(CC19_A),
    .CC20(CC20_A),
    .CC21(CC21_A),
    .CC22(CC22_A),
    .CC23(CC23_A),
    .CC24(CC24_A),
    .CC25(CC25_A),
    .CC26(CC26_A),
    .CC27(CC27_A),
    .CC28(CC28_A),
    .CC29(CC29_A),
    .CC30(CC30_A),
    .CC31(CC31_A),
    .CC32(CC32_A),
    .CC33(CC33_A),
    .CC34(CC34_A),
    .CC35(CC35_A),
    .CC36(CC36_A),
    .CC37(CC37_A),
    .CC38(CC38_A),
    .CC39(CC39_A),
    .CC112(CC112_A),
    .pitchbend(pitchbend_B),
    .VOICE_OUT(VOICE_OUT_5),
    .current_adsr_note(current_freq_voice[4]));
    
    
Voice_Allocation Voice_Allocation_top(
    .clk(clk_top),
    .rst(rst_top),
    .note_on(note_on_B),
    .note_off(note_off_B),
    .note_freq(note_freq_B),
    .freq_voice_1(freq_voice[0]),
    .freq_voice_2(freq_voice[1]),
    .freq_voice_3(freq_voice[2]),
    .freq_voice_4(freq_voice[3]),
    .freq_voice_5(freq_voice[4]),
    .current_freq_voice_1(current_freq_voice[0]),
    .current_freq_voice_2(current_freq_voice[1]),
    .current_freq_voice_3(current_freq_voice[2]),
    .current_freq_voice_4(current_freq_voice[3]),
    .current_freq_voice_5(current_freq_voice[4]),
    .note_on_voice_1(note_on_voice[0]),
    .note_on_voice_2(note_on_voice[1]),
    .note_on_voice_3(note_on_voice[2]),
    .note_on_voice_4(note_on_voice[3]),
    .note_on_voice_5(note_on_voice[4]));
    
    
    
Adder Adder_poly_mixer(
    .In1(VOICE_OUT_1),
    .In2(VOICE_OUT_2),
    .In3(VOICE_OUT_3),
    .In4(VOICE_OUT_4),
    .In5(VOICE_OUT_5),
    .sum_out(adder_mixer_out));
    
sdmz_v2_final #(.k(5), .bits(4))
//sdmz_v2_final #(.k(8), .bits(6))
   sdmz_v2_final_top_3(
    .clk(clk_top),
    .rst(rst_top),
    .x(adder_mixer_out),
    .y(Out_R_scale));    
    
    
    
endmodule
