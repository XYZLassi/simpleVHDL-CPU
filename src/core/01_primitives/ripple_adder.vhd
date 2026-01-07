library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        b : in std_logic_vector(WIDTH - 1 downto 0);
        c_in : in std_logic;
        z : out std_logic_vector(WIDTH - 1 downto 0);
        c_out: out std_logic
    );
end entity ripple_adder;

architecture rtl of ripple_adder is
    signal c : std_logic_vector(WIDTH downto 0) := (others => '0') ;
begin
    

    process (a,b,c,c_in)
    begin
        z <= (others => '0'); 
        c <= (others => '0'); 

        c(0) <= c_in;
        for i in 0 to WIDTH-1 loop
            z(i) <= a(i) xor b(i) xor c(i);
            c(i+1) <= (a(i) and b(i)) or (a(i) and c(i)) or (b(i) and c(i)); 
        end loop;
        
        c_out <= c(WIDTH);
    end process;
end architecture;