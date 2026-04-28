-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 14 Apr 2026 18:43:50 GMT
-- Request id : cfwk-fed377c2-69de8ae6ccc44

library ieee;
use ieee.std_logic_1164.all;

entity tb_counter_blink is
end tb_counter_blink;

architecture tb of tb_counter_blink is

    component counter_blink
        port (clk : in std_logic;
              rst : in std_logic;
              ce  : out std_logic);
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal ce  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter_blink
    port map (clk => clk,
              rst => rst,
              ce  => ce);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter_blink of tb_counter_blink is
    for tb
    end for;
end cfg_tb_counter_blink;