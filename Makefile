PROJECTS=HelloWorld Interrupts LZ4 VGA SoC Dhrystone Dhrystone_DualThread Debug
BOARDS_ALTERA = "de1 de2 c3board mist chameleon64 chameleon64v2 qmtech_cycloneiv55"
BOARDS_XILINX = "minimig"

all: lib832soc/lib832soc.a projects

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

EightThirtyTwo/vbcc/bin/vbcc832:
	make -C EightThirtyTwo

lib832soc/lib832soc.a: 
	make -C lib832soc

projects:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT BOARDS_ALTERA=$(BOARDS_ALTERA) BOARDS_XILINX=$(BOARDS_XILINX); \
	done

clean:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT clean; \
	done

