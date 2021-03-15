SOCDIR=../../
832DIR=../../EightThirtyTwo/

LIBDIR=$(832DIR)/lib832

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l


INCLUDE= -I$(SOCDIR)/include -I$(832DIR)/include
COPT = -O=1311 -size -fpic
CFLAGS = -+ $(COPT) $(INCLUDE)

LDFLAGS = -sSTACKSIZE=256

START = $(LIBDIR)/crt0.a
LIBS = $(LIBDIR)/lib832.a $(SOCDIR)/lib832soc/lib832soc.a

all: reloctest.832 loader.srec

clean :
	- rm *.srec
	- rm *.bin
	- rm *.elf
	- rm *.vhd
	- rm *.o
	- rm *.asm
	- rm *.832

%.srec : %.bin Makefile
	objcopy -Ibinary $*.bin --adjust-vma 0x10000000 -O srec $@

%.o : %.s Makefile
	gcc -c $*.s

%.bin : $(START) $(LIBS) %.o
	$(LD) -b 0x10000000 -M $*.map -o $@ $+

%.832 : appstart.o $(LIBDIR)/premain.o $(LIBDIR)/lib832.a %.o
	$(LD) $(LDFLAGS) -r -M $*.map -o $@ $+

%.o : %.c Makefile
	$(CC) $(CFLAGS) $*.c
	$(AS) -o $*.o $*.asm

%.o : %.S Makefile
	$(AS) -o $*.o $*.S

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.asm : %.c Makefile
	$(CC) $(CFLAGS) $*.c

force:

