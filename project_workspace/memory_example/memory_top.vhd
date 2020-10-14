library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- author: CZW
-- date: 20201014

entity memory_top is
    port (
       clk  :   in  std_logic;
       rst  :   in  std_logic;
       pos_in   :   in  integer range 0 to 3;
       --pos_out  :   in  integer range 0 to 3;
       data_out :   out std_logic_vector (7 downto 0);
       we_l     :   in  std_logic;
       
       led_pos  :   out std_logic_vector (3 downto 0)
    );
end entity;

architecture behaviour of memory_top is

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

    signal rst_sig  :   std_logic;
    signal write_enable_L_sig   :   std_logic;
    signal LED_in_pos_sig   :   integer range 0 to 3;
    signal LED_in_data_sig  :   std_logic_vector (7 downto 0);
    signal LED_out_data_sig :   std_logic_vector (7 downto 0);
    signal LED_out_pos_sig  :   integer range 0 to 3;

begin

uut: memory_async port map (rst => rst_sig, write_enable_L => write_enable_L_sig, LED_in_pos => LED_in_pos_sig,
                LED_in_data => LEd_in_data_sig, LED_out_data => LED_out_data_sig, LED_out_pos => LED_out_pos_sig);

    rst_sig <= rst;
    write_enable_L_sig <= we_l;
    LED_in_pos_sig <= pos_in;
    LED_out_pos_sig <= pos_in;
    
    LED_in_data_sig <= "01010101";
    

    data_out(7 downto 0) <= LED_out_data_sig;
    
    led_pos <= "1110" when LED_in_pos_sig = 0 else
                "1101" when LED_in_pos_sig = 1 else
                "1011" when LED_in_pos_sig = 2 else
                "0111";

end architecture;