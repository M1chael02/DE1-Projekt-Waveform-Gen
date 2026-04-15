library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_en is
    generic (
        N_PERIODS : integer := 100_000
    );

    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : out STD_LOGIC);
end clk_en;

architecture Behavioral of clk_en is
    signal sig_cnt : integer range 0 to N_PERIODS -1;
begin
 --! Count the number of clock pulses from zero to N_PERIODS-1.
    p_clk_enable : process (clk) is
    begin

        -- Synchronous proces
        if (rising_edge(clk)) then
            -- if high-active reset then
            if rst = '1' then 
                sig_cnt <= 0;
                -- Clear integer counter

            -- elsif sig_count is less than N_PERIODS-1 then
            elsif sig_cnt < N_PERIODS-1 then 
                -- Counting
                sig_cnt <= sig_cnt + 1;

            -- else reached the end of counter
                -- Clear integer counter
            else
            -- Each `if` must end by `end if`
                sig_cnt <= 0;
            end if;
        end if;

    end process p_clk_enable;
    
    ce <= '1' when sig_cnt = N_PERIODS-1 else
             '0';
    -- Generated pulse is always one clock long
    -- when sig_count = N_PERIODS-1


end Behavioral;
