----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 23:56:16
-- Design Name: 
-- Module Name: sawtoothGen_tb - Behavioral
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

entity sawtoothGen_tb is
end entity;

architecture tb of sawtoothGen_tb is

    signal phase    : std_logic_vector(31 downto 0) := (others => '0');
    signal sawtooth : std_logic_vector(7 downto 0);

begin

    -- DUT
    uut: entity work.sawtoothGen
        port map (
            phase_in => phase,
            sawtooth => sawtooth
        );

    -- stimulus
    stim_proc : process
    begin

        -- projedeme celou periodu
        for i in 0 to 255 loop
            phase <= std_logic_vector(to_unsigned(i * 2**24, 32));
            wait for 10 ns;
        end loop;

        wait;
    end process;

end architecture;
