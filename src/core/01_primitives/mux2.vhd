library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        b : in std_logic_vector(WIDTH - 1 downto 0);
        z : out std_logic_vector(WIDTH - 1 downto 0);
        sel : in std_logic_vector (0 downto 0) 
    );
end entity mux2;

architecture rtl of mux2 is
begin
    process (a,b,sel)
    begin
        case sel is
            when "0" =>
                z <= a;
            when "1" =>
                z <= b;
            when others  =>
                z <= a;
        end case;
    end process;
end architecture;