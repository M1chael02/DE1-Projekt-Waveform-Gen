-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 19 Apr 2026 14:01:42 GMT
-- Request id : cfwk-fed377c2-69e4e046dfd24

library ieee;
use ieee.std_logic_1164.all;

entity tb_square_gen is
end tb_square_gen;

architecture tb of tb_square_gen is

    component square_gen
        port (clk        : in std_logic;
              rst        : in std_logic;
              en         : in std_logic;
              freq       : in std_logic_vector (19 downto 0);
              square_out : out std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal en     : std_logic;
    signal freq   : std_logic_vector (19 downto 0);
    signal square : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : square_gen
    port map (clk    => clk,
              rst    => rst,
              en     => en,
              freq   => freq,
              square_out => square);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        en <= '0';
        freq <= b"0000_0000_0000_0000_0011";

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        en <= '1';
        wait for 20ns;
        en <= '0';
        wait for 20ns;
        freq <= b"0000_0000_0000_0000_0101";
        wait for 300ns;
        en <= '1';
        wait for 20ns;
        en <= '0';
        wait for 300ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_square_gen of tb_square_gen is
    for tb
    end for;
end cfg_tb_square_gen;