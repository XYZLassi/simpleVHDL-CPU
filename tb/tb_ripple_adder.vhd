library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_ripple_adder is
end entity tb_ripple_adder;

architecture rtl of tb_ripple_adder is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal a : std_logic_vector(3 downto 0) := "XXXX";
    signal b : std_logic_vector(3 downto 0) := "XXXX";
    
    signal c_in: std_logic := 'X';
    signal c_out: std_logic := 'X';

    signal z : std_logic_vector(3 downto 0) := "XXXX";
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.ripple_adder
    generic map (
        WIDTH => 4
    )
    port map (
        a => a,
        b => b,
        c_in => c_in,
        c_out => c_out,
        z => z
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        c_in <= '0';
        wait until rising_edge(clk);
        assert z = "0000" report "Ripple Adder: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0001";
        c_in <= '0';
        wait until rising_edge(clk);
        assert z = "0001" and c_out = '0' report "Ripple Adder: Except value 0001 and 0" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        c_in <= '1';
        wait until rising_edge(clk);
        assert z = "0001" and c_out = '0' report "Ripple Adder: Except value 0001 and 0" severity ERROR;


        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0001";
        c_in <= '0';
        wait until rising_edge(clk);
        assert z = "0010" and c_out = '0' report "Ripple Adder: Except value 0010 and 0" severity ERROR;

        

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0001";
        c_in <= '1';
        wait until rising_edge(clk);
        assert z = "0011" and c_out = '0' report "Ripple Adder: Except value 0011 and 0" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "1111";
        c_in <= '1';
        wait until rising_edge(clk);
        assert z = "0000" and c_out = '1' report "Ripple Adder: Except value 0000 and 1" severity ERROR;


        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;