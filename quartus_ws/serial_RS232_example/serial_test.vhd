library ieee ;
use ieee.std_logic_1164.all;

-- author: CZW
-- date: 20201004

ENTITY serial_test IS
	PORT (
		rx_pl2303	:	OUT	std_logic; -- TX-FPGA --> RX-PL2303
		tx_pl2303	:	IN		std_logic; -- RX-FPGA <-- TX-PL2303
		
		led1			:	OUT	std_logic;
		led2			:	OUT	std_logic
		);
END ENTITY serial_test;
-------------------------------------------------------------------------------
ARCHITECTURE behaviour OF serial_test IS

BEGIN

	led1 <= tx_pl2303;
	led2 <= tx_pl2303;
	rx_pl2303 <= tx_pl2303;

END ARCHITECTURE behaviour;