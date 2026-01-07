library ieee;
use ieee.std_logic_1164.all;

entity bitwise_and is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        b : in std_logic_vector(WIDTH - 1 downto 0);
        z : out std_logic_vector(WIDTH - 1 downto 0)
    );
end entity bitwise_and;

architecture rtl of bitwise_and is
begin
    process (a,b)
    begin
        z <= a and b;
    end process;
end architecture;