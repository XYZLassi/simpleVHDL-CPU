library ieee;
use ieee.std_logic_1164.all;

entity cpu_v1 is
    port (
        clk : in std_logic;
        reset : in std_logic;

        rom_addr : out std_logic_vector(7 downto 0);
        rom_data : in std_logic_vector(15 downto 0);

        ram_wren : out std_logic;
        ram_addr : out std_logic_vector(7 downto 0);
        ram_data_out : in std_logic_vector(7 downto 0);
        ram_data_in : out std_logic_vector(7 downto 0);

        cpu_halt : out std_logic
    );
end entity cpu_v1;

architecture rtl of cpu_v1 is
    constant ROM_WIDTH : natural := 8;
    constant RAM_WIDTH : natural := 8;
    constant DATA_WIDTH : natural := 8;
    constant IR_WIDTH: natural := 16;

    signal pc : std_logic_vector(ROM_WIDTH -1 downto 0) ;

    signal ir_tmp : std_logic_vector(IR_WIDTH -1 downto 0);
    signal ir : std_logic_vector(IR_WIDTH -1 downto 0);

    signal imd : std_logic_vector(DATA_WIDTH -1 downto 0);
    signal imd_mem_addr : std_logic_vector(RAM_WIDTH -1 downto 0);
    
    signal status: std_logic_vector(DATA_WIDTH -1 downto 0) ;

    signal alu_a : std_logic_vector(DATA_WIDTH -1 downto 0) ;
    signal alu_b : std_logic_vector(DATA_WIDTH -1 downto 0) ;
    signal alu_z : std_logic_vector(DATA_WIDTH -1 downto 0) ;
    signal alu_s : std_logic_vector(4 downto 0);
    signal alu_logic_s : std_logic_vector(1 downto 0);

    signal ra : std_logic_vector(DATA_WIDTH -1 downto 0) ;
    signal rb : std_logic_vector(DATA_WIDTH -1 downto 0) ;
    signal rc : std_logic_vector(DATA_WIDTH -1 downto 0) ;
    signal rd : std_logic_vector(DATA_WIDTH -1 downto 0) ;


    signal alu_carry : std_logic;

    signal pc_enable: std_logic;
    signal pc_load_imd : std_logic;
    signal cpu_stop : std_logic;

    signal status_en :std_logic;
    signal ir_en : std_logic;

    signal ra_en : std_logic;
    signal rb_en : std_logic;
    signal rc_en : std_logic;
    signal rd_en : std_logic;


    signal sel_alu_a : std_logic_vector(1 downto 0);
    signal sel_alu_b : std_logic_vector(1 downto 0);
    signal sel_rom_addr : std_logic_vector(0 downto 0);
    signal sel_ram_addr : std_logic_vector(1 downto 0);
begin

    imd <= ir(DATA_WIDTH -1 downto 0);
    imd_mem_addr <= ir(RAM_WIDTH -1 downto 0);

    ram_data_in <= alu_a;

    cpu_halt <= status(7);

    decoder: entity work.cpu_decoder_v1 
    generic map (
        IR_WIDTH => IR_WIDTH
    )
    port map (
        reset => reset or status(7),
        clk => clk,
        ir => ir,

        carry_in => status(0),

        ram_wren => ram_wren,

        pc_enable => pc_enable,
        pc_load_imd => pc_load_imd,
        cpu_stop => cpu_stop,

        status_en => status_en,
        ir_en => ir_en,
        
        ra_en => ra_en,
        rb_en => rb_en,
        rc_en => rc_en,
        rd_en => rd_en,
        
        alu_s => alu_s,
        alu_logic_s => alu_logic_s,

        sel_alu_a => sel_alu_a,
        sel_alu_b => sel_alu_b,
        sel_rom_addr => sel_rom_addr,
        sel_ram_addr => sel_ram_addr
    );

    reg_ir: entity work.reg
    generic map (
        WIDTH => 16
    )
    port map(
        d => rom_data,
        q => ir_tmp,
        clk => clk,
        clr => reset,
        en => ir_en
    );

    reg_ra: entity work.reg
    generic map (
        WIDTH => 8
    )
    port map(
        d => alu_z,
        q => ra,
        clk => clk,
        clr => reset,
        en => ra_en
    );

    reg_rb: entity work.reg
    generic map (
        WIDTH => 8
    )
    port map(
        d => alu_z,
        q => rb,
        clk => clk,
        clr => reset,
        en => rb_en
    );

    reg_rc: entity work.reg
    generic map (
        WIDTH => 8
    )
    port map(
        d => alu_z,
        q => rc,
        clk => clk,
        clr => reset,
        en => rc_en
    );

    reg_rd: entity work.reg
    generic map (
        WIDTH => 8
    )
    port map(
        d => alu_z,
        q => rd,
        clk => clk,
        clr => reset,
        en => rd_en
    );

    reg_pc: entity work.pc
    generic map(
        WIDTH => DATA_WIDTH
    )
    port map (
        imd => imd,
        load_imd => pc_load_imd,
        en => not reset and not cpu_halt and pc_enable,
        pc => pc,
        clk => clk,
        clr => reset
    );

    reg_status : entity work.reg
    generic map (
        WIDTH => 8
    )
    port map(
        d =>(
            0 => alu_carry,
            7 => cpu_stop,
            others => '0'
        ),
        q =>status,
        en => status_en,
        clk => clk,
        clr => reset
    );

    alu : entity work.alu
    generic map(
        WIDTH => DATA_WIDTH
    )
    port map (
        a => alu_a,
        b => alu_b,
        z => alu_z,
        s => alu_s,
        logic_s => alu_logic_s,
        c_out => alu_carry
    );

    mux_ir : entity work.mux2
    generic map (
        WIDTH => IR_WIDTH
    )
    port map(
        a => rom_data,
        b => ir_tmp,
        z => ir,
        sel => "0"

    );

    mux_alu_a : entity work.mux4
    generic map (
        WIDTH => DATA_WIDTH
    )
    port map (
        a => ra,
        b => rb,
        c => rc,
        d => rd,
        z => alu_a,
        sel => sel_alu_a
    );

    mux_alu_b : entity work.mux4
    generic map (
        WIDTH => DATA_WIDTH
    )
    port map (
        a => imd,
        b => ram_data_out,
        c => ra,
        d => rb,
        z => alu_b,
        sel => sel_alu_b
    );

    mux_rom_addr : entity work.mux2
    generic map(
        WIDTH => DATA_WIDTH
    )
    port map (
        a => pc,
        b => alu_z,
        z => rom_addr,
        sel => sel_rom_addr
    ); 

    mux_ram_addr : entity work.mux4
    generic map(
        WIDTH => RAM_WIDTH
    )
    port map(
        a => (others => '0'),
        b => imd_mem_addr,
        c => rd,
        d => (others => '0'),
        z => ram_addr,
        sel => sel_ram_addr
    );

end architecture;