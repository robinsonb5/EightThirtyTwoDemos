set_global_assignment -name VHDL_FILE ../../../Board/de10lite/Board_Config.vhd
set_global_assignment -name VHDL_FILE ../../../Board/de10lite/de10lite_top.vhd
set_global_assignment -name SDC_FILE ../../../Board/de10lite/constraints.sdc
set_global_assignment -name VHDL_FILE ../../../RTL/Video/video_vga_dither.vhd
set_global_assignment -name VERILOG_FILE ../../../RTL/Sound/hybrid_pwm_sd.v
set_global_assignment -name VERILOG_FILE ../../../RTL/Sound/hybrid_pwm_sd_2ndorder.v

set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=13"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=10"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=10000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=66000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"
