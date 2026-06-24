PROJECT = 
all: firmware

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

EightThirtyTwo/vbcc/bin/vbcc832: EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd
	make -C EightThirtyTwo

EightThirtyTwo/lib832/lib832.a: EightThirtyTwo/vbcc/bin/vbcc832
	make -C EightThirtyTwo/lib832

lib832soc/lib832soc.a: EightThirtyTwo/lib832/lib832.a
	make -C lib832soc

firmware: EightThirtyTwo/vbcc/bin/vbcc832 lib832soc/lib832soc.a
	make -C $(PROJECT)/Firmware/; \

clean: EightThirtyTwo/vbcc/bin/vbcc832 EightThirtyTwo/lib832/lib832.a
	make -C $(PROJECT)/Firmware/ clean; \

