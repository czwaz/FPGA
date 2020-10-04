library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20201004

ENTITY button_debounce IS
	GENERIC (
		CLK_FREQUENCY	:	INTEGER	:= 48000000;	-- 48 MHz
		DEBOUNCE_TIME	:	INTEGER	:= 10;	-- 10 ms
		ms_in_sec	: INTEGER := 1000
		);
		
	PORT (
		clk_in	:	IN		std_logic;
		reset		:	IN		std_logic;
		btn_in	:	IN		std_logic;
		btn_out	:	OUT	std_logic;
		
		--DEBUG PORTS
		led2		:	OUT	std_logic;
		led3		:	OUT	std_logic;
		led4		:	OUT	std_logic
		
		);
END ENTITY button_debounce;
-------------------------------------------------------------------------------
ARCHITECTURE behaviour OF button_debounce IS

	TYPE STATE_TYPE IS ( IDLE_RELEASED,
								IDLE_PRESSED,
								EVENT_PRESS,
								EVENT_RELEASE,
								WAIT_DEBOUNCE );
	SIGNAL debounce_state	: STATE_TYPE := IDLE_RELEASED;
	SIGNAL debounce_state_next	: STATE_TYPE;
	
	CONSTANT	wait_counter_max : INTEGER := ((CLK_FREQUENCY * DEBOUNCE_TIME) / ms_in_sec) ;

BEGIN

	PROCESS (clk_in, reset)
		
		VARIABLE wait_counter	: INTEGER RANGE 0 TO wait_counter_max;
	
	BEGIN
	
		IF reset = '0' THEN
			debounce_state_next <= IDLE_RELEASED;
			
		ELSIF rising_edge (clk_in) THEN
			CASE debounce_state IS
			
				WHEN IDLE_RELEASED =>
					IF btn_in = '1' THEN
						debounce_state_next <= IDLE_RELEASED;
					ELSE
						debounce_state_next <= EVENT_PRESS;
					END IF;
				
				WHEN IDLE_PRESSED =>
					IF btn_in = '0' THEN
						debounce_state_next <= IDLE_PRESSED;
					ELSE
						debounce_state_next <= EVENT_RELEASE;
					END IF;
					
				WHEN EVENT_PRESS =>
					debounce_state_next <= WAIT_DEBOUNCE;
					wait_counter := 0;
					
				WHEN EVENT_RELEASE =>
					debounce_state_next <= WAIT_DEBOUNCE;
					wait_counter := 0;
					
				WHEN WAIT_DEBOUNCE =>
					IF wait_counter = wait_counter_max THEN
						IF btn_in = '0' THEN
							debounce_state_next <= IDLE_PRESSED;
						ELSE
							debounce_state_next <= IDLE_RELEASED;
						END IF;
					ELSE
						wait_counter := wait_counter + 1;
						debounce_state_next <= WAIT_DEBOUNCE;
					END IF;
					
			END CASE;
		END IF;
		
		debounce_state <= debounce_state_next;
		
	END PROCESS;
	
	PROCESS (debounce_state)
	BEGIN
		CASE debounce_state IS
		
			WHEN IDLE_RELEASED =>
				btn_out <= '1';
				led2 <= '1';
				led3 <= '1';
				led4 <= '1';
				
			WHEN IDLE_PRESSED =>
				btn_out <= '0';
				led2 <= '1';
				led3 <= '1';
				led4 <= '1';
				
			WHEN EVENT_PRESS =>
				led2 <= '0';
				led3 <= '1';
				led4 <= '1';
				
			WHEN EVENT_RELEASE =>
				led2 <= '1';
				led3 <= '0';
				led4 <= '1';
				
			WHEN WAIT_DEBOUNCE =>
				led2 <= '1';
				led3 <= '1';
				led4 <= '0';
				
		END CASE;
	
	END PROCESS;


END ARCHITECTURE behaviour;