`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 19:55:48
// Design Name: 
// Module Name: ATTENUATOR
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


module ATTENUATOR# (
parameter k     = 127,
parameter bits  = 7)(

input                        clk,
input                        rst,
input                        SELECT,
input       [bits-1:0]       MIDI_IN,

output reg                   ATTENUATOR_OUT
);
    
wire signed [bits:0]   scaled_stream;
wire signed [bits+1:0] sum ;
reg  signed [bits+1:0] fbz ;

assign scaled_stream = SELECT ? MIDI_IN : -MIDI_IN;
assign sum = scaled_stream + fbz;
      
always@(posedge clk)
begin
    if(rst) 
        begin
        fbz             <=0;
        ATTENUATOR_OUT  <=0;
        end
            
    else if (sum >=0) 
        begin
        ATTENUATOR_OUT  <=1'b1;
        fbz             <=sum-k;
        end 
          
    else 
        begin
        ATTENUATOR_OUT  <=1'b0;
        fbz             <=sum+k;
        end
end
endmodule
