library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.math_real.all;

library work;
use work.sdram_controller_pkg.all;

package sdram_writearbiter_pkg is

	constant writearbiter_ports : integer := 2;
	
	type writearbiter_port_requests is
		array(writearbiter_ports-1 downto 0) of sdram_port_request;

	type writearbiter_port_responses is
		array(writearbiter_ports-1 downto 0) of sdram_port_response;

end package;
