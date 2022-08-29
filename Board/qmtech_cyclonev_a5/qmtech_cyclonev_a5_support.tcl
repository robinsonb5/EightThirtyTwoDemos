set_global_assignment -name SDC_FILE  ${boardpath}/qmtech_cyclonev_a5/constraints.sdc
set_global_assignment -name VHDL_FILE ../../../Board/qmtech_cyclonev_a5/Board_Config.vhd
set_global_assignment -name VHDL_FILE ../../../Board/qmtech_cyclonev_a5/qmtech_cyclonev_a5_top.vhd
set_global_assignment -name VHDL_FILE ../../../RTL/Video/video_vga_dither.vhd
set_global_assignment -name VERILOG_FILE ../../../RTL/Sound/hybrid_pwm_sd.v

set_global_assignment -name VERILOG_MACRO "SDRAM_WINBOND=1"
set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=13"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=9"
set_global_assignment -name VERILOG_MACRO "SDRAM_CL=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=7518"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=66000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"

# set_global_assignment -name VERILOG_MACRO "DEMISTIFY_C64_KEYBOARD=1"
set_global_assignment -name VERILOG_MACRO "DEMISTIFY_PS2_KEYBOARD=1"

