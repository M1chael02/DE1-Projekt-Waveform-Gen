-- created by AI (chatGPT)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Triangle wave generator based on phase input (DDS output)
entity triangle_gen is
    port (
        phase_in   : in  std_logic_vector(31 downto 0); -- Input phase from phase accumulator
        triangle   : out std_logic_vector(7 downto 0)   -- 8-bit triangle waveform output
    );
end entity;

architecture rtl of triangle_gen is
    signal phase_u : unsigned(31 downto 0); -- Unsigned version of phase input
    signal value   : unsigned(7 downto 0);  -- Extracted upper bits used for waveform generation
begin

    -- Convert input phase to unsigned for arithmetic operations
    phase_u <= unsigned(phase_in);

    -- Take upper 8 bits (excluding MSB) to form base ramp value
    value <= phase_u(30 downto 23);

    -- Generate triangle waveform based on MSB of phase
    process(phase_u, value)
    begin
        if phase_u(31) = '0' then
            -- Rising part of triangle (increasing ramp)
            triangle <= std_logic_vector(value);
        else
            -- Falling part of triangle (invert ramp)
            triangle <= std_logic_vector(not value);
        end if;
    end process;

end architecture;
