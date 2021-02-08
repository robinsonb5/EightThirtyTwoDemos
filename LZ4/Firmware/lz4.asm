
start: // 0
	// Setup the stack
	.liconst 0x800
	mr	r6

	// Setup source and destination pointers
	.lipcrel compressed
	mr	r0

	.lipcrel decompressed
	mr	r1
	mr	r2


	// Call the depack routine

	.lipcrel lz4_depack
	add	r7

	li	0
	stbinc	r1	// Write a zero-termination.

	// Now write the depacked buffer to UART.

	.lipcrel decompressed
	mr	r1

	.liconst	0xffffffc0	// UART register
	mr	r0

.txwait: // 0x15
	.liconst 0x100	// TX Ready flag
	mr	r2
	ld	r0
	and	r2
	cond	EQ
	.lipcrel	.txwait
	add	r7

	ldbinc	r1
	cond	NEQ
		st	r0
		.lipcrel	.txwait
		add	r7

.end:
	.lipcrel .end
	cond NEX
	add	r7
	add	r7


//	832 code: 72 bytes
//	68K original: 74 bytes
//	MIPS transliteration of 68K code: 204 bytes
//	r0 packed buffer
//	r1 destination pointer
//	r2 packed buffer end

	.global lz4_depack
lz4_depack:	// Source pointer in r0, dest pointer in r1, end of compressed data in r2
	stdec	r6

.tokenLoop:
	ldbinc	r0
	mr	r4
	mr	r5
	li	15
	and	r4
	li	4
	shr	r5
	cond	EQ
	  .lipcrel .lenOffset
	  add	r7

	.lipcrel .readLen
	add	r7

.litCopy:
	ldbinc	r0
	stbinc	r1
	li	1
	sub	r5
	cond	NEQ
	  .lipcrel .litCopy
	  add	r7

	mt	r2
	cmp	r0
	cond	SLT
	  .lipcrel .lenOffset
	  add	r7
			
.over:
	ldinc	r6
	mr	r7
			
.lenOffset:
	ldbinc	r0
	mr	r3
	li	8
	ror	r3
	ldbinc	r0
	or	r3
	li	24
	ror	r3

	mt	r1
	exg	r4
	mr	r5

	mt	r3
	sub	r4

	.lipcrel .readLen
	add	r7

	li	4
	add	r5
.copy:
	ldbinc	r4
	stbinc	r1
	li	1
	sub	r5
	cond	NEQ
	  .lipcrel .copy
	  add	r7

	.lipcrel .tokenLoop
	add	r7

.readLen:
	stdec	r6
	li	15
	cmp	r5
	cond	NEQ
	  .lipcrel .readEnd
	  add	r7

.readLoop:
	ldbinc	r0
	mr	r3
	add	r5
	.liconst 0xff
	xor	r3
	cond	EQ
	  .lipcrel .readLoop
	  add	r7

.readEnd:
	ldinc	r6
	mr	r7

compressed:
	.incbin "compressed.lz4"
decompressed:
	.space 550  // Reserve space for the decompressed data


