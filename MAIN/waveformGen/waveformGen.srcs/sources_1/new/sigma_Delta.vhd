----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2026 01:32:29
-- Design Name: 
-- Module Name: sigma_Delta - Behavioral
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

entity sigma_Delta is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;
        data_in     : in  std_logic_vector(7 downto 0);
        dac_out     : out std_logic
    );
end entity;

architecture rtl of sigma_Delta is
    signal acc      : unsigned(8 downto 0) := (others => '0');
    signal delayed  : std_logic;
begin

    process(clk)
        variable sum : unsigned(8 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                acc <= (others => '0');
            else
                sum := acc + unsigned('0' & data_in);
                acc <= sum;
            end if;
        end if;
    end process;

    dac_out <= acc(8);

end architecture;
