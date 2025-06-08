
package Board_Config is
	constant Board_HaveSDRAM : boolean := true;
	constant Board_SDRAM_RowBits : integer := 11;
	constant Board_SDRAM_ColBits : integer := 8;
	constant board_sdram_width : integer := 32;
	constant board_sdram_dqmwidth : integer := 4;
	constant Board_VGA_Bits : integer := 8;
	constant Board_JTAG_Uart : boolean := false;
end package;

