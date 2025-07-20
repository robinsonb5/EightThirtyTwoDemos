832DIR = ../../EightThirtyTwo
ROMGENDIR = $(832DIR)/romgen
ROMGEN = $(ROMGENDIR)/romgen

AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

LIBDIR = $(832DIR)/lib832/
LIBSOCDIR = ../../lib832soc/

INCLUDES = $(832DIR)/include ../../include


all: HelloWorld_ROM_byte.vhd HelloWorld_ROM_word.vhd HelloWorld_ROM_interleaved.vhd


clean :
	rm *.o
	rm *.bin

HelloWorld.bin : HelloWorld.o
	$(LD) -o $@ $+

%.o : %.S Makefile
	$(AS) -o $*.o $*.S

%_ROM_byte.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_ROM/' >$*_ROM_byte.vhd <$(ROMGENDIR)/rom_prologue_byte.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM_byte.vhd
	cat >>$*_ROM_byte.vhd $(ROMGENDIR)/rom_epilogue_byte.vhd

%_ROM_word.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_ROM/' >$*_ROM_word.vhd <$(ROMGENDIR)/rom_prologue_word.vhd
	$(ROMGEN) -b -w $*.bin >>$*_ROM_word.vhd
	cat >>$*_ROM_word.vhd $(ROMGENDIR)/rom_epilogue_word.vhd

%_ROM_interleaved.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom_slice/$*_rom_slice0/' >$*_ROM_interleaved.vhd <$(ROMGENDIR)/rom_prologue_slice.vhd
	$(ROMGEN) -b -z1 -o0 -s3 $*.bin >>$*_ROM_interleaved.vhd
	cat >>$*_ROM_interleaved.vhd $(ROMGENDIR)/rom_epilogue_slice.vhd
	sed 's/eightthirtytwo_rom_slice/$*_rom_slice1/' >>$*_ROM_interleaved.vhd <$(ROMGENDIR)/rom_prologue_slice.vhd
	$(ROMGEN) -b -z1 -o1 -s3 $*.bin >>$*_ROM_interleaved.vhd
	cat >>$*_ROM_interleaved.vhd $(ROMGENDIR)/rom_epilogue_slice.vhd
	sed 's/eightthirtytwo_rom_slice/$*_rom_slice2/' >>$*_ROM_interleaved.vhd <$(ROMGENDIR)/rom_prologue_slice.vhd
	$(ROMGEN) -b -z1 -o2 -s3 $*.bin >>$*_ROM_interleaved.vhd
	cat >>$*_ROM_interleaved.vhd $(ROMGENDIR)/rom_epilogue_slice.vhd
	sed 's/eightthirtytwo_rom_slice/$*_rom_slice3/' >>$*_ROM_interleaved.vhd <$(ROMGENDIR)/rom_prologue_slice.vhd
	$(ROMGEN) -b -z1 -o3 -s3 $*.bin >>$*_ROM_interleaved.vhd
	cat >>$*_ROM_interleaved.vhd $(ROMGENDIR)/rom_epilogue_slice.vhd
	sed 's/eightthirtytwo_rom/$*_rom/' >>$*_ROM_interleaved.vhd <$(ROMGENDIR)/rom_prologue_interleaved.vhd

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

