----------------------------------------------------------------------------------
-- Testbench for sawtooth_top
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sawtooth_top_tb is
end sawtooth_top_tb;

architecture Behavioral of sawtooth_top_tb is

    component sawtooth_top is
        Port ( clk          : in STD_LOGIC;
               rst          : in STD_LOGIC;
               phase_Shift  : in STD_LOGIC_VECTOR (31 downto 0);
               output_Saw   : out STD_LOGIC);
    end component sawtooth_top;

    -- Signály
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal phase_Shift : std_logic_vector(31 downto 0) := (others => '0');
    signal output_Saw  : std_logic;

    -- 100 MHz -> perioda 10 ns
    constant CLK_PERIOD : time := 10 ns;

    -- Phase step konstanty
    

begin

    -- Generátor hodin
    clk_gen : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Instance DUT
    DUT : sawtooth_top
        port map (
            clk         => clk,
            rst         => rst,
            phase_Shift => phase_Shift,
            output_Saw  => output_Saw
        );

    -- Stimuly
    stim : process
    begin
        -- Reset
        rst <= '1';
        phase_Shift <= std_logic_vector(to_unsigned(42949, 32));
        wait for 100 ns;
        rst <= '0';

        -- Test 1 kHz (necháme běžet 3 periody = 3 ms)
        wait for 3 ms;

        -- Test 50 kHz (3 periody = 60 us)
        phase_Shift <= std_logic_vector(to_unsigned(2147484, 32));
        wait for 60 us;

        -- Test 100 kHz (3 periody = 30 us)
        phase_Shift <= std_logic_vector(to_unsigned(4294967, 32));
        wait for 30 us;
        
        phase_Shift <= std_logic_vector(to_unsigned(43, 32));

        

        wait;
    end process;

end Behavioral;