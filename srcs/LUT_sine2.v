`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2024 18:56:43
// Design Name: 
// Module Name: LUT_sine2
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


module LUT_sine2(clk, rst, saw_in, sine_out);

    //parameter real      amplitude=32.0;
    parameter real      amplitude=716.0;
    parameter           number_samples=2048;
    //parameter           number_samples=64;
    parameter real      pi=3.1415926535897324;

    input clk;
    input rst;
    input       [10:0] saw_in;
    output reg signed [10:0] sine_out;

    (*rom_style = "block" *) reg signed  [10:0] sine_table   [2047:0];

    integer i=0;

    //fill table
    initial begin
        for (i = 0; i<number_samples; i = i + 1) begin
            sine_table[i] <= $rtoi(amplitude*$sin(2*pi/number_samples*i));
        end
    end

    //
    always @(posedge clk, posedge rst)
    begin
    
        if(rst)
            sine_out <= 0;
    
        else
            sine_out <= sine_table[saw_in];
    end

endmodule

