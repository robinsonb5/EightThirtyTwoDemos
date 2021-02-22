all: firmware

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

EightThirtyTwo/vbcc/bin/vbcc832: EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd
	make -C EightThirtyTwo

firmware: EightThirtyTwo/vbcc/bin/vbcc832
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT/Firmware/; \
	done

