library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench for PWM generator
entity pwm_gen_tb is
end entity;

architecture tb of pwm_gen_tb is

    signal clk      : std_logic := '0'; -- Clock signal initialization
    signal rst      : std_logic := '1'; -- Active-high reset
    signal duty_in  : std_logic_vector(7 downto 0) := (others => '0'); -- Duty cycle input
    signal pwm_out  : std_logic; -- PWM output signal

    constant CLK_PERIOD : time := 10 ns; -- Clock period (100 MHz)

begin

    -- Instantiate the Device Under Test (DUT)
    uut: entity work.pwm_gen
        port map (
            clk     => clk,
            rst     => rst,
            duty_in => duty_in,
            pwm_out => pwm_out
        );

    -- Clock generation process (runs continuously)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process: applies different duty cycle values
    stim_proc : process
    begin

        -- Apply reset for initial 50 ns
        wait for 50 ns;
        rst <= '0'; -- Release reset

        -- 25% duty cycle (64/256)
        duty_in <= std_logic_vector(to_unsigned(64, 8));
        wait for 5 us;

        -- 50% duty cycle (128/256)
        duty_in <= std_logic_vector(to_unsigned(128, 8));
        wait for 5 us;

        -- 75% duty cycle (192/256)
        duty_in <= std_logic_vector(to_unsigned(192, 8));
        wait for 5 us;

        -- ~100% duty cycle (255/256)
        duty_in <= std_logic_vector(to_unsigned(255, 8));
        wait for 5 us;

        -- 0% duty cycle
        duty_in <= std_logic_vector(to_unsigned(0, 8));
        wait for 5 us;

        -- End of simulation
        wait;
    end process;

end architecture;
