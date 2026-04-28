library ieee;
use ieee.std_logic_1164.all;

entity tb_display_controller is
end tb_display_controller;

architecture tb of tb_display_controller is

    component display_controller
        port (clk     : in std_logic;
              rst     : in std_logic;
              change  : in std_logic;
              freq_in : in std_logic_vector (19 downto 0);
              mag     : in std_logic_vector (5 downto 0);
              seg     : out std_logic_vector (6 downto 0);
              anode   : out std_logic_vector (7 downto 0));
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal change  : std_logic;
    signal freq_in : std_logic_vector (19 downto 0);
    signal mag     : std_logic_vector (5 downto 0);
    signal seg     : std_logic_vector (6 downto 0);
    signal anode   : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_controller
    port map (clk     => clk,
              rst     => rst,
              change  => change,
              freq_in => freq_in,
              mag     => mag,
              seg     => seg,
              anode   => anode);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        change <= '0';
        freq_in <= (others => '0');
        mag <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        freq_in <= b"0000_0000_1010_0001_1111";
        wait for 400 ns;
        freq_in <= b"0000_1100_1010_0001_1111";
        change <= '1';
        mag <= "001000";
        wait for 400 ns;


        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_display_controller of tb_display_controller is
    for tb
    end for;
end cfg_tb_display_controller;