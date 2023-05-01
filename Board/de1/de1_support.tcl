set_global_assignment -name VHDL_FILE ../../../Board/de1/de1_top.vhd
set_global_assignment -name VERILOG_FILE ../../../Board/de1/audio_shifter.v
set_global_assignment -name VERILOG_FILE ../../../Board/de1/audio_top.v
set_global_assignment -name VERILOG_FILE ../../../Board/de1/Board_Config.vhd

set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=12"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=8"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=10000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=66000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"
