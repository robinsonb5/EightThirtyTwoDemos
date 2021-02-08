PROJECTS=HelloWorld Interrupts LZ4 VGA SoC Dhrystone Dhrystone_DualThread Debug QuadCore

all: site.mk EightThirtyTwo/vbcc/bin/vbcc832 projects

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

EightThirtyTwo/vbcc/bin/vbcc832: EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd
	make -C EightThirtyTwo

site.mk:
	$(info Copy the example site.template file to site.mk)
	$(info and edit the paths for the version(s) of Quartus)
	$(info you have installed.)
	$(error site.mk not found.)

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

