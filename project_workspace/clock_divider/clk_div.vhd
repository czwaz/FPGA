library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201008 / 20201011

ENTITY clk_div IS
	GENERIC (
		CLK_FREQ_IN		    :	INTEGER := 48000000;
		CLK_GOAL_1		    :	INTEGER := 480000
	);
	PORT (
		rst_n			    :	IN	std_logic;
		clk 			    :	IN	std_logic;
		clk_480_KHz_out	    :	OUT	std_logic; -- 480 KHz
		clk_div32_out		:	OUT	std_logic; -- 1,5 MHz
		clk_div64_out		:	OUT	std_logic; -- 750 KHz
		clk_div128_out		:	OUT	std_logic; -- 375 KHz
		clk_div256_out		:	OUT	std_logic; -- 187,5 KHz
		clk_div512_out		:	OUT	std_logic; -- 93,750 KHz
		clk_div1024_out		:	OUT	std_logic; -- 46,875 KHz
		clk_div4096_out		:	OUT	std_logic; -- 11,718 KHz
		clk_div16384_out	:	OUT	std_logic; -- 2,929 KHz
		clk_div65536_out	:	OUT	std_logic  -- 732,42 Hz
	);
END ENTITY;

ARCHITECTURE behaviour OF clk_div IS

	SIGNAL clk_480_KHz_temp	:	std_logic	:= '0';
	SIGNAL clk_divider		:	unsigned (15 downto 0)	:= (others => '0');

BEGIN

	PROCESS (clk, rst_n)
	
		CONSTANT cnt_480_KHz_top	:	INTEGER := ((CLK_FREQ_IN / CLK_GOAL_1) / 2)-1;
		VARIABLE cnt_480_KHz 		:	INTEGER RANGE 0 TO cnt_480_KHz_top;
		
	BEGIN
	
		IF rst_n = '0' THEN
			cnt_480_KHz := 0;
			clk_480_KHz_temp <= '0';
			clk_divider <= (others => '0');
			
		ELSIF rising_edge (clk) THEN
		
			-- 480 KHz generation
			IF cnt_480_KHz = 50 - 1 THEN
				cnt_480_KHz := 0;
				clk_480_KHz_temp <= not clk_480_KHz_temp;
			ELSE
				cnt_480_KHz := cnt_480_KHz + 1;
			END IF;
			
			-- clock divider counter (16 bit counter)
			clk_divider <= clk_divider + 1;
			
		END IF;
		
	END PROCESS;
	
	clk_480_KHz_out <= clk_480_KHz_temp;

	clk_div32_out		<= clk_divider(4);
	clk_div64_out		<= clk_divider(5);
	clk_div128_out		<= clk_divider(6);
	clk_div256_out		<= clk_divider(7);
	clk_div512_out		<= clk_divider(8);
	clk_div1024_out		<= clk_divider(9);
	clk_div4096_out 	<= clk_divider(11);
	clk_div16384_out	<= clk_divider(13);
	clk_div65536_out	<= clk_divider(15);

END ARCHITECTURE behaviour;