SOCDIR=../../
832DIR=../../EightThirtyTwo/

LIBDIR=$(832DIR)/lib832

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l


INCLUDE= -I$(SOCDIR)/include -I$(832DIR)/include
COPT = -O=32767 -speed
CFLAGS = -+ $(COPT) $(INCLUDE)

PRJ=Dhrystone
PRJ_OBJ = dhry_1.o dhry_2.o dhry_3.o dhry_4.o

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

$(PRJ).bin : $(LIBDIR)/dualcrt0.a $(PRJ_OBJ) $(LIBDIR)/lib832.a 
	$(LD) -b 0x10000000 -o $@ $+

%.o : %.c Makefile
	$(CC) $(CFLAGS) $*.c
	$(AS) -o $*.o $*.asm

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.asm : %.c Makefile
	$(CC) $(CFLAGS) $*.c

force:

