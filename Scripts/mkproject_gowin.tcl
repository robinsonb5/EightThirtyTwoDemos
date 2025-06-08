if {$argc!=2} {
	puts "Must specify board and project as arguments."
	exit
}
puts $argv
set project [lindex $argv 0]
set board [lindex $argv 1]

puts "Board $board, Project $project"

set origin_dir "."
set orig_proj_dir "."

if {[string length $board]==0} {return -code error "Must specify a board"}
if {[string length $project]==0} {return -code error "Must specify a project"}

set corename "${project}"
set _proj_name_ ${board}

source ../../project_defs.tcl
source ${boardpath}/${board}/${board}_defs.tcl
if { [info exists target_frequency_gowin] == 0 } {set target_frequency_gowin $target_frequency}

create_project -name ${_proj_name_} -dir ../ -force -pn $device_full -device_version C

puts $corename

if { ${requires_sdram}==1 && ${have_sdram}==0 } {
	puts "Board ${board} doesn't have SDRAM, skipping project generation for ${project}"
	exit
}

set_device $device_full -name $fpga
set_option -synthesis_tool gowinsynthesis
set_option -output_base_name $corename
set_option -verilog_std sysv2017
set_option -top_module top
set_option -use_mspi_as_gpio 1
set_option -use_sspi_as_gpio 1

# Add source files to the project
source ${corename}_files.tcl

# Bring in any standard files required by the board.
set fpgatoolchain "gw_sh"
source ${boardpath}/${board}/${board}_support.tcl

set_option -top_module $topmodule

add_file ${boardpath}../PLL/${fpga}_${base_clock}_${target_frequency_gowin}/pll.v

if {[file exists "../../overrides_gowin.tcl"]} {
	source "../../overrides_gowin.tcl"
}
run all
run close

