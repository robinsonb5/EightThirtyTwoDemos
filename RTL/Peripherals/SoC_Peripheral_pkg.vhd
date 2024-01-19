library ieee;
use ieee.std_logic_1164.all;

library work;
use work.SoC_Peripheral_config.all;

package SoC_Peripheral_pkg is

	type SoC_Peripheral_Request is record
		addr : std_logic_vector(31 downto 0); -- from host CPU
		d : std_logic_vector(31 downto 0);
		wr : std_logic;
		req : std_logic;
	end record;

	type SoC_Peripheral_Response is record
		ack : std_logic;
		q : std_logic_vector(31 downto 0);
	end record;

	constant SoC_Peripheral_Response_Idle : SoC_Peripheral_Response := (
		ack => '0',
		others => (others => 'X')
	);

	subtype SoC_Block_Range is natural range SoC_Block_HighBit downto SoC_Block_LowBit;
	subtype SoC_Register_Range is natural range SoC_Register_HighBit downto SoC_Register_LowBit;

end package;

