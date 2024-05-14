library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.inst_pck.all;
entity inst_mem is
generic(
    ADR_WIDTH : integer := 32;
    INSTRUCTION_WIDTH : integer := 32
);
port(
    read_add : in std_logic_vector(ADR_WIDTH-1 downto 0);
    inst : out std_logic_vector(INSTRUCTION_WIDTH-1 downto 0)
);
end entity;

architecture rtl of inst_mem is
    type ram_type is array(0 to 15) of std_logic_vector(31 downto 0); -- <16(changeable)> 4_byte word ram
    signal ram : ram_type := (
        i_inst(addi,s0,zero,5),
        i_inst(sw,s0,s1,0),
        i_inst(lw,s1,s1,0),  
        j_inst(j,4),     
        r_inst(addr,s1,s0,s1), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0'), 
        (others => '0')
    );
    begin
        process(read_add) is
            begin
                if(read_add < std_logic_vector(to_unsigned(64,ADR_WIDTH))) then
                    inst <= ram(to_integer(unsigned(read_add))/4);
                else
                    inst <= (others => '0');
                end if;
        end process;
end architecture;

