library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_reg is
end entity tb_reg;

architecture rtl of tb_reg is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';


    signal d : std_logic_vector(3 downto 0) := "0000";
    signal q : std_logic_vector(3 downto 0) := "XXXX";

    signal en : std_logic := '0';
    signal clr : std_logic := '0';
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.reg
    generic map (
        WIDTH => 4
    )
    port map (
        d =>d,
        q => q,
        en => en,
        clr => reset or clr,
        clk => clk
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        d <= "0001";
        en <= '1';
        wait until rising_edge(clk);
        wait until falling_edge(clk); 
        assert q = "0001" report "Reg1: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        d <= "0010";
        en <= '0';
        wait until rising_edge(clk);
        wait until falling_edge(clk); 
        assert q = "0001" report "Reg2: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        d <= "0010";
        en <= '1';
        clr <= '1';
        
        wait until rising_edge(clk);
        assert q = "0000" report "Reg3: Except value 0000" severity ERROR;
        wait until falling_edge(clk); 

        wait until rising_edge(clk);
        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;