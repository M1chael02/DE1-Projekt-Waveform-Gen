library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench for triangle generator
entity triangle_gen_tb is
end entity;

architecture tb of triangle_gen_tb is

    signal phase    : std_logic_vector(31 downto 0) := (others => '0'); -- Input phase signal
    signal triangle : std_logic_vector(7 downto 0); -- Output triangle waveform

begin

    -- Instantiate the Device Under Test (DUT)
    uut: entity work.triangle_gen
        port map (
            phase_in => phase,
            triangle => triangle
        );

    -- Stimulus process: generates phase values to sweep one full period
    stim_proc : process
    begin

        -- Sweep through one full phase period
        for i in 0 to 1023 loop
            -- Increment phase in large steps to cover full 32-bit range
            -- (2^22 step ensures MSBs change each iteration)
            phase <= std_logic_vector(to_unsigned(i * 2**22, 32));
            wait for 98 ns; -- Wait to observe output change
        end loop;

        -- End of simulation
        wait;
    end process;

end architecture;
