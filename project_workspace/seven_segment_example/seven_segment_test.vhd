library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

-- author: CZW
-- date: 20200930 / 20201009

entity seven_segment_test is
	port (
		clk	: in std_logic;
		rst	: in std_logic;
		
		LEDs		: out std_logic_vector (0 to 7);
		led_pos	: out std_logic_vector (3 downto 0);
		
		debug1	: out std_logic;
		debug2	: out std_logic
	);
end entity seven_segment_test;


architecture behaviour of seven_segment_test is

	TYPE state_type IS (shift_digit, hold_output);
	SIGNAL fsm_state	:	state_type := shift_digit;
	SIGNAL fsm_state_next	: state_type;
	SIGNAL led_temp : std_logic_vector (3 downto 0) := "0001";
	SIGNAL temp : std_logic := '0';
	SIGNAL temp2 : std_logic := '0';
	
	CONSTANT hold_cnt_top	: INTEGER := 480000;
	
begin

	process (clk, rst)
	
		variable hold_cnt : integer := 0;
	
	begin
		
		if rst = '0' then
			fsm_state_next <= shift_digit;
			
		elsif rising_edge(clk) then
			fsm_state_next <= fsm_state;
			
			case fsm_state is
				when shift_digit =>
					fsm_state_next <= hold_output;
					
				when hold_output =>
					if hold_cnt = hold_cnt_top then
						hold_cnt := 0;
						fsm_state_next <= shift_digit;
						temp2 <= not temp2;
					else
						hold_cnt := hold_cnt + 1;
					end if;
			end case;
		end if;
		
		fsm_state <= fsm_state_next;
		debug2 <= temp2;
		
	end process;
	
	PROCESS (fsm_state)
	
		variable char : std_logic_vector (0 to 7) := "11110000";
		
	BEGIN
		case fsm_state is
		
			when shift_digit =>
				LEDs <= char;
				led_temp <= led_temp(0) & led_temp(3 downto 1);
				led_pos <= "0101";
				temp <= not temp;
				--LEDs <= "10101010";--
						
			when hold_output =>
				--LEDs <= "01010101";
			
		end case;
		
		debug1 <= temp;
	end process;
			

end architecture behaviour;