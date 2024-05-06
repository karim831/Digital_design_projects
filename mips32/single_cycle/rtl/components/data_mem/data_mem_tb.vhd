library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity data_mem_tb is
end entity;

architecture rtl of data_mem_tb is
    -- constants : 
    constant ADR_WIDTH_TB : integer := 32;
    constant DATA_WIDTH_TB : integer := 32;
    --inputs :
    signal addresse_tb :  std_logic_vector(ADR_WIDTH_TB-1 downto 0) := (others => '0');
    signal write_data_tb :  std_logic_vector(DATA_WIDTH_TB-1 downto 0) := (others => '0');
    signal read_en_tb,write_en_tb :  std_logic := '0';
    -- outupts :
    signal read_data_tb : std_logic_vector(DATA_WIDTH_TB-1 downto 0);
    begin
        -- porting : 
        data_mem : entity work.data_mem(rtl) 
        generic map(
            ADR_WIDTH => ADR_WIDTH_TB,
            DATA_WIDTH => DATA_WIDTH_TB
        )
        port map(
            addresse => addresse_tb,
            write_data => write_data_tb,
            read_en=> read_en_tb,
            write_en => write_en_tb,
            read_data => read_data_tb
        );
        -- stimulus
        process is
            begin
                write_en_tb <= '1';
                read_en_tb <= '0';
                wait for 10 ps;
                read_en_tb <= '1';
                write_en_tb <= '0';
                wait for 10 ps;
                if(addresse_tb = std_logic_vector(to_unsigned(60,ADR_WIDTH_TB))) then
                    addresse_tb <= (others => '0');
                else
                    addresse_tb <= std_logic_vector(unsigned(addresse_tb)+to_unsigned(4,ADR_WIDTH_TB));
                end if;
                wait for 10 ps;
        end process;
end architecture;