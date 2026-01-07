library ieee;
use ieee.std_logic_1164.all;
use std.env.stop; 


entity tb_alu is
end entity tb_alu;

architecture rtl of tb_alu is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    signal a : std_logic_vector(3 downto 0) := "XXXX";
    signal b : std_logic_vector(3 downto 0) := "XXXX";
    
    signal c_out: std_logic := 'X';

    signal s : std_logic_vector(4 downto 0) := "00000";

    signal z : std_logic_vector(3 downto 0) := "XXXX";
begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    tud : entity work.alu
    generic map (
        WIDTH => 4
    )
    port map (
        a => a,
        b => b,
        s => s,
        c_out => c_out,
        z => z
    );

    
    process 
    begin
        wait until reset = '0';

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        s <= "00000";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-Default: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0000";
        s <= "00000";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-Add1: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0001";
        s <= "00000";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-Add2: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0001";
        s <= "00000";
        wait until rising_edge(clk);
        assert z = "0010" report "Alu-Add3: Except value 0010" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0001";
        s <= "00100";
        wait until rising_edge(clk);
        assert z = "0011" report "Alu-Add4: Except value 0011" severity ERROR;

        wait until falling_edge(clk); 
        a <= "1111";
        b <= "0001";
        s <= "00000";
        wait until rising_edge(clk);
        assert z = "0000" and c_out = '1' report "Alu-Add4: Except value 0000 and 1" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        s <= "00001";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-And1: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0000";
        s <= "00001";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-And2: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0001";
        s <= "00001";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-And3: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0001";
        s <= "00001";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-And4: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0010";
        s <= "00010";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-InA1: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0010";
        s <= "00011";
        wait until rising_edge(clk);
        assert z = "0010" report "Alu-InB1: Except value 0110" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        s <= "01100";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-Sub1: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0011";
        b <= "0001";
        s <= "01100";
        wait until rising_edge(clk);
        assert z = "0010" report "Alu-Sub2: Except value 0010" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0001";
        s <= "01100";
        wait until rising_edge(clk);
        assert z = "1111" report "Alu-Sub3: Except value 1111" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        s <= "10100";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-Inc1: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0001";
        s <= "10100";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-Inc2: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0000";
        s <= "10100";
        wait until rising_edge(clk);
        assert z = "0010" report "Alu-Inc3: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "1111";
        b <= "0000";
        s <= "10100";
        wait until rising_edge(clk);
        assert z = "0000" and c_out = '1' report "Alu-Inc4: Except value 0001 and 1" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0000";
        b <= "0000";
        s <= "00100";
        wait until rising_edge(clk);
        assert z = "0001" report "Alu-Adc1: Except value 0001" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0001";
        s <= "00100";
        wait until rising_edge(clk);
        assert z = "0011" report "Alu-Adc2: Except value 0011" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0001";
        b <= "0000";
        s <= "01000";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-Suc1: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        a <= "0010";
        b <= "0001";
        s <= "01000";
        wait until rising_edge(clk);
        assert z = "0000" report "Alu-Suc2: Except value 0000" severity ERROR;

        wait until falling_edge(clk); 
        stop;
        wait;
    end process;

end architecture;