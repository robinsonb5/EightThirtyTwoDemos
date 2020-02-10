
vector: // Entry point and interrupt vector.  On interrupt zero flag will be set.
	cond NEQ
		.lipcrel entry
		add	r7

interrupt:	// We fall through to here if we're servicing an interrupt.
	exg	r6	// Swap the stack pointer and return address.
	stmpdec	r0	// Save one register's contents to the stack (with the stack pointer in tmp)
	stmpdec	r6	// Save the return address
	stmpdec	r1	// Save any other registers that we change in the interrupt handler.

	exg	r6	// Return address is before r0's old contents since we have to decrement the return address

	.liconst 0xffffffb0 // Interruptbase
	mr	r0

	li	0
	st	r0	// Disable interrupts
	ld	r0	// Read interrupts to acknowledge the ones we've received - 
			// tmp now contains a bitmap of triggered interrupts.


	li	1	// tick = tick ^ 1;
	mr	r1
	.lipcrel tick,4
	ldidx	r7
	xor	r1
	.lipcrel tick,8
	addt	r7
	stmpdec	r1

	mr	r1
	li	1
	stdec	r1


	ldinc r6	// Restore r1
	mr	r1

	li	1
	st	r0		// Re-enable interrupts

	ldinc r6	// Return address
	mr	r0
	li	-1
	add	r0		// Decrement return address
	ldinc r6
	exg	r0		// Restore r0
	mr	r7		// Jump to return address - 1.

tick:
	.int	0
	.int	0

entry:
	// Setup the stack
	.liconst	0x800
	mr	r6

#define TIMERBASE 0xFFFFFC00
#define REG_TIMER_ENABLE 0
#define REG_TIMER_INDEX 4
#define REG_TIMER_COUNTER 8

	.liconst 0xfffffc04  //  TIMERBASE+REG_TIMER_INDEX	// Setup the timer
	mr	r0
	li	0
	st	r0

	.liconst 0xfffffc08 //  TIMERBASE+REG_TIMER_COUNTER
	mr	r0
	.liconst 100000
	st	r0

	.liconst 0xfffffc00 // TIMERBASE+REG_TIMER_ENABLE
	mr	r0
	li	1
	st	r0

	.liconst 0xffffffb0 // Interruptbase
	mr	r0
	li	1
	st	r0

	// Main loop:

	.lipcrel tick,4
	addt	r7
	mr	r5
.loop:

//	cond NEX	// Wait for interrupt

	li	-4
	addt	r5
	mr	r0
	ld	r0
	cond EQ
		.lipcrel .loop
		add	r7	// Branch to .loop

	li	0
	st	r0

	ld	r5
	cond EQ	// If/else control flow using just predication - no branching required.
		.liabs .ticktext
	cond NEQ
		.liabs .tocktext
	cond EX

	mr	r0
	.lipcrel Puts
	add	r7	// Call the Puts subroutine

	.lipcrel .loop
	add	r7	// Branch to .loop

.ticktext:
	.ascii "Tick"
	.byte	10
	.byte	0
.tocktext:
	.ascii "Tock"
	.byte	10
	.byte	0


Puts:	// Sends the string pointed to by r0 to the UART
	stdec	r6
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6

	.liconst 0xffffffc0	// UART register
	mr	r1

.txwait:
	ld	r1
	mr	r2
	.liconst 0x100	// TX Ready flag
	and	r2
	cond	EQ
		.lipcrel .txwait
		add	r7

	ldbinc	r0
	cond	NEQ
		st	r1
		.lipcrel .txwait
		add	r7

	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r1
	ldinc	r6
	mr	r7	// 27 bytes

