library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20201004

ENTITY serial_test IS
	GENERIC (
		CLK_FREQ		:	INTEGER	:= 48000000;
		BAUD_RATE	:	INTEGER	:= 9600
		);
		
	PORT (
		rx_pl2303	:	OUT	std_logic; -- TX-FPGA --> RX-PL2303
		tx_pl2303	:	IN		std_logic; -- RX-FPGA <-- TX-PL2303
		clk			:	IN		std_logic;
		rst			:	IN		std_logic;
		
		data			:	INOUT	std_logic_vector ( 7 downto 0 );
		data_valid	:	OUT	std_logic;
		
		led_vec		:	OUT	std_logic_vector ( 3 downto 0 )
		);
END ENTITY serial_test;
-------------------------------------------------------------------------------
ARCHITECTURE behaviour OF serial_test IS

	TYPE RX_FSM_TYPE IS (IDLE,
								WAIT_T1,
								SAMPLE,
								WAIT_T2,
								SAMPLE_STOP_SET_OUTPUT
								);
	SIGNAL rx_fsm_state	:	RX_FSM_TYPE	:=	IDLE;
	SIGNAL rx_fsm_state_next	:	RX_FSM_TYPE;
	
	CONSTANT	T2_cnt_top	:	INTEGER := CLK_FREQ / BAUD_RATE;
	CONSTANT T1_cnt_top	:	INTEGER := 3 * T2_cnt_top / 2;
	CONSTANT RX_IDLE_VAL	:	std_logic := '1';
	CONSTANT	STOP_VAL		:	std_logic := '1';
	CONSTANT	NUM_OF_BITS :	INTEGER := 8;

BEGIN
	rx_pl2303 <= tx_pl2303; -- for debugging only!!!
	-- NEXT STATE PROCESS
	PROCESS (clk, rst)
		VARIABLE cnt : INTEGER RANGE 0 TO T1_cnt_top;
		VARIABLE BIT_cnt : INTEGER RANGE 0 TO NUM_OF_BITS;
	
	BEGIN
	
		IF rst = '0' THEN
			rx_fsm_state_next <= IDLE;
			--data_valid <= '0';
			--data <= (others => '0');
			--led_vec <= (others => '1');
			
		ELSIF rising_edge (clk) THEN
		
			-- by default stay in current state
			rx_fsm_state_next <= rx_fsm_state;
			
			CASE rx_fsm_state IS
				
				WHEN IDLE =>
					data_valid <= '0';
					IF tx_pl2303 = not RX_IDLE_VAL THEN
						rx_fsm_state_next <= WAIT_T1;
						cnt := 0;
					END IF;
					
				WHEN WAIT_T1 =>
					IF cnt = T1_cnt_top THEN
						rx_fsm_state_next <= SAMPLE;
						BIT_cnt := 0;
					ELSE
						cnt := cnt + 1;
					END IF;
					
				WHEN SAMPLE =>
					data (BIT_cnt) <= tx_pl2303;
					BIT_cnt := BIT_cnt + 1;
					rx_fsm_state_next <= WAIT_T2;
					cnt := 0;
					
				WHEN WAIT_T2 =>
					IF cnt = T2_cnt_top THEN
						IF BIT_cnt = NUM_OF_BITS THEN
							rx_fsm_state_next <= SAMPLE_STOP_SET_OUTPUT;
						ELSE
							rx_fsm_state_next <= SAMPLE;
						END IF;
					ELSE
						cnt := cnt + 1;
					END IF;
					
				WHEN SAMPLE_STOP_SET_OUTPUT =>
					IF tx_pl2303 = STOP_VAL THEN
						data_valid <= '1';
					END IF;
					rx_fsm_state_next <= IDLE;
				
			END CASE;
		END IF;
		
		rx_fsm_state <= rx_fsm_state_next;
		
	END PROCESS;
	
	-- OUTPUT PROCESS
	PROCESS (rx_fsm_state)
	BEGIN
		CASE rx_fsm_state IS

			WHEN SAMPLE_STOP_SET_OUTPUT =>
				led_vec <= data ( 3 downto 0 );
				
			WHEN OTHERS =>
				
				
		END CASE;
	END PROCESS;

END ARCHITECTURE behaviour;