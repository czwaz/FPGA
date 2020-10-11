library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20200927

entity decoder_2to4_tb is

end;

architecture tb of decoder_2to4_tb is

	component decoder_2to4
		port (
			INPUT : in std_logic_vector (1 downto 0);
			OUTPUT : out std_logic_vector (3 downto 0)
			);
	end component;
	
	signal tb_input : std_logic_vector (1 downto 0);

begin

	dut: decoder_2to4
		port map (
			INPUT => tb_input
		);
	
	input: process
	
	begin
		wait for 2 ns;
		tb_input <= "00";
		wait for 10 ns;
		tb_input <= "01";
		wait for 10 ns;
		tb_input <= "10";
		wait for 10 ns;
		tb_input <= "11";
		wait for 10 ns;
	
	end process;
		
end architecture tb;