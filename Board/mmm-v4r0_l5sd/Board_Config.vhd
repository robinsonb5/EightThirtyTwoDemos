library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package board_config is
	constant board_sdram_width : integer := 32;
	constant board_sdram_dqmwidth : integer := 4;
	constant board_sdram_rowbits : integer := 13;
	constant board_sdram_colbits : integer := 9;
	constant board_vga_bits : integer := 8;
	constant board_jtag_uart : boolean := false;
end package;

