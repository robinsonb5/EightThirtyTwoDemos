PROJECTS="HelloWorld Interrupts LZ4 SoC Dhrystone Dhrystone_DualThread Debug"

FPGA_SITE_MK ?= site.mk

include $(FPGA_SITE_MK)

all: site.mk EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd lib832soc/lib832soc.a
	$(info )
	$(info EightThirtyTwoDemos - example and test project for the EightThirtyTwo CPU)
	$(info )
	$(info All makefile targets take a BOARDS and PROJECTS parameter, where multiple)
	$(info item are separated by a space escaped with a backslash, for example: )
	$(info * BOARDS=mist\ de10lite\ icesugarpro)
	$(info * PROJECTS=HelloWorld\ SoC)
	$(info If these are not specified, BOARDS is taken from site.mk, and PROJECTS from)
	$(info this Makefile.)
	$(info )
	$(info * make init  -  creates project files for the select boards and projects)
	$(info )
	$(info * make compile  -  invokes the appropriate tools to compile the selected)
	$(info projects for the selected boards.)
	$(info )
	$(info * make config  -  [currently Lattice-based boards only], invokes the appropriate)
	$(info tools to load the created bistream into the FPGA SRAM)
	$(info )
	$(info * make clean  -  remove generated files for the selected boards and projects.)
	$(info )
	$(info * make project_help  -  information about projects.)
	$(info )
	$(info * make board_help  -  information about boards.)
	$(info )

project_help:
	$(info )
	$(info HelloWorld - writes the archetypal "Hello World" string to RS232 serial.)
	$(info (for boards with no serial port, this may be a JTAG-based virtual UART.))
	$(info )
	$(info Dhrystone - benchmarking the CPU running from block RAM.)
	$(info )
	$(info Dhrystone_DualThread - benchmarking the CPU running two threads from BRAM.)
	$(info )
	$(info Interrupts - responds to a timer interrupt, with firmware in assembly.)
	$(info )
	$(info LZ4 - decompresses a small chunk of LZ4 compressed text to the UART.)
	$(info )
	$(info VGA - displays a framebuffer from SDRAM on the VGA port.)
	$(info )
	$(info VGA_NoRAM - displays a test pattern generated on the fly.)
	$(info )
	$(info SoC - a system-on-chip with SDRAM, video and sound.)
	$(info )
	$(info SoCWide - a version of SoC which makes use of 32-bit wide SDRAM.)
	$(info )

board_help:
	$(info )
	$(info (To be written...))
	$(info )

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

lib832soc/lib832soc.a:
	make -f firmware.mk PROJECTS=

firmware: EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd lib832soc/lib832soc.a
	make -f firmware.mk PROJECTS=$(PROJECTS)

.phony firmware_clean:
firmware_clean:
	make -f firmware.mk PROJECTS=$(PROJECTS) clean

site.mk:
	$(info Copy the example site.template file to site.mk)
	$(info and edit the paths to Quartus, ISE, Vivado as appropriate)
	$(info for the target boards you want to use.)
	$(error site.mk not found.)

init: firmware
ifdef BOARD
	@make -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$(BOARD) CMD=init
else
	@for BOARD in ${BOARDS}; do \
		make -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$$BOARD CMD=init; \
	done
endif

compile: firmware
ifdef BOARD
	@make -f firmware.mk PROJECTS=$(PROJECTS)
	@make -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$(BOARD) CMD=compile
else
	@for BOARD in ${BOARDS}; do \
		make -f firmware.mk PROJECTS=$(PROJECTS); \
		make --quiet -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$$BOARD CMD=compile; \
	done
endif

config: firmware
ifdef BOARD
	@make -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$(BOARD) CMD=config
else
	@for BOARD in ${BOARDS}; do \
		make --quiet -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$$BOARD CMD=config; \
	done
endif

clean: firmware_clean
ifdef BOARD
	@make -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$(BOARD) CMD=clean
else
	@for BOARD in ${BOARDS}; do \
		make -f Scripts/project.mk PROJECTS=$(PROJECTS) BOARD=$$BOARD CMD=clean; \
	done
endif

