832DIR=../../EightThirtyTwo
INCDIR=$(832DIR)/include/
LIBDIR=$(832DIR)/lib832

ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

CFLAGS = -+ -speed -unsigned-char -I../../include -I$(832DIR)/include
COPT = -O=32767

LDFLAGS=-s_STACKSIZE=512

all: VGA_ROM_byte.vhd VGA_ROM_word.vhd VGA.bin

clean :
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

VGA.bin : VGA.o
	$(LD) $(LDFLAGS) -m $@.map -o $@ $+ $(LIBDIR)/lib832.a

%.o : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.asm : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

