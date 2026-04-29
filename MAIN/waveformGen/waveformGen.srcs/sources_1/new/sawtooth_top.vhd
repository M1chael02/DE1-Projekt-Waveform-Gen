----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2026 02:40:13
-- Design Name: 
-- Module Name: sawtooth_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sawtooth_top is
    Port ( clk          : in STD_LOGIC;
           rst          : in STD_LOGIC;
           phase_Shift  : in STD_LOGIC_VECTOR (31 downto 0);
           output_Saw   : out STD_LOGIC);
end sawtooth_top;

architecture Behavioral of sawtooth_top is
    -- Component declaration for Phase Accumulator
    component phase_accumulator is
        port (
            clk         : in  std_logic;            
            rst         : in  std_logic;
            phase_step  : in  std_logic_vector(31 downto 0); 
            phase_out   : out std_logic_vector(31 downto 0)
        );
    end component phase_accumulator;
    
    
     -- Component declaration for sawtooth generator
    component sawtoothGen is
        port (
            phase_in   : in  std_logic_vector(31 downto 0);
            sawtooth   : out std_logic_vector(7 downto 0)
        );
    end component sawtoothGen;
    
         -- Component declaration for sawtooth generator

    component pwm_gen is
        port (
            clk        : in  std_logic; -- System clock
            rst        : in  std_logic; -- Active-high synchronous reset
            duty_in    : in  std_logic_vector(7 downto 0); -- Duty cycle input (0-255)
            pwm_out    : out std_logic -- PWM output signal
        );
    end component pwm_gen;   
    
    signal s_phase  : std_logic_vector(31 downto 0) := (others => '0');
    signal s_saw    : std_logic_vector(7 downto 0)  := (others => '0');

begin
    
    phase_acc_2 : phase_accumulator
        port map (
            clk => clk,
            rst => rst,
            phase_step => phase_Shift,
            phase_out => s_phase
        );
        
    sawtooth_gen : sawtoothGen
        port map (
            phase_in => s_phase,
            sawtooth => s_saw
        );
        
        
    pwm_gen_1 : pwm_gen
        port map(
            clk => clk,
            rst => rst,
            duty_in => s_saw,
            pwm_out => output_Saw
        );
end Behavioral;