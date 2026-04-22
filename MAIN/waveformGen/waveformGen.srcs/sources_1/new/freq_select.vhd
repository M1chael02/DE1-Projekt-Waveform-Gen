library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity freq_select is
    Port ( mag_up       : in  STD_LOGIC;
           mag_down     : in  STD_LOGIC;
           freq_up      : in  STD_LOGIC;
           freq_down    : in  STD_LOGIC;
           freq_change  : in  STD_LOGIC;
           clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           update_tick  : out STD_LOGIC;
           freq         : out STD_LOGIC_VECTOR (19 downto 0);
           freq_comp    : out STD_LOGIC_VECTOR (19 downto 0);
           mag          : out STD_LOGIC_VECTOR (5 downto 0));
end freq_select;

architecture Behavioral of freq_select is

    signal sig_mag  : unsigned(2 downto 0)  := "000";
    signal sig_mag_d: STD_LOGIC_VECTOR(5 downto 0);
    signal sig_freq : unsigned(19 downto 0) := (others => '0');
    signal sig_freq_cmp : unsigned(19 downto 0) := (others => '0');

    signal prev_change  : STD_LOGIC := '0';
    signal tick_reg     : STD_LOGIC := '0';
    
    constant MAX_FREQ : unsigned(19 downto 0) := to_unsigned(100000, 20);

begin

    process(clk, rst)
    
    variable step_val : unsigned(19 downto 0);
    
    begin
        tick_reg <= '0';
        
        if rst = '1' then
            sig_mag      <= (others => '0');
            sig_freq     <= to_unsigned(1,20);
            sig_freq_cmp <= to_unsigned(1,20);
            prev_change  <= '0';
            tick_reg     <= '0';

        elsif rising_edge(clk) then
            if freq_change = '1' then

                if mag_up = '1' and sig_mag < "110" then
                    sig_mag <= sig_mag + 1;
                elsif mag_down = '1' and sig_mag > "001" then
                    sig_mag <= sig_mag - 1;
                end if;
                
                case sig_mag is
                    when "001"  => step_val := to_unsigned(1, 20);
                    when "010"  => step_val := to_unsigned(10, 20);
                    when "011"  => step_val := to_unsigned(100, 20);
                    when "100"  => step_val := to_unsigned(1000, 20);
                    when "101"  => step_val := to_unsigned(10000, 20);
                    when "110"  => step_val := to_unsigned(100000, 20);
                    when others => step_val := to_unsigned(0, 20);
                end case;
                
                case freq_change is
                    when '0' => 
                        sig_mag_d <= "000000";
                        sig_mag <= "000";
                    when '1' =>
                        case sig_mag is
                            when "001" => sig_mag_d <= "000001";
                            when "010" => sig_mag_d <= "000010";
                            when "011" => sig_mag_d <= "000100";
                            when "100" => sig_mag_d <= "001000";
                            when "101" => sig_mag_d <= "010000";
                            when "110" => sig_mag_d <= "100000";
                            when others => sig_mag_d <= "000000";
                        end case;
                    when others => sig_mag_d <= "000000";
                end case;
                
                if freq_up = '1' then
                    if sig_freq + step_val <= MAX_FREQ then
                        sig_freq <= sig_freq + step_val;
                    else
                        sig_freq <= MAX_FREQ;
                    end if;
    
                elsif freq_down = '1' then
                    if sig_freq > step_val then
                        sig_freq <= sig_freq - step_val;
                    else
                        sig_freq <= to_unsigned(1,20);
                    end if;

                end if;             
            end if;
            
            if prev_change = '1' and freq_change = '0' then
                sig_freq_cmp <= sig_freq;
                tick_reg <= '1';
            end if;

        prev_change <= freq_change;
        end if;
    end process;

    freq        <= std_logic_vector(sig_freq);
    freq_comp   <= std_logic_vector(sig_freq_cmp);
    mag         <= std_logic_vector(sig_mag_d);
    update_tick <= tick_reg;

end Behavioral;
