library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201014

entity memory_async_tb is
    generic (
        MEM_SIZE    :   integer := 4;
        ADDR_WIDTH  :   integer := 2; --log_2(MEM_SIZE)
        DATA_WIDTH  :   integer := 8
    );
end entity;
	
architecture tb of memory_async_tb is

	component memory_async is
        generic (
            MEM_SIZE    :   integer := 4;
            ADDR_WIDTH  :   integer := 2; --log_2(MEM_SIZE)   
            DATA_WIDTH  :   integer := 8
        );
        port (
            rst_n       :   in  std_logic;
            wr_en_n_in  :   in  std_logic;
            wr_addr_in  :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            wr_data_in  :   in  std_logic_vector (DATA_WIDTH-1 downto 0);
            rd_addr_in  :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            rd_data_out :   out std_logic_vector (DATA_WIDTH-1 downto 0)
        );
	end component;

signal	rst_tb      :	std_logic;
signal	we_n_tb     :	std_logic;
signal	wr_addr_tb  :	std_logic_vector (ADDR_WIDTH-1 downto 0);
signal  wr_data_tb  :   std_logic_vector (DATA_WIDTH-1 downto 0);
signal  rd_addr_tb  :   std_logic_vector (ADDR_WIDTH-1 downto 0);

begin

uut:    memory_async port map (
            rst_n       => rst_tb,
            wr_en_n_in  => we_n_tb,
            wr_addr_in  => wr_addr_tb,
            wr_data_in  => wr_data_tb,
            rd_addr_in  => rd_addr_tb
        );

tb:	process
begin
	wait for 1 ps;
	wr_addr_tb <= "00";
	wr_data_tb <= x"00";
    rd_addr_tb <= "00";
	we_n_tb <= '1';
    rst_tb <= '0';
    wait for 1 ps;
    rst_tb <= '1';
    wait for 1 ps;
   
-- store 0xAA on memory address 0
	wr_addr_tb <= "00";
	wr_data_tb <= x"AA";
    wait for 2 ps;
    we_n_tb <= '0';
    wait for 2 ps;
    we_n_tb <= '1';
    wait for 10 ps;

-- store 0x55 on memory address 1  
    wr_addr_tb <= "01";
	wr_data_tb <= x"55";
    wait for 2 ps;
    we_n_tb <= '0';
    wait for 2 ps;
    we_n_tb <= '1';
    wait for 10 ps;
  
-- store 0xA0 on memory address 2 
    wr_addr_tb <= "10";
	wr_data_tb <= x"A0";
    wait for 2 ps;
    we_n_tb <= '0';
    wait for 2 ps;
    we_n_tb <= '1';
    wait for 10 ps;
 
-- store 0xFF on memory address 3  
    wr_addr_tb <= "11";
	wr_data_tb <= x"FF";
    wait for 2 ps;
    we_n_tb <= '0';
    wait for 2 ps;
    we_n_tb <= '1';
    wait for 10 ps;

-- output one memory address after another on data-out    
    rd_addr_tb <= "00";
    wait for 2 ps;
    rd_addr_tb <= "01";
    wait for 2 ps;
    rd_addr_tb <= "10";
    wait for 2 ps;
    rd_addr_tb <= "11";
    wait for 2 ps;

	wait;
    
	
end process;


end architecture;