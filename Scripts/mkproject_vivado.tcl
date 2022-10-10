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

set origin_dir "."
set orig_proj_dir "."

if {[string length $board]==0} {return -code error "Must specify a board"}
if {[string length $project]==0} {return -code error "Must specify a project"}

set corename "${project}"
set _xil_proj_name_ $corename

source ../../project_defs.tcl
source ${boardpath}/${board}/${board}_defs.tcl
if { [info exists target_frequency_xilinx] == 0 } {set target_frequency_xilinx $target_frequency}

create_project ${_xil_proj_name_} . -part $device_full -force

puts $corename

if { ${requires_sdram}==1 && ${have_sdram}==0 } {
	puts "Board ${board} doesn't have SDRAM, skipping project generation for ${project}"
	exit
}

# Add source files to the project
if {[string equal [get_filesets -quiet sources_1] ""]} {
	create_fileset -srcset sources_1
}
set obj [get_filesets sources_1]
source ${corename}_files.tcl
add_files -norecurse -fileset $obj $files
add_files -norecurse -scan_for_includes -fileset $obj ${boardpath}../PLL/${fpga}_${base_clock}_${target_frequency_xilinx}/pll.v

# Set the type of each file
foreach ifile $files {
	set ext [file extension $ifile]
	if {[string compare -nocase $ext ".vhd"] == 0} {set type "VHDL"}
	if {[string compare -nocase $ext ".v"] == 0} {set type "Verilog"}
	if {[string compare -nocase $ext ".vh"] == 0} {set type "Verilog Header"}
	if {[string compare -nocase $ext ".sv"] == 0} {set type "SystemVerilog"}
	if {[string compare -nocase $ext ".svh"] == 0} {set type "Verilog Header"}
	set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$ifile"]]
	set_property -name "file_type" -value $type -objects $file_obj
}

# Bring in any standard files required by the board.
set fpgatoolchain "vivado"
source ${boardpath}/${board}/${board}_support.tcl

set_property top -value $topmodule -objects [get_filesets sources_1]

if {[info exists sim_topmodule]} {
	# Add sim files to the project
	if {[string equal [get_filesets -quiet sim_1] ""]} {
		create_fileset -srcset sim_1
	}
	set obj [get_filesets sim_1]
	source ${corename}_sim_files.tcl
	add_files -norecurse -fileset $obj $files

	# Set the type of each file
	foreach ifile $files {
		set ext [file extension $ifile]
		if {[string compare -nocase $ext ".vhd"] == 0} {set type "VHDL"}
		if {[string compare -nocase $ext ".v"] == 0} {set type "Verilog"}
		if {[string compare -nocase $ext ".vh"] == 0} {set type "Verilog Header"}
		if {[string compare -nocase $ext ".sv"] == 0} {set type "SystemVerilog"}
		if {[string compare -nocase $ext ".svh"] == 0} {set type "Verilog Header"}
		set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$ifile"]]
		set_property -name "file_type" -value $type -objects $file_obj
	}
	set_property top -value $sim_topmodule -objects [get_filesets sim_1]

	add_files -norecurse -scan_for_includes -fileset $obj ${boardpath}../PLL/${fpga}_${base_clock}_${target_frequency_xilinx}/pll.v
}

if {[file exists "../../overrides_vivado.tcl"]} {
	source "../../overrides_vivado.tcl"
}

update_compile_order -fileset sources_1

close_project

