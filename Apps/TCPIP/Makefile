SOCDIR=../../
832DIR=../../EightThirtyTwo/

LIBDIR=$(832DIR)/lib832

CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

UIPPATH=../3rdParty/uip/
APPPATH=$(UIPPATH)/apps/hello-world/

INCLUDE= -I$(SOCDIR)/include -I$(832DIR)/include -I$(UIPPATH)/uip/ -I. -I$(UIPPATH)/apps/hello-world/
COPT = -O=1343 -size
CFLAGS = -+ $(COPT) $(INCLUDE)

PRJ=TCP_IP
PRJ_OBJ = uip.o uip_arp.o uiplib.o psock.o timer.o uip-neighbor.o uip-split.o slipdev.o main.o hello-world.o

START = $(LIBDIR)/crt0.a
LIBS = $(LIBDIR)/lib832.a $(SOCDIR)/lib832soc/lib832soc.a

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

$(PRJ).bin : $(START) $(PRJ_OBJ) $(LIBS)
	$(LD) -b 0x10000000 -m $(PRJ).map -o $@ $+

%.o : $(UIPPATH)/uip/%.c Makefile
	$(CC) $(CFLAGS) $(UIPPATH)/uip/$*.c
	$(AS) -o $*.o $(UIPPATH)/uip/$*.asm

%.o : $(APPPATH)%.c Makefile
	$(CC) $(CFLAGS) $(APPPATH)/$*.c
	$(AS) -o $*.o $(APPPATH)/$*.asm

%.o : %.c Makefile
	$(CC) $(CFLAGS) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(UIPPATH)/uip/%.asm Makefile
	$(AS) -o $*.o $*.asm

$(UIPPATH)/uip/%.asm : $(UIPPATH)/uip/%.c Makefile
	$(CC) $(CFLAGS) $*.c

force:

