library ieee;
use ieee.std_logic_1164.all;
entity sign_extend_tb is
end entity;

architecture rtl of sign_extend_tb is
    -- constants :
    constant IMM_WIDTH_TB : integer := 16;
    constant EX_IMM_WIDTH_TB : integer := 32;
    -- inputs :
    signal imm_const_tb : std_logic_vector(IMM_WIDTH_TB-1 downto 0) := (others => '0');
    -- outputs :
    signal ex_imm_const_tb :std_logic_vector(EX_IMM_WIDTH_TB-1 downto 0);
    begin
    -- porting :
        sign_ex : entity work.sign_extend(rtl)
        generic map(
            IMM_WIDTH => IMM_WIDTH_TB,
            EX_IMM_WIDTH => EX_IMM_WIDTH_TB 
        )    
        port map(
            imm_const => imm_const_tb,
            ex_imm_const => ex_imm_const_tb
        );
    -- stimulus process :
        process is
            begin 
                wait for 100 ps;
                imm_const_tb <= x"5FFF";
                wait for 100 ps;
                imm_const_tb <= x"A000";
                wait;
            end process;
end architecture;