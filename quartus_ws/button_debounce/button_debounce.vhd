library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20201004


ENTITY button_debounce IS
	PORT (
		clk_in	: IN	std_logic;
		reset		: IN	std_logic;
		btn_in	: IN	std_logic;
		btn_out	: OUT	std_logic
		);
END ENTITY button_debounce;



ARCHITECTURE behaviour OF button_debounce IS
	TYPE STATE_TYPE IS (S1, S2);
	--variable wait_counter	: INTEGER RANGE (0 to XXX);

BEGIN




END ARCHITECTURE behaviour;