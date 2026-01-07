library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_mux2 is
end entity tb_mux2;

architecture rtl of tb_mux2 is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal sel : std_logic_vector(0 downto 0) := "0";
    signal a : std_logic_vector(3 downto 0) := "0000";
    signal b : std_logic_vector(3 downto 0) := "0001";
    signal z : std_logic_vector(3 downto 0) := "XXXX";
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.mux2
    generic map (
        WIDTH => 4
    )
    port map (
        a => a,
        b => b,
        z => z,
        sel => sel
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        sel <= "0";
        wait until rising_edge(clk);
        assert z = "0000" report "Mux2: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        sel <= "1";  
        wait until rising_edge(clk);
        assert z = "0001" report "Mux2: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;