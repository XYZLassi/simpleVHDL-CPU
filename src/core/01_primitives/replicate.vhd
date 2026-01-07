library ieee;
use ieee.std_logic_1164.all;

entity replicate is
    generic (
        WIDTH: natural
    );
    port (
        a : in std_logic;
        z : out std_logic_vector(WIDTH - 1 downto 0)
    );
end entity replicate;

architecture rtl of replicate is
begin
    process (a)
    begin
       z <= (others => a);
    end process;
end architecture;