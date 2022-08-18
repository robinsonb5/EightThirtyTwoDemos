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

end package;

