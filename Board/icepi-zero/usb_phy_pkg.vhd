library ieee;
use ieee.std_logic_1164.all;

package usb_phy_pkg is

	constant usb_phy_ports : integer := 2;

	type usb_phy_inout is record
		dp : std_logic_vector(usb_phy_ports-1 downto 0);
		dm : std_logic_vector(usb_phy_ports-1 downto 0);
	end record;

end package;
