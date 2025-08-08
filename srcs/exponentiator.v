`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2024 18:57:21
// Design Name: 
// Module Name: exponentiator
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


module exponentiator(note, pitch,coarse_tune, fine_tune, FM, tuning_word_out, clk_exp,rst_exp);

// constant scaler BW_FS for counter Bit-Width (32Bit) divided through sampling frequeny (12MHz) 357,9139413
//parameter       BW_FS           = 357.9139413;
parameter       BW_FS           = 22.36962132;
//parameter       lowest_tone    = 8.2052;
parameter       lowest_tone    = 16.4104;
//parameter       lowest_tone    = 32.8208;
//parameter       lowest_tone    = 16.35;
parameter       number_samples  = 2048;

input                   rst_exp;
input                   clk_exp;
//input [10:0] note;
input           [6:0]   note;
input           [6:0]   fine_tune;
input           [6:0]   coarse_tune;
input           [13:0]  pitch;
input           [6:0]   FM;
output reg      [31:0]  tuning_word_out;

wire            [10:0]  pitchbend;

assign pitchbend = pitch >> 4;

(*rom_style = "block" *) reg [31:0] tuning_word_table [0:number_samples - 1];

integer i=0;

    initial begin
        for (i = 0; i<number_samples; i = i + 1) begin
            tuning_word_table[i]    <= $rtoi(BW_FS * lowest_tone * 2**((i - 1)/192.0) );
        end
    end
    
    
    always @(posedge clk_exp, posedge rst_exp)
        begin
            if(rst_exp)
                tuning_word_out <=0;
            else
                begin
                tuning_word_out <= tuning_word_table[note * 16 + pitchbend + coarse_tune * 16 + fine_tune];
                end
        end

endmodule

