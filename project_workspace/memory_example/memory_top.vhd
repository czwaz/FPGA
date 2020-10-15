library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201014

entity memory_top is
    generic (
        MEM_SIZE    :   integer := 4;
        ADDR_WIDTH  :   integer := 2; --log_2(MEM_SIZE)   
        DATA_WIDTH  :   integer := 8
    );
    port (
        rst_n       :   in  std_logic;
        clk         :   in  std_logic;
        
        we_n        :   in  std_logic;
        pos_in      :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
        -- data in not used (dummy value used for testing)
        -- addr out not used (pos_in used for testing)
        data_out    :   out std_logic_vector (DATA_WIDTH-1 downto 0);
        
        led_pos     :   out std_logic_vector (3 downto 0) -- for testing
    );
end entity;

architecture behaviour of memory_top is

--    component memory_async is
--        generic (
--            MEM_SIZE    :   integer := 4;
--            ADDR_WIDTH  :   integer := 2; --log_2(MEM_SIZE)   
--            DATA_WIDTH  :   integer := 8
--        );
--        port (
--            rst_n       :   in  std_logic;
--            wr_en_n_in  :   in  std_logic;
--            wr_addr_in  :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
--            wr_data_in  :   in  std_logic_vector (DATA_WIDTH-1 downto 0);
--            rd_addr_in  :   in  std_logic_vector (ADDR_WIDTH-1 downto 0);
--            rd_data_out :   out std_logic_vector (DATA_WIDTH-1 downto 0)
--        );
--    end component;
    
    component memory_sync is
        generic (
            MEM_SIZE    :   integer := 4;
            ADDR_WIDTH  :   integer := 2; --log_2(MEM_SIZE)   
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

    signal rst_n_sig    :   std_logic;
    signal clk_sig      :   std_logic;
    signal wr_en_n_sig  :   std_logic;
    signal wr_addr_sig  :   std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal wr_data_sig  :   std_logic_vector (DATA_WIDTH-1 downto 0);
    signal rd_addr_sig  :   std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal rd_data_sig  :   std_logic_vector (DATA_WIDTH-1 downto 0);

begin

--uut: memory_async port map (
--                    rst_n       => rst_n_sig,
--                    wr_en_n_in  => wr_en_n_sig,
--                    wr_addr_in  => wr_addr_sig,
--                    wr_data_in  => wr_data_sig,
--                    rd_addr_in  => rd_addr_sig,
--                    rd_data_out => rd_data_sig
--                  );

uut: memory_sync port map (
                    rst_n       => rst_n_sig,
                    clk         => clk_sig,
                    wr_en_n_in  => wr_en_n_sig,
                    wr_addr_in  => wr_addr_sig,
                    wr_data_in  => wr_data_sig,
                    rd_addr_in  => rd_addr_sig,
                    rd_data_out => rd_data_sig
                  );

    rst_n_sig   <= rst_n;
    clk_sig     <= clk;
    wr_en_n_sig <= we_n;
    wr_addr_sig <= not pos_in;  -- set rd and wr-addr to same value for testing
    rd_addr_sig <= not pos_in;  -- set rd and wr-addr to same value for testing
    
    wr_data_sig <= "01010101"; -- dummy value for testing
    

    data_out(DATA_WIDTH-1 downto 0) <= rd_data_sig;
    
    led_pos <= "1110" when wr_addr_sig = "00" else
               "1101" when wr_addr_sig = "01" else
               "1011" when wr_addr_sig = "10" else
               "0111";

end architecture;