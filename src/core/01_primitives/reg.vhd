library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic (
        WIDTH: natural;
        EDGE: std_logic := '1' 
    );
    port (
        d : in std_logic_vector(WIDTH - 1 downto 0);
        q : out std_logic_vector(WIDTH - 1 downto 0);

        en: in std_logic;
        clk : in std_logic;
        clr: in STD_LOGIC := '0'
    );
end entity reg;

architecture rtl of reg is

begin
    
    process (clk,clr)
    begin
        if clr = '1' then
            q <= (others => '0');
        elsif en = '1' and clk'event and clk = EDGE  then
            q <= d;
        end if;
    end process;

end architecture;