832DIR=../../EightThirtyTwo/Lib/
LIBDIR=../../Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
CFLAGS = -+ -speed
COPT = -O=1311
all: SoC_ROM.vhd

clean :
	rm *.S
	rm *.o
	rm *.vhd
	rm *.bin
	rm *.elf

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_rom/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

%.bin : %.elf Makefile
	objcopy -Obinary $< $@

%.o : %.s Makefile
	gcc -c $*.s

SoC.elf : start.o uart.o small_printf.o division.o spi.o minfat.o swap.o main.o
	gcc -Wl,--build-id=none -Wl,--gc-sections -nostartfiles -nostdlib -Tldscript.ld -o $@ $+

%.o : %.S Makefile ldscript.ld $(832DIR)/start.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : %.c Makefile ldscript.ld $(832DIR)/start.S
	../../EightThirtyTwo/vbcc/bin/vbcc832 $(COPT) $(CFLAGS) -I$(LIBDIR) $*.c
	mv $*.asm $*.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : $(832DIR)/%.S Makefile ldscript.ld $(832DIR)/assembler.pp $(832DIR)/start.S
	gcc -c $(832DIR)/$*.S -I$(832DIR) -o $*.o

%.o : $(LIBDIR)/%.S Makefile ldscript.ld
	gcc -c $(LIBDIR)/$*.S -I$(832DIR) -I$(LIBDIR) -o $*.o

%.S : %.c Makefile
	../../EightThirtyTwo/vbcc/bin/vbcc832 $(COPT) $(CFLAGS) -I$(LIBDIR) $*.c
	mv $*.asm $*.S

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:
