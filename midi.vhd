library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity midi is
	generic(clk_freq:integer:=12e6);
	port (clk,midi_in:in std_logic;
		   fertig:out std_logic;
			midi1,midi2,midi3:out std_logic_vector(7 downto 0));
end midi;

architecture midi_arc of midi is
	

begin
	process(clk)
		variable state:integer range 0 to 13:=0;
		variable next_state,old_state:integer range 0 to 3:=0;
		variable var_fertig:std_logic:='1';
		variable midi_in1,midi_in2,old_midi_in2:std_logic:='1';
		variable var_midi1,var_midi2,empf:std_logic_vector(7 downto 0):=(others=>'0');
		variable cnt:integer range 0 to 10*clk_freq/31250:=0;
	begin
		if rising_edge(clk) then
			midi_in2:=midi_in1;midi_in1:=midi_in;
			case state is
				when 0 => var_fertig:='1';
						    if midi_in2='0' and old_midi_in2='1' then --startbit erkannt
								state:=4;next_state:=1;old_state:=0;
							 end if;
				when 1 => var_midi1:=empf;
							 if cnt=10*clk_freq/31250 then cnt:=0;state:=0; --time_out, idle_state
							 elsif midi_in2='0' and old_midi_in2='1' then --startbit erkannt
								state:=4;next_state:=2;old_state:=1;cnt:=0;
							 else cnt:=cnt+1;
							 end if;
				when 2 => var_midi2:=empf;
							 if cnt=10*clk_freq/31250 then cnt:=0;state:=0; --time_out, idle_state
							 elsif midi_in2='0' and old_midi_in2='1' then --startbit erkannt
								state:=4;next_state:=3;old_state:=2;cnt:=0;
							 else cnt:=cnt+1;
							 end if;
				when 3 => midi1<=var_midi1;midi2<=var_midi2;midi3<=empf;
							 var_fertig:='0';state:=0;
							 
							 
				when 4 => --serieller Empfang
							 if cnt=clk_freq/(2*31250) then cnt:=0;--Zeiger auf Bitmitte
								if midi_in2='1' then state:=old_state; --falsches Startbit, zurueck
								else state:=5;
								end if;	
							 else cnt:=cnt+1;
							 end if;
				when 5 => if cnt=clk_freq/31250-1 then 
								empf(0):=midi_in2;cnt:=0;state:=6; --Bit0
							 else cnt:=cnt+1;
							 end if;
				when 6 => if cnt=clk_freq/31250-1 then 
								empf(1):=midi_in2;cnt:=0;state:=7; --Bit1
							 else cnt:=cnt+1;
							 end if;
				when 7 => if cnt=clk_freq/31250-1 then 
								empf(2):=midi_in2;cnt:=0;state:=8; --Bit2
							 else cnt:=cnt+1;
							 end if;
				when 8 => if cnt=clk_freq/31250-1 then 
								empf(3):=midi_in2;cnt:=0;state:=9; --Bit3
							 else cnt:=cnt+1;
							 end if;
				when 9 => if cnt=clk_freq/31250-1 then 
								empf(4):=midi_in2;cnt:=0;state:=10; --Bit4
							 else cnt:=cnt+1;
							 end if;
				when 10=> if cnt=clk_freq/31250-1 then 
								empf(5):=midi_in2;cnt:=0;state:=11; --Bit5
							 else cnt:=cnt+1;
							 end if;
				when 11=> if cnt=clk_freq/31250-1 then 
								empf(6):=midi_in2;cnt:=0;state:=12; --Bit6
							 else cnt:=cnt+1;
							 end if;
				when 12=> if cnt=clk_freq/31250-1 then 
								empf(7):=midi_in2; --Bit7
								cnt:=0;state:=next_state;--Ruecksprung
							 else cnt:=cnt+1;
							 end if;
				
				when others => var_fertig:='1';state:=0;next_state:=0;cnt:=0;
			end case;
			old_midi_in2:=midi_in2;
		end if;
		
		fertig<=var_fertig;
	end process;

end midi_arc;