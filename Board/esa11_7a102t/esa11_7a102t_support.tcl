# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set xdcfile [file normalize "$origin_dir/../../../Board/esa11_7a102t/esa11_7a102t_11_phys.xdc"]
set file_added [add_files -norecurse -fileset $obj [list $xdcfile]]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$xdcfile"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

set xdcfile [file normalize "$origin_dir/../../../Board/esa11_7a102t/esa11_7a102t_ddr.xdc"]
set file_added [add_files -norecurse -fileset $obj [list $xdcfile]]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$xdcfile"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

set xdcfile [file normalize "$origin_dir/user.xdc"]
set file_added [add_files -norecurse -fileset $obj [list $xdcfile]]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$xdcfile"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "$xdcfile" -objects $obj
set_property -name "target_part" -value "xc7a100tfgg484-2" -objects $obj
set_property -name "target_ucf" -value "$xdcfile" -objects $obj

set topmodule esa11_7a102t_top

