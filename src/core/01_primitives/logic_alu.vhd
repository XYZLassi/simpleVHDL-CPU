library ieee;
use ieee.std_logic_1164.all;

entity logic_alu is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        b : in std_logic_vector(WIDTH - 1 downto 0);
        s: in std_logic_vector(1 downto 0);

        z : out std_logic_vector(WIDTH - 1 downto 0)
    );
end entity logic_alu;

architecture rtl of logic_alu is
begin
    process (a,b,s)
    begin
        case s is
            when "00" =>
                z <=  not a ;
            when "01" =>
                z <= a and b;    
            when "10" =>
                z <= a or b; 
            when "11" =>
                z <= a xor b;
            when others =>
                z <= (others => '0');
        end case;
    end process;

end architecture;