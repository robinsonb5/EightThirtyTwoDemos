set_global_assignment -name FAMILY "Cyclone II"
set_global_assignment -name DEVICE EP2C35F672C6
set_global_assignment -name ORIGINAL_QUARTUS_VERSION "12.0 SP1"
set_global_assignment -name PROJECT_CREATION_TIME_DATE "00:14:38  JUNE 09, 2013"
set_global_assignment -name LAST_QUARTUS_VERSION "13.0 SP1"
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to I2C_SCLK
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to I2C_SDAT
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to *
set_instance_assignment -name FAST_INPUT_REGISTER ON -to *
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to *
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE stp1.stp
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
set_global_assignment -name STRATIX_CONFIGURATION_DEVICE EPCS16
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

