library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201014

entity memory_async_tb is
    generic (SIZE : integer := 4);
end entity;
	
architecture tb of memory_async_tb is

	component memory_async is
        generic (
            SIZE : integer := 4
        );
		port (
			rst             :   in  std_logic;
			write_enable_L  :   in  std_logic;
			LED_in_pos      :   in  integer range 0 to SIZE-1;
			LED_in_data     :   in  std_logic_vector (7 downto 0);
			LED_out_pos     :   in  integer range 0 to SIZE-1;
			LED_out_data    :   out std_logic_vector (7 downto 0)
        );
	end component;

signal	rst_tb	:	std_logic;
signal	we_l_tb	:	std_logic;
signal	LED_in_pos_tb	:	integer range 0 to SIZE-1;
signal  LED_in_data_tb  :   std_logic_vector (7 downto 0);
signal  LED_out_pos_tb  :   integer range 0 to SIZE-1;

begin

uut:    memory_async port map (rst => rst_tb, write_enable_L => we_l_tb, 
               LED_in_pos => LED_in_pos_tb, LED_in_data => LED_in_data_tb,
               LED_out_pos => LED_out_pos_tb);

tb:	process
begin
	wait for 0 ps;
	LED_in_pos_tb <= 0;
	LED_in_data_tb <= x"00";
	we_l_tb <= '0';
    rst_tb <= '0';
    wait for 1 ps;
    rst_tb <= '1';
    wait for 1 ps;
    
    we_l_tb <= '0';
	LED_in_pos_tb <= 0;
	LED_in_data_tb <= x"aa";
    wait for 2 ps;
  
    LED_in_pos_tb <= 1;
	LED_in_data_tb <= x"55";
    wait for 2 ps;
    
    LED_in_pos_tb <= 2;
	LED_in_data_tb <= x"a0";
    wait for 2 ps;
    
    LED_in_pos_tb <= 3;
	LED_in_data_tb <= x"ff";
    wait for 2 ps;
    we_l_tb <= '1';
    rst_tb <= '0';
    wait for 1 ps;
    rst_tb <= '1';
    
    LED_out_pos_tb <= 0;
    wait for 2 ps;
    LED_out_pos_tb <= 1;
    wait for 2 ps;
    LED_out_pos_tb <= 2;
    wait for 2 ps;
    LED_out_pos_tb <= 3;
    wait for 2 ps;

	wait for 100 ps;
	wait;
    
	
end process;


end architecture;