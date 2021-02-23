# EightThirtyTwoDemos
Demo projects for the EightThirtyTwo CPU

Copyright 2020, 2021 by Alastair M. Robinson

This repository contains a number of example projects using the EightThirtyTwo CPU
in various configurations, demonstrating usage both as a standalone CPU running
from ROM, and a more complete System-on-Chip with support for SDRAM and VGA video,
bootstrapping a larger application from both RS232 and SDRAM.

A number of boards are supported, mostly Altera/Intel based, but with preliminary
support for a Xilinx Spartan 6 board, too.

## License

    EightThirtyTwoDemos is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

	The startup code and minimal C library, lib832, is licensed under the
	terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

	EightThirtyTwoDemos distributed in the hope that they will
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with EightThirtyTwoDemos.  If not, see <https://www.gnu.org/licenses/>.

## Building:
Because the toolchains from each vendor only tend to support a subset of devices
the supplied makefiles are set up to reference the tools by path.  This allows
multiple versions to co-exist on a single system, but means that you will need 
to configure the Makefile for your system.
To do this, simply copy the site.template file to site.mk, then edit and adjust
the paths accordingly.
If there are any boards for which you don't want to build the cores (perhaps because
you don't have them, or don't have the toolchain for them), simply remove them from
the BOARDS defines at the top of the file.

Having done this, the makefile will attempt to build the projects for any boards
which are still enabled in site.mk.

You can build a specific subset of projects if you wish, simply by defining the
PROJECTS variable when invoking make, like so:

&gt; make PROJECTS=HelloWorld

You can also make just the project files with
&gt; make init
and compile with
&gt; make compile

## Projects:

### HelloWorld:
A simply assembly-language program which sends the archetypal "Hello, World!" string 
to a serial port. (RS232, TTL, LVTTL or USB depending on the board.)

### LZ4:
Similar to HelloWorld, this project decompresses some LZ4-compressed text to serial,
demonstrating the code-density of 832 assembly language.

### VGA:
This project sets up and fills a simple VGA framebuffer.  Requires SDRAM, so won't
be built for boards which don't have it.

### Interrupts:
Similar to the VGA demo, this project sets up and fills a simple VGA framebuffer but
also sets up a vblank interrupt to scroll it.  Requires SDRAM, so won't
be built for boards which don't have it.

### Dhrystone:
The firmware for this project is written in C and compiled using the vbcc backend.
Runs the archetypal Dhrystone benchmark program and prints the results to serial.

### Dhrystone_DualThread:
This project runs the CPU in dual-thread mode, and runs two Dhrystone benchmarks
concurrently, printing the results to serial.

### QuadCore:
The firmware for this demo in a dual-port RAM, allowing two copies of the CPU
to run from the same ROM.  Each CPU is running in dual thread mode, allowing four
threads in total.  The project includes some simple thread-synchronisation,
and each thread greets the user over serial in turn.

### Debug:
A project demonstrating the use of 832's debug interface, which allows the
832ocd program to connect to the CPU over JTAG, using quartus_stp as a bridge.
Currently this is Altera/Intel only, though there's no reason why something
similar wouldn't be possible with Xilinx parts.

### SoC:
This project includes a System-on-Chip with VGA framebuffer, PS/2 keyboard and
mouse and audio capabilities.
The CPU runs in dualthread mode, so single- or dual-thread applications can be run.
The bootcode will attempt to load from SDCARD, but if unsuccessful will boot from
an S-record uploaded over serial.

## Applications:

### HelloWorld:
A simple Hellow World program written in C

### Dhrystone:
The Dhrystone demo compiled as an application which will run from SDRAM rather than
ROM.  For this reason it's somewhat slower than the ROM-based version.

### Dhrystone_Dual:
As above, but running two copies of the benchmark concurrently.

### Malloc:
A test program for a malloc implementation.  The amount of system memory is detected
and added to a pool, then chunks are allocated and freed until the pool is exhausted.

### PS2Keyboard:
Demonstrates reading PS/2 keyboard and mouse.  Interrupt driven.

### Filesystem:
A program which lists the contents of an SD card.

### Modplayer
A program to play an Amiga ProTracker module.  The actual replay code is ported from
8bitbusby's replayer.

### TCPIP
An attempt to port UIP to 832, communicating via SLIP with an ESP8322 module.

