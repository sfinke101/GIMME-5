
module Voice_Allocation(
input clk,
    input               rst,
    input               note_on,
    input               note_off,
    input [6:0]         note_freq,
    input [6:0]         current_freq_voice_1,
    input [6:0]         current_freq_voice_2,
    input [6:0]         current_freq_voice_3,
    input [6:0]         current_freq_voice_4,
    input [6:0]         current_freq_voice_5,
    output wire [6:0]   freq_voice_1,
    output wire [6:0]   freq_voice_2,
    output wire [6:0]   freq_voice_3,
    output wire [6:0]   freq_voice_4,
    output wire [6:0]   freq_voice_5,
    output wire         note_on_voice_1,
    output wire         note_on_voice_2,
    output wire         note_on_voice_3,
    output wire         note_on_voice_4,
    output wire         note_on_voice_5);
        
parameter MAX_MEMORY        = 10;
parameter VOICES            = 5;

parameter WAIT_FOR_NOTE                                 =   1;
parameter NOTE_ON                                       =   2;
parameter CHECK_MEMORY_SPACE                            =   3;
parameter CHECK_VOICE_SPACE                             =   4;
parameter SEARCH_OLDEST_VOICE                           =   5;
parameter SHIFT_MEMORY                                  =   6;
parameter SHIFT_VOICE_ADRESS                            =   7;
parameter SHIFT_VOICE_ASSIGNMENTS                       =   17;
parameter COUNT_VOICES                                  =   27;
parameter COMPARE_INCOMING_NOTE_WITH_CURRENT_ADSR_NOTES =   37;
parameter ASSIGN_VOICE                                  =   8;
parameter ASSIGN_VOICE_ROUND_ROBIN                      =   28;
parameter ASSIGN_TO_SAME_VOICE                          =   38;
parameter ASSIGN_NEW_VOICE_TO_OLD_VOICE                 =   9;
parameter RETRIG_NOTE_ON                                =   22;

parameter NOTE_OFF                                      =   10;
parameter CHECK_IF_NEWEST_NOTE                          =   11;
parameter IS_NOTE_OFF_PLAYING_ATM                       =   12;
parameter FREE_UP_VOICE                                 =   13;
parameter ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN          =   14;
parameter CHECK_NEWEST_NOT_PLAYED_NOTE                  =   15;
parameter ASSIGN_NEWEST_NOT_PLAYED_NOTE                 =   16;
parameter SET_META_FLAGS                                =   18;
parameter FREE_UP_MEM_SLOT                              =   19;
parameter CHANGE_VOICE_ASSIGNMENTS_3                    =   20;
parameter CHANGE_VOICE_ASSIGNMENTS_4_5                  =   21;

    
reg     [6:0]       note_memory         [0:MAX_MEMORY - 1];
reg     [6:0]       freq_voice          [0:VOICES - 1];
reg     [6:0]       current_freq_voice  [0:VOICES - 1];
reg                 note_on_voice       [0:VOICES - 1];
reg     [3:0]       voice_adress        [0:VOICES - 1];
reg     [6:0]       freq_newest_not_played_note;
reg     [2:0]       last_note_off_voice;
reg     [7:0]       state;
reg     [7:0]       next_state;

integer i;  
reg     [6:0]       g;
reg     [6:0]       j;
reg     [6:0]       k;
reg     [6:0]       k_round;
reg     [6:0]       m;
reg     [6:0]       n;
reg     [6:0]       o;
reg     [6:0]       p;
reg     [6:0]       q;
reg     [6:0]       r;
reg     [6:0]       s;
reg     [6:0]       t;
reg     [6:0]       u;
reg     [6:0]       x;
reg     [6:0]       z;
reg     [3:0]       oldest_voice;
reg     [3:0]       oldest_voice_condition;
reg     [2:0]       round_robin_counter;
reg     [2:0]       voice_counter;


reg                 flag_note_on;
reg                 flag_mem_free;
reg                 flag_mem_full;
reg                 flag_voice_free;
reg                 flag_voice_full;
reg                 flag_oldest_voice;
reg                 flag_memory_shifted;
reg                 flag_adress_shifted;
reg                 flag_voice_assigned;
reg                 flag_old_voice_replaced;
reg                 flag_voices_shifted;
reg                 flag_retrig_note_on;
reg                 flag_voices_counted;
reg                 flag_same_adsr_note;
reg                 flag_diff_adsr_note;
reg                 flag_rr_voice_assigned;
reg                 flag_note_assigned_to_same_voice;

reg                 flag_note_off;
reg                 flag_note_is_playing_atm;
reg                 flag_note_is_not_playing_atm;
reg                 flag_newest_note;
reg                 flag_not_newest_note;
reg                 flag_mem_slot_cleared;

reg                 META_FLAG_1;
reg                 META_FLAG_2;
reg                 META_FLAG_3;
reg                 META_FLAG_4;
reg                 META_FLAG_5;

reg                 flag_voice_freed_up;
reg                 flag_checked_newest_not_played_note;
reg                 flag_mem_slots_went_down;
reg                 flag_assigned_newest_not_played_note;
reg                 flag_note_off_voices_shifted;
reg                 flag_no_valid_note;

reg                 NO_DEFINED_META_STATE;

assign freq_voice_1         = freq_voice[0];
assign freq_voice_2         = freq_voice[1];
assign freq_voice_3         = freq_voice[2];
assign freq_voice_4         = freq_voice[3];
assign freq_voice_5         = freq_voice[4];

always @(posedge clk) begin
    current_freq_voice[0] <= current_freq_voice_1;
    current_freq_voice[1] <= current_freq_voice_2;
    current_freq_voice[2] <= current_freq_voice_3;
    current_freq_voice[3] <= current_freq_voice_4;
    current_freq_voice[4] <= current_freq_voice_5;
end

assign note_on_voice_1      = note_on_voice[0];
assign note_on_voice_2      = note_on_voice[1];
assign note_on_voice_3      = note_on_voice[2];
assign note_on_voice_4      = note_on_voice[3];
assign note_on_voice_5      = note_on_voice[4];

//================\\
//STATE NEXT STATE\\
//================\\

always@(posedge clk or posedge rst) 
begin
    if(rst)
        state <= WAIT_FOR_NOTE;
    else
        state <= next_state;
end


//WAIT_FOR_NOTE -> note_on -> CHECK_MEMORY_SPACE -> CHECK_VOICE_SPACE
//mem free & voice free -> ASSIGN VOICE
//mem free & voice full -> SEARCH_OLDEST_VOICE -> ASSIGN_VOICE
//mem full & voice full -> SEARCH_OLDEST_VOICE -> SHIFT MEMORY -> ASSIGN_VOICE -> SHIFT_VOICE_ADRESS


//WAIT_FOR_NOTE -> NOTE_OFF -> IS_IT_NEWEST_NOTE -> CHECK_VOICE_SPACE -> COUNT_MEMORY_SLOTS -> IS_NOTE_OFF_NOTE_PLAYING_ATM -> CHECK_NEWEST_NOT_PLAYED_NOTE

//newest note & (voice free || voice_full) & (slots <= 5)        -> FREE_UP_VOICE
//newest note & voice full & (slots > 5)                         -> FREE_UP_VOICE -> CHECK_NEWEST_NOT_PLAYED_NOTE -> ASSIGN_NEWEST_NOT_PLAYED_NOT_TO_FREE_VOICE

//not newest note & voice free & (slots <= 5)                    -> FREE_UP_VOICE -> ALL_SLOTS_ABOVE_GO_ONE_DOWN
//not newest note & voice full & (slots > 5) & is not playing    -> ALL_SLOTS_ABOVE_GO_ONE_DOWN
//not newest note & voice full & (slots > 5) & is playing        -> FREE_UP_VOICE -> ALL_SLOTS_ABOVE_GO_ONE_DOWN -> CHECK_NEWEST_NOT_PLAYED_NOTE -> ASSIGN_NEWEST_NOT_PLAYED_NOT_TO_FREE_VOICE

//====================\\
// ZUSTANDSFOLGELOGIK \\
//====================\\
always@(state, note_on, note_off,flag_note_on, flag_mem_full, flag_mem_free, flag_voice_full, flag_voice_free, 
        flag_oldest_voice, flag_memory_shifted, flag_adress_shifted, flag_voice_assigned, flag_old_voice_replaced, 
        flag_voices_shifted,flag_retrig_note_on, flag_voices_counted, flag_same_adsr_note, flag_diff_adsr_note, flag_rr_voice_assigned, flag_note_assigned_to_same_voice, flag_note_off, flag_note_is_playing_atm, flag_note_is_not_playing_atm, flag_newest_note, 
        flag_not_newest_note, flag_mem_slot_cleared, META_FLAG_1, META_FLAG_2, META_FLAG_3, META_FLAG_4, META_FLAG_5, 
        flag_voice_freed_up, flag_checked_newest_not_played_note, flag_mem_slots_went_down,
        flag_assigned_newest_not_played_note, flag_note_off_voices_shifted,flag_no_valid_note) 
begin
    
    case(state)
 /////   
        WAIT_FOR_NOTE: 
            begin
            if      (note_on && !note_off)
                        begin
                        next_state <= NOTE_ON; 
                        end
            else if (note_off && !note_on)
                        begin
                        next_state <= NOTE_OFF; 
                        end         
            else
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            end



//                                                                                                                                                                          //
////                                                                                                                                                                      ////
//////                                                                                                                                                                  //////
/////////                                                                                                                                                            /////////
/////////// NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE OFF NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ////////////  
/////////// NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE OFF NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ////////////
/////////// NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE OFF NOTE ON NOTE ON NOTE ON NOTE ON NOTE ON NOTE ////////////

            
        NOTE_ON:
            begin
            if (flag_note_on)
                begin
                next_state <= CHECK_MEMORY_SPACE;
                end 
            else
                begin
                next_state <= NOTE_ON;
                end
            end
                       
        CHECK_MEMORY_SPACE:
            begin
            if      ((flag_note_on || flag_note_off) && (flag_mem_free || flag_mem_full))
                        begin
                        next_state <= CHECK_VOICE_SPACE;
                        end
            else
                        begin
                        next_state <= CHECK_MEMORY_SPACE;
                        end
            end
                                   
        CHECK_VOICE_SPACE:
            begin
            if      (flag_note_on && flag_mem_free && flag_voice_free)
                        begin
                        next_state <= COUNT_VOICES;
                        end
            else if (flag_note_on && flag_voice_full)
                        begin
                        next_state <= SEARCH_OLDEST_VOICE;
                        end
            else if (flag_note_off && (flag_voice_full || flag_voice_free))
                        begin
                        next_state <= CHECK_IF_NEWEST_NOTE;
                        end
            else
                        begin
                        next_state <= CHECK_VOICE_SPACE;
                        end
            end
            
        COUNT_VOICES:
            begin
            if      (flag_note_on && flag_voices_counted && voice_counter == 4)
                        begin
                        next_state <= ASSIGN_VOICE;
                        end
            else if (flag_note_on && flag_voices_counted && voice_counter < 4)
                        begin
                        next_state <= COMPARE_INCOMING_NOTE_WITH_CURRENT_ADSR_NOTES;
                        end
            else
                        begin
                        next_state <= COUNT_VOICES;
                        end
            end
            
        COMPARE_INCOMING_NOTE_WITH_CURRENT_ADSR_NOTES:
            begin
            if      (flag_note_on && flag_same_adsr_note)
                        begin
                        next_state <= ASSIGN_TO_SAME_VOICE;
                        end
            else if (flag_note_on && flag_diff_adsr_note)
                        begin
                        next_state <= ASSIGN_VOICE_ROUND_ROBIN;
                        end 
            else
                        begin
                        next_state <= COMPARE_INCOMING_NOTE_WITH_CURRENT_ADSR_NOTES;
                        end
            end
                        
        SEARCH_OLDEST_VOICE:
            begin
            if      (flag_note_on && flag_oldest_voice && flag_mem_free)
                        begin
                        next_state <= ASSIGN_NEW_VOICE_TO_OLD_VOICE;
                        end
            else if (flag_note_on && flag_oldest_voice && flag_mem_full)
                        begin
                        next_state <= SHIFT_MEMORY;
                        end
            else
                        begin
                        next_state <= SEARCH_OLDEST_VOICE;
                        end
            end
            
        SHIFT_MEMORY:
            begin
            if      (flag_note_on && flag_memory_shifted)
                        begin
                        next_state <= SHIFT_VOICE_ADRESS;
                        end
            else
                        begin
                        next_state <= SHIFT_MEMORY;
                        end
            end
                        
        SHIFT_VOICE_ADRESS:
            begin
            if      (flag_note_on && flag_adress_shifted)
                        begin
                        next_state <= SHIFT_VOICE_ASSIGNMENTS;
                        end
            else
                        begin
                        next_state <= SHIFT_VOICE_ADRESS;
                        end
            end
            
        ASSIGN_VOICE_ROUND_ROBIN:
            begin
            if      (flag_note_on && flag_rr_voice_assigned)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            else
                        begin
                        next_state <= ASSIGN_VOICE_ROUND_ROBIN;
                        end
           end
                        
        ASSIGN_VOICE:
            begin
            if      (flag_note_on && flag_voice_assigned)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            else
                        begin
                        next_state <= ASSIGN_VOICE;
                        end
            end
            
        ASSIGN_TO_SAME_VOICE:
            begin
            if      (flag_note_on && flag_note_assigned_to_same_voice)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            else
                        begin
                        next_state <= ASSIGN_TO_SAME_VOICE;
                        end
            end
            
        ASSIGN_NEW_VOICE_TO_OLD_VOICE:
            begin
            if      (flag_note_on && flag_old_voice_replaced)
                        begin
                        next_state <= RETRIG_NOTE_ON;
                        end                      
            else        
                        begin
                        next_state <= ASSIGN_NEW_VOICE_TO_OLD_VOICE;
                        end
            end
            
        SHIFT_VOICE_ASSIGNMENTS:
            begin
            if      (flag_note_on && flag_voices_shifted)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end                      
            else        
                        begin
                        next_state <= SHIFT_VOICE_ASSIGNMENTS;
                        end
           end  
           
         RETRIG_NOTE_ON:
           begin    
           if       (flag_note_on && flag_retrig_note_on)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
           else
                        begin
                        next_state <= RETRIG_NOTE_ON;
                        end
           end
           
//                                                                                                                                                                             //
////                                                                                                                                                                         ////
//////                                                                                                                                                                     //////
/////////                                                                                                                                                               /////////
/////////// NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF ////////////  
/////////// NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF //////////// 
/////////// NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF NOTE OFF ////////////           
        NOTE_OFF:
            begin
            if      (flag_note_off)
                        begin
                        next_state <= CHECK_MEMORY_SPACE;
                        end
            else
                        begin
                        next_state <= NOTE_OFF;
                        end
            end
                        
       CHECK_IF_NEWEST_NOTE:
            begin
            if      (flag_note_off && (flag_newest_note || flag_not_newest_note))
                        begin
                        next_state <= IS_NOTE_OFF_PLAYING_ATM;
                        end                               
            else
                        begin
                        next_state <= CHECK_IF_NEWEST_NOTE;
                        end
            end
            
       IS_NOTE_OFF_PLAYING_ATM:
            begin
            if      (flag_note_off && (flag_note_is_playing_atm || flag_note_is_not_playing_atm))
                        begin
                        next_state <= FREE_UP_MEM_SLOT;
                        end                               
            else
                        begin
                        next_state <= IS_NOTE_OFF_PLAYING_ATM;
                        end
            end
            
        FREE_UP_MEM_SLOT:
            begin
            if      (flag_note_off && flag_mem_slot_cleared)
                        begin
                        next_state <= SET_META_FLAGS;
                        end
            else if (flag_note_off && flag_no_valid_note)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            else
                        begin
                        next_state <= FREE_UP_MEM_SLOT;
                        end
            end
            
        SET_META_FLAGS:
            begin
            if      (META_FLAG_1 || META_FLAG_2 || META_FLAG_3 || META_FLAG_5)
                        begin
                        next_state <= FREE_UP_VOICE;
                        end
            else if (META_FLAG_4)
                        begin
                        next_state <= ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN;
                        end
            else
                        begin
                        next_state <= SET_META_FLAGS;
                        end
            end
            
       FREE_UP_VOICE:
            begin
            if      (flag_voice_freed_up && META_FLAG_3)
                        begin
                        next_state <= ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN;
                        end
            else if (flag_voice_freed_up && (META_FLAG_2 || META_FLAG_5))
                        begin
                        next_state <= CHECK_NEWEST_NOT_PLAYED_NOTE;
                        end
            else if (flag_voice_freed_up && META_FLAG_1)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end                               
            else
                        begin
                        next_state <= FREE_UP_VOICE;
                        end
            end
             
       ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN:
            begin
            if      (flag_mem_slots_went_down && META_FLAG_3)
                        begin
                        next_state <= CHANGE_VOICE_ASSIGNMENTS_3;
                        end     
            else if (flag_mem_slots_went_down && (META_FLAG_5 || META_FLAG_4))
                        begin
                        next_state <= CHANGE_VOICE_ASSIGNMENTS_4_5;
                        end                          
            else
                        begin
                        next_state <= ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN;
                        end
            end
                      

        CHANGE_VOICE_ASSIGNMENTS_3:
            begin
            if      (flag_note_off_voices_shifted && META_FLAG_3)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            else
                        begin
                        next_state <= CHANGE_VOICE_ASSIGNMENTS_3;
                        end
            end
            
            
        CHANGE_VOICE_ASSIGNMENTS_4_5:
            begin
            if      (flag_note_off_voices_shifted && META_FLAG_4)
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end
            else if (flag_note_off_voices_shifted && META_FLAG_5)
                        begin
                        next_state <= ASSIGN_NEWEST_NOT_PLAYED_NOTE;
                        end
            else
                        begin
                        next_state <= CHANGE_VOICE_ASSIGNMENTS_4_5;
                        end
            end
            
       
       CHECK_NEWEST_NOT_PLAYED_NOTE:
            begin
            if      (flag_checked_newest_not_played_note && META_FLAG_5)
                        begin
                        next_state <= ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN;
                        end
            else if (flag_checked_newest_not_played_note && META_FLAG_2)
                        begin
                        next_state <= ASSIGN_NEWEST_NOT_PLAYED_NOTE;
                        end                                
            else
                        begin
                        next_state <= CHECK_NEWEST_NOT_PLAYED_NOTE;
                        end
            end
            
            
       ASSIGN_NEWEST_NOT_PLAYED_NOTE:
            begin
            if      (flag_assigned_newest_not_played_note && (META_FLAG_2 || META_FLAG_5))
                        begin
                        next_state <= WAIT_FOR_NOTE;
                        end                               
            else
                        begin
                        next_state <= ASSIGN_NEWEST_NOT_PLAYED_NOTE;
                        end
            end
            
       endcase  
end  
                          
//////====================\\\\\\\
////// AUSGANGSFOLGELOGIK \\\\\\\
//////====================\\\\\\\
 always@(posedge clk or posedge rst) 
 begin
 
    if(rst)
        begin
        g                           <= 7'b0;
        j                           <= 7'b0;
        k                           <= 7'b0;
        k_round                     <= 7'b0;
        m                           <= 7'b0;
        n                           <= 7'b0;
        o                           <= 7'b0;
        p                           <= 7'b0;
        q                           <= 7'b0;
        r                           <= 7'b0;
        s                           <= 7'b0;
        t                           <= 0;
        u                           <= 0;
        x                           <= 7'b0;
        z                           <= 7'b0;
        
        voice_counter               <= 0;
        
        
        
        flag_note_on                            <= 0;
        flag_oldest_voice                       <= 0;
        flag_mem_free                           <= 0;
        flag_mem_full                           <= 0;
        flag_voice_free                         <= 0;
        flag_voice_full                         <= 0;
        flag_memory_shifted                     <= 0;
        flag_adress_shifted                     <= 0;
        flag_voice_assigned                     <= 0;
        flag_old_voice_replaced                 <= 0;
        flag_voices_shifted                     <= 0;
        flag_retrig_note_on                     <= 0;
        flag_voices_counted                     <= 0;
        flag_same_adsr_note                     <= 0;
        flag_diff_adsr_note                     <= 0;
        flag_rr_voice_assigned                  <= 0;
        flag_note_assigned_to_same_voice        <= 0;
        oldest_voice                            <= 0;
        oldest_voice_condition                  <= MAX_MEMORY;  
        round_robin_counter                     <= VOICES - 1;
        last_note_off_voice                     <= 0; ///// oder 5 als INIT???
        
        flag_note_off                           <= 0;
        flag_note_is_playing_atm                <= 0;
        flag_note_is_not_playing_atm            <= 0;
        flag_newest_note                        <= 0;
        flag_not_newest_note                    <= 0;

        META_FLAG_1                             <= 0;
        META_FLAG_2                             <= 0;
        META_FLAG_3                             <= 0;
        META_FLAG_4                             <= 0;
        META_FLAG_5                             <= 0;

        flag_voice_freed_up                     <= 0;
        flag_checked_newest_not_played_note     <= 0;
        flag_mem_slots_went_down                <= 0;
        flag_assigned_newest_not_played_note    <= 0;   
        flag_mem_slot_cleared            <= 0;     
        flag_note_off_voices_shifted            <= 0;
        flag_no_valid_note                      <= 0;
        
        NO_DEFINED_META_STATE                   <= 0;
        
        freq_newest_not_played_note             <= 0;
                        
        for (i = 0; i < MAX_MEMORY; i = i + 1)
            begin
            note_memory[i]      <=  7'b0;
            end
        for (i = 0; i < VOICES; i = i + 1)
            begin
            freq_voice[i]       <=  7'b0;
            note_on_voice[i]    <=  0;
            end
        for (i = 0; i < VOICES; i = i + 1)
            begin
            voice_adress[i]     <=  7'b1111;
            end
        end    
    
    else 
    begin     
        case (state)
                
        WAIT_FOR_NOTE:
        begin
        g                           <= 7'b0;
        j                           <= 7'b0;
        k                           <= 7'b0;
        m                           <= 7'b0;
        n                           <= 7'b0;
        o                           <= 7'b0;
        p                           <= 7'b0;
        //q                           <= 7'b0;
        r                           <= 7'b0;
        s                           <= 7'b0;
        t                           <= 0;
        u                           <= 0;
        x                           <= 7'b0;
        z                           <= 7'b0;
        
        
        voice_counter               <= 0;
        
                
        flag_note_on                            <= 0;
        flag_oldest_voice                       <= 0;
        flag_mem_free                           <= 0;
        flag_mem_full                           <= 0;
        flag_voice_free                         <= 0;
        flag_voice_full                         <= 0;
        flag_memory_shifted                     <= 0;
        flag_adress_shifted                     <= 0;
        flag_voice_assigned                     <= 0;
        flag_old_voice_replaced                 <= 0;
        flag_voices_shifted                     <= 0;
        flag_retrig_note_on                     <= 0;
        flag_voices_counted                     <= 0;
        flag_same_adsr_note                     <= 0;
        flag_diff_adsr_note                     <= 0;
        flag_rr_voice_assigned                  <= 0;
        flag_note_assigned_to_same_voice        <= 0;
        oldest_voice                            <= 0;   
        oldest_voice_condition                  <= MAX_MEMORY;   
        flag_note_off                           <= 0;
        flag_note_is_playing_atm                <= 0;
        flag_note_is_not_playing_atm            <= 0;
        flag_newest_note                        <= 0;
        flag_not_newest_note                    <= 0;

        META_FLAG_1                             <= 0;
        META_FLAG_2                             <= 0;
        META_FLAG_3                             <= 0;
        META_FLAG_4                             <= 0;
        META_FLAG_5                             <= 0;

        flag_voice_freed_up                     <= 0;
        flag_checked_newest_not_played_note     <= 0;
        flag_mem_slots_went_down                <= 0;
        flag_assigned_newest_not_played_note    <= 0;  
        flag_mem_slot_cleared            <= 0;
        flag_note_off_voices_shifted            <= 0;
        flag_no_valid_note                      <= 0;
        
        NO_DEFINED_META_STATE                   <= 0;        
        freq_newest_not_played_note             <= 0;
        
        end

        NOTE_ON:
        begin
        flag_note_on <= 1;
        end
        
        //Check if memory has space available and count how many are busy
        CHECK_MEMORY_SPACE:
        begin
        if      (note_memory[j] == 0)
                    begin
                    flag_mem_free  <= 1;
                    end
        else if (j < MAX_MEMORY)
                    begin
                    j <= j + 1;
                    end
        else
                    begin
                    flag_mem_full  <= 1;
                    end
        end
        
        //Check if voices have space available, stop by the first free and store it in k
        CHECK_VOICE_SPACE:
        begin
        if      (freq_voice[k] == 0)
                    begin
                    flag_voice_free  <= 1;
                    end
        else if (k < VOICES && !flag_voice_free)
                    begin
                    k <= k + 1;
                    end
        else
                    begin
                    flag_voice_full <= 1;
                    end
        end
        
        
        COUNT_VOICES:
        begin
                    if      (t < VOICES - 1 && freq_voice[t] != 0)
                                begin
                                voice_counter <= voice_counter + 1;
                                t <= t + 1;
                                end
                    else if (t < VOICES - 1)
                                begin
                                t <= t + 1;
                                end
                    else
                                begin
                                flag_voices_counted <= 1;
                                note_memory[j]                <= note_freq;                                
                                end          
                                 
        end
        
        COMPARE_INCOMING_NOTE_WITH_CURRENT_ADSR_NOTES:
        begin
                    if      (current_freq_voice[g] == note_freq)
                                begin
                                flag_same_adsr_note <= 1;
                                end
                    else if (g < VOICES && !flag_same_adsr_note)
                                begin
                                g <= g + 1;
                                end
                    else
                                begin
                                flag_diff_adsr_note <= 1;
                                end
        end
        
        ASSIGN_VOICE_ROUND_ROBIN:
        begin
                    
                    if (freq_voice[q + 1 + u] == 0 && !flag_rr_voice_assigned && ((q + 1 + u) < VOICES))
                            begin

                            freq_voice[q+1+u]               <= note_memory[j];
                            voice_adress[q+1+u]             <= j;
                            note_on_voice[q+1+u]            <= 1;
                            q                               <= q + 1;
                            flag_rr_voice_assigned          <= 1;  
                            end
                    else if (u < VOICES && ((q+1+u) < (VOICES - 1)) && !flag_rr_voice_assigned)
                            begin
                            u <= u + 1;
                            end
                    else
                            begin
                            if      (freq_voice[0 + x] == 0 && !flag_rr_voice_assigned)
                                    begin
                                    freq_voice[0 + x]       <= note_memory[j];
                                    voice_adress[0 + x]     <= j; 
                                    note_on_voice[0 + x]    <= 1;
                                    flag_rr_voice_assigned  <= 1;
                                    end
                            else if (!flag_rr_voice_assigned)
                                    begin
                                    x = x + 1;
                                    end
                    end            
        end
              
        ASSIGN_VOICE:
        begin
                    note_memory[j]      <= note_freq;
                    freq_voice[k]       <= note_memory[j];
                    voice_adress[k]     <= j;
                    note_on_voice[k]    <= 1;
                    flag_voice_assigned <= 1;
        end  
        
        ASSIGN_TO_SAME_VOICE:
        begin
                    note_memory[j]                      <= note_freq;
                    freq_voice[g]                       <= note_memory[j];
                    voice_adress[g]                     <= j;
                    note_on_voice[g]                    <= 1;
                    flag_note_assigned_to_same_voice    <= 1;
        end  
        
        
        SEARCH_OLDEST_VOICE:
        begin
                    if ( (voice_adress[m] < oldest_voice_condition) && (m < VOICES) )
                            begin
                            oldest_voice_condition <= voice_adress[m];
                            oldest_voice <= m;
                            m <= m + 1;
                            end
                    else if (m < 5)
                            begin
                            m <= m + 1;
                            end
                    else
                            begin
                            flag_oldest_voice <= 1;
                            end                  
        end      
                
        //Write new note into oldest voice slot (lowest number of temporary assigned)
        ASSIGN_NEW_VOICE_TO_OLD_VOICE:
        begin                                   
                    note_memory[j]                              <= note_freq;
                    freq_voice[oldest_voice]                    <= note_memory[j];
                    voice_adress[oldest_voice]                  <= j;
                    note_on_voice[oldest_voice]                 <= 0;
                    flag_old_voice_replaced                     <= 1;
        end
        
        //RETRIG HANDLER ,noch umbennen!!!
        RETRIG_NOTE_ON:
        begin
                    note_on_voice[oldest_voice] <= 1;
                    flag_retrig_note_on         <= 1;
        end
                
        SHIFT_MEMORY:
        begin       
        
                if      (n < MAX_MEMORY - 1)
                        begin
                        note_memory[n] <= note_memory[n + 1];
                        n <= n + 1;
                        end
                else if (n == MAX_MEMORY - 1) 
                        begin
                        note_memory[n] <= note_freq;
                        n <= n + 1;
                        end
                else
                        begin
                        flag_memory_shifted <= 1;
                        end                                        
        end
                
        //degrade assignments of mem slots to voice slots by 1, mem slot 10 get voice from mem slot 6
        SHIFT_VOICE_ADRESS:
        begin              
                    if      (o < VOICES && voice_adress[o] != MAX_MEMORY - VOICES)
                                begin
                                voice_adress[o] <= voice_adress[o] - 1;
                                o = o + 1;
                                end
                    else if (voice_adress[o] == MAX_MEMORY - VOICES)
                                begin  
                                voice_adress[o] <= MAX_MEMORY - 1;
                                note_on_voice[o] <= 0;
                                o = o + 1;    
                                end                
                    else
                                begin
                                flag_adress_shifted <= 1;
                                end
        end
                
        SHIFT_VOICE_ASSIGNMENTS:
        begin
                    if  (p < VOICES)
                            begin
                            freq_voice[p] <= note_memory[voice_adress[p]];
                            p <= p+1;
                            if (note_on_voice[p] == 0)
                                begin
                                note_on_voice[p] <= 1;
                                end
                            end
                    else
                            begin
                            flag_voices_shifted <= 1;
                            end
        end
        
        
///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//NOTE_OFF SPECIFIC CASES        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////       
                        
        NOTE_OFF:
        begin
        flag_note_off       <= 1;
        q                   <= 0;
        end          
        
        CHECK_IF_NEWEST_NOTE:
        begin
                        if (note_memory[j-1] == note_freq)
                                begin
                                flag_newest_note <= 1;
                                end
                        else
                                begin
                                flag_not_newest_note <= 1;
                                end                                                               
        end
       
       //vllt voices - 1!!!!!!!!!!!!!!!!!!!
        SET_META_FLAGS:
        begin
                        if      (flag_note_off && flag_newest_note && j <= VOICES)
                                    begin
                                    META_FLAG_1 <= 1;
                                    end
                            
                        else if (flag_note_off && flag_newest_note && j > VOICES)
                                    begin
                                    META_FLAG_2 <= 1;
                                    end
                            
                        else if (flag_note_off && flag_not_newest_note && j <= VOICES)
                                    begin
                                    META_FLAG_3 <= 1;
                                    end
                        
                        else if (flag_note_off && flag_not_newest_note && j > VOICES && flag_note_is_not_playing_atm)
                                    begin
                                    META_FLAG_4 <= 1;
                                    end
                                    
                        else if (flag_note_off && flag_not_newest_note && j > VOICES && flag_note_is_playing_atm)
                                    begin
                                    META_FLAG_5 <= 1;
                                    end                        
                        else
                                    begin
                                    NO_DEFINED_META_STATE <= 1;
                                    end
        end                            
                
        IS_NOTE_OFF_PLAYING_ATM:
        begin
        if      (freq_voice[q] == note_freq)
                    begin
                    flag_note_is_playing_atm  <= 1;
                    end
        else if (q < VOICES && flag_note_is_playing_atm != 1 )
                    begin
                    q <= q + 1;
                    end
        else
                    begin
                    flag_note_is_not_playing_atm <= 1;
                    end
        end
        
        FREE_UP_MEM_SLOT:
        begin
        if      (note_memory[r] == note_freq)
                    begin
                    note_memory[r] <= 0;
                    flag_mem_slot_cleared <= 1;
                    s <= r;                    
                    end
        else if (flag_mem_slot_cleared !=1 && r < MAX_MEMORY)
                    begin
                    r <= r + 1;
                    end
        else if (r > MAX_MEMORY - 1)
                    begin
                    flag_no_valid_note <= 1;
                    end
        end                              
        
        FREE_UP_VOICE:
        begin
                freq_voice[q]       <= 0;
                voice_adress[q]     <= 15;
                note_on_voice[q]    <= 0;
                last_note_off_voice <= q;
                flag_voice_freed_up <= 1;
        end
        
        
        ALL_MEM_SLOTS_ABOVE_FREE_GO_ONE_DOWN:
        begin
        if      (s < j -1)
                    begin
                    note_memory[s] <= note_memory[s + 1];
                    s <= s + 1;
                    end
        else
                    begin
                    note_memory[s] <= 0;
                    flag_mem_slots_went_down <= 1;                    
                    end         
        end
                        
        CHANGE_VOICE_ASSIGNMENTS_4_5:
        begin
                if      (voice_adress[z] > r && z < VOICES)
                        begin
                        voice_adress[z] <= voice_adress[z] - 1;
                        z <= z+1;
                        end
                else if (voice_adress[z] == r && z < VOICES)
                        begin
                        voice_adress[z] <= j - VOICES - 1;
                        z <= z+1;
                        end
                else if (voice_adress[z] < r && z < VOICES)    
                        begin
                        voice_adress[z] <= voice_adress[z];
                        z <= z+1;
                        end
                else
                        begin
                        flag_note_off_voices_shifted <= 1;
                        end 
        end        
        
        CHANGE_VOICE_ASSIGNMENTS_3:
        begin
        if (z < VOICES)
        begin
                if      (voice_adress[z] > r && voice_adress[z] < j )
                        begin
                        voice_adress[z] <= voice_adress[z] - 1;
                        z <= z+1;
                        end
                else if (voice_adress[z] == r)
                        begin
                        voice_adress[z] <= 15;
                        z <= z+1;
                        end
                else if (voice_adress[z] < r)    
                        begin
                        voice_adress[z] <= voice_adress[z];
                        z <= z+1;
                        end
                else
                        begin
                        z <= z+1;
                        end
                end
                     
        else
        begin
        flag_note_off_voices_shifted <= 1;
        end 
        end 
                
        CHECK_NEWEST_NOT_PLAYED_NOTE:
        begin
                freq_newest_not_played_note <= note_memory[j - VOICES -1];
                flag_checked_newest_not_played_note <= 1;
        end
       
       
        ASSIGN_NEWEST_NOT_PLAYED_NOTE:
        begin
                freq_voice[q]   <= freq_newest_not_played_note;
                voice_adress[q] <= j - VOICES - 1;
                note_on_voice[q]<= 1;
                flag_assigned_newest_not_played_note <= 1;        
        end

        
        endcase
        end
        end
        
endmodule


