#! ./oocd.sh
#
# IceSugarPro demo JTAG script
#

init
scan_chain

# 16-bit project ID, so we can be sure we're capturing from the correct design
set projectid 0xaa55

# The total number of bits here must match the width defined in jcapture_pkg.vhd
source ./capturefields.tcl

set loc [file dirname [file normalize [info script]]]
source ${loc}/../../RTL/JTAG/jcapture.tcl

# Enumerate user IR codes, starting at 0
set ::jcapture::usercodes {
	
}

puts "Setting TAP, capture fields and length"

::jcapture::setup target.tap $capture_fields $projectid

puts "Initial status: [::jcapture::getstatus]"

# Set up triggers

::jcapture::settrigger mask d_stb 1
::jcapture::settrigger edge d_stb 0
::jcapture::settrigger value d_stb 1

#::jcapture::settrigger mask usb_in_dp 3
#::jcapture::settrigger edge usb_in_dp 0
#::jcapture::settrigger value usb_in_dp 1


::jcapture::setsubsample 0

puts "Recording to cap.vcd"

	set chan [::jcapture::create_vcd cap.vcd 0]
	::jcapture::setleadin 0

	puts "About to capture - status: [::jcapture::getstatus]"

	::jcapture::capture
	::jcapture::wait_fifofull
	::jcapture::fifo_to_vcd $chan 
exit
