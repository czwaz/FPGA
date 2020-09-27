library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20200927

entity buzzer_test is
	port (
		clk : in std_logic;
		SW1 : in std_logic;
		SW2 : in std_logic;
		LED1 : out std_logic;
		LED2 : out std_logic;
		BUZZER : out std_logic
	);
end entity buzzer_test;



architecture behaviour of buzzer_test is

begin
	process (clk, SW1, SW2)
	
	variable clk_cnt: integer := 0;
	variable buzz_cnt : integer := 0;
	variable buzz_state : std_logic := '0';
	variable buzz_onoff : std_logic := '0';
	variable led_s1: std_logic;
	variable led_s2: std_logic;
	
	begin
	
	if (clk'event and clk = '1') then
		
		-- let Led D2 blink with an interval of 1Hz
		if clk_cnt = 48000000/2 then
			led_s1 := not led_s1;
			clk_cnt := 0;
		else
			clk_cnt := clk_cnt + 1;
		end if;
		
		-- buzzer with 1kHz if SW2 is pressed
		
		--bug that integer overruns and buffer isn't responing anymore until...
		if buzz_cnt = 48000 and buzz_onoff = '1' then
			buzz_state := not buzz_state;
			buzz_cnt := 0;
		else
			buzz_cnt := buzz_cnt + 1;
		end if;
		
		buzz_onoff := not SW2;
	
	LED1 <= led_s1;
	LED2 <= buzz_onoff;
	BUZZER <= buzz_state;
	
	end if;
	
	end process;

end architecture behaviour;