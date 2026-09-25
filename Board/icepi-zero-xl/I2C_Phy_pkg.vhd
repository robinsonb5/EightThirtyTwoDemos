library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package I2C_Phy_pkg is
	constant i2c_ports_log2 :integer := 0;
	constant i2c_ports : integer := (2**i2c_ports_log2);
	
	type I2C_Port_Type is (NONE, EDID, SMBUS, GP0, GP1);

	type I2C_Phy_In is record
		scl : std_logic_vector(i2c_ports-1 downto 0);
		sda : std_logic_vector(i2c_ports-1 downto 0);	
	end record;

	type I2C_Phy_Out is record
		porttype : I2C_Port_Type;
		scl      : std_logic_vector(i2c_ports-1 downto 0);
		sda      : std_logic_vector(i2c_ports-1 downto 0);
	end record;

	constant i2c_out_null : I2C_Phy_out := (porttype => NONE, others => (others => '0'));

end package;

