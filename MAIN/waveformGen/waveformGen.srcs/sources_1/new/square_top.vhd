library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity square_top is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        en          : in  STD_LOGIC;
        freq        : in  STD_LOGIC_VECTOR(19 downto 0);
        square_out  : out STD_LOGIC
    );
end square_top;

architecture Behavioral of square_top is

    -- Internal counter signal
    signal counter : unsigned(19 downto 0) := (others => '0');
    signal wave    : STD_LOGIC := '0';

    signal freq_u  : unsigned(19 downto 0);

begin

    -- Sets output to 0
    square_out <= wave;

process(clk, rst)
begin
    if rst = '1' then
        counter <= (others => '0');
        wave    <= '0';
    elsif rising_edge(clk) then
        -- Waits for signal from freq_select that frequency is done changing
        if en = '1' then
            -- Counts max value of counter so that correct frequncy is achieved
            freq_u <= 100000000/unsigned(freq)/2; -- 100000000 real aplication, 30 for simulation
        -- Starts orking after max value is counted
        elsif en = '0' then
            -- Works as counter_blink, When internal counter reaches half of maximal count switches output to 1
            if freq_u > 1 then
                if counter >= freq_u-1 then
                    counter <= (others => '0');
                    wave <= not wave;
                else
                    counter <= counter + 1;
                end if;
            else
                -- Puts output and internal counter to 0 in unexpected scenario
                counter <= (others => '0');
                wave <= '0';
            end if;
        else
            -- Puts output and internal counter to 0 in unexpected scenario
            counter <= (others => '0');
            wave <= '0';
        end if;
    end if;
end process;

end Behavioral;
