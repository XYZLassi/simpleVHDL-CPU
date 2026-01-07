library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        b : in std_logic_vector(WIDTH - 1 downto 0);
        c : in std_logic_vector(WIDTH - 1 downto 0);
        d : in std_logic_vector(WIDTH - 1 downto 0);
        z : out std_logic_vector(WIDTH - 1 downto 0);
        sel : in std_logic_vector (1 downto 0) 
    );
end entity mux4;

architecture rtl of mux4 is
begin
    process (a,b,c,d,sel)
    begin
        case sel is
            when "00" =>
                z <= a;
            when "01" =>
                z <= b;
            when "10" =>
                z <= c;
            when "11" =>
                z <= d;
            when others  =>
                z <= a;
        end case;
    end process;
end architecture;