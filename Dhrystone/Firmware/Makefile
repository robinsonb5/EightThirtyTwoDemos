832DIR=../../EightThirtyTwo
INCDIR=$(832DIR)/include/
LIBDIR=$(832DIR)/lib832

ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

DUMP=objdump
CFLAGS = -+ -speed -unsigned-char -I../../include -I$(832DIR)/include
COPT = -O=32767

LDFLAGS=-s_STACKSIZE=512

all: Dhrystone_ROM_byte.vhd Dhrystone_ROM_word.vhd Dhrystone.bin

clean :
	-rm *.S
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

%.rpt: %.elf
	@echo -n "End of code:\t"
	@$(DUMP) -x $< | grep _romend
	@echo -n "Start of BSS:\t"
	@$(DUMP) -x $< | grep __bss_start__
	@echo -n "End of BSS:\t"
	@$(DUMP) -x $< | grep __bss_end__

Dhrystone.bin : $(LIBDIR)/crt0.a $(LIBDIR)/lib832.a dhry_1.o dhry_2.o
	$(LD) $(LDFLAGS) -m $@.map -o $@ $+

%.o : %.c Makefile ldscript.ld
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(832DIR)/%.S Makefile
	$(AS) -o $*.o $(832DIR)/$*.S

%.o : $(832DIR)/%.asm Makefile
	$(AS) -o $*.o $(832DIR)/$*.asm

%.o : $(LIBDIR)/%.S Makefile 
	$(AS) -o $*.o $(LIBDIR)/$*.S

%.o : $(LIBDIR)/%.asm Makefile 
	$(AS) -o $*.o $(LIBDIR)/$*.asm

%.asm : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

