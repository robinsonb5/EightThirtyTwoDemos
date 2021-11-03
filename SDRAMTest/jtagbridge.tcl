#!/opt/intelFPGA_lite/18.1/quartus/bin/quartus_stp -t

#   jtagbridge.tcl - Virtual JTAG proxy for Altera devices

source [file dirname [info script]]/../EightThirtyTwo/tcl/vjtagutil.tcl

####################### Main code ###################################

global vjtag_instance

# Find the USB Blaster
usbblaster_setup
set vjtag_instance [vjtag_findinstance 0x55aa]

if {$vjtag_instance<0} {
	puts "Error - couldn't open virtual JTAG instance"
	exit
}
# Loop forever

fconfigure stdin -blocking 0

puts "\nType 'q' then enter to quit.  Type 'r' then enter to reset (not yet reliable)"
puts "\n\n\n\n\n"

puts "\x1b\[?25l"
puts "\x1b\[7B"
gets stdin keystrokes
while {$keystrokes != "q" } {
	gets stdin keystrokes
	if [ usbblaster_open $vjtag_instance ] {
		puts "\x1b\[7A"
		for {set i 0} {$i<5} {incr i} {
			vjtag_send $vjtag_instance $i
			set reads [vjtag_recv_blocking $vjtag_instance]
			set errors [vjtag_recv_blocking $vjtag_instance]
			set errbits [format %x [vjtag_recv_blocking $vjtag_instance]]
			puts "\x1b\[Kport $i\treads: $reads\terrors: $errors\terror bits: $errbits"
		}
		if {$keystrokes != ""} {
			while { [vjtag_recv $vjtag_instance]>=0 } { }
			if {$keystrokes == "r"} {
				vjtag_send $vjtag_instance 255
			}

			puts "\x1b\[2A"
		}
		puts "\x1b\[K"
		while { [vjtag_recv $vjtag_instance]>=0 } { }
		usbblaster_close $vjtag_instance
	}
}
puts "\x1b\[?25h"

##################### End Code ########################################

