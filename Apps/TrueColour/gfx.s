	// Assembly language draw functions.
	// Currently only supports 32-bit screenmode.

	.section	.text.makeRectFast
	
	// Parameters:  r1 - xS, (r6) - yS, 4(a6) - xE, 8(a6) - yE, 12(a6) - color
	
	.global	_makeRectFast
_makeRectFast:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5	// 16 bytes on the stack
	exg	r6
	stdec	r6	// Allocate 4 stack bytes
	stdec	r6	// Allocate another 4 stack bytes

	.liconst	24
	ldidx	r6	// yS
	mr	r5
	.liabs _screenwidth
	ldt
	mul	r5
	mt	r1
	add	r5
	.liconst 4
	mul	r5	// r5 now contains an offset into the framebuffer
	.liabs	_FrameBuffer
	ldt
	add	r5	// r5 now points to the data
	
	.liconst	28
	ldidx	r6	// xE
	exg	r1
	sub	r1	// r1 now contains the span width
	mt	r1
	st	r6	// Span width is now at the top of the stack
	
	.liconst 36
	ldidx	r6 // colour
	mr	r4
	.liconst 1
	shr	r4
	.liconst 0x7f7f7f7f
	and	r4
	
	.liabs _screenwidth
	ldt
	mr	r3
	mt	r1
	sub	r3
	.liconst 4
	mul	r3	// r3 contains the row modulo
	
	.liconst 8
	addt	r6
	stmpdec r3 // 4(a6) contains the row modulo

	.liconst 32
	ldidx r6
	mr	r2
	.liconst 24
	ldidx r6
	sub r2	// r2 contains the number of rows

	.liconst 0x7f7f7f7f
	mr r1

.rowloop:

	ld	r6	// Span width
	mr	r0
.colloop
	ld	r5
	mr	r3
	.liconst 1
	shr	r3
	.liconst 0x7f7f7f7f
	and r3
	mt	r4
	addt r3
	stinc	r5
	.liconst 1
	sub	r0
	cond NEQ
		.lipcrel .colloop
		add r7

	.liconst 4
	ldidx	r6	// Row modulo
	add	r5

	.liconst 1
	sub	r2
	cond	NEQ
		.lipcrel .rowloop
		add	r7

	ldinc	r6 // Restore stack
	ldinc	r6 // Restore stack
	ldinc	r6
	mr	r5

	ldinc	r6
	mr	r4

	ldinc	r6
	mr	r3

	ldinc	r6
	mr	r7

