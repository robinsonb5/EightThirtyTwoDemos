package Board_Config is
	constant board_sdram_width : integer := 16;
	constant Board_HaveSDRAM : boolean := true;
	constant Board_SDRAM_RowBits : integer := 13;
	constant Board_SDRAM_ColBits : integer := 9;
	constant Board_VGA_Bits : integer := 6;
	constant Board_JTAG_Uart : boolean := false;
	constant Board_TechLevel : integer := 6;
end package;
