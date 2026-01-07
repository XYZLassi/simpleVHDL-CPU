library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.env.stop; 


entity tb_cpu_v1 is
end entity tb_cpu_v1;

architecture rtl of tb_cpu_v1 is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal cpu_halt : std_logic;

    signal rom_addr : std_logic_vector(7 downto 0) :=  (others => '0') ;
    signal rom_data : std_logic_vector(15 downto 0) :=  (others => '0');
    
    signal ram_wren : std_logic;
    signal ram_addr : std_logic_vector(7 downto 0) :=(others => '0');
    signal ram_data_in : std_logic_vector(7 downto 0) :=(others => '0');
    signal ram_data_out : std_logic_vector(7 downto 0) :=(others => '0');

    type DATA_ROM_TABLE is array(0 to ((2**8) -1) ) of std_logic_vector (15 downto 0);
    type DATA_RAM_TABLE is array(0 to ((2**8) -1) ) of std_logic_vector (7 downto 0);

    signal ROM : DATA_ROM_TABLE := (
        "0001010000000010", -- LD rb 0x02
        "0010100100000010", -- MV rc rb
        "0001110000000011", -- LDI rd 0x03
        "0011110000000010", -- ADD rd, 0x02
        "0101110000001000", -- SUB rd, 0x08
        "0111110000000000", -- NEG rd 
        "0011110000000001", -- ADD rd, 0x01
        "1011110000000001", -- ST rd, 0x01
        "0001000100000001", -- LD ra [0x01]
        "1111000000000000", -- HLT
        others => "0000000000000000" 
    );

    signal RAM : DATA_RAM_TABLE :=(
        others => "00000000"
    );

begin

    clk <= not clk after 1 ns;
    reset <= '1', '0' after 5 ns;

    process (clk)   
    begin
        if rising_edge(clk) then
            rom_data <= ROM(CONV_INTEGER(rom_addr));
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if ram_wren = '1' then 
                RAM(CONV_INTEGER(ram_addr)) <= ram_data_in;
                ram_data_out <= (others => 'X'); 
            else
                ram_data_out <= RAM(CONV_INTEGER(ram_addr));
            end if;
        end if;    
    end process;

    tud : entity work.cpu_v1
    port map (
       reset => reset,
       clk => clk,
       cpu_halt => cpu_halt,
       rom_addr => rom_addr,
       rom_data => rom_data,
       ram_wren => ram_wren,
       ram_addr => ram_addr,
       ram_data_in => ram_data_in,
       ram_data_out => ram_data_out
    );

    
    process 
    begin
        wait until reset = '0';
        wait until cpu_halt;
        
        stop;
        wait;
    end process;

end architecture;