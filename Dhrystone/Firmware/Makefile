832DIR=../../EightThirtyTwo/Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
CFLAGS = -+ -O=1311 -size
COPT = -O=1311
all: Dhrystone_ROM.vhd

clean :
	rm *.o
	rm *.bin

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_rom/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

%.bin : %.elf Makefile
	objcopy -Obinary $< $@

%.o : %.s Makefile
	gcc -c $*.s

Dhrystone.elf : start.o uart.o small_printf.o division.o strcmp.o dhry_1.o dhry_2.o
	gcc -Wl,--build-id=none -Wl,--gc-sections -nostartfiles -nostdlib -Tldscript.ld -o $@ $+

%.o : %.S Makefile ldscript.ld $(832DIR)/start.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : %.c Makefile ldscript.ld $(832DIR)/start.S
	../../EightThirtyTwo/vbcc/bin/vbcc832 -+ $(COPT) -size -I$(832DIR) $*.c
	mv $*.asm $*.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : $(832DIR)/%.S Makefile ldscript.ld $(832DIR)/assembler.pp $(832DIR)/start.S
	gcc -c $(832DIR)/$*.S -I$(832DIR) -o $*.o

%.S : %.c Makefile
	../../EightThirtyTwo/vbcc/bin/vbcc832 -+ $(COPT) -size -I$(832DIR) $*.c
	mv $*.asm $*.S

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

