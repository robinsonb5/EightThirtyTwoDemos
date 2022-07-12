	// Assembly language draw functions.
	// Currently only supports 32-bit screenmode.

	.section	.text.makeRectFastUnrolled
	
	// Parameters:  r1 - xS, (r6) - yS, 4(a6) - xE, 8(a6) - yE, 12(a6) - color
	
	.global	_makeRectFastUnrolled
_makeRectFastUnrolled:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5	// 16 bytes on the stack
	exg	r6

	.liconst	16
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
	
	.liconst	20
	ldidx	r6	// xE
	exg	r1
	sub	r1	// r1 now contains the span width

	.liconst 28
	ldidx	r6 // colour
	mr	r4
	
	.liabs _screenwidth
	ldt
	mr	r3
	mt	r1
	sub	r3
	.liconst 4
	mul	r3	// r3 contains the row modulo

	.liconst 24
	ldidx r6
	mr	r2
	.liconst 16
	ldidx r6
	sub r2	// r2 contains the number of rows

.urowloop:

	mt	r1
	mr	r0
	.liconst	0x7
	and r0
	cond EQ
		.lipcrel .uskip
		add r7
		
.ucolloop
	mt	r4
	stinc	r5
	.liconst 1
	sub	r0
	cond NEQ
		.lipcrel .ucolloop
		add r7

.uskip:
	mt	r1
	mr	r0
	.liconst	0xfffffff8
	and r0
	cond EQ
		.lipcrel .uskip2
		add r7
.ucolburstloop
	mt	r4
	stinc	r5
	stinc	r5
	stinc	r5
	stinc	r5
	stinc	r5
	stinc	r5
	stinc	r5
	stinc	r5
	.liconst 8
	sub	r0
	cond SGT
		.lipcrel .ucolburstloop
		add r7

.uskip2:
	mt	r3
	add	r5

	.liconst 1
	sub	r2
	cond	NEQ
		.lipcrel .urowloop
		add	r7

	ldinc	r6
	mr	r5

	ldinc	r6
	mr	r4

	ldinc	r6
	mr	r3

	ldinc	r6
	mr	r7


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

	.liconst	16
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
	
	.liconst	20
	ldidx	r6	// xE
	exg	r1
	sub	r1	// r1 now contains the span width

	.liconst 28
	ldidx	r6 // colour
	mr	r4
	
	.liabs _screenwidth
	ldt
	mr	r3
	mt	r1
	sub	r3
	.liconst 4
	mul	r3	// r3 contains the row modulo

	.liconst 24
	ldidx r6
	mr	r2
	.liconst 16
	ldidx r6
	sub r2	// r2 contains the number of rows

.rowloop:

	mt	r1
	mr	r0
.colloop
	mt	r4
	stinc	r5
	.liconst 1
	sub	r0
	cond NEQ
		.lipcrel .colloop
		add r7

	mt	r3
	add	r5

	.liconst 1
	sub	r2
	cond	NEQ
		.lipcrel .rowloop
		add	r7

	ldinc	r6
	mr	r5

	ldinc	r6
	mr	r4

	ldinc	r6
	mr	r3

	ldinc	r6
	mr	r7

