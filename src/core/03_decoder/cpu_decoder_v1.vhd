library ieee;
use ieee.std_logic_1164.all;

entity cpu_decoder_v1 is
    generic (
        IR_WIDTH:natural
    );
    port (
        clk: in std_logic;
        reset: in std_logic;
        ir: in std_logic_vector(IR_WIDTH - 1 downto 0);

        carry_in : in std_logic;

        ram_wren : out std_logic;

        alu_s: out std_logic_vector(4 downto 0);
        alu_logic_s: out std_logic_vector(1 downto 0);

        pc_enable: out std_logic;
        pc_load_imd : out std_logic;
        cpu_stop: out std_logic;

        status_en: out std_logic;
        ir_en: out std_logic;

        ra_en: out std_logic;
        rb_en: out std_logic;
        rc_en: out std_logic;
        rd_en: out std_logic;

        sel_alu_a : out std_logic_vector(1 downto 0);
        sel_alu_b : out std_logic_vector(1 downto 0);
        sel_rom_addr: out std_logic_vector(0 downto 0);
        sel_ram_addr : out std_logic_vector(1 downto 0)
    );
end entity cpu_decoder_v1;

architecture rtl of cpu_decoder_v1 is
    signal op : std_logic_vector(3 downto 0);

    signal dst : std_logic_vector(1 downto 0);
    signal src : std_logic_vector(1 downto 0);

    signal current_state : std_logic_vector(0 downto 0);
    signal next_state : std_logic_vector(0 downto 0);

    constant OP_NOP : std_logic_vector := "0000";
    constant OP_LD : std_logic_vector := "0001";
    constant OP_MV : std_logic_vector := "0010";

    constant OP_ADD : std_logic_vector := "0011";
    constant OP_ADC : std_logic_vector := "0100";
    constant OP_SUB : std_logic_vector := "0101";
    constant OP_SUC : std_logic_vector := "0110";

    constant OP_NEG : std_logic_vector := "0111";
    constant OP_AND : std_logic_vector := "1000";
    constant OP_OR : std_logic_vector := "1001";
    constant OP_XOR : std_logic_vector := "1010";

    constant OP_ST : std_logic_vector := "1011";

    constant OP_RJMP : std_logic_vector := "1101";
    constant OP_JMP : std_logic_vector := "1110";

    constant OP_HLT : std_logic_vector := "1111";

    constant DST_SRC_RA : STD_LOGIC_VECTOR := "00";
    constant DST_SRC_RB : STD_LOGIC_VECTOR := "01";
    constant DST_SRC_RC : STD_LOGIC_VECTOR := "10";
    constant DST_SRC_RD : STD_LOGIC_VECTOR := "11";

    constant OP_B_IMD :  STD_LOGIC_VECTOR := "00";
    constant OP_B_MEM :  STD_LOGIC_VECTOR := "01";
    constant OP_B_RA :  STD_LOGIC_VECTOR := "10";
    constant OP_B_RB :  STD_LOGIC_VECTOR := "11";

    constant ALU_ADD : std_logic_vector := "00000";
    constant ALU_ADD_INC : std_logic_vector := "00100";
    constant ALU_SUB : std_logic_vector := "01100";
    constant ALU_SUB_DEC : std_logic_vector := "01000";
    constant ALU_LOGIC : std_logic_vector := "00001";
    constant ALU_INPUT_A : std_logic_vector := "00010";
    constant ALU_INPUT_B : std_logic_vector := "00011";
    constant ALU_INC : std_logic_vector := "10100";

    constant ALU_LOGIC_NOT_A : std_logic_vector := "00";
    constant ALU_LOGIC_AND : std_logic_vector := "01";
    constant ALU_LOGIC_OR : std_logic_vector := "10";
    constant ALU_LOGIC_XOR : std_logic_vector := "11";

    constant MUX_ALU_A_RA : std_logic_vector := "00";
    constant MUX_ALU_A_RB : std_logic_vector := "01";
    constant MUX_ALU_A_RC : std_logic_vector := "10";
    constant MUX_ALU_A_RD : std_logic_vector := "11";

    constant MUX_ALU_B_IMD : std_logic_vector := "00";
    constant MUX_ALU_B_MEM : std_logic_vector := "01";
    constant MUX_ALU_B_RA : std_logic_vector := "10";
    constant MUX_ALU_B_RB : std_logic_vector := "11";

    constant MUX_ROM_ADDR_PC : std_logic_vector := "0";
    constant MUX_ROM_ADDR_ALU : std_logic_vector := "1";

    constant MUX_RAM_ADDR_ZERO : std_logic_vector := "00";
    constant MUX_RAM_ADDR_IMD : std_logic_vector := "01";
    constant MUX_RAM_ADDR_RD : std_logic_vector := "10";

begin
    process (clk,reset)
    begin
        if reset = '1' then
            current_state <= (others => '0') ;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process (reset,ir, op, current_state)
    variable loadMemOp : std_logic := '0';
    begin

        status_en <= '0';
        ir_en <= '0';

        next_state <= "0";

        ra_en <= '0';
        rb_en <= '0';
        rc_en <= '0';
        rd_en <= '0';

        op <= ir(IR_WIDTH - 1 downto IR_WIDTH - 4);
        dst <= ir(IR_WIDTH - 5 downto IR_WIDTH - 6);
        src <= ir(IR_WIDTH - 7 downto IR_WIDTH - 8);

        ram_wren <= '0';

        pc_enable <= '1';
        pc_load_imd <= '0';
        cpu_stop <= '0';

        alu_s <= ALU_ADD;
        alu_logic_s <= ALU_LOGIC_NOT_A;

        sel_alu_a <= MUX_ALU_A_RA;
        sel_alu_b <= MUX_ALU_B_IMD;

        sel_rom_addr <= MUX_ROM_ADDR_PC;
        sel_ram_addr <= MUX_RAM_ADDR_ZERO;



        if reset = '1' then
        elsif op = OP_NOP then   
        elsif op = OP_LD then
            alu_s <= ALU_INPUT_B;
            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
            
            loadMemOp := '1';
        elsif op = OP_MV then
            alu_s <= ALU_INPUT_A;

            sel_alu_a <= MUX_ALU_A_RA when src = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when src = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when src = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when src = DST_SRC_RD;

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_ADD then
            alu_s <= ALU_ADD;
            status_en <= '1';

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;

            sel_alu_b <= MUX_ALU_B_IMD when src = OP_B_IMD;
            sel_alu_b <= MUX_ALU_B_RA when src = OP_B_RA;
            sel_alu_b <= MUX_ALU_B_RB when src = OP_B_RB;
            loadMemOp := '1';

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_ADC then
            alu_s <= ALU_ADD_INC when carry_in else ALU_ADD;
            status_en <= '1';

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;

            sel_alu_b <= MUX_ALU_B_IMD when src = OP_B_IMD;
            sel_alu_b <= MUX_ALU_B_RA when src = OP_B_RA;
            sel_alu_b <= MUX_ALU_B_RB when src = OP_B_RB;
            loadMemOp := '1';

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_SUB then
            alu_s <= ALU_SUB;
            status_en <= '1';

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;

            sel_alu_b <= MUX_ALU_B_IMD when src = OP_B_IMD;
            sel_alu_b <= MUX_ALU_B_RA when src = OP_B_RA;
            sel_alu_b <= MUX_ALU_B_RB when src = OP_B_RB;
            loadMemOp := '1';

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_SUC then
            alu_s <= ALU_SUB_DEC when carry_in else ALU_SUB;
            status_en <= '1';

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;

            sel_alu_b <= MUX_ALU_B_IMD when src = OP_B_IMD;
            sel_alu_b <= MUX_ALU_B_RA when src = OP_B_RA;
            sel_alu_b <= MUX_ALU_B_RB when src = OP_B_RB;
            loadMemOp := '1';

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_NEG then
            alu_s <= ALU_LOGIC;
            alu_logic_s <= ALU_LOGIC_NOT_A;
            status_en <= '1';

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_AND or op = OP_OR or op = OP_XOR then
            alu_s <= ALU_LOGIC;
            alu_logic_s <= ALU_LOGIC_AND when op = OP_AND;
            alu_logic_s <= ALU_LOGIC_OR when op = OP_OR;
            alu_logic_s <= ALU_LOGIC_XOR when op = OP_XOR;
            status_en <= '1';

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;

            sel_alu_b <= MUX_ALU_B_IMD when src = OP_B_IMD;
            sel_alu_b <= MUX_ALU_B_RA when src = OP_B_RA;
            sel_alu_b <= MUX_ALU_B_RB when src = OP_B_RB;
            loadMemOp := '1';

            ra_en <= '1'  when dst = DST_SRC_RA;
            rb_en <= '1'  when dst = DST_SRC_RB;
            rc_en <= '1'  when dst = DST_SRC_RC;
            rd_en <= '1'  when dst = DST_SRC_RD;
        elsif op = OP_ST then
            ram_wren <= '1';
            sel_ram_addr <= MUX_RAM_ADDR_IMD;

            sel_alu_a <= MUX_ALU_A_RA when dst = DST_SRC_RA;
            sel_alu_a <= MUX_ALU_A_RB when dst = DST_SRC_RB;
            sel_alu_a <= MUX_ALU_A_RC when dst = DST_SRC_RC;
            sel_alu_a <= MUX_ALU_A_RD when dst = DST_SRC_RD;
        elsif op = OP_HLT then  
            cpu_stop <= '1';
            status_en <= '1';
        end if;

        if loadMemOp = '1' and src = OP_B_MEM then
            pc_enable <= '0';
            next_state <= "1";
            sel_ram_addr <= MUX_RAM_ADDR_IMD;
            sel_alu_b <= MUX_ALU_B_MEM;

            if(current_state = "1") then
                pc_enable <= '1';
                next_state <= "0";

                sel_alu_b <= MUX_ALU_B_MEM;
            end if;
        end if;
    end process;

end architecture;