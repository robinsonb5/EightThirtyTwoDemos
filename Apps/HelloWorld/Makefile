832DIR=../../EightThirtyTwo/Lib/
LIBDIR=../../Lib/
ROMGENDIR = ../../EightThirtyTwo/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=../../EightThirtyTwo/vbcc/bin/vbcc832
CFLAGS = -+ -speed
COPT = -O=1311

LIB_OBJ=start.o uart.o small_printf.o division.o strcmp.o

PRJ_OBJ=helloworld.o

PRJ=HelloWorld

all: $(PRJ).bin $(PRJ).srec

$(PRJ).elf : $(LIB_OBJ) $(PRJ_OBJ) ldscript.ld
	gcc -Wl,--build-id=none -Wl,--gc-sections -nostartfiles -nostdlib -Tldscript.ld -o $@ $(LIB_OBJ) $(PRJ_OBJ)

clean :
	- rm *.o
	- rm *.srec
	- rm *.bin
	- rm *.elf

%.srec: %.elf
	objcopy -O srec $< $@

%.bin : %.elf Makefile 
	objcopy -Obinary $< $@

%.o : %.s Makefile
	gcc -c $*.s

%.o : %.S Makefile $(832DIR)/start.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : %.c Makefile $(832DIR)/start.S
	../../EightThirtyTwo/vbcc/bin/vbcc832 $(COPT) $(CFLAGS) -I$(LIBDIR) $*.c
	mv $*.asm $*.S
	gcc -I. -I$(832DIR) -c $*.S -o $*.o

%.o : $(832DIR)/%.S Makefile $(832DIR)/assembler.pp $(832DIR)/start.S
	gcc -c $(832DIR)/$*.S -I$(832DIR) -o $*.o

%.o : $(LIBDIR)/%.S Makefile ldscript.ld
	gcc -c $(LIBDIR)/$*.S -I$(832DIR) -I$(LIBDIR) -o $*.o

%.S : %.c Makefile
	../../EightThirtyTwo/vbcc/bin/vbcc832 $(COPT) $(CFLAGS) -I$(LIBDIR) $*.c
	mv $*.asm $*.S

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:

