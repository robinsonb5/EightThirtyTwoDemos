PROJECTS=HelloWorld Interrupts LZ4 VGA SoC Dhrystone Dhrystone_DualThread Debug

all: projects

projects: EightThirtyTwo/vbcc/bin/vbcc832
	for PROJECT in ${PROJECTS}; do \
		make -f project.mk PROJECT=$$PROJECT; \
	done

clean:
	for PROJECT in ${PROJECTS}; do \
		make -f project.mk PROJECT=$$PROJECT clean; \
	done

EightThirtyTwo/vbcc/bin/vbcc832: EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd
	make -C EightThirtyTwo

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

