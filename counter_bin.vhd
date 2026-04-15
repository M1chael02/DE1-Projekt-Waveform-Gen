library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_bin is
    generic ( G_BITS : positive := 3);
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        en  : in STD_LOGIC;
        cnt : out STD_LOGIC_VECTOR(G_BITS-1 downto 0)
    );
end counter_bin;

architecture Behavioral of counter_bin is

    signal sig_cnt : integer range 0 to (2**G_BITS - 1) := 0;

begin

    process (clk)
    begin
        if (rising_edge(clk) and en = '1') then
            if rst = '1' then
                sig_cnt <= 0;
            elsif sig_cnt = (2**G_BITS - 1) then
                sig_cnt <= 0;
            else
                sig_cnt <= sig_cnt + 1;
            end if;
        end if;
    end process;

    cnt <= std_logic_vector(to_unsigned(sig_cnt, G_BITS));

end Behavioral;