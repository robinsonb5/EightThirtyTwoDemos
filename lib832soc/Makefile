832DIR=../EightThirtyTwo
AS=$(832DIR)/832a/832a
LD=$(832DIR)/832a/832l
CC=$(832DIR)/vbcc/bin/vbcc832
COPT = -O=1311 -size
CFLAGS = -+ -fpic -c99 -unsigned-char $(COPT) -I../include -I$(832DIR)/include/ 
TIME=2ms

OBJDIR=832dir

all: $(OBJDIR) lib832soc.a

clean :
	-rm *.asm
	-rm $(OBJDIR)/*.o
	-rm *.bin
	-rm *.a


lib832soc.a : $(OBJDIR)/interrupts.o $(OBJDIR)/syscalls.o $(OBJDIR)/uart_buffered.o $(OBJDIR)/signals.o \
				$(OBJDIR)/minfat.o $(OBJDIR)/fileutils.o $(OBJDIR)/keyboard.o $(OBJDIR)/ps2.o $(OBJDIR)/hw_ringbuffer.o $(OBJDIR)/timer.o \
				$(OBJDIR)/spi_c.o $(OBJDIR)/hexdump.o $(OBJDIR)/memorypool.o $(OBJDIR)/socmemory.o $(OBJDIR)/malloc.o \
				$(OBJDIR)/swap.o $(OBJDIR)/rand.o $(OBJDIR)/screenmode.o $(OBJDIR)/framebuffer.o $(OBJDIR)/mousedriver.o
	cat >$@ $+

$(OBJDIR)/%.o : %.asm Makefile
	$(AS) -o $@ $*.asm

$(OBJDIR)/%.o : %.S Makefile
	$(AS) -o $@ $*.S

%.asm : %.c Makefile
	$(CC) $(CFLAGS) $*.c

$(OBJDIR):
	mkdir $(OBJDIR)

#%.o : %.c Makefile
#	$(CC) $(CFLAGS) $*.c
#	$(AS) $*.asm

