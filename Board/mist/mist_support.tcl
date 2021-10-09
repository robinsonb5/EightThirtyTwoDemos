set_global_assignment -name VHDL_FILE ../../../Board/mist/mist_top.vhd
set_global_assignment -name SDC_FILE ../../../Board/mist/constraints.sdc
set_global_assignment -name VERILOG_FILE ../../../Board/mist/osd.v
set_global_assignment -name VERILOG_FILE ../../../Board/mist/user_io.v
set_global_assignment -name VERILOG_FILE ../../../Board/mist/sd_card.v
set_global_assignment -name VERILOG_FILE ../../../Board/mist/mist_console.v
set_global_assignment -name VHDL_FILE ../../../RTL/Video/video_vga_dither.vhd
set_global_assignment -name VERILOG_FILE ../../../RTL/Sound/hybrid_pwm_sd.v

set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=13"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=9"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=10000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=66000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"
