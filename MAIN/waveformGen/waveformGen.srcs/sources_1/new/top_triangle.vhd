library ieee;
use ieee.std_logic_1164.all;

-- Top-level module connecting DDS, triangle generator, and PWM
entity top_triangle is
    port (
        clk        : in std_logic; -- System clock
        rst        : in std_logic; -- Active-high reset
        phase_step : in std_logic_vector(31 downto 0); -- Frequency control word (DDS tuning)
        pwm_out    : out std_logic -- Final PWM output signal
    );
end entity;

architecture rtl of top_triangle is

    signal phase    : std_logic_vector(31 downto 0); -- Phase accumulator output
    signal triangle : std_logic_vector(7 downto 0);  -- Triangle waveform (used as PWM duty cycle)
    
begin

    -- Phase accumulator (DDS core)
    -- Generates a continuously increasing phase value based on phase_step
    phase_acc_1: entity work.phase_accumulator
        port map (
            clk => clk,
            rst => rst,
            phase_step => phase_step,
            phase_out => phase
        );

    -- Triangle waveform generator
    -- Converts phase into an 8-bit triangle wave
    tri: entity work.triangle_gen
        port map (
            phase_in => phase,
            triangle => triangle
        );
        
    -- PWM generator
    -- Uses triangle waveform as duty cycle input
    -- Produces PWM signal corresponding to triangle amplitude
    pwm: entity work.pwm_gen
        port map (
            clk => clk,
            rst => rst,
            duty_in => triangle,
            pwm_out => pwm_out
        );

end architecture;
