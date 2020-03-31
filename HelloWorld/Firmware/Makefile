832DIR = ../../EightThirtyTwo
ROMGENDIR = $(832DIR)/romgen
ROMGEN = $(ROMGENDIR)/romgen

AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

LIBDIR = $(832DIR)/lib832/
LIBSOCDIR = ../../lib832soc/

INCLUDES = $(832DIR)/include ../../include


all: HelloWorld_ROM.vhd


clean :
	rm *.o
	rm *.bin

HelloWorld.bin : HelloWorld.o
	$(LD) -o $@ $+

%.o : %.S Makefile
	$(AS) -o $*.o $*.S

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_ROM/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

