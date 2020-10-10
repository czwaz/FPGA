library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201009

entity ps2 is
	port (
		ps2_clk_in		:	IN		std_logic;
		ps2_data_in		:	IN		std_logic;
		
		ps2_clk_out		:	OUT	std_logic;
		ps2_data_out	:	OUT	std_logic
		);
end entity;

architecture behaviour of ps2 is


begin

	ps2_clk_out	<= ps2_clk_in;
	ps2_data_out <= ps2_data_in;
	
end architecture;