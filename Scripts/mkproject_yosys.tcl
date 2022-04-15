set board [lindex $argv 1]
set project [lindex $argv 0]

set origin_dir "."
set orig_proj_dir "."

if {[string length $board]==0} {return -code error "Must specify a board"}
if {[string length $project]==0} {return -code error "Must specify a project"}

set corename "${project}"

source ../../project_defs.tcl
source ${boardpath}/${board}/${board}_defs.tcl
if { [info exists target_frequency_lattice] == 0 } {set target_frequency_lattice $target_frequency}

puts $corename

if { ${requires_sdram}==1 && ${have_sdram}==0 } {
	puts "Board ${board} doesn't have SDRAM, skipping project generation for ${project}"
	exit
}

# Add source files to the project
source ${corename}_${board}_files.tcl

# Add clocks to the project
lappend verilog_files "${boardpath}/../PLL/${fpga}_${base_clock}_${target_frequency_lattice}/pll.v"

# Bring in any standard files or definitions required by the board.
source ${boardpath}/${board}/${board}_support.tcl

# Parse HDL files
if {[info exists vhdl_files]} {
	foreach {f} $vhdl_files {
		exec ghdl -a $f
	}
}
if { [info exists vhdl_hierarchies] == 1 } {
	foreach {h} $vhdl_hierarchies {
		yosys ghdl $h
	}
}
if {[info exists verilog_files]} {
	foreach {f} $verilog_files {
		yosys read_verilog -sv $f
	}
}
yosys ghdl ${topmodule}
# Create .json file
yosys synth_ecp5 -top ${topmodule} -json ${corename}.json
# yosys hierarchy -top ${topmodule}
# yosys proc
# yosys scc -specify

