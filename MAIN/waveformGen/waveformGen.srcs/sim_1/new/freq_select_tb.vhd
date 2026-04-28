library ieee;
use ieee.std_logic_1164.all;

entity tb_freq_select is
end tb_freq_select;

architecture tb of tb_freq_select is

    component freq_select
        port (mag_up      : in std_logic;
              mag_down    : in std_logic;
              freq_up     : in std_logic;
              freq_down   : in std_logic;
              freq_change : in std_logic;
              clk         : in std_logic;
              rst         : in std_logic;
              update_tick : out std_logic;
              freq        : out std_logic_vector (19 downto 0);
              freq_comp   : out std_logic_vector (19 downto 0);
              mag         : out std_logic_vector (2 downto 0));
    end component;

    signal mag_up      : std_logic;
    signal mag_down    : std_logic;
    signal freq_up     : std_logic;
    signal freq_down   : std_logic;
    signal freq_change : std_logic;
    signal clk         : std_logic;
    signal rst         : std_logic;
    signal update_tick : std_logic;
    signal freq        : std_logic_vector (19 downto 0);
    signal freq_comp   : std_logic_vector (19 downto 0);
    signal mag         : std_logic_vector (2 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : freq_select
    port map (mag_up      => mag_up,
              mag_down    => mag_down,
              freq_up     => freq_up,
              freq_down   => freq_down,
              freq_change => freq_change,
              clk         => clk,
              rst         => rst,
              update_tick => update_tick,
              freq        => freq,
              freq_comp   => freq_comp,
              mag         => mag);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        mag_up <= '0';
        mag_down <= '0';
        freq_up <= '0';
        freq_down <= '0';
        freq_change <= '1';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        freq_up <= '1';
        wait for 20ns;
        
        mag_up <= '1';
        freq_up <= '1';
        wait for 20ns;
        
        freq_up <= '0';
        freq_down <= '1';
        wait for 20ns;
        
        freq_up <= '1';
        freq_down <= '0';
        wait for 20ns;
        
        freq_change <= '0';
        wait for 20ns;
        
        freq_change <= '1';
        freq_up <= '1';
        wait for 20ns;
        
        freq_up <= '1';
        wait for 20ns;
        
        TbSimEnded <= '1';
        wait;

    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_freq_select of tb_freq_select is
    for tb
    end for;
end cfg_tb_freq_select;