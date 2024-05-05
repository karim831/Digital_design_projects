--n_bit six_operation_ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu is
    generic(
        INPUT_WIDTH : integer := 32
    );
    port(
        in1 : in std_logic_vector(INPUT_WIDTH-1 downto 0);
        in2 : in std_logic_vector(INPUT_WIDTH-1 downto 0);
        control : in std_logic_vector(3 downto 0);
        alu_result : out std_logic_vector(INPUT_WIDTH-1 downto 0);
        zero : out std_logic
    );
end entity;

architecture rtl of alu is
    signal result : std_logic_vector(INPUT_WIDTH-1 downto 0);
    begin
        process(in1,in2,control) is
            begin
                case control is
                    when "0000" =>  -- logical and
                        result <= in1 and in2;
                    when "0001" =>  -- logical or
                        result <= in1 or in2;
                    when "0010" =>  -- add
                        result <= std_logic_vector(unsigned(in1)+unsigned(in2));
                    when "0011" =>  -- sub
                        result <= std_logic_vector(unsigned(in1)-unsigned(in2));
                    when "0100" =>  -- set lower than
                        if(in1 < in2) then
                            result <= x"00000001";
                        else
                            result <= x"00000000";
                        end if;
                    when "0101" =>  -- logic nor
                        result <= in1 nor in2;
                    when others => null;    
                        result <= x"00000000";
                end case;
        end process;
        alu_result <= result;
        zero <= result(0);
end architecture;