832DIR=../../EightThirtyTwo/Lib/
INCDIR=../../EightThirtyTwo/include/
LIBDIR=../../Lib/
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
AS=../../EightThirtyTwo/832a/832a
LD=../../EightThirtyTwo/832a/832l

CFLAGS = -+ -DNULL=0
COPT = -O=32767 -speed
all: PS2Keyboard.bin PS2Keyboard.srec

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

PS2Keyboard.bin : start.o premain.o uart.o small_printf.o division.o string.o keyboard.o interrupts.o ps2.o main.o
	$(LD) -b 0x10000000 -o $@ $+

%.o : %.S Makefile $(832DIR)/start.S
	$(AS) -o $*.o $*.S

%.o : %.c Makefile $(832DIR)/start.S
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(832DIR)/%.S Makefile $(832DIR)/start.S
	$(AS) -o $*.o $(832DIR)/$*.S

%.o : $(LIBDIR)/%.S Makefile
	$(AS) -o $*.o $(LIBDIR)/$*.S

%.o : $(LIBDIR)/%.asm Makefile
	$(AS) -o $*.o $(LIBDIR)/$*.asm

%.o : $(832DIR)/%.asm Makefile
	$(AS) -o $*.o $(832DIR)/$*.asm

%.o : %.asm Makefile
	$(AS) -o $*.o $*.asm

%.asm : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c

%.asm : $(832DIR)/%.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $(832DIR)/$*.c

%.asm : $(LIBDIR)/%.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $(LIBDIR)/$*.c

force:

