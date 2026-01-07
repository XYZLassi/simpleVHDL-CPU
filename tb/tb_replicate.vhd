library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_replicate is
end entity tb_replicate;

architecture rtl of tb_replicate is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal a : std_logic := 'X';
    signal z : std_logic_vector(3 downto 0) := "XXXX";
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.replicate
    generic map (
        WIDTH => 4
    )
    port map (
        a => a,
        z => z
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        a <= '0';
        wait until rising_edge(clk);
        assert z = "0000" report "Replicate: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= '1';
        wait until rising_edge(clk);
        assert z = "1111" report "Replicate: Except value 1111" severity ERROR;

        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;