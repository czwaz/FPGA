library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

-- author: CZW
-- date: 20201011

entity clk_div_tb is

end;

architecture tb of clk_div_tb is

COMPONENT clk_div
	PORT (
		reset				:	IN		std_logic;
		clk_in			:	IN		std_logic;
		clk_480_KHz		:	OUT	std_logic; -- 480 KHz
		clk_div32		:	OUT	std_logic; -- 1,5 MHz
		clk_div64		:	OUT	std_logic; -- 750 KHz
		clk_div128		:	OUT	std_logic; -- 375 KHz
		clk_div256		:	OUT	std_logic; -- 187,5 KHz
		clk_div512		:	OUT	std_logic; -- 93,750 KHz
		clk_div1024		:	OUT	std_logic; -- 46,875 KHz
		clk_div4096		:	OUT	std_logic; -- 11,718 KHz
		clk_div16384	:	OUT	std_logic; -- 2,929 KHz
		clk_div65536	:	OUT	std_logic  -- 732,42 Hz
		);
END COMPONENT;

SIGNAL clk	: std_logic := '0';
SIGNAL rst	: std_logic := '1';

begin

dut : clk_div
	PORT MAP (
	clk_in => clk,
	reset => rst);

clock : PROCESS
	begin
	wait for 10.4166666666667 ns; clk <= not clk;
end PROCESS clock;


end tb;
