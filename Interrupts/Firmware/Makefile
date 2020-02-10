ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
COMMONDIR = ../../EightThirtyTwo/Assembler
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

all: Interrupts_ROM.vhd


clean :
	rm *.o
	rm *.bin

Interrupts.bin : Interrupts.o
	$(LD) -o $@ $+

%.o : %.S Makefile
	$(AS) -o $*.o $*.S

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_ROM/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

