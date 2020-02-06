832DIR=../../EightThirtyTwo/Lib/
INCDIR=../../EightThirtyTwo/include/
LIBDIR=../../Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

CFLAGS = -+
COPT = -O=32767 -speed
all: Dhrystone.bin Dhrystone.srec

clean :
	- rm *.srec
	- rm *.bin
	- rm *.elf
	- rm *.vhd
	- rm *.o
	- rm *.S

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_rom/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

%.srec : %.bin Makefile
	srec_cat $*.bin -binary -offset 0x10000000 -o $@

%.o : %.s Makefile
	gcc -c $*.s

Dhrystone.bin : start.o uart.o small_printf.o division.o string.o dhry_1.o dhry_2.o
	$(LD) -b 0x10000000 -o $@ $+

%.o : %.S Makefile ldscript.ld $(832DIR)/start.S
	$(AS) -o $*.o $*.S

%.o : %.c Makefile ldscript.ld $(832DIR)/start.S
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(832DIR)/%.S Makefile ldscript.ld $(832DIR)/assembler.pp $(832DIR)/start.S
	$(AS) -o $*.o $(832DIR)/$*.S

%.o : $(832DIR)/%.asm Makefile ldscript.ld $(832DIR)/assembler.pp $(832DIR)/start.S
	$(AS) -o $*.o $(832DIR)/$*.asm

%.o : $(LIBDIR)/%.S Makefile ldscript.ld
	$(AS) -o $*.o $(LIBDIR)/$*.S

%.o : $(LIBDIR)/%.asm Makefile ldscript.ld
	$(AS) -o $*.o $(LIBDIR)/$*.asm

%.asm : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

