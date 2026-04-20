----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 23:36:47
-- Design Name: 
-- Module Name: phase_Accumulator - Behavioral
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

entity phase_accumulator is
    port (
        clk         : in  std_logic;            
        rst         : in  std_logic;
        phase_step  : in  std_logic_vector(31 downto 0); 
        phase_out   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of phase_accumulator is
    signal phase_reg : unsigned(31 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                phase_reg <= (others => '0');

            else
                phase_reg <= phase_reg + unsigned(phase_step);
            end if;
        end if;
    end process;

    phase_out <= std_logic_vector(phase_reg);

end architecture;
