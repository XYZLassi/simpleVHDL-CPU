library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_pc is
end entity tb_pc;

architecture rtl of tb_pc is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal pc : std_logic_vector(3 downto 0);

begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.pc
    generic map (
        WIDTH => 4
    )
    port map(
        pc => pc,
        clk => clk,
        clr => reset
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        wait until rising_edge(clk);
        assert pc = "0001" report "PC-Inc1: Except value 0001" severity ERROR;


        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;