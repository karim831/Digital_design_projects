library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity inst_mem_tb is
end entity;

architecture rtl of inst_mem_tb is 
    -- constants :
    constant ADR_WIDTH_TB,INSTRUCTION_WIDTH_TB : integer := 32;
    -- inputs :
    signal read_add_tb : std_logic_vector(ADR_WIDTH_TB-1 downto 0) := (others => '0');
    -- outputs :
    signal inst_tb :  std_logic_vector(INSTRUCTION_WIDTH_TB-1 downto 0); 
    begin
    -- porting :
    INST_MEM : entity work.inst_mem(rtl) 
    generic map(
        ADR_WIDTH => ADR_WIDTH_TB,
        INSTRUCTION_WIDTH => INSTRUCTION_WIDTH_TB
    )
    port map(
        read_add => read_add_tb,
        inst => inst_tb
    );
    -- stimulus :
    process is
        begin
            wait for 100 ps;
            if(read_add_tb = x"0000003C") then
                read_add_tb <= (others => '0');
            else
                read_add_tb <= std_logic_vector(unsigned(read_add_tb)+x"00000004");
            end if;
    end process;
end architecture;