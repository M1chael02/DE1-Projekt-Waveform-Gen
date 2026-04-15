library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( clk : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (5 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           dp : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

    component display_controller is
    Port(
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        freq_in     : in  STD_LOGIC_VECTOR(16 downto 0);
        mag         : in  STD_LOGIC_VECTOR(5 downto 0);
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        anode       : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

begin

    display_0 : display_controller
    port map(
        clk => clk,
        rst => btnc,
        freq_in => b"10101010101010101",
        mag => sw,
        seg => seg,
        anode => an
    );
    
    dp <= '1';

end Behavioral;
