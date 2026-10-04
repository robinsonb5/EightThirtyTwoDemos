library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package board_config is
	constant board_sdram_width : integer := 16;
	constant board_sdram_rowbits : integer := 13;
	constant board_sdram_colbits : integer := 9;
	constant board_vga_bits : integer := 8;
	constant board_jtag_uart : boolean := false;
	
	constant board_have_usb : boolean := true;
	constant board_have_i2c : boolean := true;
	
	constant spi_device_count : integer := 4;
	constant SPI_DEVICE_SDCARD : integer := 0;
	constant SPI_DEVICE_FLASH : integer := 1;
	constant SPI_DEVICE_AUX1 : integer := 2;
	constant SPI_DEVICE_AUX2 : integer := 3;

	constant board_spi_devices : std_logic_vector(spi_device_count-1 downto 0) := (
		SPI_DEVICE_SDCARD => '1',
		SPI_DEVICE_AUX1 => '1',
		SPI_DEVICE_AUX2 => '1',
		others => '0' );

end package;

