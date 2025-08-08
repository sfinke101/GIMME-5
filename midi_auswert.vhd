library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity midi_auswert is
    generic(clk_freq: integer := 12e6);
    port (
        clk, fertig_midi: in std_logic;
        note_on, note_off: out std_logic;
        midi1, midi2, midi3: in std_logic_vector(7 downto 0);
        note_freq: out std_logic_vector(6 downto 0);
        velocity: out std_logic_vector(6 downto 0);
        
        contrl_8, contrl_9, contrl_10, contrl_11: out std_logic_vector(6 downto 0);
        contrl_12, contrl_13, contrl_14, contrl_15: out std_logic_vector(6 downto 0);
                
        contrl_16, contrl_17, contrl_18, contrl_19: out std_logic_vector(6 downto 0);
        contrl_20, contrl_21, contrl_22, contrl_23: out std_logic_vector(6 downto 0);
        
        contrl_24, contrl_25, contrl_26, contrl_27: out std_logic_vector(6 downto 0);
        contrl_28, contrl_29, contrl_30, contrl_31: out std_logic_vector(6 downto 0);
        
        contrl_32, contrl_33, contrl_34, contrl_35: out std_logic_vector(6 downto 0);
        contrl_36, contrl_37, contrl_38, contrl_39: out std_logic_vector(6 downto 0);
        
        contrl_40, contrl_41, contrl_42, contrl_43: out std_logic_vector(6 downto 0);
        contrl_44, contrl_45, contrl_46, contrl_47: out std_logic_vector(6 downto 0);
        
        contrl_48, contrl_49, contrl_50, contrl_51: out std_logic_vector(6 downto 0);
        contrl_52, contrl_53, contrl_54, contrl_55: out std_logic_vector(6 downto 0);
        
        contrl_56, contrl_57, contrl_58, contrl_59: out std_logic_vector(6 downto 0);
        contrl_60, contrl_61, contrl_62, contrl_63: out std_logic_vector(6 downto 0);
        
        contrl_64, contrl_65, contrl_66, contrl_67: out std_logic_vector(6 downto 0);
        contrl_68, contrl_69, contrl_70, contrl_71: out std_logic_vector(6 downto 0);
        
        contrl_72, contrl_73, contrl_74, contrl_75: out std_logic_vector(6 downto 0);
        contrl_76, contrl_77, contrl_78, contrl_79: out std_logic_vector(6 downto 0);
        
        contrl_80, contrl_81, contrl_82, contrl_83: out std_logic_vector(6 downto 0);
        contrl_84, contrl_85, contrl_86, contrl_87: out std_logic_vector(6 downto 0);
        
        contrl_88, contrl_89, contrl_90, contrl_91: out std_logic_vector(6 downto 0);
        contrl_92, contrl_93, contrl_94, contrl_95: out std_logic_vector(6 downto 0);
        
        contrl_96, contrl_97, contrl_98, contrl_99: out std_logic_vector(6 downto 0);
        contrl_100, contrl_101, contrl_102, contrl_103: out std_logic_vector(6 downto 0);
        
        contrl_104, contrl_105, contrl_106, contrl_107: out std_logic_vector(6 downto 0);
        contrl_108, contrl_109, contrl_110, contrl_111: out std_logic_vector(6 downto 0);
        
        contrl_112, contrl_113, contrl_114, contrl_115: out std_logic_vector(6 downto 0);
        contrl_116, contrl_117, contrl_118, contrl_119: out std_logic_vector(6 downto 0);
        
        pitchbend: out std_logic_vector(13 downto 0)
    );
end midi_auswert;

architecture midi_auswert_arc of midi_auswert is
    signal note_on_active: std_logic := '0';
    signal note_off_active: std_logic := '0';
    signal cycle_counter_on: integer := 0;  -- Zähler für note_on
    signal cycle_counter_off: integer := 0; -- Zähler für note_off
    constant CYCLE_LIMIT: integer := 3;      -- Anzahl der Taktrunden für die Aktivierung
begin
    process(clk)
        variable old_fertig_midi: std_logic := '1';
    begin
        if rising_edge(clk) then
            if fertig_midi = '1' and old_fertig_midi = '0' then
                case midi1 is
                    when x"90" => 
                        if midi3 = x"00" then  -- Prüfen, ob Velocity 0 ist
                            note_freq <= midi2(6 downto 0);
                            velocity <= midi3(6 downto 0);
                            note_on_active <= '0';   -- Deaktivierung des note_on Signals
                            note_off_active <= '1';  -- Aktivierung des note_off Signals
                            cycle_counter_on <= 0;   -- Zähler für note_on zurücksetzen
                            cycle_counter_off <= 0;  -- Zähler für note_off zurücksetzen
                        else
                            note_freq <= midi2(6 downto 0);
                            velocity <= midi3(6 downto 0);
                            note_on_active <= '1';   -- Aktivierung des note_on Signals
                            note_off_active <= '0';  -- Deaktivierung des note_off Signals
                            cycle_counter_on <= 0;   -- Zähler für note_on zurücksetzen
                            cycle_counter_off <= 0;  -- Zähler für note_off zurücksetzen
                        end if;


                    when x"80" => 
                        note_freq <= midi2(6 downto 0);
                        velocity <= midi3(6 downto 0);
                        note_on_active <= '0';   -- Deaktivierung des note_on Signals
                        note_off_active <= '1';  -- Aktivierung des note_off Signals
                        cycle_counter_on <= 0;    -- Zähler für note_on zurücksetzen
                        cycle_counter_off <= 0;   -- Zähler für note_off zurücksetzen

                    when x"E0" => 
                        pitchbend <= midi3(6 downto 0) & midi2(6 downto 0);

                    when x"B0" => 
                        case midi2 is
                            when x"08" => contrl_8 <= midi3(6 downto 0);
                            when x"09" => contrl_9 <= midi3(6 downto 0);
                            when x"0A" => contrl_10 <= midi3(6 downto 0);
                            when x"0B" => contrl_11 <= midi3(6 downto 0);
                            when x"0C" => contrl_12 <= midi3(6 downto 0);
                            when x"0D" => contrl_13 <= midi3(6 downto 0);
                            when x"0E" => contrl_14 <= midi3(6 downto 0);
                            when x"0F" => contrl_15 <= midi3(6 downto 0);
                            when x"10" => contrl_16 <= midi3(6 downto 0);
                            when x"11" => contrl_17 <= midi3(6 downto 0);                            
                            when x"12" => contrl_18 <= midi3(6 downto 0);
                            when x"13" => contrl_19 <= midi3(6 downto 0);
                            
                            when x"14" => contrl_20 <= midi3(6 downto 0);
                            when x"15" => contrl_21 <= midi3(6 downto 0);
                            when x"16" => contrl_22 <= midi3(6 downto 0);
                            when x"17" => contrl_23 <= midi3(6 downto 0);
                            when x"18" => contrl_24 <= midi3(6 downto 0);
                            when x"19" => contrl_25 <= midi3(6 downto 0);
                            when x"1A" => contrl_26 <= midi3(6 downto 0);
                            when x"1B" => contrl_27 <= midi3(6 downto 0);
                            when x"1C" => contrl_28 <= midi3(6 downto 0);
                            when x"1D" => contrl_29 <= midi3(6 downto 0);
                            
                            when x"1E" => contrl_30 <= midi3(6 downto 0);
                            when x"1F" => contrl_31 <= midi3(6 downto 0);
                            when x"20" => contrl_32 <= midi3(6 downto 0);
                            when x"21" => contrl_33 <= midi3(6 downto 0);
                            when x"22" => contrl_34 <= midi3(6 downto 0);
                            when x"23" => contrl_35 <= midi3(6 downto 0);
                            when x"24" => contrl_36 <= midi3(6 downto 0);
                            when x"25" => contrl_37 <= midi3(6 downto 0);
                            when x"26" => contrl_38 <= midi3(6 downto 0);
                            when x"27" => contrl_39 <= midi3(6 downto 0);
                            
                            when x"28" => contrl_40 <= midi3(6 downto 0);
                            when x"29" => contrl_41 <= midi3(6 downto 0);
                            when x"2A" => contrl_42 <= midi3(6 downto 0);
                            when x"2B" => contrl_43 <= midi3(6 downto 0);
                            when x"2C" => contrl_44 <= midi3(6 downto 0);
                            when x"2D" => contrl_45 <= midi3(6 downto 0);
                            when x"2E" => contrl_46 <= midi3(6 downto 0);
                            when x"2F" => contrl_47 <= midi3(6 downto 0);
                            when x"30" => contrl_48 <= midi3(6 downto 0);
                            when x"31" => contrl_49 <= midi3(6 downto 0);
                            
                            when x"32" => contrl_50 <= midi3(6 downto 0);
                            when x"33" => contrl_51 <= midi3(6 downto 0);
                            when x"34" => contrl_52 <= midi3(6 downto 0);
                            when x"35" => contrl_53 <= midi3(6 downto 0);
                            when x"36" => contrl_54 <= midi3(6 downto 0);
                            when x"37" => contrl_55 <= midi3(6 downto 0);
                            when x"38" => contrl_56 <= midi3(6 downto 0);
                            when x"39" => contrl_57 <= midi3(6 downto 0);
                            when x"3A" => contrl_58 <= midi3(6 downto 0);
                            when x"3B" => contrl_59 <= midi3(6 downto 0);
                            
                            when x"3C" => contrl_60 <= midi3(6 downto 0);
                            when x"3D" => contrl_61 <= midi3(6 downto 0);
                            when x"3E" => contrl_62 <= midi3(6 downto 0);
                            when x"3F" => contrl_63 <= midi3(6 downto 0);
                            when x"40" => contrl_64 <= midi3(6 downto 0);
                            when x"41" => contrl_65 <= midi3(6 downto 0);
                            when x"42" => contrl_66 <= midi3(6 downto 0);
                            when x"43" => contrl_67 <= midi3(6 downto 0);
                            when x"44" => contrl_68 <= midi3(6 downto 0);
                            when x"45" => contrl_69 <= midi3(6 downto 0);
                            
                            when x"46" => contrl_70 <= midi3(6 downto 0);
                            when x"47" => contrl_71 <= midi3(6 downto 0);
                            when x"48" => contrl_72 <= midi3(6 downto 0);
                            when x"49" => contrl_73 <= midi3(6 downto 0);
                            when x"4A" => contrl_74 <= midi3(6 downto 0);
                            when x"4B" => contrl_75 <= midi3(6 downto 0);
                            when x"4C" => contrl_76 <= midi3(6 downto 0);
                            when x"4D" => contrl_77 <= midi3(6 downto 0);
                            when x"4E" => contrl_78 <= midi3(6 downto 0);
                            when x"4F" => contrl_79 <= midi3(6 downto 0);
                            
                            when x"50" => contrl_80 <= midi3(6 downto 0);
                            when x"51" => contrl_81 <= midi3(6 downto 0);
                            when x"52" => contrl_82 <= midi3(6 downto 0);
                            when x"53" => contrl_83 <= midi3(6 downto 0);
                            when x"54" => contrl_84 <= midi3(6 downto 0);
                            when x"55" => contrl_85 <= midi3(6 downto 0);
                            when x"56" => contrl_86 <= midi3(6 downto 0);
                            when x"57" => contrl_87 <= midi3(6 downto 0);
                            when x"58" => contrl_88 <= midi3(6 downto 0);
                            when x"59" => contrl_89 <= midi3(6 downto 0);
                            
                            when x"5A" => contrl_90 <= midi3(6 downto 0);
                            when x"5B" => contrl_91 <= midi3(6 downto 0);
                            when x"5C" => contrl_92 <= midi3(6 downto 0);
                            when x"5D" => contrl_93 <= midi3(6 downto 0);
                            when x"5E" => contrl_94 <= midi3(6 downto 0);
                            when x"5F" => contrl_95 <= midi3(6 downto 0);
                            when x"60" => contrl_96 <= midi3(6 downto 0);
                            when x"61" => contrl_97 <= midi3(6 downto 0);
                            when x"62" => contrl_98 <= midi3(6 downto 0);
                            when x"63" => contrl_99 <= midi3(6 downto 0);
                            
                            when x"64" => contrl_100 <= midi3(6 downto 0);
                            when x"65" => contrl_101 <= midi3(6 downto 0);
                            when x"66" => contrl_102 <= midi3(6 downto 0);
                            when x"67" => contrl_103 <= midi3(6 downto 0);
                            when x"68" => contrl_104 <= midi3(6 downto 0);
                            when x"69" => contrl_105 <= midi3(6 downto 0);
                            when x"6A" => contrl_106 <= midi3(6 downto 0);
                            when x"6B" => contrl_107 <= midi3(6 downto 0);
                            when x"6C" => contrl_108 <= midi3(6 downto 0);
                            when x"6D" => contrl_109 <= midi3(6 downto 0);
                            
                            when x"6E" => contrl_110 <= midi3(6 downto 0);
                            when x"6F" => contrl_111 <= midi3(6 downto 0);
                            when x"70" => contrl_112 <= midi3(6 downto 0);
                            when x"71" => contrl_113 <= midi3(6 downto 0);
                            when x"72" => contrl_114 <= midi3(6 downto 0);
                            when x"73" => contrl_115 <= midi3(6 downto 0);
                            when x"74" => contrl_116 <= midi3(6 downto 0);
                            when x"75" => contrl_117 <= midi3(6 downto 0);
                            when x"76" => contrl_118 <= midi3(6 downto 0);
                            when x"77" => contrl_119 <= midi3(6 downto 0);
                            
                            
                            when others => null;
                        end case;

                    when others => null;
                end case;
            end if;

            -- Zähler erhöhen, wenn note_on aktiv ist
            if note_on_active = '1' then
                cycle_counter_on <= cycle_counter_on + 1;

                -- Nach 3 Taktrunden deaktivieren
                if cycle_counter_on = CYCLE_LIMIT then
                    note_on_active <= '0';  -- note_on zurücksetzen
                end if;
            end if;

            -- Zähler erhöhen, wenn note_off aktiv ist
            if note_off_active = '1' then
                cycle_counter_off <= cycle_counter_off + 1;

                -- Nach 3 Taktrunden deaktivieren
                if cycle_counter_off = CYCLE_LIMIT then
                    note_off_active <= '0';  -- note_off zurücksetzen
                end if;
            end if;

            -- Outputs setzen
            note_on <= note_on_active;
            note_off <= note_off_active;

            old_fertig_midi := fertig_midi;
        end if;
    end process;

end midi_auswert_arc;
