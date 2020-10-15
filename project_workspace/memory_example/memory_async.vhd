library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201014/20201015

entity memory_async is
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
end entity;

architecture behaviour of memory_async is

begin
    -- rewrite code to don't use a process
    process (rst_n, wr_en_n_in, wr_addr_in, wr_data_in, rd_addr_in)
    
        type mem_array is array (MEM_SIZE-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
    
        variable mem : mem_array;
    
    begin
    
        if (rst_n = '0') then
            mem := (others => (others => '0'));
            
        elsif (wr_en_n_in = '0') then
            mem(to_integer(unsigned(wr_addr_in))) := wr_data_in;
            
        end if;
        
        rd_data_out <= mem(to_integer(unsigned(rd_addr_in)));
    
    end process;

end architecture;