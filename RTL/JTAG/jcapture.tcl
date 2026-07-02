# JCapture utility functions.
#
#    Copyright (c) 2025 by Alastair M. Robinson

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.



# Supported devices and the IR scan codes of their user registers

set ::jcapture::devices {
	# GW2AR-18 on TangNano 20k
	{ 0x0000081b 0x42 0x43 GW2AR }
	
	# ECP5 LFE5U25 on IceSugarPro
	{ 0x41111043 0x32 0x38 ECP5 }

	# ECP5 LFE5U45 on ULX3S
	{ 0x41112043 0x32 0x38 ECP5 }

	# ECP5 LFE5U85 on ULX3S
	{ 0x41113043 0x32 0x38 ECP5 }
	
	# ECP5 LFE5UM85 on MMM-V4R0-L5SD
	{ 0x01113043 0x32 0x38 ECP5 }

	# XC3S1600 on PanoLogic G1
	{ 0x21c3a093 0x02 0x03 {Spartan 3E}}

	# XC7K325T on QMTech Kintex 7 core board
	{ 0x43651093 0x22 0x23 {Kintex 7}}
}

set ::jcapture::irsize 5

set ::jcapture::tap ""
set ::jcapture::fields ""
set ::jcapture::capture_width 0
set ::jcapture::capture_depth 0
set ::jcapture::trigger_width 0
set ::jcapture::vir -1
set ::jcapture::vdr -1

set ::jcapture::membernames {
	"name" "width" "mask" "edge" "value"
}

# Setup function, makes a copy of the fields to be captured, and sets the tap to be used hereafter

proc ::jcapture::setup { newtap capture_fields {designid 0x35ac}} {
	# Make stdin non-blocking so we can abort captures with a keypress.
	fconfigure stdin -blocking 0

	set ::jcapture::tap $newtap
	set ::jcapture::fields ""
	set cw 0
	for {set i 0} {$i< [llength $capture_fields]} {incr i} {
		set record [lindex $capture_fields $i]
		set cw [expr {$cw + [lindex $record 1]}]
		# Add mask, edge and invert fields to capture list
		lappend record 0
		lappend record 0
		lappend record 0
		lappend ::jcapture::fields $record
	}

	# Determine Usr1 and Usr2 JTAG IR scan codes for the current device
	set id [jtag cget $::jcapture::tap -idcode]

	set v -1
	for {set i 0} {$i < [llength $::jcapture::devices]} {incr i} {
		set record [lindex $::jcapture::devices $i]
		if {[lindex $record 0] == $id} {
			set ::jcapture::vir [lindex $record 1]
			set ::jcapture::vdr [lindex $record 2]
			puts "[lindex $record 3] found - vir $::jcapture::vir, vdr $::jcapture::vdr"
			set v $i
		}
	}

	if {$v==-1} {
		puts "Device with JTAG ID $id needs to be added to jcapture.tcl."
		exit
	}

	# Fetch capture width, depth and trigger width from design
	command capturewidth
	set t [vdrscan 32 0]
	set ::jcapture::capture_width [expr 0x$t]

	command capturedepth
	set t [vdrscan 32 0]
	set ::jcapture::capture_depth [expr "2**0x$t"]

	command triggerwidth
	set t [vdrscan 32 0]
	set ::jcapture::trigger_width [expr 0x$t]

	puts "Capture width: ${::jcapture::capture_width}"
	puts "Capture depth: ${::jcapture::capture_depth}"
	puts "Trigger width: ${::jcapture::trigger_width}"

	flush_fifo

	set t [getstatus]
	scan $t %x t
	set t [expr {($t >> 4) & 0xffff}]
	if {$t != $designid} {
		puts "ID mismatch - got 0x[format %x $t], expected $designid - exiting."
		exit	
	}
	
	if {$cw != $::jcapture::capture_width} {
		puts "Warning: field mismatch - $cw bits defined but design contains $::jcapture::capture_width bits"
	}
	return $::jcapture::capture_width
}


# Virtual IR scan - shifts a value into a register attached to ER1.
# The index of these commands must match their assigned command codes in the the jcapture package.
# These system commands are mapped to bits 3:0 of the ir scan code, with bit 4 clear.
set ::jcapture::ircodes {
	"cmd" "read" "write" "setleadin" "setmask" "setinvert" "setedge" "capturewidth" "capturedepth" "triggerwidth"
	"subsample" "spare1" "spare2" "spare3" "spare4" "bypass"
}

set ::jcapture::commands {
	"nop" "sample" "capture" "abort" "flushfifo"
}

proc ::jcapture::virscan {{cmd status}} {
	set v [lsearch $::jcapture::ircodes $cmd]
	if {$v>=0} {
		irscan $::jcapture::tap $::jcapture::vir
		return [drscan $::jcapture::tap $::jcapture::irsize $v]
	} else {
		error "Unknown command $cmd";
	}
}

# User IR and DR scan
# User ir codes are transmitted with bit 4 set. Bits 3 to 0 are passed to the
# user design as the user IR code.

# Empty list of user IR codes. The user design should override this.
set ::jcapture::usercodes [list]

proc ::jcapture::userir {cmd} {
	set v [lsearch $::jcapture::usercodes $cmd]
	if {$v>=0} {
		# If bit 4 is set the jcapture module treats the lower 4 bits as the user ir code.
		set v [ expr "$v | 0x10" ]
		irscan $::jcapture::tap $::jcapture::vir
		return [drscan $::jcapture::tap $::jcapture::irsize $v]
	} else {
		error "Unknown command $cmd";
	}
}

proc ::jcapture::userdr {data} {
	return [::jcapture::vdrscan $::jcapture::capture_width $data]
}

proc ::jcapture::usercmd {cmd data} {
	::jcapture::userir $cmd
	::jcapture::userdr $data
}


proc ::jcapture::command {{comd bypass}} {
	set v [lsearch $::jcapture::commands $comd]
	if {$v>=0} {
		virscan cmd
		return [vdrscan $::jcapture::capture_width $v]
	} else {
		virscan $comd
	}
	return 0
}


# Virtual DR scan - shifts a value into a register attached to ER2
proc ::jcapture::vdrscan {c v {sp -full}} {
	if {$sp == "-full" || $sp == "-start"} {
		irscan $::jcapture::tap $::jcapture::vdr
	}
	if {$sp == "-full" || $sp == "-end"} {
#		puts "Scanning $c bits: $v"
		return [drscan $::jcapture::tap $c $v]
	}
#	puts "Scanning $c bits: $v, ending in pause state"
	return [drscan $::jcapture::tap $c $v -endstate DRPAUSE]	
}


# Flag definitions
set ::jcapture::flag_busy 0x1
set ::jcapture::flag_full 0x2
set ::jcapture::flag_empty 0x4


# Wait for the busy flag to fall 
proc ::jcapture::wait_fifobusy { } {
	set status [getstatus]
	while {[expr "0x$status & $::jcapture::flag_busy"] != 0 } {
		set status [getstatus]
	}
}

# Wait for the FIFO to fill 
proc ::jcapture::wait_fifofull { } {
	set status [getstatus]
	set done 0
	puts "FIFO status $status (Waiting for flag_full: $::jcapture::flag_full)"
	puts "Press enter to abort"
	while {$done == 0 } {
		if {[expr "0x$status & $::jcapture::flag_full"] == $::jcapture::flag_full} {
			set done 1
		}
		set line [read stdin]
		if {[string length $line] > 0} {
			puts "Aborting"
			command abort
			command flushfifo
			set done 1
		}
		set status [getstatus]
	}
	wait_fifobusy
}

# Dump the FIFO contents to the shell window
proc ::jcapture::dump_fifo { } {
	set fields [llength $::jcapture::fields]
	set status [getstatus]
	while {[expr "0x$status & $::jcapture::flag_empty"] == 0 } {
		set captures ""
		set lastfield [expr {$fields - 1}]
		
		virscan read

		for {set i 0 } {$i < $fields} {incr i} {
			set record [lindex $::jcapture::fields $i]
			set w [lindex $record 1]
			if {$i==0} {
				set d [vdrscan $w 0 -start]
			} else {
				if {$i==$lastfield} {
					set d [vdrscan $w 0 -end]
				} else {
					set d [vdrscan $w 0 -cont]
				}
			}			
			lappend captures $d
		}
				
		for {set i 0} {$i < $fields} {incr i} {
			puts -nonewline "[lindex $captures [expr {$fields - $i -1 }]] "
		}
		puts ""
		set status [getstatus]
	}
}


# Convert decimal number to the required binary code
proc ::jcapture::dec2bin {i {width {}}} {

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


# Helper function for creating VCD files - creates a unique signal name from an index.

proc ::jcapture::vcdid { c } {
	set result [format %c [expr {97 + $c % 26}]]
	set c [expr {$c / 26}]
	while { $c > 0 } {
		append result [format %c [expr {97 + $c % 26}]]
		set c [expr {$c / 26}]
	}
	return $result
}


# Create a VCD file from the capture_fields array, and write a header.

proc ::jcapture::create_vcd {filename {timezero 0}} {	
	set chan [open $filename w]
	
	puts $chan "\$version Generated by jcapture \$end"
	puts -nonewline $chan "\$date "
	puts $chan [clock format [clock seconds]]
	puts $chan " \$end"
	puts $chan "\$timescale 10ns \$end"
	puts $chan "\$timezero $timezero \$end"

	puts $chan "\$scope module TOP \$end"

	for {set i 0 } {$i < [llength $::jcapture::fields]} {incr i} {
		set record [lindex $::jcapture::fields $i]
		set w [lindex $record 1]
		if {$w > 1} {
			set wfmt "\[[expr {$w - 1}]:0\]"
		} else {
			set wfmt ""
		}
		set id [vcdid $i]
		puts $chan "\$var wire [lindex $record 1] $id [lindex $record 0] $wfmt \$end"
	}
	puts $chan {$enddefinitions $end}
	return $chan
}


# Given a hex string from OpenOCD, extract bits from the right hand edge.
# The start bit is the rightmost bit of the desired sub-field, and
# $width bits will be extracted leftwards

proc ::jcapture::extractbits {word start width} {
	set mask [expr "2 ** $width - 1"]
	
	set shift [expr "$start & 3"]
	
	set lastchar [expr "[string length $word] - $start / 4 - 1"]

	set firstchar [expr "[string length $word] - ($start + ($width - 1)) / 4 - 1"]
#	puts "mask: $mask, shift: $shift, character range: $firstchar $lastchar"
	
	set result [string range $word $firstchar $lastchar]
	set result [expr "0x$result >> $shift"]
	set result [expr "$result & $mask"]
	return $result
}

# Dump the FIFO contents to a previously-created VCD file
proc ::jcapture::fifo_to_vcd { chan } {
    puts "Dumping to VCD file"
	set fields [llength $::jcapture::fields]

	set vcdi 0
	set lastfield [expr {$fields - 1}]

	set status [getstatus]
	virscan read
	set dr [vdrscan $::jcapture::capture_width 0]
	while {[expr "0x$status & $::jcapture::flag_empty"] == 0 } {
		set captures ""

		virscan read
		set dr [vdrscan $::jcapture::capture_width 0]
		
		set comp [extractbits $dr [expr "$::jcapture::capture_width - 1"] 1 ]		
		
		if {$comp==0} {
			puts $chan "#$vcdi"

			set firstbit 0
			for {set i 0 } {$i < $fields} {incr i} {
				set record [lindex $::jcapture::fields $i]
				set w [lindex $record 1]
				
				set d [extractbits $dr $firstbit $w]
				set firstbit [expr "$firstbit + $w"]
				set id [vcdid $i]
				puts $chan "b[dec2bin $d $w] $id"
				lappend captures "b[dec2bin $d $w] $id"
			}
			incr vcdi
		} else {
			set rl [expr "[extractbits $dr 0 8] + 1"]
#			puts "$dr : $comp : $rl"
			if {$vcdi > 0} {
				for {set i 0} {$i < $rl} {incr i} {
					puts $chan "#$vcdi"
					foreach cap $captures {
						puts $chan $cap
					}
					incr vcdi
				}
			}
		}
		set status [getstatus]

	}
	puts $chan "#$vcdi"
	close $chan
}


# Silently empty the FIFO.
proc ::jcapture::flush_fifo { } {
	puts "Flushing FIFO..."
	command abort
	command flushfifo

	puts "Done"
}

proc ::jcapture::triggerconf {idx} {
	set fields [llength $::jcapture::fields]
	set lastfield [expr {$fields - 1}]
	for {set i 0} {$i < [llength $::jcapture::fields]} {incr i } {
		set record [lindex $::jcapture::fields $i]
        puts "$i - [lindex $record 0] [lindex $record $idx]"
		if {$i==0} {
			vdrscan [lindex $record 1] [lindex $record $idx] -start
		} else {
			if {$i==$lastfield} {
				vdrscan [lindex $record 1] [lindex $record $idx] -end
			} else {
				vdrscan [lindex $record 1] [lindex $record $idx] -cont
			}
		}
	}
    puts ""
}

proc ::jcapture::checktrigger { } {
	set twidth 0
	for {set i 0} {$i < [llength $::jcapture::fields]} {incr i } {
		set record [lindex $::jcapture::fields $i]
		set mask [lindex $record 2]
		set twidth [expr {$twidth + [lindex $record 1]}]
		if {$mask > 0 } {
			if {$twidth > $::jcapture::trigger_width } {
				puts "Warning: trigger fields are $twidth bits wide, the design only supports $::jcapture::trigger_width"
			}
		}
	}
}


proc ::jcapture::getstatus { } {
	command spare1
	return [vdrscan 28 0]
}


proc ::jcapture::capture { } {
	checktrigger
	command setmask
	triggerconf 2
	command setedge
	triggerconf 3
	command setinvert
	triggerconf 4
	command capture
}


proc ::jcapture::setleadin { leadin } {
	::jcapture::command setleadin
	::jcapture::vdrscan $::jcapture::capture_width $leadin
}


proc ::jcapture::settrigger {triggerparam field value} {
	set v 0
	for {set i 0} {$i < [llength $::jcapture::membernames]} {incr i} {
		if {[lindex $::jcapture::membernames $i] == $triggerparam} {
			set v $i
			set i [llength $::jcapture::membernames]
		}
	}
	if {$v > 1} {
		for {set i 0} {$i < [llength $::jcapture::fields]} {incr i } {
			set record [lindex $::jcapture::fields $i]
			if {$field == [lindex $record 0]} {
				puts "Setting $triggerparam for $field to $value"
				lset record $v $value
				lset ::jcapture::fields $i $record
				set i [llength $::jcapture::fields]
			}
		}	
	} else {
		puts "Unknown trigger parameter $triggerparam"
	}
}


# Subsampling allows the design to capture a sample every n clocks
# where n ranges from 0 to 127.
# If the strobe bit is set, the design will wait for an external strobe
# before capturing a sample.
proc ::jcapture::setsubsample {schedule {mode ""} {mode2 ""} } {
	set triggermode 0
	if {$mode=="strobe" || $mode2=="strobe"} {set triggermode 0x80}
	if {$mode=="trigger" || $mode2=="trigger"} {set triggermode [expr $triggermode | 0x40]}
    puts "Trigger mode: $triggermode"
	set v [expr "$triggermode | ($schedule & 0x3f)"]
	command subsample
	vdrscan $::jcapture::capture_width $v
	puts "Setting subsample to $v"
}


# Make the script interruptable with ctrl-c
signal handle SIGINT SIGTERM
catch -signal {
	exit
}

