library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

-- author: CZW
-- date: 20201011

entity seven_segment_test_tb is

end entity;


architecture tb of seven_segment_test_tb is

	component seven_segment_test
		port (
			clk_48_MHz	: in std_logic;
			rst	    	: in std_logic;
			
			LEDs    		: out std_logic_vector (0 to 7);
			led_pos 		: out std_logic_vector (3 downto 0);
			
			debug1  		: out std_logic;
			debug2  		: out std_logic
		);
	end component;
	
-- testbench input signals
signal tb_clk	: std_logic := '0';
signal tb_rst	: std_logic;
	
begin

uut: seven_segment_test
	port map (
		clk_48_MHz => tb_clk,
		rst => tb_rst
	);
	
clock: process
begin
	wait for 10.416666666666666667 ns;
	tb_clk <= not tb_clk;
end process clock;

reset: process
begin
	wait for 1 ps;
	tb_rst <= '0';
	wait for 1 ns;
	tb_rst <= '1';
	wait;
end process reset;

end architecture tb;