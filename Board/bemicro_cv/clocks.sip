set_global_assignment -entity "clocks" -library "lib_clocks" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clocks" -library "lib_clocks" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "clocks" -library "lib_clocks" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clocks" -name SPD_FILE [file join $::quartus(sip_path) "clocks.spd"]

set_global_assignment -library "lib_clocks" -name MISC_FILE [file join $::quartus(sip_path) "clocks_sim/clocks.vho"]
