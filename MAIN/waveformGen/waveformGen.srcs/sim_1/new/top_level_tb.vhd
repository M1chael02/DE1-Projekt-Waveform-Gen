library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk  : in std_logic;
              btnc : in std_logic;
              btnu : in std_logic;
              btnd : in std_logic;
              btnl : in std_logic;
              btnr : in std_logic;
              sw   : in std_logic_vector (0 downto 0);
              led  : out std_logic_vector (3 downto 0);
              ja   : out std_logic_vector (3 downto 1);
              seg  : out std_logic_vector (6 downto 0);
              an   : out std_logic_vector (7 downto 0);
              dp   : out std_logic);
    end component;

    signal clk  : std_logic;
    signal btnc : std_logic;
    signal btnu : std_logic;
    signal btnd : std_logic;
    signal btnl : std_logic;
    signal btnr : std_logic;
    signal sw   : std_logic_vector (0 downto 0);
    signal led  : std_logic_vector (3 downto 0);
    signal ja   : std_logic_vector (3 downto 1);
    signal seg  : std_logic_vector (6 downto 0);
    signal an   : std_logic_vector (7 downto 0);
    signal dp   : std_logic;

    constant TbPeriod : time := 1 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (clk  => clk,
              btnc => btnc,
              btnu => btnu,
              btnd => btnd,
              btnl => btnl,
              btnr => btnr,
              sw   => sw,
              led  => led,
              ja   => ja,
              seg  => seg,
              an   => an,
              dp   => dp);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btnc <= '0';
        btnu <= '0';
        btnd <= '0';
        btnl <= '0';
        btnr <= '0';
        sw <= (others => '0');

        -- Reset generation
        --  ***EDIT*** Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        btnc <= '1';
        wait for 10 ns;
        btnc <= '0';
        wait for 10 ns;

        -- ***EDIT*** Add stimuli here
        sw(0) <= '1';
        wait for 20 ns;
        btnl <= '1';
        wait for 20 ns;
        btnl <= '0';
        wait for 20 ns;
        btnl <= '1';
        wait for 20 ns;
        btnl <= '0';
        wait for 20 ns;
        btnl <= '1';
        wait for 20 ns;
        btnl <= '0';
        wait for 20 ns;
        btnl <= '1';
        wait for 20 ns;
        btnl <= '0';
        wait for 20 ns;
        btnl <= '1';
        wait for 20 ns;
        btnl <= '0';
        wait for 20 ns;
        btnl <= '1';
        wait for 20 ns;
        btnu <= '1';
        wait for 20 ns;
        btnl <= '0';
        btnu <= '0';
        sw(0) <= '0';
        wait for 3000*TBPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;