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
        x"00000000",
        r_inst(addr,s3,s1,s2), 
        j_inst(j,std_logic_vector(to_unsigned(14,26))), 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000", 
        x"00000000"
    );
    begin
        process(read_add) is
            begin
                inst <= ram(to_integer(unsigned(read_add))/4);
        end process;
end architecture;

