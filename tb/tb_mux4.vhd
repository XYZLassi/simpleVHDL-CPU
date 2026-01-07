library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_mux4 is
end entity tb_mux4;

architecture rtl of tb_mux4 is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal sel : std_logic_vector(1 downto 0) := "XX";
    signal a : std_logic_vector(3 downto 0) := "0000";
    signal b : std_logic_vector(3 downto 0) := "0001";
    signal c : std_logic_vector(3 downto 0) := "0010";
    signal d : std_logic_vector(3 downto 0) := "0011";
    signal z : std_logic_vector(3 downto 0) := "XXXX";
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.mux4
    generic map (
        WIDTH => 4
    )
    port map (
        a => a,
        b => b,
        c => c,
        d => d,
        z => z,
        sel => sel
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        sel <= "00";
        wait until rising_edge(clk);
        assert z = "0000" report "Mux4: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        sel <= "01";  
        wait until rising_edge(clk);
        assert z = "0001" report "Mux4: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        sel <= "10";  
        wait until rising_edge(clk);
        assert z = "0010" report "Mux4: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        sel <= "11";  
        wait until rising_edge(clk);
        assert z = "0011" report "Mux4: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;