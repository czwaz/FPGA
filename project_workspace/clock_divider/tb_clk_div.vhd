library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

-- author: CZW
-- date: 20201011

entity tb_clk_div is
end;

architecture tb of tb_clk_div is

    COMPONENT clk_div
        GENERIC (
            CLK_FREQ_IN		    :	INTEGER := 48000000;
            CLK_GOAL_1		    :	INTEGER := 480000
        );
        PORT (
            rst_n			    :	IN	std_logic;
            clk 			    :	IN	std_logic;
            clk_480_KHz_out	    :	OUT	std_logic; -- 480 KHz
            clk_div32_out		:	OUT	std_logic; -- 1,5 MHz
            clk_div64_out		:	OUT	std_logic; -- 750 KHz
            clk_div128_out		:	OUT	std_logic; -- 375 KHz
            clk_div256_out		:	OUT	std_logic; -- 187,5 KHz
            clk_div512_out		:	OUT	std_logic; -- 93,750 KHz
            clk_div1024_out		:	OUT	std_logic; -- 46,875 KHz
            clk_div4096_out		:	OUT	std_logic; -- 11,718 KHz
            clk_div16384_out	:	OUT	std_logic; -- 2,929 KHz
            clk_div65536_out	:	OUT	std_logic  -- 732,42 Hz
        );
    END COMPONENT;

SIGNAL clk_tb	: std_logic := '0';
SIGNAL rst_tb	: std_logic := '1';

begin

dut : clk_div PORT MAP (
            clk => clk_tb,
            rst_n => rst_tb
        );

clock : PROCESS
	begin
	wait for 10.4166666666667 ns; clk_tb <= not clk_tb;
end PROCESS clock;


end tb;
