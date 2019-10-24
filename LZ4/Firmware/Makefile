ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
COMMONDIR = ../../EightThirtyTwo/Assembler

all: LZ4_ROM.vhd


clean :
	rm *.o
	rm *.bin

%.bin : %.o Makefile
	objcopy -Obinary $*.o $@

%.o : %.s Makefile
	gcc -c $*.s

%.o : %.S Makefile $(COMMONDIR)/assembler.pp
	gcc -I $(COMMONDIR)/ -c $*.S

%.s : %.832 Makefile
	cpp -P $< > $*.s

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_ROM/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c
