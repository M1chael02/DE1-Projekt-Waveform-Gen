library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_blink is
    generic ( G_MAX : positive := 5 );  -- Default number of clock cycles
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : out STD_LOGIC);
end counter_blink;

architecture Behavioral of counter_blink is
 -- Internal counter
    signal sig_cnt : integer range 0 to G_MAX-1;

begin

    -- Count clock pulses and generate a one-clock-cycle enable pulse
    process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            if rst = '1' then     -- High-active reset
                ce      <= '0';   -- Reset output
                sig_cnt <= 0;     -- Reset internal counter

            elsif sig_cnt = G_MAX-1 then
                ce <= '1';
                sig_cnt <= 0;
            elsif sig_cnt > G_MAX/2 then
                ce <= '1';
                sig_cnt <= sig_cnt + 1;
            elsif sig_cnt < G_MAX/2 then
                ce <= '0';
                sig_cnt <= sig_cnt + 1;
            else
                ce <= '0';
                sig_cnt <= sig_cnt + 1;

            end if;  -- End if for reset/check
        end if;      -- End if for rising_edge
    end process;

end Behavioral;