library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        b : in std_logic_vector(WIDTH - 1 downto 0);

        s: in std_logic_vector(4 downto 0);
        logic_s: in std_logic_vector(1 downto 0);

        z : out std_logic_vector(WIDTH - 1 downto 0);
        c_out: out std_logic
    );
end entity alu;

architecture rtl of alu is
    signal  replicate_z : std_logic_vector(WIDTH -1 downto 0);
    signal  bitwise_not_z : std_logic_vector(WIDTH -1 downto 0);
    signal  bitwise_and_z : std_logic_vector(WIDTH -1 downto 0);
    signal  logic_alu_z : std_logic_vector(WIDTH -1 downto 0);
    signal  ripple_adder_z : std_logic_vector(WIDTH -1 downto 0);
begin
    replicate : entity work.replicate
    generic map (
        WIDTH => WIDTH
    )
    port map (
        a => not s(4),
        z => replicate_z
    );

    bitwise_not : entity work.bitwise_neg
    generic map (
        WIDTH=> WIDTH
    )
    port map (
      a => b,
      z => bitwise_not_z,
      en => s(3)  
    );

    bitwise_and_1 : entity work.bitwise_and
    generic map (
        WIDTH=> WIDTH
    )
    port map (
        a => replicate_z,
        b => bitwise_not_z,
        z => bitwise_and_z
    );

    adder : entity work.ripple_adder
    generic map (
        WIDTH=> WIDTH
    )
    port map (
        a => a,
        b => bitwise_and_z,
        z => ripple_adder_z,
        c_in => s(2),
        c_out => c_out
    );

    logic_alu : entity work.logic_alu
    generic map (
        WIDTH=> WIDTH
    )
    port map (
        a => a,
        b => b,
        s => logic_s,
        z => logic_alu_z
    );

    mux : entity work.mux4
    generic map (
        WIDTH=> WIDTH
    )
    port map (
        a => ripple_adder_z,
        b => logic_alu_z,
        c => a,
        d => b,
        z => z,
        sel => s(1 downto 0)
        
    );

end architecture;