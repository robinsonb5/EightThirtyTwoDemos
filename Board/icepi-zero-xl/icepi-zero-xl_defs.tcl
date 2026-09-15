set have_sdram 1
set base_clock 50
set vendor "lattice_yosys"
set fpga "ECP5"
set device --45k
set device_package CABGA256
set device_speed 6

lappend verilog_files ${boardpath}/${board}/icepi-zero-xl_sdram_defs.v

