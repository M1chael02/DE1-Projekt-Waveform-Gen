-- partially created by AI (chatGPT)


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_triangle_tb is
end entity;

architecture tb of top_triangle_tb is

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    --signal phase_step : std_logic_vector(31 downto 0);
    signal phase_step : std_logic_vector(31 downto 0) := (others => '0');
    signal triangle_out    : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    -- DUT
    uut: entity work.top_triangle
        port map (
            clk        => clk,
            rst        => rst,
           -- enable     => enable,
            phase_step => phase_step,
            --triangle_out => triangle_out, --POUZE TEST, SMAZAT!!!!!!!!
            pwm_out    => triangle_out
        );

    -- clock
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- stimulus
    stim_proc : process
    begin

        -- reset
        wait for 50 ns;
        rst <= '0';
        
        -- Wait for a clean rising edge before starting stimulus
        wait until rising_edge(clk);

        -- Low frequency setting (~10 kHz)
        phase_step <= std_logic_vector(to_unsigned(429497, 32));
        wait for 0.25 ms;
        
        -- Medium frequency setting
        phase_step <= std_logic_vector(to_unsigned(858993, 32));
        wait for 0.25 ms;
        -- Higher frequency setting
        phase_step <= std_logic_vector(to_unsigned(2147484, 32));
        wait for 0.25 ms;
        
        wait;
    end process;

end architecture;