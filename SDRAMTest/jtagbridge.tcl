#!/opt/intelFPGA_lite/18.1/quartus/bin/quartus_stp -t

#   jtagbridge.tcl - Virtual JTAG proxy for Altera devices
#  
#   Based on Binary Logic's vjtag example code.
#   
#   This file is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

###################### Parameters ###########################


###################### Code #################################

# Setup connection
proc setup_blaster {} {
	global usbblaster_name
	global test_device

	# List all USB-Blasters connected to the system.  If there's only one
	# use that, otherwise prompt the user to choose one.
	set count 0
	foreach hardware_name [get_hardware_names] {
		if {
			[string match "USB-Blaster*" $hardware_name] ||
			[string match "*SoC*" $hardware_name] ||
			[string match "*MAX*" $hardware_name] } {
			puts "Device $count: $hardware_name"
			set usbblaster_name $hardware_name
			set count [expr $count + 1]
		}
	}

	if {$count==0} {
		puts "No JTAG interfaces found"
		exit
	}
	if {$count!=1} {
		puts "More than one USB-Blaster found - please select a device."
		gets stdin id
		scan $id "%d" idno
		set count 1
		foreach hardware_name [get_hardware_names] {
			if {
				[string match "USB-Blaster*" $hardware_name] ||
				[string match "*SoC*" $hardware_name] ||
				[string match "*MAX*" $hardware_name] } {
				if { $count == $idno } {
					puts "Selected $hardware_name"
					set usbblaster_name $hardware_name
				}
				set count [expr $count + 1]
			}
		}
	}


	# List all devices on the chain.  If there's only one, select that,
	# otherwise prompt the user to select one.

	puts "Devices on JTAG chain:";
	set count 0
	foreach device_name [get_device_names -hardware_name $usbblaster_name] {
		puts "Candidate: $device_name"
		if { [string match "*: EP*C*" $device_name] } {
			puts "Found Cyclone II or III"
			set test_device $device_name
			set count [expr $count + 1]
		}
		if { [string match "*: 10CL*" $device_name] } {
			puts "Found Cyclone 10LP"
			set test_device $device_name
			set count [expr $count + 1]
		}
		if { [string match "*: 10M*" $device_name] } {
			puts "Found MAX10"
			set test_device $device_name
			set count [expr $count + 1]
		}
		if { [string match "*: 5CSE*" $device_name] } {
			puts "Found Cyclone V"
			set test_device $device_name
			set count [expr $count + 1]
		}
	}

	if {$count!=1} {
		puts "Please select a device.";
		gets stdin id
		foreach device_name [get_device_names -hardware_name $usbblaster_name] {
			if { [string match "@$id*" $device_name] } {
				set test_device $device_name
			}
		}
	}
	puts "Selected $test_device.";
}

# Open device 
proc openport {} {
	global usbblaster_name
	global test_device
	set res 1
	if [ catch { open_device -hardware_name $usbblaster_name -device_name $test_device } ] { set res 0 }

	# Set IR to 0, which is bypass mode - which has the side-effect of verifying that there's a suitable JTAG instance.
	catch { device_lock -timeout 10000 }
	if [ catch { device_virtual_ir_shift -instance_index 0 -ir_value 3 -no_captured_ir_value } ] {
		set res 0
		catch {device_unlock}
		catch {close_device}
	}
	return $res
}


# Close device.  Just used if communication error occurs
proc closeport { } {
	global usbblaster_name
	global test_device

	# Set IR back to 0, which is bypass mode
	catch { device_virtual_ir_shift -instance_index 0 -ir_value 3 -no_captured_ir_value }

	catch {device_unlock}
	catch {close_device}
}

# Convert decimal number to the required binary code
proc dec2bin {i {width {}}} {

    set res {}
    if {$i<0} {
        set sign -
        set i [expr {abs($i)}]
    } else {
        set sign {}
    }
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res == {}} {set res 0}

    if {$width != {}} {
        append d [string repeat 0 $width] $res
        set res [string range $d [string length $res] end]
    }
    return $sign$res
}

# Convert a binary string to a decimal/ascii number
proc bin2dec {bin} {
    if {$bin == 0} {
        return 0
    } elseif {[string match -* $bin]} {
        set sign -
        set bin [string range $bin[set bin {}] 1 end]
    } else {
        set sign {}
    }
    return $sign[expr 0b$bin]
}

# Send data to the Altera input FIFO buffer
proc send {chr} {
	if [ catch { device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value } ] { return -1 }
	device_virtual_dr_shift -dr_value [dec2bin $chr 32] -instance_index 0  -length 32 -no_captured_dr_value
	return 1
}

# Read data in from the Altera output FIFO buffer
proc recv {} {
	# Check if there is anything to read
	if [ catch { device_virtual_ir_shift -instance_index 0 -ir_value 2 -no_captured_ir_value } ] { return -1 }
	set tdi [device_virtual_dr_shift -dr_value 0000 -instance_index 0 -length 4]
	if {![expr $tdi & 1]} {
		device_virtual_ir_shift -instance_index 0 -ir_value 0 -no_captured_ir_value
		set tdi [device_virtual_dr_shift -dr_value 00000000000000000000000000000000 -instance_index 0 -length 32]
		return [bin2dec $tdi]
	} else {
		return -1
	}
}

# Read data in from the Altera output FIFO buffer
proc recv_blocking {} {
	while {1} {
		if [ catch { device_virtual_ir_shift -instance_index 0 -ir_value 2 -no_captured_ir_value } ] { return [ bin2dec 0 ] }
		set tdi [device_virtual_dr_shift -dr_value 0000 -instance_index 0 -length 4]
#		puts $tdi
		if {![expr $tdi & 1]} {
			device_virtual_ir_shift -instance_index 0 -ir_value 0 -no_captured_ir_value
			set tdi [device_virtual_dr_shift -dr_value 00000000000000000000000000000000 -instance_index 0 -length 32]
			return [bin2dec $tdi]
		}
	}
}

####################### Main code ###################################

global usbblaster_name
global test_device
global wait_connection

# Find the USB Blaster
setup_blaster

# Start the server socket

# Loop forever

fconfigure stdin -blocking 0

puts "\nType 'q' then enter to quit.  Type 'r' then enter to reset (not yet reliable)"
puts "\n\n\n\n\n"

puts "\x1b\[?25l"
puts "\x1b\[7B"
gets stdin keystrokes
while {$keystrokes != "q" } {
	gets stdin keystrokes
	if [ openport ] {
		puts "\x1b\[7A"
		for {set i 0} {$i<5} {incr i} {
			send $i
			set reads [recv_blocking]
			set errors [recv_blocking]
			set errbits [format %x [recv_blocking]]
			puts "\x1b\[Kport $i\treads: $reads\terrors: $errors\terror bits: $errbits"
		}
		if {$keystrokes != ""} {
			while { [recv]>=0 } { }
			if {$keystrokes == "r"} {
				send 255
			}

			puts "\x1b\[2A"
		}
		puts "\x1b\[K"
		while { [recv]>=0 } { }
		closeport
	}
}
puts "\x1b\[?25h"

##################### End Code ########################################

