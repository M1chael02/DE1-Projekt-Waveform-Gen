----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2026 01:34:40
-- Design Name: 
-- Module Name: sigma_Delta_tb - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sigma_delta_dac_tb is
end entity;

architecture tb of sigma_delta_dac_tb is

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal data_in : std_logic_vector(7 downto 0) := (others => '0');
    signal dac_out : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- DUT
    uut : entity work.sigma_Delta
        port map (
            clk     => clk,
            rst     => rst,
            data_in => data_in,
            dac_out => dac_out
        );

    -- Clock generator
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus
    stim_proc : process
    begin

        -- Reset
        wait for 100 ns;
        rst <= '0';

        --------------------------------------------------------
        -- Test 1: 12.5 %
        --------------------------------------------------------
        data_in <= x"20";
        wait for 500 ns;

        --------------------------------------------------------
        -- Test 2: 25 %
        --------------------------------------------------------
        data_in <= x"40"; -- 64
        wait for 500 ns;

        --------------------------------------------------------
        -- Test 3: 50 %
        --------------------------------------------------------
        data_in <= x"80"; -- 128
        wait for 500 ns;

        --------------------------------------------------------
        -- Test 4: 75 %
        --------------------------------------------------------
        data_in <= x"C0"; -- 192
        wait for 5 ns;

        --------------------------------------------------------
        -- Test 5: 100 %
        --------------------------------------------------------
        data_in <= x"FF"; -- 255
        wait for 5 ns;

        --------------------------------------------------------
        -- Test 6: pila na vstupu
        --------------------------------------------------------
        for i in 0 to 255 loop
            data_in <= std_logic_vector(to_unsigned(i,8));
            wait for 200 ns;
        end loop;

        wait;
    end process;

end architecture;
