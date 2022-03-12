load_package flow

package require cmdline
variable ::argv0 $::quartus(args)
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
source ${boardpath}${board}/${board}_defs.tcl

if { [info exists target_frequency_altera] == 0 } {set target_frequency_altera $target_frequency}

if { ${requires_sdram}==0 || ${have_sdram}==1 } {
	project_new $corename -revision $corename -overwrite
	set_global_assignment -name TOP_LEVEL_ENTITY ${board}_top

	source ${boardpath}${board}/${board}_opts.tcl
	source ${boardpath}${board}/${board}_pins.tcl
	source ${boardpath}${board}/${board}_support.tcl
	source ${corename}_files.tcl
	set_global_assignment -name QIP_FILE ${boardpath}/../PLL/${fpga}_${base_clock}_${target_frequency_altera}/pll.qip
} else {
	puts "Board ${board} has no SDRAM, not building ${project}"
}

