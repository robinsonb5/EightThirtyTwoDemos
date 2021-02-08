832DIR = ../../EightThirtyTwo
ROMGENDIR = $(832DIR)/romgen
ROMGEN = $(ROMGENDIR)/romgen

AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

LIBDIR = $(832DIR)/lib832/
LIBSOCDIR = ../../lib832soc/

INCLUDES = $(832DIR)/include ../../include


all: HelloWorld_ROM_byte.vhd HelloWorld_ROM_word.vhd


clean :
	rm *.o
	rm *.bin

HelloWorld.bin : HelloWorld.o
	$(LD) -el -o $@ $+

%.o : %.S Makefile
	$(AS) -el -o $*.o $*.S

%_ROM_byte.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_rom/' >$*_ROM_byte.vhd <$(ROMGENDIR)/rom_prologue_byte.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM_byte.vhd
	cat >>$*_ROM_byte.vhd $(ROMGENDIR)/rom_epilogue_byte.vhd

%_ROM_word.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_rom/' >$*_ROM_word.vhd <$(ROMGENDIR)/rom_prologue_word.vhd
	$(ROMGEN) -b -w $*.bin >>$*_ROM_word.vhd
	cat >>$*_ROM_word.vhd $(ROMGENDIR)/rom_epilogue_word.vhd

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

