library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity main_control is
    port(
        op_code : in std_logic_vector(5 downto 0);
        regdst,jump,branch,memread,memtoreg,aluop,memwrite,alusrc,regwrite :
            out std_logic
    );
end entity;

architecture rtl of main_control is

end architecture;