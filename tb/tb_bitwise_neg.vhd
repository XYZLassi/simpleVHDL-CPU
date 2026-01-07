library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_bitwise_neg is
end entity tb_bitwise_neg;

architecture rtl of tb_bitwise_neg is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal a : std_logic_vector(3 downto 0) := "XXXX";
    signal en : std_logic := '0';
    
    signal z : std_logic_vector(3 downto 0) := "XXXX";
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.bitwise_neg
    generic map (
        WIDTH => 4
    )
    port map (
        a => a,
        en => en,
        z => z
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        a <= "0000";
        en <= '0';
        wait until rising_edge(clk);
        assert z = "0000" report "Replicate: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        en <= '1';
        wait until rising_edge(clk);
        assert z = "1111" report "Replicate: Except value 1111" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0100";
        en <= '0';
        wait until rising_edge(clk);
        assert z = "0100" report "Replicate: Except value 0100" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0100";
        en <= '1';
        wait until rising_edge(clk);
        assert z = "1011" report "Replicate: Except value 1011" severity ERROR;

        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;