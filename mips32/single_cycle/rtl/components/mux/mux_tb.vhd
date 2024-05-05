library ieee;
use ieee.std_logic_1164.all;

entity mux_tb is 
end entity;

architecture rtl of mux_tb is 
    -- constans :
    constant tb_WIDTH : integer := 32;
    -- inputs :
    signal tb_in1,tb_in2 : std_logic_vector(tb_WIDTH-1 downto 0) := (others => '0');
    signal tb_sel : std_logic := '0';
    -- outputs :
    signal tb_o : std_logic_vector(tb_WIDTH-1 downto 0);

    begin
    -- porting :
    mux_tb : entity work.mux(rtl) 
        generic map(
            WIDTH => tb_WIDTH
        )
        port map(
            in1 => tb_in1,
            in2 => tb_in2,
            sel => tb_sel,
            o   => tb_o
        );


    -- stimulus process
    stim_porcess : process 
        begin
            tb_in1 <= x"AAAAFFFF";
            tb_in2 <= x"FFFFAAAA";

            tb_sel <= '1';
            wait for 100 ps;
            tb_sel <= '0';
            wait;
        end process;
end architecture;