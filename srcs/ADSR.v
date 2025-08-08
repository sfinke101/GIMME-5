`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2025 12:53:31
// Design Name: 
// Module Name: ADSR
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


module ADSR(clk, rst, note_on, Attack, Decay, Sustain, Release, voice_freq, Level, voice_freq_adsr);


input                   clk;
input                   rst;

input                   note_on;
//input                   note_off;

input   [6:0]           Attack;
input   [6:0]           Decay;
input   [6:0]           Sustain;
input   [6:0]           Release;
input   [6:0]           voice_freq;

output  [10:0]          Level;
output  [6:0]           voice_freq_adsr;

reg     [7:0]           state;
reg     [7:0]           next_state;

reg     [31:0]          counter_attack;
reg     [31:0]          counter_decay;
reg     [31:0]          counter_release;

reg     [31:0]          diff_limit_decay;
reg     [31:0]          diff_limit_release;

reg                     attack_ready_flag;
reg                     decay_ready_flag;
reg                     sustain_ready_flag;
reg                     release_ready_flag;

reg                     flag_retrig;

reg                     INIT_REL_ATT;
reg                     INIT_REL_DEC;
reg                     INIT_REL_SUS;

reg     [6:0]           voice_freq_adsr_internal;

reg     [10:0]          phase_saw;
reg     [10:0]          attack_phase_saw;
reg     [10:0]          decay_phase_saw;
reg     [10:0]          sustain_phase_saw;
reg     [10:0]          release_phase_saw;

reg    [31:0]           tuning_word_att;
reg    [31:0]           tuning_word_dec;
reg    [31:0]           tuning_word_sus;
reg    [31:0]           tuning_word_rel;

wire   [21:0]           saw_squared;


assign saw_squared      =  (phase_saw **2) >>11 ;
assign Level            =   phase_saw;
assign voice_freq_adsr  =   voice_freq_adsr_internal;

parameter OFF               =   0;
//parameter STORE_VOICE_NOTE  =   10;
parameter ATT               =   1;
parameter RETRIG            =   11;
parameter DEC               =   2;
parameter SUS               =   3;
parameter REL_ATT           =   4;
parameter REL_DEC           =   5;
parameter REL_SUS           =   6;
parameter TW_CONST          =   16;
parameter count_limit       =   2**31;
parameter READY             =   5;

parameter UPPER_BOUND       =   31;
parameter LOWER_BOUND       =   23;

//Tuning Word
always @(posedge clk or posedge rst) begin
    if(rst)begin
        tuning_word_att    <=   0;
        tuning_word_dec    <=   0;
        tuning_word_sus    <=   0;
        tuning_word_rel    <=   0;
    end
    else begin
        tuning_word_att    <=   Attack**2   *   TW_CONST;
        tuning_word_dec    <=   Decay**2    *   TW_CONST;
        tuning_word_sus    <=   Sustain**2  *   2**17;
        tuning_word_rel    <=   Release**2  *   TW_CONST;
        end
end

//////Note_On Edge Detection
reg note_on_d;
reg prev_note_on;

always @(posedge clk or posedge rst) begin
    if (rst)
        note_on_d <= 0;
    else
        note_on_d <= note_on;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        prev_note_on <= 0;
    else
        prev_note_on <= note_on_d;
end
wire note_on_trigger = note_on_d && !prev_note_on;

///////State Next State
always@(posedge clk or posedge rst) begin
    if(rst)
        state <= OFF;
    else
        state <= next_state;
end

////
////////
/////////////
///////////////////////
/////////////////////////////////////
//Zustandsfolgelogik
////////////////////////////////////////////////
////////////////////////////////////////////////////////////
always@(state,note_on,attack_ready_flag,decay_ready_flag, sustain_ready_flag, release_ready_flag,note_on_trigger,flag_retrig) begin
    
    case(state)
    
        OFF:
            if(note_on_trigger)begin
                next_state <= ATT; end
            else
                next_state <= OFF; 
                
        RETRIG:begin
            if (flag_retrig)
                    begin
                    next_state <= ATT;
                    end
            else
                    begin
                    next_state <= RETRIG;
                    end
            end
                       
        ATT:begin
            if (attack_ready_flag == 1 && note_on)begin
                     next_state <= DEC;end
            
            else if (!note_on)
                     next_state <= REL_ATT;
            else
                     next_state <= ATT;
             end
        

                                           
        DEC: begin
            if (decay_ready_flag == 1 && note_on) begin
                next_state <= SUS;
            end           
            else if (!note_on)
                next_state <= REL_DEC; 
            else
                next_state <= DEC;end
                
        SUS: begin
            if(sustain_ready_flag == 1) begin
                next_state <= REL_SUS;
            end
            else
                next_state <= SUS;
            end
            
        REL_ATT: begin
            if(release_ready_flag == 1) 
                        begin
                        next_state <= OFF; 
                        end
            else if (note_on_trigger)
                        begin
                        next_state <= RETRIG;
                        end
            else
                next_state <= REL_ATT;
            end             
                        
        REL_DEC: begin
            if      (release_ready_flag == 1) 
                        begin
                        next_state <= OFF; 
                        end
            else if (note_on_trigger)
                        begin
                        next_state <= RETRIG;
                        end
            else
                        next_state <= REL_DEC;
            end 
        
        REL_SUS: begin
            if(release_ready_flag == 1) begin
                next_state <= OFF; end
            else if (note_on)
                next_state <= RETRIG;
            else
                next_state <= REL_SUS;
            end    
                    
    endcase                   
 end

/////////////////////////////////////////////////////
////////////////////////////////////////// 
//Ausgangsfolgelogik
/////////////////////////////
//////////////////
///////////
//////
//
 always@(posedge clk or posedge rst) begin
    if(rst)begin
        counter_attack      <=  0;
        counter_decay       <=  0;
        counter_release     <=  0;
        
        attack_ready_flag   <=  0;
        decay_ready_flag    <=  0;
        sustain_ready_flag  <=  0;
        release_ready_flag  <=  0;
        
        phase_saw           <=  0;
        attack_phase_saw    <=  0;
        decay_phase_saw     <=  0;
        sustain_phase_saw   <=  0;
        release_phase_saw   <=  0;
        diff_limit_decay    <=  count_limit;
        diff_limit_release  <=  0;
        
        INIT_REL_ATT        <=  1;
        INIT_REL_DEC        <=  1;
        INIT_REL_SUS        <=  1;
        flag_retrig         <=  0;
        
    end
    
    else begin case (state)
        
        OFF: begin
            phase_saw <= 0;
            attack_phase_saw    <=  0;
            decay_phase_saw     <=  0;
            sustain_phase_saw   <=  0;
            release_phase_saw   <=  0;
            
            attack_ready_flag   <=  0;
            decay_ready_flag    <=  0;
            sustain_ready_flag  <=  0;
            release_ready_flag  <=  0;
            
            counter_attack      <=  0;
            counter_decay       <=  0;
            counter_release     <=  0;
            
            diff_limit_decay    <=  count_limit;
            diff_limit_release  <=  0;
            
            INIT_REL_ATT        <=  1;
            INIT_REL_DEC        <=  1;
            INIT_REL_SUS        <=  1;
            flag_retrig         <=  0;
            voice_freq_adsr_internal <= voice_freq; 
        end    

        RETRIG: begin
            phase_saw <= 0;
            attack_phase_saw    <=  0;
            decay_phase_saw     <=  0;
            sustain_phase_saw   <=  0;
            release_phase_saw   <=  0;
            
            attack_ready_flag   <=  0;
            decay_ready_flag    <=  0;
            sustain_ready_flag  <=  0;
            release_ready_flag  <=  0;
            
            counter_attack      <=  0;
            counter_decay       <=  0;
            counter_release     <=  0;
            
            diff_limit_decay    <=  count_limit;
            diff_limit_release  <=  0;
            
            INIT_REL_ATT        <=  1;
            INIT_REL_DEC        <=  1;
            INIT_REL_SUS        <=  1;
            flag_retrig         <=  1;
            voice_freq_adsr_internal <= voice_freq; 
            end              
        
        ATT:
        begin  
        flag_retrig     <= 0;         
            if (counter_attack < count_limit) 
                    begin
                    counter_attack      <= counter_attack + tuning_word_att;
                    attack_phase_saw    <= counter_attack[UPPER_BOUND:LOWER_BOUND];
                    phase_saw           <= attack_phase_saw;
                    end
                    
            else    begin
                    attack_ready_flag   <= 1;                    
                    end                
         end

            
        DEC: begin
            if (counter_decay < count_limit - tuning_word_sus) 
                    begin                    
                    counter_decay       <= counter_decay + tuning_word_dec;
                    diff_limit_decay    <= count_limit - counter_decay;
                    decay_phase_saw     <= diff_limit_decay[UPPER_BOUND:LOWER_BOUND];
                    phase_saw           <= decay_phase_saw;
                    end
                    
            else    begin
                    decay_ready_flag    <= 1;
                    sustain_phase_saw   <= decay_phase_saw;
                    end                
            end
            
        SUS: begin
            if (note_on == 1) 
                    begin
                    phase_saw           <= sustain_phase_saw;
                    end 
            else    begin
                    sustain_ready_flag <= 1;
                    end
             end


       REL_ATT: begin
            if (INIT_REL_ATT)
                    begin                    
                    counter_release     <= counter_attack; 
                    INIT_REL_ATT        <= 0;
                    end
                    
            else if (counter_release < count_limit)
                    begin
                    counter_release     <= counter_release - tuning_word_rel;
                    diff_limit_release  <= count_limit - counter_release;
                    //release_phase_saw   <= diff_limit_release[30:20];
                    release_phase_saw   <= counter_release[UPPER_BOUND:LOWER_BOUND];
                    phase_saw           <= release_phase_saw;
                    end
                    
            else    begin
                    release_ready_flag  <= 1;
                    end 
          end
           
           
       REL_DEC: begin
          if (INIT_REL_DEC)
                    begin                    
                    counter_release     <= counter_decay; 
                    INIT_REL_DEC        <= 0;
                    end
                    
          else if  (counter_release < count_limit)
                    begin
                    counter_release     <= counter_release + tuning_word_rel;
                    diff_limit_release  <= count_limit - counter_release;
                    release_phase_saw   <= diff_limit_release[UPPER_BOUND:LOWER_BOUND];
                    phase_saw           <= release_phase_saw;
                    end
                    
          else      begin
                    release_ready_flag  <= 1;
                    end 
          end
             
       REL_SUS: begin
          if (INIT_REL_SUS)
                    begin                    
                    counter_release     <= counter_decay; 
                    INIT_REL_SUS        <= 0;
                    end  
                               
          else if  (counter_release < count_limit)
                    begin
                    counter_release     <= counter_release + tuning_word_rel;
                    diff_limit_release  <= count_limit - counter_release;
                    release_phase_saw   <= diff_limit_release[UPPER_BOUND:LOWER_BOUND];
                    phase_saw           <= release_phase_saw;
                end
                
          else      begin
                    release_ready_flag  <= 1;
                    end 
          end
            
    endcase
    end
end

endmodule