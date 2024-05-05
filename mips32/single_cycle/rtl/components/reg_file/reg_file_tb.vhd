library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg_file_tb is
end entity;

architecture rtl of reg_file_tb is 
    -- constants :
    constant REG_WIDTH_TB : integer := 32;
    constant ADR_WIDTH_TB : integer := 5;

    -- inputs :
    signal read_reg1_tb : std_logic_vector(ADR_WIDTH_TB-1 downto 0) := "01010";
    signal read_reg2_tb : std_logic_vector(ADR_WIDTH_TB-1 downto 0) := "01100";
    signal write_reg_tb : std_logic_vector(ADR_WIDTH_TB-1 downto 0) := "00101";
    signal write_data_tb : std_logic_vector(REG_WIDTH_TB-1 downto 0) := x"00003B51";
    signal write_en_tb : std_logic := '0';

    -- outputs :
    signal read_data1_tb,read_data2_tb : std_logic_vector(REG_WIDTH_TB-1 downto 0);
    begin

    -- porting :
        RF : entity work.reg_file(rtl) 
        generic map(
            REG_WIDTH => REG_WIDTH_TB,
            ADR_WIDTH => ADR_WIDTH_TB
        )    
        port map(
            read_reg1 => read_reg1_tb,
            read_reg2 => read_reg2_tb,
            write_reg => write_reg_tb,
            write_data => write_data_tb,
            write_en => write_en_tb,
            read_data1 => read_data1_tb,
            read_data2 => read_data2_tb
        );

    -- stimulus :
        read_ing : process is 
            begin
                wait for 100 ps;
                if(write_en_tb = '1') then 
                    read_reg1_tb <= write_reg_tb;
                else
                    read_reg1_tb <= std_logic_vector(unsigned(read_reg1_tb) + "00001");
                    read_reg2_tb <= std_logic_vector(unsigned(read_reg2_tb) + "00001");
                end if;
        end process;
        writing : process is
            begin
                wait for 300 ps;
                write_en_tb <= not write_en_tb;
                wait for 100 ps;
                write_data_tb <= std_logic_vector(unsigned(write_data_tb)+x"00000001");
        end process;

end architecture;