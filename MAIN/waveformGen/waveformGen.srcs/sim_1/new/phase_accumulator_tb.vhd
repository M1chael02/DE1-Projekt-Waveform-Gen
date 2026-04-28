-- partially created by AI (chatGPT)



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accumulator_tb is
end entity;

architecture tb of phase_accumulator_tb is

    -- DUT signály
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal phase_step : std_logic_vector(31 downto 0) := (others => '0');
    signal phase_out  : std_logic_vector(31 downto 0);

    -- clock period
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- instance DUT
    uut: entity work.phase_accumulator
        port map (
            clk        => clk,
            rst        => rst,
            phase_step => phase_step,
            phase_out  => phase_out
        );

    -- clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- stimulus
    stim_proc : process
    begin

        -- reset
        wait for 50 ns;
        rst <= '0';


        -- test 1: small phase_step
        phase_step <= std_logic_vector(to_unsigned(1000, 32));
        wait for 200 ns;

        -- test 2: bigger step 
        phase_step <= std_logic_vector(to_unsigned(100000, 32));
        -- konec simulace
        wait;
    end process;

end architecture;
