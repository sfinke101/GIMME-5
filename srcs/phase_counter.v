`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2024 18:56:43
// Design Name: 
// Module Name: phase_counter
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


module phase_counter(clk, rst, tuning_word, saw_out);

input clk;
input rst;
input [31:0] tuning_word;

//output [10:0] saw_out;
output [10:0] saw_out;
//reg [31:0] counter; //register mit 32 stellen
reg [27:0] counter; //test

always@(posedge clk, posedge rst)
    begin     
            if(rst)             //wenn reset aktiv, setze counter 0
                counter <= 0;                       
            else                //ansonsten erhöhe wert von counter um tuning_word
                counter <= counter + tuning_word;   
    end
    
// Die höchsten 11 Bits abschneiden
//assign saw_out = counter >> 21;
assign saw_out = counter >> 17; ////test









//assign saw_out = counter >> 26;

endmodule
