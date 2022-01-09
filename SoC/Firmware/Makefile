SOCDIR=../../
832DIR=../../EightThirtyTwo/

LIBDIR=$(832DIR)/lib832

ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

INCLUDE= -I$(SOCDIR)/include -I$(832DIR)/include
COPT = -O=-1 -size
CFLAGS = -+ $(COPT) $(INCLUDE)

all: SoC_ROM_byte.vhd SoC_ROM_word.vhd

clean :
	-rm *.asm
	-rm *.o
	-rm *.vhd
	-rm *.bin
	-rm *.elf

%_ROM_byte.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_rom/' >$*_ROM_byte.vhd <$(ROMGENDIR)/rom_prologue_byte.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM_byte.vhd
	cat >>$*_ROM_byte.vhd $(ROMGENDIR)/rom_epilogue_byte.vhd

%_ROM_word.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_rom/' >$*_ROM_word.vhd <$(ROMGENDIR)/rom_prologue_word.vhd
	$(ROMGEN) -b -w $*.bin >>$*_ROM_word.vhd
	cat >>$*_ROM_word.vhd $(ROMGENDIR)/rom_epilogue_word.vhd

SoC.bin : $(LIBDIR)/dualcrt0.a $(LIBDIR)/lib832.a thread2boot.o main.o ../../lib832soc/lib832soc.a
	$(LD) -m $@.map -o $@ $+
	grep __bss_end__ $@.map

%.o : %.c Makefile
	$(CC) $(CFLAGS) $*.c
	$(AS) -o $*.o $*.asm

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.o : %.S Makefile
	$(AS) -o $*.o $*.S

%.asm : %.c Makefile
	$(CC) $(CFLAGS) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

