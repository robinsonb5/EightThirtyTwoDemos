library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package I2C_Phy_pkg is
	type I2C_Port_Type is (NONE, EDID, SMBUS, GP0, GP1);

	type I2C_Phy_In is record
		scl : std_logic;
		sda : std_logic;	
	end record;

	type I2C_Phy_Out is record
		porttype : I2C_Port_Type;
		scl      : std_logic;
		sda      : std_logic;
	end record;

	constant i2c_out_null : I2C_Phy_out := (porttype => NONE, others => '0');

end package;

