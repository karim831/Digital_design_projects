-- mips 32_bit single_cycle_processor
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mips is  -- mips 32_bit single_cycle_processor  
    port(
        clk,reset,reg_clk_read,reg_clk_write : 
            in std_logic := '0'
    );
end entity;

architecture rtl of mips is
    ----------------------------------------------------------------------
    --                      FETCH_INSTRUCTION                           --
    ----------------------------------------------------------------------
    signal pc_out : std_logic_vector(31 downto 0) := (others => '0');
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --                        NXT_INSTRUCTION                           --
    ----------------------------------------------------------------------
    signal adder1_out,adder2_out : std_logic_vector(31 downto 0);
    signal mux1_out,mux2_out : std_logic_vector(31 downto 0);
    ----------------------------------------------------------------------
    
    
    ----------------------------------------------------------------------


    ----------------------------------------------------------------------
    --                       INST_DEC && REG_FET                        --
    ----------------------------------------------------------------------
    signal inst_out : std_logic_vector(31 downto 0);
    signal mux_out_reg_file1 : std_logic_vector(4 downto 0);
    signal reg_file_out1,reg_file_out2 : std_logic_vector(31 downto 0); 

    signal sign_extend_out : std_logic_vector(31 downto 0);
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    --                   EXECUTE && EVALUTE_MEM_ADD                     --
    ----------------------------------------------------------------------
    signal alu_ctrl_out : std_logic_vector(5 downto 0);
    signal mux_out_alu,alu_out : std_logic_vector(31 downto 0);
    signal alu_zero : std_logic;

    ----------------------------------------------------------------------


    ----------------------------------------------------------------------
    --                       STORE && WRITE_BACK                        --
    ----------------------------------------------------------------------
    signal data_mem_out : std_logic_vector(31 downto 0);
    
    signal mux_out_reg_file2 : std_logic_vector(31 downto 0);
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    --                          MAIN_CONTROL                            --
    ----------------------------------------------------------------------
    
    signal alu_op : std_logic_vector(5 downto 0);
    signal reg_dst,jump,branch ,mem_read,mem_to_reg,mem_write,alu_src,reg_write : std_logic; 
    ----------------------------------------------------------------------

    
    




    begin    

        PC : process(clk,reset)
            begin
                if(reset = '1') then 
                    pc_out <= (others => '0');
                else if(rising_edge(clk)) then
                    pc_out <= mux2_out;
                end if;
                end if;
        end process;


    ----------------------------------------------------------------------
    --                      FETCH_INSTRUCTION                           --
    ----------------------------------------------------------------------

        ADDR_PC_PLUS_4 : entity work.alu(rtl) 
        generic map(
            INPUT_WIDTH => 32
        )
        port map(
            -- inputs
            in1 => pc_out,
            in2 => std_logic_vector(to_unsigned(4,32)),
            control => "000010",
            -- outputs
            alu_result => adder1_out,
            zero => open
        );

        ADD_BRANCH : 
        entity work.alu(rtl) 
        generic map(
            INPUT_WIDTH => 32
        )
        port map(
            -- inputs
            in1 => adder1_out,
            in2 => (sign_extend_out sll 2),
            control => "000010",
            -- outputs
            alu_result => adder2_out,
            zero => open
        );

        MUX_BRCH :
        entity work.mux(rtl)
        generic map(
            WIDTH => 32
        )
        port map(
            -- inputs
            in1 => adder1_out,
            in2 => adder2_out,
            sel => '0',             --(branch and alu_zero),
            -- outputs
            o => mux1_out
        );

        MUX_JUMP :
        entity work.mux(rtl)
        generic map(
            WIDTH => 32
        )
        port map(
            -- inputs
            in1 => mux1_out,
            in2 => (adder1_out(31 downto 28) & (("00" & inst_out(25 downto 0))  sll 2)),
            sel => jump,
            -- outputs
            o => mux2_out
        );

        INST_MEM : entity work.inst_mem(rtl) 
        generic map(
            ADR_WIDTH => 32,
            INSTRUCTION_WIDTH => 32
        )
        port map(
            -- inputs
            read_add => pc_out,
            -- outputs
            inst => inst_out
        );
        
    -----------------------------------------------------------------------------------------


    ----------------------------------------------------------------------
    --                          MAIN_CONTROL                            --
    ----------------------------------------------------------------------
        MAIN_CONTROL : entity work.main_control(rtl) 
        port map(
            op_code => inst_out(31 downto 26),
            ctrls(13) => reg_dst,
            ctrls(12) => jump,
            ctrls(11) => branch,
            ctrls(10) => mem_read,
            ctrls(9)  => mem_to_reg,
            ctrls(8 downto 3) => alu_op,
            ctrls(2) => mem_write,
            ctrls(1) => alu_src,
            ctrls(0) => reg_write
        );


    ------------------------------------------------------------------


    ----------------------------------------------------------------------
    --                          INST_DEC && REG_FET                     --
    ----------------------------------------------------------------------
        REG_DIST_MUX : entity work.mux(rtl) 
        generic map(
            WIDTH => 5
        )
        port map(
            -- inputs
            in1 => inst_out(20 downto 16),
            in2 => inst_out(15 downto 11),
            sel => reg_dst,
            -- outputs
            o => mux_out_reg_file1
        );

        REG_FILE : entity work.reg_file(rtl)
        generic map(
            REG_WIDTH => 32,
            ADR_WIDTH => 5
        )
        port map(
            -- inputs 
            clk_read => reg_clk_read,
            read_reg1 => inst_out(25 downto 21),
            read_reg2 => inst_out(20 downto 16),

            clk_write => reg_clk_write,
            write_reg => mux_out_reg_file1,
            write_data => alu_out,               --mux_out_reg_file2,
            write_en =>  reg_write,
            -- outputs
            read_data1 => reg_file_out1,
            read_data2 => reg_file_out2
        );
        
        SIGN_EXT : entity work.sign_extend(rtl) 
        generic map(
            IMM_WIDTH => 16,
            EX_IMM_WIDTH => 32
        )
        port map(
            -- inputs
            imm_const => inst_out(15 downto 0),
            -- outputs 
            ex_imm_const => sign_extend_out
        );
    ----------------------------------------------------------------------





    ----------------------------------------------------------------------
    --                          EXCUATION && EVALUATE_MEM               --
    ----------------------------------------------------------------------
    MUX_ALU_SRC : entity work.mux(rtl) 
    generic map(
        WIDTH => 32
    )
    port map(
        -- inputs
        in1 => reg_file_out2,
        in2 => sign_extend_out,
        sel => alu_src,
        -- outputs
        o => mux_out_alu
    );
    ------------------------------------
    --          ALU CONTROL           --
    ------------------------------------
    ALU_CTR : entity work.alu_cont(rtl)
    port map(
        -- inputs 
        alu_op => alu_op,
        r_func => inst_out(5 downto 0),
        -- outputs
        alu_ctr => alu_ctrl_out 
    );
    ------------------------------------
    ALU_OPERATIONS : entity work.alu(rtl) 
    generic map(
        INPUT_WIDTH => 32
    )
    port map(
        -- inputs
        in1 => reg_file_out1,
        in2 => mux_out_alu,
        control => alu_ctrl_out,
        -- outputs
        alu_result => alu_out,
        zero => alu_zero
    );
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    --                       STORE && WRITE_BACK                        --
    ----------------------------------------------------------------------
    -- DATA_MEM : entity work.data_mem(rtl)
    -- generic map(
    --     ADR_WIDTH => 32,    
    --     DATA_WIDTH => 32
    -- )
    -- port map(
    --     -- inputs
    --     addresse => alu_out,
    --     write_data => reg_file_out2,
    --     read_en => mem_read,
    --     write_en => mem_write,
    --     -- outputs
    --     read_data => data_mem_out
    -- );

    -- MUX_TO_REGFILE : entity work.mux(rtl)
    -- generic map(
    --     WIDTH => 32
    -- )
    -- port map(
    --     -- inputs
    --     in1 => data_mem_out,
    --     in2 => alu_out,
    --     sel => mem_to_reg,
    --     -- outputs
    --     o => mux_out_reg_file2
    -- );
    ----------------------------------------------------------------------



end architecture;