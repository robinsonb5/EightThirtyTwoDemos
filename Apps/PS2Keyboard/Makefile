832DIR=../../EightThirtyTwo/Lib/
INCDIR=../../EightThirtyTwo/include/
LIBDIR=../../Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832

STACKTOP=0x10002000

CFLAGS = -+ -c99 -speed -DNULL=0 -DDISABLE_FILESYSTEM
COPT = -O=1311
all: PS2Keyboard.srec

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

%.bin : %.elf Makefile
	objcopy -Obinary $< $@

%.srec : %.elf Makefile
	objcopy -Osrec $< $@

%.o : %.s Makefile
	gcc -c $*.s

PS2Keyboard.elf : start.o premain.o uart.o small_printf.o division.o malloc.o hexdump.o swap.o spi.o\
	syscalls.o fat.o rafile.o string.o ps2.o interrupts.o keyboard.o main.o
	gcc -Wl,--build-id=none -Wl,--gc-sections -nostartfiles -nostdlib -T$(LIBDIR)/stdapp.ld -o $@ $+

%.o : %.S Makefile
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : %.c Makefile
	../../EightThirtyTwo/vbcc/bin/vbcc832 $(COPT) $(CFLAGS) -I$(LIBDIR) -I$(INCDIR) $*.c
	mv $*.asm $*.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : $(LIBDIR)/%.S Makefile
	gcc -c $(LIBDIR)/$*.S -I$(832DIR) -I$(LIBDIR) -o $*.o

%.o : $(832DIR)/%.S Makefile
	gcc -c $(832DIR)/$*.S -I$(832DIR) -DLDSTACK -o $*.o

%.S : %.c Makefile
	../../EightThirtyTwo/vbcc/bin/vbcc832 $(COPT) $(CFLAGS) -I$(LIBDIR) -I$(INCDIR) $*.c
	mv $*.asm $*.S

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

