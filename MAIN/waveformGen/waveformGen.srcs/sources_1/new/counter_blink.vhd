library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_blink is
    -- Default number of clock cycles
    generic ( G_MAX : positive := 5 );  
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           dis : in STD_LOGIC;
           ce  : out STD_LOGIC);
end counter_blink;

architecture Behavioral of counter_blink is
 -- Internal counter
    signal sig_cnt : integer range 0 to G_MAX-1;

begin
    process (clk) is
    begin
        -- Reacts to clock
        if rising_edge(clk) then  
            if rst = '1' then     
                ce      <= '0';   
                sig_cnt <= 0;     
            -- Dissables blinking when frequency isnt changing
            elsif dis = '0' then
                ce      <= '0';
                sig_cnt <= 0'

            -- Returns counter to 0 when it reaches max
            elsif sig_cnt = G_MAX-1 then
                ce      <= '1';
                sig_cnt <= 0;
            -- Counter outputs 1 when sig_cnt over half of max value
            elsif sig_cnt > G_MAX/2 then
                ce      <= '1';
                sig_cnt <= sig_cnt + 1;
            -- Counter outputs 0 when sig_cnt under half of max value
            elsif sig_cnt < G_MAX/2 then
                ce      <= '0';
                sig_cnt <= sig_cnt + 1;
            else
                ce      <= '0';
                sig_cnt <= sig_cnt + 1;

            end if;  
        end if;      
    end process;

end Behavioral;
