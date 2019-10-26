#include "assembler.pp"


start: // 0
	// Setup the stack
	li	IMW2(0x800)
	li	IMW1(0x800)
	li	IMW0(0x800)
	mr	r6

	// Setup source and destination pointers
	li	IMW1(compressed-start)
	li	IMW0(compressed-start)
	mr	r0

	li	IMW1(decompressed-start)
	li	IMW0(decompressed-start)
	mr	r1
	mr	r2


	// Call the depack routine

	li	IMW0(PCREL(lz4_depack))
	add	r7

	li	0
	stbinc	r1	// Write a zero-termination.

	// Now write the depacked buffer to UART.

	li	IMW1(decompressed-start)
	li	IMW0(decompressed-start)
	mr	r1

	li	IMW1(0xffffffc0)	// UART register
	li	IMW0(0xffffffc0)
	mr	r0

.txwait: // 0x15
	li	IMW1(0x100)	// TX Ready flag
	li	IMW0(0x100)
	mr	r2
	ld	r0
	and	r2
	cond	EQ
	li	IMW0(PCREL(.txwait))
	add	r7

	ldbinc	r1
	cond	NEQ
	st	r0
	li	IMW0(PCREL(.txwait))
	add	r7

.end:
	li	IMW0(PCREL(.end))
	add	r7


//	832 code: 72 bytes
//	68K original: 74 bytes
//	MIPS transliteration of 68K code: 204 bytes
//	r0 packed buffer
//	r1 destination pointer
//	r2 packed buffer end

lz4_depack: // 0x24
	stdec	r6
	li	PCREL(.tokenLoop)
	add	r7
			
.lenOffset: // 0x27 
	ldbinc	r0
	mr	r3
	li	8
	ror	r3
	ldbinc	r0
	or	r3
	li	24
	ror	r3

	mt	r4
	mr	r5

	mt	r1
	mr	r4
	mt	r3
	sub	r4

	li	IMW1(PCREL(.readLen-1))
	li	IMW0(PCREL(.readLen))
	add	r7

	li	4
	add	r5
.copy:
	ldbinc	r4
	stbinc	r1
	li	1
	sub	r5
	cond	NEQ
	  li	IMW0(PCREL(.copy))
	  add	r7
			
.tokenLoop:	// 0x41
	ldbinc	r0
	mr	r4
	mr	r5
	li	15
	and	r4
	li	4
	shr	r5
	cond	EQ
	  li	IMW1(PCREL(.lenOffset-1))
	  li	IMW0(PCREL(.lenOffset))
	  add	r7

	li	IMW0(PCREL(.readLen))
	add	r7

.litCopy: // 0x4e
	ldbinc	r0
	stbinc	r1
	li	1
	sub	r5
	cond	NEQ
	  li	IMW0(PCREL(.litCopy))
	  add	r7

	mt	r2
	cmp	r0
	cond	SLT
	  li	IMW1(PCREL(.lenOffset-1))
	  li	IMW0(PCREL(.lenOffset))
	  add	r7
			
.over: // 0x5b
	ldinc	r6
	mr	r7

.readLen: // 0x5d
	stdec	r6
	li	15
	cmp	r5
	cond	NEQ
	  li	IMW0(PCREL(.readEnd))
	  add	r7

.readLoop: // 0x63
	ldbinc	r0
	mr	r3
	add	r5
	li	IMW1(255)
	li	IMW0(255)
	xor	r3
	cond	EQ
	  li	IMW0(PCREL(.readLoop))
	  add	r7

.readEnd: // 0x6c
	ldinc	r6
	mr	r7

compressed:
	.incbin "compressed.lz4"
decompressed:
	.fill	550,1,-1  // Reserve space for the decompressed data


