load_package flow

package require cmdline
variable ::argv0 $::quartus(args)
set options {
   { "project.arg" "" "Project name" }
   { "board.arg" "" "Target board" }
   { "frequency.arg" 0 "Fastest clock frequency" }
}
set usage "You need to specify options and values"
array set optshash [::cmdline::getoptions ::argv $options $usage]
set board $optshash(board)
set project $optshash(project)
set frequency $optshash(frequency)

if {[string length $board]==0} {return -code error "Must specify a board"}
if {[string length $project]==0} {return -code error "Must specify a project"}
if {$frequency==0} {return -code error "Must specify a frequency"}

set corename "${project}_${board}"

source ../../project_defs.tcl
source ../../../Board/${board}/${board}_defs.tcl

if { ${requires_sdram}==0 || ${have_sdram}==1 } {
	project_new $corename -revision $corename -overwrite
	set_global_assignment -name TOP_LEVEL_ENTITY ${board}_top

	source ../../../Board/${board}/${board}_opts.tcl
	source ../../../Board/${board}/${board}_pins.tcl
	source ../../../Board/${board}/${board}_support.tcl
	source ../../project_files.tcl
	set_global_assignment -name QIP_FILE ../../../PLL/${fpga}_${base_clock}_${target_frequency}/pll.qip
} else {
	puts "Board ${board} has no SDRAM, not building ${project}"
}

