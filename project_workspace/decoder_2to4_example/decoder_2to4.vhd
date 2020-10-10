library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20200927

entity decoder_2to4 is
	port (
		INPUT : in std_logic_vector (1 downto 0);
		OUTPUT : out std_logic_vector (3 downto 0)
		);
	end entity decoder_2to4;

	
architecture behaviour of decoder_2to4 is

begin
	process (INPUT)
	
	begin
		
		case INPUT is
			-- leds and switches are active low!!!
			when "11" => OUTPUT <= "1110";
			when "10" => OUTPUT <= "1101";
			when "01" => OUTPUT <= "1011";
			when "00" => OUTPUT <= "0111";
			
			when others => OUTPUT <= "XXXX";
		end case;
	end process;
	
end architecture behaviour;