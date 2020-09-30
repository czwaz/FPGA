library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20200930

entity seven_segment_test is
	port (
		clk : in std_logic;
		
		SW1 : in std_logic;
		SW2 : in std_logic;
		SW3 : in std_logic;
		SW4 : in std_logic;
		
		A : out std_logic;
		B : out std_logic;
		C : out std_logic;
		D : out std_logic;
		E : out std_logic;
		F : out std_logic;
		G : out std_logic;
		DP : out std_logic;
		
		DIG1 : out std_logic;
		DIG2 : out std_logic;
		DIG3 : out std_logic;
		DIG4 : out std_logic
	);
end entity seven_segment_test;


architecture behaviour of seven_segment_test is
begin

	A <= '1';
	B <= '1';
	C <= '1';
	D <= '1';
	E <= '1';
	F <= '1';
	G <= '1';
	DP <= '1';
	
	DIG1 <= '0';
	DIG2 <= '0';
	DIG3 <= '0';
	DIG4 <= '0';

end architecture behaviour;