set_global_assignment -name VHDL_FILE ../../../Board/neptuno/neptuno_top.vhd
set_global_assignment -name SDC_FILE ../../../Board/neptuno/constraints.sdc
# Audio and Jostick support
set_global_assignment -name VHDL_FILE ../../../Board/neptuno/audio_i2s.vhd
set_global_assignment -name VERILOG_FILE ../../../Board/neptuno/joydecoder.v
set_global_assignment -name VHDL_FILE ../../../RTL/Video/video_vga_dither.vhd
set_global_assignment -name VERILOG_FILE ../../../RTL/Sound/hybrid_pwm_sd.v

set_global_assignment -name VERILOG_MACRO "SDRAM_WINBOND=1"
set_global_assignment -name VERILOG_MACRO "SDRAM_ROWBITS=13"
set_global_assignment -name VERILOG_MACRO "SDRAM_COLBITS=9"
set_global_assignment -name VERILOG_MACRO "SDRAM_CL=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tCKminCL2=7500"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRC=60000"
set_global_assignment -name VERILOG_MACRO "SDRAM_tWR=2"
set_global_assignment -name VERILOG_MACRO "SDRAM_tRP=15000"

set_global_assignment -name VERILOG_MACRO "DEMISTIFY_PARALLEL_AUDIO=1"
set_global_assignment -name VERILOG_MACRO "DEMISTIFY_NEPTUNO=1"
