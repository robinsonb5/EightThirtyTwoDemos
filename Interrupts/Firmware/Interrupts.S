#include "assembler.pp"

#define TIMERBASE 0xFFFFFC00
#define REG_TIMER_ENABLE 0
#define REG_TIMER_INDEX 4
#define REG_TIMER_COUNTER 8

#define INTERRUPTBASE 0xffffffb0

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

	exg	r6	// Return address is before r0's old contents since we have to decrement the return address

	li	IMW1(INTERRUPTBASE)
	li	IMW0(INTERRUPTBASE)
	mr	r0

	li	0
	st	r0	// Disable interrupts
	ld	r0	// Read interrupts to acknowledge the ones we've received - 
			// tmp now contains a bitmap of triggered interrupts.

	li	1	// tick = tick ^ 1;
	mr	r1
	li	IMW1(PCREL(tick)-1)
	li	IMW0(PCREL(tick))
	ldidx	r7
	xor	r1
	li	IMW1(PCREL(tick+4)-1)
	li	IMW0(PCREL(tick+4))
	addt	r7
	stmpdec	r1

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

	li	IMW1(PCREL(tick)-1)
	li	IMW0(PCREL(tick))
	addt	r7
	mr	r5
.loop:
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


Puts:	// Sends the string pointed to by r0 to the UART
	stdec	r6
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6

	li	IMW1(0xffffffc0)	// UART register
	li	IMW0(0xffffffc0)
	mr	r1

.txwait:
	ld	r1
	mr	r2
	li	IMW1(0x100)	// TX Ready flag
	li	IMW0(0x100)
	and	r2
	cond	EQ
		li	IMW0(PCREL(.txwait))
		add	r7

	ldbinc	r0
	cond	NEQ
		st	r1
		li	IMW0(PCREL(.txwait))
		add	r7

	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r1
	ldinc	r6
	mr	r7	// 27 bytes

