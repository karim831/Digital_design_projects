library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mux_tb is 
end entity;

architecture rtl of mux_tb is 
    -- constans :
    constant WIDTH_TB : integer := 32;
    -- inputs :
    signal in1_tb,in2_tb : std_logic_vector(WIDTH_TB-1 downto 0) := (others => '0');
    signal sel_tb : std_logic := '0';
    -- outputs :
    signal o_tb : std_logic_vector(WIDTH_TB-1 downto 0);

    begin
    -- porting :
    mux_tb : entity work.mux(rtl) 
        generic map(
            WIDTH => WIDTH_TB
        )
        port map(
            in1 => in1_tb,
            in2 => in2_tb,
            sel => sel_tb,
            o   => o_tb
        );


    -- stimulus process
    stim_porcess : process 
        begin
            in1_tb <= std_logic_vector(to_unsigned(2220,WIDTH_TB));
            in2_tb <= std_logic_vector(to_unsigned(5023,WIDTH_TB));

            sel_tb <= '1';
            wait for 100 ps;
            sel_tb <= '0';
            wait;
        end process;
end architecture;