library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( clk  : in  STD_LOGIC;
           btnc : in  STD_LOGIC;
           btnu : in  STD_LOGIC;
           btnd : in  STD_LOGIC;
           btnl : in  STD_LOGIC;
           btnr : in  STD_LOGIC;
           sw   : in  STD_LOGIC_VECTOR (0 downto 0);
           led  : out STD_LOGIC_VECTOR (3 downto 0);
           ja   : out STD_LOGIC_VECTOR (3 downto 1);
           seg  : out STD_LOGIC_VECTOR (6 downto 0);
           an   : out STD_LOGIC_VECTOR (7 downto 0);
           dp   : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

    component debounce is
    Port(
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        btn_in      : in  STD_LOGIC;
        btn_state   : out STD_LOGIC;
        btn_press   : out STD_LOGIC);
    end component;
    
    component triangle_top is
    Port(
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        phase_step  : in  STD_LOGIC_VECTOR(31 downto 0);
        pwm_out    : out STD_LOGIC);
    end component;
    
    component sawtooth_top is
    Port(
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        phase_shift     : in  STD_LOGIC_VECTOR(31 downto 0);
        output_Saw      : out STD_LOGIC);
    end component;
    
    component square_top is
    Port(
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        en          : in  STD_LOGIC;
        freq        : in  STD_LOGIC_VECTOR(19 downto 0);
        square_out  : out STD_LOGIC);
    end component;
    
    component display_controller is
    Port(
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        change      : in  STD_LOGIC;
        freq_in     : in  STD_LOGIC_VECTOR(19 downto 0);
        mag         : in  STD_LOGIC_VECTOR(5 downto 0);
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        anode       : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component shiftGen is
    Port(
        clk         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        update_tick : in STD_LOGIC;
        freqIn      : in STD_LOGIC_VECTOR(19 downto 0);
        phaseShift  : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component freq_select is
    Port(
        mag_up       : in  STD_LOGIC;
        mag_down     : in  STD_LOGIC;
        freq_up      : in  STD_LOGIC;
        freq_down    : in  STD_LOGIC;
        freq_change  : in  STD_LOGIC;
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        update_tick  : out STD_LOGIC;
        freq         : out STD_LOGIC_VECTOR (19 downto 0);
        freq_comp    : out STD_LOGIC_VECTOR (19 downto 0);
        mag          : out STD_LOGIC_VECTOR (5 downto 0));
    end component;
    
    signal sig_freq         : std_logic_vector(19 downto 0);
    signal sig_freq_c       : std_logic_vector(19 downto 0);
    signal sig_phase_shift  : std_logic_vector(31 downto 0);
    signal sig_mag          : std_logic_vector(5 downto 0);
    signal sig_update       : std_logic;
    signal sig_btnu         : std_logic;
    signal sig_btnd         : std_logic;
    signal sig_btnl         : std_logic;
    signal sig_btnr         : std_logic;
begin
    
    debounce_0 : debounce
    port map(
        clk         => clk,
        rst         => btnc,
        btn_in      => btnu,
        btn_state   => led(0),
        btn_press   => sig_btnu
    );
    
    debounce_1 : debounce
    port map(
        clk         => clk,
        rst         => btnc,
        btn_in      => btnd,
        btn_state   => led(1),
        btn_press   => sig_btnd
    );
    
    debounce_2 : debounce
    port map(
        clk         => clk,
        rst         => btnc,
        btn_in      => btnl,
        btn_state   => led(2),
        btn_press   => sig_btnl
    );
    
    debounce_3 : debounce
    port map(
        clk         => clk,
        rst         => btnc,
        btn_in      => btnr,
        btn_state   => led(3),
        btn_press   => sig_btnr
    );
    
    triangle_0 : triangle_top
    port map(
        clk         => clk,
        rst         => btnc,
        phase_step  => sig_phase_shift,
        pwm_out    => ja(1)
    );
    
    saw_0 : sawtooth_top
    port map(
        clk             => clk,
        rst             => btnc,
        phase_shift     => sig_phase_shift,
        output_Saw      => ja(3)
    );
    
    square_0 : square_top
    port map(
        clk         => clk,
        rst         => btnc,
        en          => sig_update,
        freq        => sig_freq_c,
        square_out  => ja(2)
    );
    
    display_0 : display_controller
    port map(
        clk     => clk,
        rst     => btnc,
        change  => sw(0),
        freq_in => sig_freq,
        mag     => sig_mag,
        seg     => seg,
        anode   => an
    );
    dp <= '1';
    
    freq_to_phase_0 : shiftGen
    port map(
        clk         => clk,
        rst         => btnc,
        update_tick => sig_update,
        freqIn      => sig_freq_c
    );
    
    freq_0 : freq_select
    port map(
        mag_up      => sig_btnl,
        mag_down    => sig_btnr,
        freq_up     => sig_btnu,
        freq_down   => sig_btnd,
        freq_change => sw(0),
        clk         => clk,
        rst         => btnc,
        update_tick => sig_update,
        freq        => sig_freq,
        freq_comp   => sig_freq_c,
        mag         => sig_mag
    );

end Behavioral;
