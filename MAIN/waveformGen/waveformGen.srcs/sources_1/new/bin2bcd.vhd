-- Sourced from my previous projects
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2bcd is
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        binary_in : in  std_logic_vector(19 downto 0);
        bcd_out   : out std_logic_vector(23 downto 0)
    );
end bin2bcd;

architecture Behavioral of bin2bcd is
begin

process(clk, rst)
    variable shift_reg : std_logic_vector(40 downto 0);
begin
    if rst = '1' then
        bcd_out <= (others => '0');

    elsif rising_edge(clk) then

        -- clear register
        shift_reg := (others => '0');

        -- load binary input into lower bits
        shift_reg(19 downto 0) := binary_in;

        -- Double Dabble Algorithm
        for i in 0 to 16 loop

            -- Check each BCD digit and add 3 if > 4
            if unsigned(shift_reg(20 downto 17)) > 4 then
                shift_reg(20 downto 17) := std_logic_vector(unsigned(shift_reg(20 downto 17)) + 3);
            end if;

            if unsigned(shift_reg(24 downto 21)) > 4 then
                shift_reg(24 downto 21) := std_logic_vector(unsigned(shift_reg(24 downto 21)) + 3);
            end if;

            if unsigned(shift_reg(28 downto 25)) > 4 then
                shift_reg(28 downto 25) := std_logic_vector(unsigned(shift_reg(28 downto 25)) + 3);
            end if;

            if unsigned(shift_reg(32 downto 29)) > 4 then
                shift_reg(32 downto 29) := std_logic_vector(unsigned(shift_reg(32 downto 29)) + 3);
            end if;

            if unsigned(shift_reg(36 downto 33)) > 4 then
                shift_reg(36 downto 33) := std_logic_vector(unsigned(shift_reg(36 downto 33)) + 3);
            end if;

            if unsigned(shift_reg(40 downto 37)) > 4 then
                shift_reg(40 downto 37) := std_logic_vector(unsigned(shift_reg(40 downto 37)) + 3);
            end if;

            -- Shift left
            shift_reg := shift_reg(39 downto 0) & '0';

        end loop;

        -- Output BCD digits
        bcd_out <= shift_reg(40 downto 17);

    end if;
end process;

end Behavioral;
