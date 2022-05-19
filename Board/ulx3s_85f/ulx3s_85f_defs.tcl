set have_sdram 1
set base_clock 25
set fpga "ECP5"
set device --85k
set device_package CABGA381
set device_speed 6

lappend verilog_files ${boardpath}/${board}/ulx3s_85f_sdram_defs.v

