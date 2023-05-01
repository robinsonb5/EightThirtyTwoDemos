library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package board_config is
	constant board_sdram_width : integer := 16;
	constant board_sdram_dqmwidth : integer := 2;
	constant board_sdram_rowbits : integer := 12;
	constant board_sdram_colbits : integer := 8;
	constant board_vga_bits : integer := 8;
	constant board_jtag_uart : boolean := false;
end package;

