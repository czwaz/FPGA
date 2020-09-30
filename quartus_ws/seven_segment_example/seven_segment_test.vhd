library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20200930

entity seven_segment_test is
	port (
		clk : in std_logic;
		
		SW : in std_logic_vector (3 downto 0);
		
		LEDs : out std_logic_vector (0 to 7);
		
		DIG1 : out std_logic;
		DIG2 : out std_logic;
		DIG3 : out std_logic;
		DIG4 : out std_logic
	);
end entity seven_segment_test;


architecture behaviour of seven_segment_test is
begin
	process (clk)
	
		variable clk_cnt : integer := 0;
		variable char : std_logic_vector (0 to 7) := "10000000";
	
	begin
	
		DIG1 <= '0';
		DIG2 <= '0';
		DIG3 <= '0';
		DIG4 <= '0';
	
		if clk'event and clk = '1' then
		
			if clk_cnt = 48000000/2 then
				clk_cnt := 0;
			else
				clk_cnt := clk_cnt + 1;
			end if;
			
			LEDs <= char;
	
		end if;
		
	end process;

end architecture behaviour;