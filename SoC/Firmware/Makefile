832DIR=../../EightThirtyTwo/Lib/
INCDIR=../../EightThirtyTwo/include/
LIBDIR=../../Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l
DUMP=objdump
CFLAGS = -+ -size
COPT = -O=1311
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

%.bin : %.elf Makefile
	objcopy -Obinary $< $@

%.o : %.s Makefile
	gcc -c $*.s

SoC.bin : start.o uart.o tiny_printf.o spi_c.o minfat.o swap.o main.o
	$(LD) -o $@ $+

%.o : %.S Makefile $(832DIR)/start.S
	$(AS) -o $*.o $*.S

%.o : %.c Makefile ldscript.ld $(832DIR)/start.S
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(832DIR)/%.S Makefile $(832DIR)/assembler.pp $(832DIR)/start.S
	$(AS) -o $*.o $(832DIR)/$*.S

%.o : $(832DIR)/%.asm Makefile $(832DIR)/assembler.pp $(832DIR)/start.S
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

