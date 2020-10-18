library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201018

entity tb_memory_sync is
    generic (
        ADDR_WIDTH  :   integer := 2; 
        DATA_WIDTH  :   integer := 8
    );
end entity;

architecture tb of tb_memory_sync is

    component memory_sync is
        generic (
            ADDR_WIDTH  :   integer := 2;
            DATA_WIDTH  :   integer := 8
        );
        port (
            rst_n       :   in  std_logic;
            clk         :   in  std_logic;
            wr_en_n_in  :   in  std_logic;
            wr_addr_in  :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            wr_data_in  :   in  std_logic_vector (DATA_WIDTH-1 downto 0);
            rd_addr_in  :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            rd_data_out :   out std_logic_vector (DATA_WIDTH-1 downto 0)
        );
    end component;
    
signal  rst_n_tb        :   std_logic;
signal  clk_tb          :   std_logic;
signal  wr_en_n_in_tb   :   std_logic;
signal  wr_addr_in_tb   :   std_logic_vector (ADDR_WIDTH-1 downto 0);
signal  wr_data_in_tb   :   std_logic_vector (DATA_WIDTH-1 downto 0);
signal  rd_addr_in_tb   :   std_logic_vector (ADDR_WIDTH-1 downto 0);
signal	rd_data_out_tb	:	std_logic_vector (DATA_WIDTH-1 downto 0);

begin

uut:    memory_sync port map (
            rst_n       =>  rst_n_tb,
            clk         =>  clk_tb,
            wr_en_n_in  =>  wr_en_n_in_tb,
            wr_addr_in  =>  wr_addr_in_tb,
            wr_data_in  =>  wr_data_in_tb,
            rd_addr_in  =>  rd_addr_in_tb,
			rd_data_out	=>	rd_data_out_tb
            );
            
tb_clk: process
begin
    clk_tb  <=  '0';
    wait for 3.33 ns;
    clk_tb  <=  '1';
    wait for 3.33 ns;
end process;


tb: process
begin
    rst_n_tb <= '0';
    wait for 5 ns;
    rst_n_tb <= '1';
    wait for 5 ns;
	wr_en_n_in_tb <= '1';
	wr_addr_in_tb <= (others => '0');
	wr_data_in_tb <= (others => '0');
	rd_addr_in_tb <= (others => '0');

	wait for 10 ns;
	wr_addr_in_tb <= "00";
	wr_data_in_tb <= x"11";
	wr_en_n_in_tb <= '0';
	wait for 10 ns;
	wr_en_n_in_tb <= '1';
	wait for 20 ns;

	wr_addr_in_tb <= "01";
	wr_data_in_tb <= x"22";
	wr_en_n_in_tb <= '0';
	wait for 10 ns;
	wr_en_n_in_tb <= '1';
	wait for 20 ns;

	wr_addr_in_tb <= "10";
	wr_data_in_tb <= x"33";
	wr_en_n_in_tb <= '0';
	wait for 10 ns;
	wr_en_n_in_tb <= '1';
	wait for 20 ns;

	wr_addr_in_tb <= "11";
	wr_data_in_tb <= x"44";
	wr_en_n_in_tb <= '0';
	wait for 10 ns;
	wr_en_n_in_tb <= '1';
	wait for 20 ns;



	wait for 10 ns;
	rd_addr_in_tb <= "01";
	wait for 10 ns;
	rd_addr_in_tb <= "10";
	wait for 10 ns;
	rd_addr_in_tb <= "11";
	wait for 10 ns;
	rd_addr_in_tb <= "00";


	wait;
end process;


end architecture;