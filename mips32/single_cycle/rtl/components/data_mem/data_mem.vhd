library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity data_mem is 
    generic(
        ADR_WIDTH : integer := 32;
        DATA_WIDTH : integer := 32
    );
    port(
        addresse : in std_logic_vector(ADR_WIDTH-1 downto 0);
        write_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        read_en,write_en : in std_logic;
        read_data : out std_logic_vector(DATA_WIDTH-1 downto 0)    
    );
end entity;

architecture rtl of data_mem is
    type ram_t is array(0 to 15) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_t := (
        (others => 'X'),
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X'), 
        (others => 'X')
    );
    begin 
        write_d : process(addresse,write_data,write_en)
            begin
                if(write_en = '1') then
                    if(addresse < std_logic_vector(to_unsigned(64,ADR_WIDTH))) then
                        ram(to_integer(unsigned(addresse))/4) <= write_data;
                    end if;
                end if; 
        end process;
        read_d : process(addresse,read_en,ram)
            begin
                if(read_en = '1') then 
                    if(addresse < std_logic_vector(to_unsigned(64,ADR_WIDTH))) then
                        read_data <= ram(to_integer(unsigned(addresse)/4));
                    else
                        read_data <= (others => 'U');
                    end if;
                end if;
        end process;
end architecture;