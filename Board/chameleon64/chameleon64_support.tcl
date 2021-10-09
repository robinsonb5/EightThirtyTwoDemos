set_global_assignment -name VHDL_FILE ../../../Board/chameleon64/chameleon64_top.vhd
set_global_assignment -name QIP_FILE ../../../Board/chameleon-modules/chameleonv1.qip
set_global_assignment -name SDC_FILE ../../../Board/chameleon64/constraints.sdc
set_global_assignment -name VHDL_FILE ../../../Board/chameleon64/gen_reset.vhd
set_global_assignment -name VHDL_FILE ../../../RTL/Video/video_vga_dither.vhd
set_global_assignment -name VERILOG_FILE ../../../RTL/Sound/hybrid_pwm_sd.v

set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=13"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=9"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=7500"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=60000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"

