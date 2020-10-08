library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20201004

ENTITY serial_test IS
	GENERIC (
		CLK_FREQ		:	INTEGER	:= 48000000;
		CLK_DIV		:	INTEGER	:= 100;
		BAUD_RATE	:	INTEGER	:= 9600
		);
		
	PORT (
		rx_pl2303	:	OUT	std_logic; -- TX-FPGA --> RX-PL2303
		tx_pl2303	:	IN		std_logic; -- RX-FPGA <-- TX-PL2303
		clk			:	IN		std_logic; -- 48MHz
		rst			:	IN		std_logic;
		
		data			:	INOUT	std_logic_vector ( 7 downto 0 );
		data_valid	:	OUT	std_logic;
		
		led_vec		:	OUT	std_logic_vector ( 3 downto 0 );
		hsync			:	OUT	std_logic;
		vsync			:	INOUT	std_logic;
		debug			:	OUT	std_logic_vector ( 2 downto 0 )
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
	SIGNAL clk_480KHz		:	std_logic := '0';
	
	CONSTANT	T2_cnt_top	:	INTEGER := CLK_FREQ / CLK_DIV / BAUD_RATE;
	CONSTANT T1_cnt_top	:	INTEGER := 3 * T2_cnt_top / 2;
	CONSTANT RX_IDLE_VAL	:	std_logic := '1';
	CONSTANT	STOP_VAL		:	std_logic := '1';
	CONSTANT	NUM_OF_BITS :	INTEGER := 8;

BEGIN
	rx_pl2303 <= tx_pl2303; -- for debugging only!!!
	hsync	<=	tx_pl2303;		-- for debugging only!!!
	
	-- Clock divider: 48MHz --> 480KHz
	CLK_DIVIDER: PROCESS (clk, rst)
		VARIABLE clk_cnt : INTEGER RANGE 0 TO 50;
	BEGIN
		IF rst = '0' THEN
			clk_cnt := 0;
		ELSIF rising_edge(clk) THEN
			IF clk_cnt = 50-1 THEN
				clk_cnt := 0;
				clk_480KHz <= not clk_480KHz;
				VSYNC <= not VSYNC;
			ELSE
				clk_cnt := clk_cnt + 1;
			END IF;
		END IF;
	END PROCESS;
		
	
	-- NEXT STATE PROCESS
	PROCESS (clk_480KHz, rst)
		VARIABLE cnt : INTEGER RANGE 0 TO T1_cnt_top;
		VARIABLE BIT_cnt : INTEGER RANGE 0 TO NUM_OF_BITS;
	
	BEGIN
		IF rst = '0' THEN
			rx_fsm_state_next <= IDLE;
			
		ELSIF rising_edge (clk_480KHz) THEN
			rx_fsm_state_next <= rx_fsm_state;	-- by default stay in current state
			
			CASE rx_fsm_state IS
				
				WHEN IDLE =>
					data_valid <= '0';
					IF tx_pl2303 = not RX_IDLE_VAL THEN
						rx_fsm_state_next <= WAIT_T1;
						cnt := 0;
					END IF;
					
				WHEN WAIT_T1 =>
					IF cnt = T1_cnt_top-1 THEN
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
					IF cnt = T2_cnt_top-2 THEN
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
		
			WHEN IDLE =>
				debug <= "000";
				
			WHEN WAIT_T1 =>
				debug <= "001";
		
			WHEN SAMPLE =>
				debug <= "010";
				
			WHEN WAIT_T2 =>
				debug <= "011";

			WHEN SAMPLE_STOP_SET_OUTPUT =>
				led_vec <= not data ( 3 downto 0 );
				debug <= "100";
				
			WHEN OTHERS =>
				debug <= "111";
				
		END CASE;
	END PROCESS;

END ARCHITECTURE behaviour;