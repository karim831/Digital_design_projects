-- n_bit_addr n_bit_data reg_file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg_file is 
    generic(
        REG_WIDTH : integer := 32;
        ADR_WIDTH : integer := 5
    );
    port(
        read_reg1,read_reg2,write_reg : in std_logic_vector(ADR_WIDTH-1 downto 0);
        write_data : in std_logic_vector(REG_WIDTH-1 downto 0);
        write_en :in std_logic;
        read_data1,read_data2 : out std_logic_vector(REG_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of reg_file is
    type reg_file_type is array(0 to 2**ADR_WIDTH-1) of std_logic_vector(REG_WIDTH-1 downto 0);
    signal reg_file : reg_file_type := (
        x"00000000",
        x"11111111",
        x"22222222",
        x"33333333",
        x"44444444",
        x"55555555",
        x"66666666",
        x"77777777",
        x"88888888",
        x"99999999",
        x"AAAAAAAA",
        x"BBBBBBBB",
        x"CCCCCCCC",
        x"DDDDDDDD",
        x"EEEEEEEE",
        x"FFFFFFFF",
        x"00000000",
        x"11111111",
        x"22222222",
        x"33333333",
        x"44444444",
        x"55555555",
        x"66666666",
        x"77777777",
        x"88888888",
        x"99999999",
        x"AAAAAAAA",
        x"BBBBBBBB",
        x"CCCCCCCC",
        x"DDDDDDDD",
        x"EEEEEEEE",
        x"FFFFFFFF"
    );
    begin
        read_data1 <= reg_file(to_integer(unsigned(read_reg1)));
        read_data2 <= reg_file(to_integer(unsigned(read_reg2)));

        process(write_en,write_data) is
            begin
                if(write_en = '1') then
                    reg_file(to_integer(unsigned(write_reg))) <= write_data;
                end if;
        end process;
end architecture;

--  |name        |reg#    |convention           |                        
--  |$ZERO       |0       |constant 0           |                    
--  |$at         |1       |reserved for compiler|                
--  |$v0-$v1     |2-3     |results              |                
--  |$a0-$a3     |4-7     |arguments            |                    
--  |$t0-$t7     |8-15    |caller-temps         |            
--  |$s0-$s7     |16-23   |caller-saved         |    
--  |$t8-$t9     |24-25   |caller-temps         |    
--  |$k0-$k1     |26-27   |reserved for OS      |            
--  |$gp         |28      |global_pointer       |            
--  |$sp         |29      |stack_pointer        |            
--  |$fp         |30      |frame_pointer        |            
--  |$ra         |31      |return_pointer       |    