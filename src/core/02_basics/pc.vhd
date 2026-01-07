library ieee;
use ieee.std_logic_1164.all;

entity pc is
    generic (
        WIDTH: natural
    );
    port (
        imd: in std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
        pc : out std_logic_vector(WIDTH - 1 downto 0);

        en: in std_logic := '1';

        inc_2: in std_logic := '0';
        load_imd: in std_logic := '0';

        clk : in std_logic;
        clr: in STD_LOGIC := '0'
    );
end entity pc;

architecture rtl of pc is
    signal pc_input :  std_logic_vector(WIDTH - 1 downto 0);
    signal pc_pre :  std_logic_vector(WIDTH - 1 downto 0);
begin
    
    mux : entity work.mux2
    generic map(
        WIDTH => WIDTH
    )
    port map(
        a => pc_pre,
        b => imd,
        z => pc_input,
        sel => (0 => load_imd)
    );

    reg_pc : entity work.reg
    generic map (
        WIDTH => WIDTH,
        EDGE => '0'
    )
    port map(
        d => pc_input,
        q => pc,
        clk => clk,
        en => en,
        clr => clr
    );

    adder : entity work.ripple_adder
    generic map(
        WIDTH => WIDTH
    )
    port map(
        a=>pc,
        b=>( 0 => '1', others => '0'),
        c_in=>inc_2,
        z => pc_pre
    );

end architecture;