`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2024 11:16:14
// Design Name: 
// Module Name: Voice
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


module VCO(OSC_Out, clk_top, rst_top, 
note_on, note_off, note_freq,COARSE_TUNE_CC,FINE_TUNE_CC, WAVE_CC,SHAPE_CC,LEVEL_CC, 
velocity, pitchbend,FM);

input                       clk_top;
input                       rst_top;

input                       note_on;
input                       note_off;
input           [6:0]       note_freq;
input           [6:0]       COARSE_TUNE_CC;
input           [6:0]       FINE_TUNE_CC; 
input           [6:0]       WAVE_CC; 
input           [6:0]       SHAPE_CC;  
input           [6:0]       LEVEL_CC;   
input           [6:0]       velocity;
input           [6:0]       FM;
input           [13:0]      pitchbend;     


output                      OSC_Out;    /// Output Oscillator


/////// SDM

wire                        Out_SDM;

/////// Scaler
wire signed    [7:0]        out_mux_top;

/////// Wave Outputs
wire signed     [10:0]      sine_top;
wire            [10:0]      rect_top_top;
wire            [10:0]      saw_top;
wire            [10:0]      triangle_top;

/////// Wave Selector
wire           [10:0]       waveshape_mod;
wire           [10:0]       wave_top;

/////// Exponentiator
wire            [31:0]      tuning_word_top;


assign waveshape_mod = SHAPE_CC * 16 + 1;


//assign stecker_in = pio26;
//assign ld1 = ~stecker_in;



///////Include Exponentiator   
exponentiator exponentiator_top (
    .rst_exp(rst_top),
    .clk_exp(clk_top),
    .note(note_freq),
    ///////////////////////////////////////////////////////////////////////////.FM(FM),
    .pitch(pitchbend),
    .coarse_tune(COARSE_TUNE_CC),
    .fine_tune(FINE_TUNE_CC),
    .tuning_word_out(tuning_word_top)
    );

////////Include Phase Counter
phase_counter phase_counter_top(
    .clk(clk_top),
    .rst(rst_top),
    .tuning_word(tuning_word_top),
    .saw_out(saw_top));

///////Include Amplitude Converter - Sinusoidal Look Up Table  
LUT_sine2 LUT_sine_top(
    .clk(clk_top),
    .rst(rst_top),
    .saw_in(saw_top),
    .sine_out(sine_top));
 
 ///////Include Rectangle Wave      
 rect rect_top (
    .clk(clk_top),
    .rst(rst_top),
    .pwm(waveshape_mod),
    .saw_in(saw_top),
    .rect_out(rect_top_top));

///////Include Triangle Wave
triangle triangle_module_top (
    .clk(clk_top),
    .rst(rst_top),
    .waveshape_tri(waveshape_mod),
    .saw_in(saw_top),
    .tri_out(triangle_top));   

///////Include Wave Selector     
wave_switch wave_switch_top (
    .clk(clk_top),
    .rst(rst_top),
    .switch(WAVE_CC),
    .sine(sine_top),
    .saw(saw_top - 1024),
    .rect(rect_top_top - 1024),
    .triangle(triangle_top-1024),
    .wave(wave_top)
    );    





///////MAIN
///////Include Scaler - Multiplexer and SDM OSC
//wire signed     [10:0]      x1;
//assign x1 = (note_on==1) ? wave_top : 0;
sdmz_v2_final #(.k(1024), .bits(11))
   sdmz_v2_final_top_1(
    .clk(clk_top),
    .rst(rst_top),
    .x(wave_top),
    .y(Out_SDM));

///////Include Scaler - Multiplexer and SDM OSC
ATTEN_MUX #(.bits(7))
    mux_scale(
    .in1(LEVEL_CC),
    //.in2(-LEVEL_CC),
    .select(Out_SDM),
    .out(out_mux_top));

sdmz_v2_final #(.k(127), .bits(8))
   sdmz_v2_final_top_3(
    .clk(clk_top),
    .rst(rst_top),
    .x(out_mux_top),
    .y(OSC_Out));
    
       
///////SUB       
///////Include Scaler - Multiplexer and SDM SUB OSC
//SUB_OSC SUB_OSC_TOP(

//    .clk(clk),
//    .rst(rst),
//    .VCO_IN(Out_SDM),
//    .SUB_OUT(SUB_OUT_VCO));
/*
mux #(.bits(9))
    mux_scale_sub(
    .in1(contrl_19),
    .in2(0),
    .select(SUB_OUT_VCO),
    .out(out_mux_SUB));

sdmz_v2_final #(.k(128), .bits(9))
   sdmz_v2_final_top_sub(
    .clk(clk_top),
    .rst(rst_top),
    .x(out_mux_SUB),
    //.y(SUB_Out_TOP));
    .y(OSC_Out));
    


//////// ADD MAIN AND SUB
  
//assign MAIN_plus_SUB = Main_Out_TOP + SUB_Out_TOP;  

//sdmz_v2_final #(.k(2), .bits(1))
//   sdmz_v2_final_top_ADDER_VCO(
//    .clk(clk_top),
//    .rst(rst_top),
//    .x(MAIN_plus_SUB),
//    .y(OSC_Out));    
    
*/


//diff_delay diff_dely_top (
//);
//integrator integrator_top();        
endmodule
