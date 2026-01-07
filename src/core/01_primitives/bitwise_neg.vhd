library ieee;
use ieee.std_logic_1164.all;

entity bitwise_neg is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic_vector(WIDTH - 1 downto 0);
        z : out std_logic_vector(WIDTH - 1 downto 0);
        en : in std_logic
    );
end entity bitwise_neg;

architecture rtl of bitwise_neg is
begin
    process (a,en)
    begin
        z <= a xor en;
    end process;
end architecture;