set_global_assignment -name SDC_FILE ../../../Board/de2/constraints.sdc
set_global_assignment -name VERILOG_FILE ../../../Board/de2/de2_top.v
set_global_assignment -name VERILOG_FILE ../../../Board/de2/A_CODEC2.V
set_global_assignment -name VERILOG_FILE ../../../Board/de2/audio_shifter.v
set_global_assignment -name VERILOG_FILE ../../../Board/de2/audio_top.v
set_global_assignment -name VERILOG_FILE ../../../Board/de2/I2C_Controller.v
set_global_assignment -name VERILOG_FILE ../../../Board/de2/I2C_AV_Config.v
set_global_assignment -name VHDL_FILE ../../../Board/de2/Board_Config.vhd

set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=12"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=8"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=10000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=66000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"
