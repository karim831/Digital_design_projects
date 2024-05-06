library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu_tb is 
end entity;

architecture rtl of alu_tb is
    -- constants :
    constant INPUT_WIDTH_TB : integer := 32;
    -- inputs :
    signal in1_tb : std_logic_vector(INPUT_WIDTH_TB-1 downto 0) := std_logic_vector(to_unsigned(250,INPUT_WIDTH_TB));
    signal in2_tb : std_logic_vector(INPUT_WIDTH_TB-1 downto 0) := std_logic_vector(to_unsigned(139,INPUT_WIDTH_TB));
    signal control_tb : std_logic_vector(5 downto 0) := (others => '0');
    
    -- outputs :
    signal alu_result_tb : std_logic_vector(INPUT_WIDTH_TB-1 downto 0);
    signal zero_tb : std_logic;
    
    begin
    -- porting :
    ALU : entity work.alu(rtl) 
    generic map(INPUT_WIDTH => INPUT_WIDTH_TB)    
    port map(
        in1 => in1_tb, 
        in2 => in2_tb,
        control => control_tb,
        alu_result => alu_result_tb,
        zero => zero_tb
    );

    -- stimulus :
    process is 
        begin 
            wait for 100 ps;
            if(control_tb < (0 to control_tb'length-4 => '0') & "111") then 
                control_tb <= std_logic_vector(unsigned(control_tb) + to_unsigned(1,control_tb'length));
            else 
                control_tb <= (others => '0');
            end if;
    end process;
end architecture;