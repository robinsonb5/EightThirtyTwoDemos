	.equ TIMERBASE 0xFFFFFC00
	.equ REG_TIMER_ENABLE 0
	.equ REG_TIMER_INDEX 4
	.equ REG_TIMER_COUNTER 8

	.equ INTERRUPTBASE 0xffffffb0

	.equ VGABASE 0xFFFFFE00
	.equ REG_VGA_FRAMEBUFFER 0
	.equ REG_VGA_SP0PTR 0x10
	.equ REG_VGA_SP0XPOS 0x14
	.equ REG_VGA_SP0YPOS 0x18

	.section .text.main

	.global vector
vector: // Entry point and interrupt vector.  On interrupt zero flag will be set.
	cond SGT	// Carry clear, zero clear - thread 1
		.lipcrel entry
		add	r7
	cond SLT	// Carry set, zero clear - thread 2
		.lipcrel thread2_entry
		add	r7

	.global interrupt
interrupt:	// We fall through to here if we're servicing an interrupt.
	exg	r6	// Swap the stack pointer and return address.
	stmpdec	r0	// Save one register's contents to the stack (with the stack pointer in tmp)
	stmpdec	r6	// Save the return address
	stmpdec	r1	// Save any other registers that we change in the interrupt handler.
	stmpdec	r2
	exg	r6	// Return address is before r0's old contents since we have to decrement the return address

	.liconst INTERRUPTBASE
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
		.lipcrel tick,4
		ldidx	r7
		xor	r1
		.lipcrel tick,8
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
		.lipcrel	fbptr
		addt	r7
		mr	r2
		ld	r2
		add	r1
		li	12
		shl	r1
		li	1
		or	r1
		li	12
		ror	r1
		mt	r1
		st	r2
		
		.liconst VGABASE+REG_VGA_FRAMEBUFFER+4
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
	li	-1
	add	r0		// Decrement return address
	ldinc r6
	exg	r0		// Restore r0
	mr	r7		// Jump to return address - 1.

	.global tick
tick:
	.int	0
	.int	0
	.global fbptr
fbptr:
	.int	0

	.global thread2_entry
thread2_entry:
	// Setup the stack
	.liconst 0x400
	mr	r6

	.liconst 0x10100000
	mr	r4
	li	0
	mr	r3
.thread2mainloop:
	mt	r3
	st	r4
	li	1
	add	r3
	li	4
	add	r4	// Just write an ever-increasing value to an ever-increasing address.
	li	12
	shl r4	// Get rid of MSB to avoid hitting peripheral space
	.liconst 0x101
	or	r4
	li	12
	ror	r4
	.lipcrel .thread2mainloop
	add	r7

	.global entry
entry:
	// Setup the stack
	.liconst 0x800
	mr	r6

	.liconst TIMERBASE+REG_TIMER_INDEX	// Setup the timer
	mr	r0
	li	0
	st	r0
	.liconst TIMERBASE+REG_TIMER_COUNTER
	mr	r0
	.liconst 100000
	st	r0

	.liconst TIMERBASE+REG_TIMER_ENABLE
	mr	r0
	li	1
	st	r0

	.liconst INTERRUPTBASE	// Enable interrupts
	mr	r0
	li	1
	st	r0

	// Main loop:

	li	0
	mr	r1
	.liconst VGABASE+REG_VGA_FRAMEBUFFER
	mr	r2

	.lipcrel tick,4
	addt	r7
	mr	r5

.loop:
	cond NEX	// Suspend execution.  An interrupt will restart it.
	mt r0		// This instruction will be lost.
	mt r0		// This one gives the interrupt an opportunity to fire

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

	mr	r1
	.lipcrel _puts
	add	r7	// Call the Puts subroutine

	.lipcrel .loop
	add	r7	// Branch to .loop

.ticktext:
	.ascii "Tick"
	.byte 10
	.byte 0
.tocktext:
	.ascii "Tock"
	.byte 10
	.byte 0

