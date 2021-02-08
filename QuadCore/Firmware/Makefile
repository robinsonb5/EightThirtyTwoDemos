832DIR=../../EightThirtyTwo/lib832/
INCDIR=../../EightThirtyTwo/include/
LIBDIR=../../Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l
DUMP=objdump
CFLAGS = -+ -speed
LIBS = $(832DIR)/dualcrt0.a $(832DIR)/lib832.a
COPT = -O=32767
all: QuadTest_ROM_byte.vhd QuadTest_ROM_word.vhd QuadTest.bin

clean :
	-rm *.S
	-rm *.asm
	-rm *.o
	-rm *.vhd
	-rm *.bin
	-rm *.elf

%_ROM_byte.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_rom/' >$*_ROM_byte.vhd <$(ROMGENDIR)/rom_prologue_dualport_byte.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM_byte.vhd
	cat >>$*_ROM_byte.vhd $(ROMGENDIR)/rom_epilogue_dualport_byte.vhd

%_ROM_word.vhd: %.bin $(ROMGEN)
	sed 's/eightthirtytwo_rom/$*_rom/' >$*_ROM_word.vhd <$(ROMGENDIR)/rom_prologue_dualport_word.vhd
	$(ROMGEN) -b -w $*.bin >>$*_ROM_word.vhd
	cat >>$*_ROM_word.vhd $(ROMGENDIR)/rom_epilogue_dualport_word.vhd

QuadTest.bin : QuadTest.o
	$(LD) $(LIBS) -m QuadTest.map -o $@ $+

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

