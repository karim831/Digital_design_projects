library ieee;
use ieee.std_logic_1164.all;
entity alu_cont is
    port(
        alu_op,r_func : in std_logic_vector(5 downto 0);
        alu_ctr : out std_logic_vector(5 downto 0)
    );
end entity;

architecture rtl of alu_cont is
    begin
        process(alu_op,r_func) is 
            begin
                if(alu_op = (0 to alu_op'length-1 => '0')) then
                    alu_ctr <= r_func;
                else
                    if(alu_op < (0 to alu_op'length-4 => '0') & "110") then
                        alu_ctr <= r_func;
                    else
                        case alu_op is 
                            when (0 to alu_op'length-4 => '0') & "110"  =>
                                alu_ctr <= (0 to alu_ctr'length-3 => '0') & "10"; 
                            when (0 to alu_op'length-4 => '0') & "111"  =>
                                alu_ctr <= (0 to alu_ctr'length-3 => '0') & "10"; 
                            when (0 to alu_op'length-5 => '0') & "1000" =>
                                alu_ctr <= (0 to alu_ctr'length-4 => '0') & "100"; 
                            when others => null;
                                alu_ctr <= (others => 'U'); 
                        end case;
                    end if; 
                end if;
        end process;
end architecture;