#include "assembler.pp"

#define TIMERBASE 0xFFFFFC00
#define REG_TIMER_ENABLE 0
#define REG_TIMER_INDEX 4
#define REG_TIMER_COUNTER 8

#define INTERRUPTBASE 0xffffffb0

#define VGABASE 0xFFFFFE00
#define REG_VGA_FRAMEBUFFER 0
#define REG_VGA_SP0PTR 0x10
#define REG_VGA_SP0XPOS 0x14
#define REG_VGA_SP0YPOS 0x18


vector: // Entry point and interrupt vector.  On interrupt zero flag will be set.
	cond NEQ
		li IMW1(PCREL(entry-1))
		li IMW0(PCREL(entry))
		add	r7

interrupt:	// We fall through to here if we're servicing an interrupt.
	exg	r6	// Swap the stack pointer and return address.
	stmpdec	r0	// Save one register's contents to the stack (with the stack pointer in tmp)
	stmpdec	r6	// Save the return address
	stmpdec	r1	// Save any other registers that we change in the interrupt handler.
	stmpdec	r2
	exg	r6	// Return address is before r0's old contents since we have to decrement the return address

	li	IMW1(INTERRUPTBASE)
	li	IMW0(INTERRUPTBASE)
	mr	r0

	li	0
	st	r0	// Disable interrupts
	ld	r0	// Read interrupts to acknowledge the ones we've received - 
			// tmp now contains a bitmap of triggered interrupts.

	mr	r2
	li	1
	ror	r2	// LSB (timer int) gets shifted into the carry flag, rotate rather than shift to keep the Z flag clear.
	cond	SLT	// Timer interrupt
		li	1	// tick = tick ^ 1;
		mr	r1
		li	IMW1(PCREL(tick+4)-1)
		li	IMW0(PCREL(tick+4))
		ldidx	r7
		xor	r1
		li	IMW1(PCREL(tick+8)-1)
		li	IMW0(PCREL(tick+8))
		addt	r7
		stmpdec	r1

		mr	r1
		li	1
		stdec	r1
	cond	EX

	li	1
	ror	r2
	cond	SLT // VBlank interrupt
		li	4
		mr	r1
		li	IMW1(PCREL(fbptr)-1)
		li	IMW0(PCREL(fbptr))
		addt	r7
		mr	r2
		ld	r2
		add	r1
		mt	r1
		st	r2
		
		li	IMW1(VGABASE+REG_VGA_FRAMEBUFFER+4)
		li	IMW0(VGABASE+REG_VGA_FRAMEBUFFER+4)
		stmpdec	r1
	cond	EX

	ldinc r6	// Restore r2
	mr	r2
	ldinc r6	// Restore r1
	mr	r1

	li	1
	st	r0		// Re-enable interrupts

	ldinc r6	// Return address
	mr	r0
	li	IMW0(-1)
	add	r0		// Decrement return address
	ldinc r6
	exg	r0		// Restore r0
	mr	r7		// Jump to return address - 1.

tick:
	.int	0
	.int	0
fbptr:
	.int	0

entry:
	// Setup the stack
	li	IMW2(0x800)
	li	IMW1(0x800)
	li	IMW0(0x800)
	mr	r6

	li	IMW1(TIMERBASE+REG_TIMER_INDEX)	// Setup the timer
	li	IMW0(TIMERBASE+REG_TIMER_INDEX)
	mr	r0
	li	0
	st	r0
	li	IMW1(TIMERBASE+REG_TIMER_COUNTER)
	li	IMW0(TIMERBASE+REG_TIMER_COUNTER)
	mr	r0
	li	IMW2(100000)
	li	IMW1(100000)
	li	IMW0(100000)
	st	r0

	li	IMW1(TIMERBASE+REG_TIMER_ENABLE)
	li	IMW0(TIMERBASE+REG_TIMER_ENABLE)
	mr	r0
	li	1
	st	r0

	li	IMW1(INTERRUPTBASE)	// Enable interrupts
	li	IMW0(INTERRUPTBASE)
	mr	r0
	li	1
	st	r0

	// Main loop:

	li	0
	mr	r1
	li	IMW1(VGABASE+REG_VGA_FRAMEBUFFER)
	li	IMW0(VGABASE+REG_VGA_FRAMEBUFFER)
	mr	r2

	li	IMW1(PCREL(tick+4)-1)
	li	IMW0(PCREL(tick+4))
	addt	r7
	mr	r5

	li	IMW5(0x20000000)
	li	IMW4(0x20000000)
	li	IMW3(0x20000000)
	li	IMW2(0x20000000)
	li	IMW1(0x20000000)
	li	IMW0(0x20000000)
	mr	r4
	li	0
	mr	r3

.loop:
	mt	r3
	st	r4
	li	1
	add	r3
	li	4
	add	r4	// Just write an ever-increasing value to an ever-increasing address.
	//  FIXME - Will eventually hit peripheral space and crash.

	li	IMW0(-4)
	addt	r5
	mr	r0
	ld	r0
	cond EQ
		li	IMW1(PCREL(.loop)-1)
		li	IMW0(PCREL(.loop))
		add	r7	// Branch to .loop

	li	0
	st	r0

	ld	r5
	cond EQ	// If/else control flow using just predication - no branching required.
		li	IMW1((.ticktext-.tickpoint))
		li	IMW0((.ticktext-.tickpoint))
	cond NEQ
		li	IMW1((.tocktext-.tickpoint))
		li	IMW0((.tocktext-.tickpoint))
	cond EX
	addt	r7
.tickpoint:	// The PC relative calculation is done here, so the offsets must be relative to this address.

	mr	r0
	li	IMW1(PCREL(Puts)-1)
	li	IMW0(PCREL(Puts))
	add	r7	// Call the Puts subroutine

	li	IMW1(PCREL(.loop)-1)
	li	IMW0(PCREL(.loop))
	add	r7	// Branch to .loop

.ticktext:
	.ascii "Tick\n\0"
.tocktext:
	.ascii "Tock\n\0"


#include "puts.S"

