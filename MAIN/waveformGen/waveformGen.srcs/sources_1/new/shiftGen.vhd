----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2026 02:03:05
-- Design Name: 
-- Module Name: shiftGen - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shiftGen is
    Port( 
        clk         : in std_logic;
        rst         : in std_logic;
        update_tick : in std_logic; -- External trigger for updating the frequency
        freqIn      : in std_logic_vector(19 downto 0);
        phaseShift  : out std_logic_vector(31 downto 0)
    );
end shiftGen;

architecture Behavioral of shiftGen is
    signal s_phase          : unsigned (31 downto 0) := (others => '0');    -- Signal holding the output value
    signal s_update_delayed : std_logic;                                    -- Delayed trigger for edge detection
    constant K : unsigned(31 downto 0) := to_unsigned(45_035_988, 32);         -- Precalculated constant for later multiplication in formula to get the shift value

begin

    phaseShifter : process (clk) is
        variable mult_v : unsigned(51 downto 0);
    begin
        if rising_edge (clk) then
            if rst = '1' then
                s_phase <= (others => '0');
                s_update_delayed <= '0';
                
            else
                 s_update_delayed <= update_tick;
                 
                 if update_tick = '1' and s_update_delayed = '0' then
                    mult_v := unsigned(freqIn) * K;

                -- scale down (>> 16)
                    s_phase <= resize(mult_v(51 downto 20), 32) + resize(mult_v(9 downto 9), 32);
                 end if;
            end if;
        end if;
    end process;
    
    phaseShift <= std_logic_vector(s_phase);
end Behavioral;
