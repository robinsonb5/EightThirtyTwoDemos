SOCDIR=../../
832DIR=../../EightThirtyTwo/

LIBDIR=$(832DIR)/lib832

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l


INCLUDE= -I$(SOCDIR)/include -I$(832DIR)/include
COPT = -O=32767 -speed
CFLAGS = -+ $(COPT) $(INCLUDE)
LIBS = $(LIBDIR)/lib832.a $(SOCDIR)/lib832soc/lib832soc.a

PRJ=UBasic
PRJ_OBJ = tokenizer.o program.o ubasic.o

all: $(PRJ).bin $(PRJ).srec

clean :
	- rm *.srec
	- rm *.bin
	- rm *.elf
	- rm *.vhd
	- rm *.o
	- rm *.S
	- rm *.asm

%.srec : %.bin Makefile
	objcopy -Ibinary $*.bin --adjust-vma 0x10000000 -O srec $@

%.o : %.s Makefile
	gcc -c $*.s

$(PRJ).bin : $(LIBDIR)/crt0.a $(PRJ_OBJ) $(LIBS) 
	$(LD) -b 0x10000000 -o $@ $+

%.o : %.c Makefile
	$(CC) $(CFLAGS) $*.c
	$(AS) -o $*.o $*.asm

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.asm : %.c Makefile
	$(CC) $(CFLAGS) $*.c

force:

