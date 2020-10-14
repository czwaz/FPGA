library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201014

entity memory_async is
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
end entity;

architecture behaviour of memory_async is

begin

    process (rst, write_enable_L, LED_out_pos, LED_in_data, LED_in_pos)
    
        type mem_array is array (SIZE-1 downto 0) of std_logic_vector (7 downto 0);
    
        variable mem : mem_array;
    
    begin
    
        if (rst = '0') then
            mem := (others => "00000000");
            
        elsif (write_enable_L = '0') then
            mem(LED_in_pos) := LED_in_data;
            
        end if;
        
        LED_out_data <= mem(LED_out_pos);
    
    
    end process;

end architecture;