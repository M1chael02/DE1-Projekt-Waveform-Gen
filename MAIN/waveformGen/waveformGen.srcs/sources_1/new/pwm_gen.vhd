library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- PWM generator using an 8-bit counter and comparator
entity pwm_gen is
    port (
        clk        : in  std_logic; -- System clock
        rst        : in  std_logic; -- Active-high synchronous reset
        duty_in    : in  std_logic_vector(7 downto 0); -- Duty cycle input (0-255)
        pwm_out    : out std_logic -- PWM output signal
    );
end entity;

architecture rtl of pwm_gen is
    signal counter : unsigned(7 downto 0) := (others => '0'); -- 8-bit free-running counter
begin

    -- Counter process (increments every clock cycle)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset counter to zero
                counter <= (others => '0');

            else
                -- Increment counter (wraps around automatically at 255 → 0)
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Comparator: generates PWM signal
    -- Output is '1' when duty_in is greater than current counter value
    -- This creates a pulse width proportional to duty_in
    pwm_out <= '1' when unsigned(duty_in) > counter else '0';

end architecture;