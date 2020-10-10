library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201008

ENTITY clk_div IS
	PORT (
		reset			:	IN		std_logic;
		clk_in		:	IN		std_logic;
		clk_480_KHz	:	OUT	std_logic; -- 480 KHz
		clk_div32	:	OUT	std_logic; -- 1,5 MHz
		clk_div64	:	OUT	std_logic; -- 750 KHz
		clk_div128	:	OUT	std_logic; -- 375 KHz
		clk_div256	:	OUT	std_logic  -- 187,5 KHz
		);
END ENTITY;

ARCHITECTURE behaviour OF clk_div IS

	SIGNAL clk_480_KHz_out	:	std_logic	:= '0';
	SIGNAL clk_divider		:	unsigned (7 downto 0)	:= (others => '0');

BEGIN

	PROCESS (clk_in, reset)
	
		VARIABLE cnt : INTEGER RANGE 0 TO 50 - 1;
		
	BEGIN
	
		IF reset = '0' THEN
			cnt := 0;
			clk_480_KHz_out <= '0';
			clk_divider <= (others => '0');
			
		ELSIF rising_edge (clk_in) THEN
		
			IF cnt = 50 - 1 THEN
				cnt := 0;
				clk_480_KHz_out <= not clk_480_KHz_out;
				
			ELSE
				cnt := cnt + 1;
				
			END IF;
			
			clk_divider <= clk_divider + 1;
			
		END IF;
		
	END PROCESS;
	
	clk_480_KHz <= clk_480_KHz_out;
	clk_div32	<= clk_divider(4);
	clk_div64	<= clk_divider(5);
	clk_div128	<= clk_divider(6);
	clk_div256	<= clk_divider(7);

END ARCHITECTURE behaviour;