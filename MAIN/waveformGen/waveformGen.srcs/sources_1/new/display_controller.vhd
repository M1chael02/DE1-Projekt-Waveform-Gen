library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_controller is
    Port(   
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        change      : in  STD_LOGIC;
        freq_in     : in  STD_LOGIC_VECTOR(19 downto 0);
        mag         : in  STD_LOGIC_VECTOR(5 downto 0);
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        anode       : out STD_LOGIC_VECTOR(7 downto 0));
end display_controller;

architecture Behavioral of display_controller is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
 
    -- Component declaration for binary counter
    component counter_bin is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter_bin;
    
    -- Component declaration for binary counter that holds ce for half of period
    component counter_blink is
    generic ( G_MAX : positive);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           dis : in STD_LOGIC;
           ce  : out STD_LOGIC);
    end component counter_blink;
    
    -- Component declaration for binary translator to 7 segment display
    component bin2seg is
        Port (  
            rst   : in  STD_LOGIC;
            bcd   : in  STD_LOGIC_VECTOR (3 downto 0);
            seg   : out STD_LOGIC_VECTOR (6 downto 0));
    end component bin2seg;
    
    --Component declaration for translator from binary to bcd
    component bin2bcd is
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        binary_in : in  std_logic_vector(19 downto 0);
        bcd_out   : out std_logic_vector(23 downto 0)
        );
    end component bin2bcd;
 
    -- Internal signal(s)
    signal sig_en       : std_logic;
    signal sig_digit    : std_logic_vector (2 downto 0); 
    signal sig_bcd      : std_logic_vector (3 downto 0);
    signal sig_data     : std_logic_vector (23 downto 0);
    signal sig_blink    : std_logic;

begin

    -- Clock enable generator for refresh timing
    clock_0 : clk_en
        generic map ( G_MAX => 100_000 ) 
        port map (                  
            clk => clk,             
            rst => rst,
            ce  => sig_en
        );
        
    -- Conter for digit select
    counter_0 : counter_bin
        generic map ( G_BITS => 3 )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );
        
    counter_1 : counter_blink
    generic map ( G_MAX => 50000000)
    port map ( 
           clk => clk,
           rst => rst,
           dis => change,
           ce  => sig_blink
        );
    
    -- Translator   
    bin2bcd_0 : bin2bcd
        port map (
            clk => clk,
            rst => rst,
            binary_in => freq_in,
            bcd_out => sig_data
        );

    -- 7-segment decoder
    decoder_0 : bin2seg
        port map (
            rst => rst,
            bcd => sig_bcd,
            seg => seg
        );
    -- Digit select process
    p_digit_select : process (sig_digit) is
    begin   
            case sig_digit is
                when "000" => 
                    sig_bcd <= sig_data(3 downto 0);
                when "001" => 
                    sig_bcd <= sig_data(7 downto 4);
                when "010" => 
                    sig_bcd <= sig_data(11 downto 8);
                when "011" => 
                    sig_bcd <= sig_data(15 downto 12);
                when "100" => 
                    sig_bcd <= sig_data(19 downto 16);
                when "101" => 
                    sig_bcd <= sig_data(23 downto 20);
                when others =>
                    sig_bcd <= "0000";
            end case;
    end process;
    
    -- Anode select process
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "000" =>
                if (mag(0) = '1' and sig_blink = '1') then
                    anode <= b"1111_1111";
                else
                    anode <= b"1111_1110";
                end if;
            when "001" =>
                if (mag(1) = '1' and sig_blink = '1') then
                    anode <= b"1111_1111";
                else
                    anode <= b"1111_1101";
                end if;
            when "010" =>
                if (mag(2) = '1' and sig_blink = '1') then
                    anode <= b"1111_1111";
                else
                    anode <= b"1111_1011";
                end if;
            when "011" =>
                if (mag(3) = '1' and sig_blink = '1') then
                    anode <= b"1111_1111";
                else
                    anode <= b"1111_0111";
                end if;
            when "100" =>
                if (mag(4) = '1' and sig_blink = '1') then
                    anode <= b"1111_1111";
                else
                    anode <= b"1110_1111";
                end if;
            when "101" =>
                if (mag(5) = '1' and sig_blink = '1') then
                    anode <= b"1111_1111";
                else
                    anode <= b"1101_1111";
                end if;
            when "110" =>
                anode <= b"1111_1111";
            when "111" =>
                anode <= b"1111_1111";

            when others =>
                anode <= b"1111_1111";  
        end case;
    end process;

end Behavioral;
