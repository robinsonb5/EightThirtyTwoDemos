SOCDIR=../../
832DIR=../../EightThirtyTwo/

LIBDIR=$(832DIR)/lib832

ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

INCLUDE= -I$(SOCDIR)/include -I$(832DIR)/include
COPT = -O=1311 -size
CFLAGS = -+ $(COPT) $(INCLUDE)

all: SoC_ROM.vhd

clean :
	-rm *.asm
	-rm *.S
	-rm *.o
	-rm *.vhd
	-rm *.bin
	-rm *.elf

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_rom/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

SoC.bin : $(LIBDIR)/dualcrt0.a $(LIBDIR)/lib832.a thread2boot.o main.o minfat.o ../../lib832soc/lib832soc.a
	$(LD) -m $@.map -o $@ $+

%.o : %.c Makefile
	$(CC) $(CFLAGS) $*.c
	$(AS) -o $*.o $*.asm

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.o : $(832DIR)/%.asm Makefile
	$(AS) -o $*.o $(832DIR)/$*.asm

%.asm : %.c Makefile
	$(CC) $(CFLAGS) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

