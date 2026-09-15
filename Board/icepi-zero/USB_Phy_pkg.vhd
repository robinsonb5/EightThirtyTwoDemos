library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package USB_Phy_pkg is
	constant usb_ports_log2 :integer := 1;
	constant usb_ports : integer := (2**usb_ports_log2);

	type USB_Phy_In is record
		dp : std_logic_vector(usb_ports-1 downto 0);
		dm : std_logic_vector(usb_ports-1 downto 0);	
	end record;

	type USB_Phy_Out is record
		dp : std_logic_vector(usb_ports-1 downto 0);
		dm : std_logic_vector(usb_ports-1 downto 0);
		oe : std_logic_vector(usb_ports-1 downto 0);
	end record;
	
end package;

