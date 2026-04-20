----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2026 01:24:36
-- Design Name: 
-- Module Name: shiftGen_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shiftGen_tb is
end entity;

architecture tb of shiftGen_tb is

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal update_tick : std_logic := '0';
    signal freqIn      : std_logic_vector(19 downto 0) := (others => '0');
    signal phaseShift  : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- DUT
    uut: entity work.shiftGen
        port map (
            clk         => clk,
            rst         => rst,
            update_tick => update_tick,
            freqIn      => freqIn,
            phaseShift  => phaseShift
        );

    -- clock
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
        rst <= '1';
        wait for 50 ns;
        rst <= '0';

        --------------------------------------------------------------------
        -- TEST 1: low frequency
        --------------------------------------------------------------------
        freqIn <= std_logic_vector(to_unsigned(1000, 20));

        wait for 20 ns;

        update_tick <= '1';
        wait for CLK_PERIOD;
        update_tick <= '0';

        wait for 200 ns;

        --------------------------------------------------------------------
        -- TEST 2: higher frequency
        --------------------------------------------------------------------
        freqIn <= std_logic_vector(to_unsigned(50000, 20));

        wait for 20 ns;

        update_tick <= '1';
        wait for CLK_PERIOD;
        update_tick <= '0';

        wait for 200 ns;

        --------------------------------------------------------------------
        -- TEST 3: max-ish value
        --------------------------------------------------------------------
        freqIn <= std_logic_vector(to_unsigned(100000, 20));

        wait for 20 ns;

        update_tick <= '1';
        wait for CLK_PERIOD;
        update_tick <= '0';

        wait for 200 ns;

        --------------------------------------------------------------------
        -- hold simulation
        --------------------------------------------------------------------
        wait;

    end process;

end architecture;
