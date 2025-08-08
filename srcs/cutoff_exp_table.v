`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 19:17:01
// Design Name: 
// Module Name: cutoff_exp_table
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


module cutoff_exp_table(CUTOFF_CC, KEYTRACK_CC, CUTOFF_EXP, VOICE_FREQ, clk, rst);

//parameter       lowest_tone    = 16.4104;
parameter       lowest_tone    = 10;
//parameter       lowest_tone    = 4.1026;
//parameter       lowest_tone    = 8.2052;
//parameter       lowest_tone    = 16.35;
//parameter       number_samples  = 128;
parameter       number_samples  = 2048;

input rst;
input clk;

input           [6:0]   KEYTRACK_CC;
input           [6:0]   CUTOFF_CC;
input           [6:0]   VOICE_FREQ;
output reg      [14:0]  CUTOFF_EXP;

reg  signed    [14:0]   summed_control_value;
reg             [10:0]  limited_control_value;

/////calculate expo table
(*rom_style = "block" *) reg [31:0] cutoff_table [0:number_samples - 1];
integer i=1;
initial begin
    for (i = 1; i<=number_samples; i = i + 1) 
    begin
    cutoff_table[i-1]    <= $rtoi(lowest_tone * 2**((i - 1)/192.0) );
    end
end



/////calculate control value for expo table 
always@(*)
begin
if      (rst)                                       summed_control_value = 0;
else if (KEYTRACK_CC == 0)                          summed_control_value = CUTOFF_CC * 16;
else if (KEYTRACK_CC > 0  && KEYTRACK_CC < 32)      summed_control_value = CUTOFF_CC * 16 +      (VOICE_FREQ-13);
else if (KEYTRACK_CC > 31 && KEYTRACK_CC < 64)      summed_control_value = CUTOFF_CC * 16 + 2 *  (VOICE_FREQ-13);
else if (KEYTRACK_CC > 63 && KEYTRACK_CC < 96)      summed_control_value = CUTOFF_CC * 16 + 4 *  (VOICE_FREQ-13);
else if (KEYTRACK_CC > 95 && KEYTRACK_CC < 127)     summed_control_value = CUTOFF_CC * 16 + 8 *  (VOICE_FREQ-13);
else if (KEYTRACK_CC == 127)                        summed_control_value = CUTOFF_CC * 16 + 16 * (VOICE_FREQ-13);
end
/////CV Limiter
always@(*)
begin
if      (rst)                           limited_control_value = 0;
else if (summed_control_value > 2047)   limited_control_value = 2047;
else if (summed_control_value < 0)      limited_control_value = 0;
else                                    limited_control_value = summed_control_value;
end    
/////choose table value
always @(posedge clk)
begin
if(rst) CUTOFF_EXP <=0;
else    CUTOFF_EXP <= cutoff_table[limited_control_value];
end

endmodule
