----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 23:53:19
-- Design Name: 
-- Module Name: sawtoothGen - Behavioral
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

entity sawtoothGen is
    port (
        phase_in   : in  std_logic_vector(31 downto 0);
        sawtooth   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sawtoothGen is
    signal phase_u : unsigned(31 downto 0);
    signal value   : unsigned(7 downto 0);
begin

    phase_u <= unsigned(phase_in);

    -- vezmeme horních 8 bitů
    value <= phase_u(31 downto 24);

    process(phase_u, value)
    begin
        sawtooth <= std_logic_vector(value);

    end process;

end architecture;
