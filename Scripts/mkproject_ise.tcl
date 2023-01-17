proc xcofile_add {xcofile} {
	file mkdir ip_cores
	file copy $xcofile ip_cores/[file tail $xcofile]
	xfile add "ip_cores/[file tail $xcofile]"
}

package require cmdline
variable ::argv0
set options {
   { "project.arg" "" "Project name" }
   { "board.arg" "" "Target board" }
}
set usage "You need to specify options and values"
array set optshash [::cmdline::getoptions ::argv $options $usage]
set board $optshash(board)
set project $optshash(project)

if {[string length $board]==0} {return -code error "Must specify a board"}
if {[string length $project]==0} {return -code error "Must specify a project"}

set corename "${project}_${board}"

source ../../project_defs.tcl
source ${boardpath}/${board}/${board}_defs.tcl

if { [info exists target_frequency_xilinx] == 0 } {set target_frequency_xilinx $target_frequency}

if { ${requires_sdram}==0 || ${have_sdram}==1 } {
	project new ${corename}.xise
	project set family "${fpga}"
	project set device "${device}"
	project set package "${device_package}"
	project set speed "${device_speed}"
	project set top_level_module_type "HDL"
	project set synthesis_tool "XST (VHDL/Verilog)"
	project set simulator "ISim (VHDL/Verilog)"
	project set "Preferred Language" "VHDL"
	project set "Enable Message Filtering" "false"

	set fpgatoolchain "ise"

	source ${boardpath}/${board}/${board}_support.tcl
	source ${corename}_files.tcl
	xfile add ${boardpath}../PLL/${fpga}_${base_clock}_${target_frequency_xilinx}/pll.${pll_extension}
	if ${requires_sdram}==1 {
		xfile add ${boardpath}/${board}/sdram_iobs.ucf
	} else {
		puts "Project doesn't require SDRAM, omitting sdram_iobs.ucf"
	}
	project save
	project close
} else {
	puts "Board ${board} has no SDRAM, not building ${project}"
}

