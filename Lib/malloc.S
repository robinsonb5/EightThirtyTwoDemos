#include "assembler.pp"

	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
l2:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// allocreg r3

	//../../Lib//malloc.c, line 35
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r3
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r3
					// (save result) isreg

	//../../Lib//malloc.c, line 35
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 8)
	//(val 0)
	ld	r3
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2

	//../../Lib//malloc.c, line 36
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 36
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 12)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r4

	//../../Lib//malloc.c, line 37
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 5
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
	mr	r4
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 37
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r2, offset 4, val 0
	mt	r2
					// (save temp) store
	st	r4
				//save_temp done
				// freereg r4

	//../../Lib//malloc.c, line 38
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 38
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
l5:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// allocreg r3

	//../../Lib//malloc.c, line 45
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r3
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r3
					// (save result) isreg

	//../../Lib//malloc.c, line 45
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 8)
	//(val 0)
	ld	r3
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2

	//../../Lib//malloc.c, line 46
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 46
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 12)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r4

	//../../Lib//malloc.c, line 47
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 5
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
	mr	r4
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 47
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r2, offset 4, val 0
	mt	r2
					// (save temp) store
	st	r4
				//save_temp done
				// freereg r4

	//../../Lib//malloc.c, line 48
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 48
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
	//registers used:
		//r0: yes
		//r1: yes
		//r2: no
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
l8:
	stdec	r6

	//../../Lib//malloc.c, line 53
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//../../Lib//malloc.c, line 53
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5))
	add	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//malloc.c, line 54
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//../../Lib//malloc.c, line 54
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l2)-1)
	li	IMW0(PCREL(l2))
	add	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

	ldinc	r6
	mr	r7

// stacksize=0+??
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	___malloc_from_block
___malloc_from_block:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// constant: 8 in 1 chunks
	li	IMW0(8)
	sub	r6
				// allocreg r2

	//../../Lib//malloc.c, line 62
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 62
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 20)
	//(val 0)
	ld	r2
					// (save temp) store
	st	r1
				//save_temp done
				// freereg r2
				// allocreg r2

	//../../Lib//malloc.c, line 65
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 65
// code 0x4d
					// (compare) (q1 unsigned) (q2 unsigned)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
	ld	r6
	mr	r1
					// (objtotemp)  reg r2, offset 32, val 0
	mt	r2
	cmp	r1
				// freereg r2

	//../../Lib//malloc.c, line 65
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l14)-1)
	li	IMW0(PCREL(l14))
		add	r7
				// allocreg r3

	//../../Lib//malloc.c, line 67
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
	add	r3
					// (save result) isreg
				// allocreg r2

	//../../Lib//malloc.c, line 68
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg
				// allocreg r4

	//../../Lib//malloc.c, line 68
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 100)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib//malloc.c, line 70
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//malloc.c, line 71
// code 0x1c
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
	ld	r6
	mr	r0
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
	sub	r0
					// (save result) store reg
// Store_reg to type 0x103
					// (prepobj tmp) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// allocreg r5

	//../../Lib//malloc.c, line 71
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 6
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r5
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r5
					// (save result) isreg

	//../../Lib//malloc.c, line 71
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
					// (save temp) store
	st	r5
				//save_temp done
				// freereg r5

	//../../Lib//malloc.c, line 72
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// var FIXME - deref? reg 
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done
				// allocreg r5

	//../../Lib//malloc.c, line 73
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r5
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r5
					// (save result) isreg

	//../../Lib//malloc.c, line 73
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
					// (save temp) store
	st	r5
				//save_temp done
				// freereg r5
				// allocreg r5

	//../../Lib//malloc.c, line 77
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 6
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r5
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r5
					// (save result) isreg

	//../../Lib//malloc.c, line 77
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
					// (save temp) store
	st	r5
				//save_temp done
				// freereg r5
				// allocreg r5

	//../../Lib//malloc.c, line 78
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 6
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r5
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r5
					// (save result) isreg

	//../../Lib//malloc.c, line 78
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r4, offset 8, val 0
	mt	r4
					// (save temp) store
	st	r5
				//save_temp done
				// freereg r5

	//../../Lib//malloc.c, line 79
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 79
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
					// (save temp) store
	st	r4
				//save_temp done
				// freereg r4

	//../../Lib//malloc.c, line 80
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2
				// allocreg r4

	//../../Lib//malloc.c, line 83
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 5
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r4
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 83
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 72)
	//(val 0)
	ld	r4
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r2

	//../../Lib//malloc.c, line 83
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 83
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r4, offset 12, val 0
	mt	r4
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2
				// allocreg r2

	//../../Lib//malloc.c, line 84
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 84
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 80)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r5

	//../../Lib//malloc.c, line 84
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 6
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r5
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r5
					// (save result) isreg

	//../../Lib//malloc.c, line 84
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r2, offset 16, val 0
	mt	r2
					// (save temp) store
	st	r5
				//save_temp done
				// freereg r5

	//../../Lib//malloc.c, line 85
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 85
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
					// (save temp) store
	st	r4
				//save_temp done
				// freereg r4

	//../../Lib//malloc.c, line 86
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 86
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2

	//../../Lib//malloc.c, line 87
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l15)-1)
	li	IMW0(PCREL(l15))
	add	r7
l14: # 

	//../../Lib//malloc.c, line 88
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// var FIXME - deref? reg 
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 89
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	stdec	r6

	//../../Lib//malloc.c, line 89
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5))
	add	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l15: # 
				// allocreg r2

	//../../Lib//malloc.c, line 92
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 92
// code 0x5e
					//setreturn
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r2, offset 96, val 0
	mt	r2
	mr	r0
				// freereg r2
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
l16:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r5
				// allocreg r4
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib//malloc.c, line 99
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	stdec	r6

	//../../Lib//malloc.c, line 99
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l19+0
	stdec	r6

	//../../Lib//malloc.c, line 99
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//malloc.c, line 101
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 101
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 16)
	//(val 0)
	ld	r2
					// (save temp) store
	st	r1
				//save_temp done
				// freereg r2
				// allocreg r2

	//../../Lib//malloc.c, line 102
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 102
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 20)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r5
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 115
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? reg 
	ld	r6
		//sizemod based on type 0x3
	ldt
//marker 2
	mr	r1
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 115
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l21)-1)
	li	IMW0(PCREL(l21))
		add	r7
				// allocreg r2

	//../../Lib//malloc.c, line 115
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 115
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 3, 3
					// (objtotemp)  deref 
	//(offset 24)
	//(val 0)
	ld	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
	ld	r6
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 115
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//malloc.c, line 115
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l21)-1)
	li	IMW0(PCREL(l21))
		add	r7

	//../../Lib//malloc.c, line 117
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l23+0
	stdec	r6

	//../../Lib//malloc.c, line 117
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//../../Lib//malloc.c, line 118
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg
				// allocreg r3

	//../../Lib//malloc.c, line 118
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 4
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r3
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r3
					// (save result) isreg

	//../../Lib//malloc.c, line 118
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 3, 1
					// (objtotemp)  deref 
	//(offset 40)
	//(val 0)
	ld	r3
	mr	r0
					// (objtotemp)  deref 
	//(offset 36)
	//(val 0)
	ld	r2
	add	r0
					// (save result) store reg
// Store_reg to type 0x103
	mt	r0
	st	r2
				// freereg r3
				// freereg r2
				// allocreg r2

	//../../Lib//malloc.c, line 119
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 119
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2
				// allocreg r2

	//../../Lib//malloc.c, line 120
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 120
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
	ld	r6
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 122
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
	ld	r6
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib//malloc.c, line 124
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l24)-1)
	li	IMW0(PCREL(l24))
	add	r7
l21: # 

	//../../Lib//malloc.c, line 126
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r4
				//save_temp done
				// allocreg r2

	//../../Lib//malloc.c, line 131
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 131
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) //static not varadr
				//statictotemp
	ldinc	r7
	.int	l1+16
	//static deref
	ldt
					// (save temp) store
	st	r2
				//save_temp done
				// allocreg r3

	//../../Lib//malloc.c, line 132
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 4
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r3
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r3
					// (save result) isreg

	//../../Lib//malloc.c, line 132
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 10)					// (prepobj tmp) static
	ldinc	r7
	.int	l1+0
// static pe is varadr
					// (save temp) store
	st	r3
				//save_temp done
				// freereg r3

	//../../Lib//malloc.c, line 133
// code 0x2
					// (a/p assign)
					// (prepobj r1) static
	ldinc	r7
	.int	l1+16
// static pe not varadr
	mr	r1
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 134
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  deref 
	//(offset 128)
	//(val 0)
	ld	r2
	mr	r2
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 134
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2
l24: # 

	//../../Lib//malloc.c, line 143
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r5
	mr	r1
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 143
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l26)-1)
	li	IMW0(PCREL(l26))
		add	r7
				// allocreg r2

	//../../Lib//malloc.c, line 143
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 143
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 3, 3
					// (objtotemp)  deref 
	//(offset 60)
	//(val 0)
	ld	r2
	mr	r2
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 143
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//malloc.c, line 143
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l26)-1)
	li	IMW0(PCREL(l26))
		add	r7
				// allocreg r2

	//../../Lib//malloc.c, line 144
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg
				// allocreg r3

	//../../Lib//malloc.c, line 144
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 4
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r3
					// (save result) isreg

	//../../Lib//malloc.c, line 144
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 3, 1
					// (objtotemp)  deref 
	//(offset 72)
	//(val 0)
	ld	r3
	mr	r0
					// (objtotemp)  deref 
	//(offset 68)
	//(val 0)
	ld	r2
	add	r0
					// (save result) store reg
// Store_reg to type 0x103
	mt	r0
	st	r2
				// freereg r3
				// freereg r2

	//../../Lib//malloc.c, line 145
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	stdec	r6

	//../../Lib//malloc.c, line 145
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l28+0
	stdec	r6

	//../../Lib//malloc.c, line 145
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//malloc.c, line 148
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	stdec	r6

	//../../Lib//malloc.c, line 148
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l8)-1)
	li	IMW0(PCREL(l8))
	add	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l26: # 

	//../../Lib//malloc.c, line 152
// code 0x5e
					//setreturn
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r0
				// freereg r4
				// freereg r5
	ldinc	r6	// quickest way to add 4 to sp
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
	.section	.rodata
l23:
	.byte	67
	.byte	111
	.byte	97
	.byte	108
	.byte	101
	.byte	115
	.byte	99
	.byte	105
	.byte	110
	.byte	103
	.byte	46
	.byte	46
	.byte	46
	.byte	10
	.byte	0
l28:
	.byte	77
	.byte	101
	.byte	114
	.byte	103
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	119
	.byte	105
	.byte	116
	.byte	104
	.byte	32
	.byte	115
	.byte	117
	.byte	98
	.byte	115
	.byte	101
	.byte	113
	.byte	117
	.byte	101
	.byte	110
	.byte	116
	.byte	32
	.byte	98
	.byte	108
	.byte	111
	.byte	99
	.byte	107
	.byte	58
	.byte	32
	.byte	37
	.byte	120
	.byte	10
	.byte	0
l19:
	.byte	70
	.byte	114
	.byte	101
	.byte	101
	.byte	32
	.byte	98
	.byte	108
	.byte	111
	.byte	99
	.byte	107
	.byte	58
	.byte	32
	.byte	37
	.byte	120
	.byte	10
	.byte	0
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_malloc_add
_malloc_add:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r5

	//../../Lib//malloc.c, line 160
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 161
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// var FIXME - deref? reg 
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done
				// allocreg r3

	//../../Lib//malloc.c, line 162
// code 0x12
					// (bitwise) loadreg
	//ops: 0, 0, 4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r3
					// (objtotemp)  const
				// constant: fffffe00 in 2 chunks
	li	IMW1(-512)
	li	IMW0(-512)
	and	r3
					// (save result) isreg
				// allocreg r2

	//../../Lib//malloc.c, line 162
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 162
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r3, offset 8, val 0
	mt	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2

	//../../Lib//malloc.c, line 165
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	stdec	r6

	//../../Lib//malloc.c, line 165
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
	stdec	r6

	//../../Lib//malloc.c, line 165
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l31+0
	stdec	r6

	//../../Lib//malloc.c, line 165
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//../../Lib//malloc.c, line 167
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l1+0
	stdec	r6

	//../../Lib//malloc.c, line 167
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l32+0
	stdec	r6

	//../../Lib//malloc.c, line 167
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//malloc.c, line 173
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) //static not varadr
				//statictotemp
	ldinc	r7
	.int	l1+12
	//static deref
	ldt
					// (save temp) isreg
	mr	r5
				//save_temp done

	//../../Lib//malloc.c, line 174
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? static
	ldinc	r7
	.int	l1+12
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 174
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l40)-1)
	li	IMW0(PCREL(l40))
		add	r7
l39: # 

	//../../Lib//malloc.c, line 175
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
	ld	r6
	sgn
	cmp	r5

	//../../Lib//malloc.c, line 175
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l40)-1)
	li	IMW0(PCREL(l40))
		add	r7
				// allocreg r2

	//../../Lib//malloc.c, line 174
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 174
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 28)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r5
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 174
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r5
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 174
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39))
		add	r7
l40: # 
				// allocreg r3

	//../../Lib//malloc.c, line 181
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 4
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r3
					// (save result) isreg
				// allocreg r2

	//../../Lib//malloc.c, line 181
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 181
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 68)
	//(val 0)
	ld	r3
					// (save temp) store
	st	r2
				//save_temp done
				// allocreg r4

	//../../Lib//malloc.c, line 182
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 5
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r4
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 182
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done
				// freereg r4

	//../../Lib//malloc.c, line 183
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
	ld	r6
					// (save temp) store
	st	r3
				//save_temp done
				// freereg r3

	//../../Lib//malloc.c, line 184
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  deref 
	//(offset 72)
	//(val 0)
	ld	r2
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 184
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
	ld	r6
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 187
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
	ld	r6
	stdec	r6

	//../../Lib//malloc.c, line 187
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l16)-1)
	li	IMW0(PCREL(l16))
	add	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// freereg r5
	ldinc	r6	// quickest way to add 4 to sp
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
l31:
	.byte	65
	.byte	100
	.byte	100
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	37
	.byte	120
	.byte	32
	.byte	98
	.byte	121
	.byte	116
	.byte	101
	.byte	115
	.byte	32
	.byte	97
	.byte	116
	.byte	32
	.byte	37
	.byte	120
	.byte	32
	.byte	116
	.byte	111
	.byte	32
	.byte	116
	.byte	104
	.byte	101
	.byte	32
	.byte	109
	.byte	101
	.byte	109
	.byte	111
	.byte	114
	.byte	121
	.byte	32
	.byte	112
	.byte	111
	.byte	111
	.byte	108
	.byte	10
	.byte	0
l32:
	.byte	77
	.byte	97
	.byte	108
	.byte	108
	.byte	111
	.byte	99
	.byte	32
	.byte	104
	.byte	101
	.byte	97
	.byte	100
	.byte	58
	.byte	32
	.byte	37
	.byte	120
	.byte	10
	.byte	0
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_malloc
_malloc:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// allocreg r4
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3

	//../../Lib//malloc.c, line 197
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	stdec	r6

	//../../Lib//malloc.c, line 197
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l43+0
	stdec	r6

	//../../Lib//malloc.c, line 197
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//malloc.c, line 199
// code 0x44
					// (test)
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	and	r4

	//../../Lib//malloc.c, line 199
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l45)-1)
	li	IMW0(PCREL(l45))
		add	r7

	//../../Lib//malloc.c, line 200
// code 0x5e
					//setreturn
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib//malloc.c, line 203
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l45: # 
				// allocreg r2

	//../../Lib//malloc.c, line 203
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 1f in 1 chunks
	li	IMW0(31)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 203
// code 0x12
					// (bitwise) loadreg
	//ops: 3, 0, 5
					// (objtotemp)  reg r2, offset 24, val 0
	mt	r2
	mr	r4
					// (objtotemp)  const
				// constant: fffffff0 in 1 chunks
	li	IMW0(-16)
	and	r4
					// (save result) isreg
				// freereg r2

	//../../Lib//malloc.c, line 204
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) //static not varadr
				//statictotemp
	ldinc	r7
	.int	l1+16
	//static deref
	ldt
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 205
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? static
	ldinc	r7
	.int	l1+16
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 205
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l53)-1)
	li	IMW0(PCREL(l53))
		add	r7
l52: # 
				// allocreg r2

	//../../Lib//malloc.c, line 207
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 207
// code 0x4d
					// (compare) (q1 unsigned) (q2 unsigned)					// (objtotemp)  deref 
	//(offset 36)
	//(val 0)
	ld	r2
	mr	r1
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	cmp	r1
				// freereg r2

	//../../Lib//malloc.c, line 207
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l51)-1)
	li	IMW0(PCREL(l51))
		add	r7

	//../../Lib//malloc.c, line 209
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r4, offset -4, val 0
	mt	r4
	stdec	r6

	//../../Lib//malloc.c, line 209
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
	stdec	r6

	//../../Lib//malloc.c, line 209
// code 0x2a
					//call
	ldinc	r7
	.int	___malloc_from_block
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//malloc.c, line 209
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//malloc.c, line 209
// code 0x5e
					//setreturn
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r2, offset 40, val 0
	mt	r2
	mr	r0
				// freereg r2

	//../../Lib//malloc.c, line 210
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l51: # 
				// allocreg r2

	//../../Lib//malloc.c, line 205
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 0, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 205
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 44)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r3
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 205
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 0)
	//(val 0)
	ld	r3
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 205
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l52)-1)
	li	IMW0(PCREL(l52))
		add	r7
l53: # 

	//../../Lib//malloc.c, line 217
// code 0x5e
					//setreturn
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l41: # 
				// freereg r3
				// freereg r4
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
l43:
	.byte	67
	.byte	117
	.byte	115
	.byte	116
	.byte	111
	.byte	109
	.byte	32
	.byte	109
	.byte	97
	.byte	108
	.byte	108
	.byte	111
	.byte	99
	.byte	32
	.byte	97
	.byte	115
	.byte	107
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	102
	.byte	111
	.byte	114
	.byte	32
	.byte	48
	.byte	120
	.byte	37
	.byte	120
	.byte	32
	.byte	98
	.byte	121
	.byte	116
	.byte	101
	.byte	115
	.byte	10
	.byte	0
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_free
_free:
	stdec	r6
	mt	r2
	stdec	r6

	//../../Lib//malloc.c, line 224
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6

	//../../Lib//malloc.c, line 224
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l54)-1)
	li	IMW0(PCREL(l54))
		add	r7
				// allocreg r2

	//../../Lib//malloc.c, line 228
// code 0x1c
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	sub	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 230
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 0, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//../../Lib//malloc.c, line 230
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l16)-1)
	li	IMW0(PCREL(l16))
	add	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l54: # 
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_malloc_dump
_malloc_dump:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
				// allocreg r4
				// allocreg r3

	//../../Lib//malloc.c, line 240
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10)					// (prepobj tmp) static
	ldinc	r7
	.int	l1+0
// static pe is varadr
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 241
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib//malloc.c, line 242
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l60+0
	stdec	r6

	//../../Lib//malloc.c, line 242
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l74: # 
				// allocreg r2

	//../../Lib//malloc.c, line 245
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 245
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 16)
	//(val 0)
	ld	r2
	stdec	r6
				// freereg r2

	//../../Lib//malloc.c, line 245
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r3
	stdec	r6

	//../../Lib//malloc.c, line 245
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	stdec	r6

	//../../Lib//malloc.c, line 245
// code 0x4e
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l64+0
	stdec	r6

	//../../Lib//malloc.c, line 245
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6

				// allocreg r2

	//../../Lib//malloc.c, line 247
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 247
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 24)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r5
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 248
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r5, offset 0, val 0
	mt	r5
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 249
// code 0x1c
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 250
// code 0x44
					// (test)
					// (objtotemp)  reg r4, offset 8, val 0
	mt	r4
	and	r4

	//../../Lib//malloc.c, line 250
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l76)-1)
	li	IMW0(PCREL(l76))
		add	r7

	//../../Lib//malloc.c, line 250
// code 0x44
					// (test)
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	and	r3

	//../../Lib//malloc.c, line 250
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l76)-1)
	li	IMW0(PCREL(l76))
		add	r7

	//../../Lib//malloc.c, line 250
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r3
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 250
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l74)-1)
	li	IMW0(PCREL(l74))
		add	r7
l76: # 

	//../../Lib//malloc.c, line 252
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l67+0
	stdec	r6

	//../../Lib//malloc.c, line 252
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//malloc.c, line 253
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10)					// (prepobj tmp) static
	ldinc	r7
	.int	l1+0
// static pe is varadr
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 254
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) isreg
	mr	r4
				//save_temp done
l75: # 
				// allocreg r2

	//../../Lib//malloc.c, line 257
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 257
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 32)
	//(val 0)
	ld	r2
	stdec	r6
				// freereg r2

	//../../Lib//malloc.c, line 257
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r3
	stdec	r6

	//../../Lib//malloc.c, line 257
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	stdec	r6

	//../../Lib//malloc.c, line 257
// code 0x4e
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l71+0
	stdec	r6

	//../../Lib//malloc.c, line 257
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6

				// allocreg r2

	//../../Lib//malloc.c, line 259
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5, offset 0, val 0
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 259
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 40)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r5
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 260
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r5, offset 0, val 0
	mt	r5
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 261
// code 0x1c
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 262
// code 0x44
					// (test)
					// (objtotemp)  reg r4, offset 8, val 0
	mt	r4
	and	r4

	//../../Lib//malloc.c, line 262
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l77)-1)
	li	IMW0(PCREL(l77))
		add	r7

	//../../Lib//malloc.c, line 262
// code 0x44
					// (test)
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	and	r3

	//../../Lib//malloc.c, line 262
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l77)-1)
	li	IMW0(PCREL(l77))
		add	r7

	//../../Lib//malloc.c, line 262
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r3
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 262
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l75)-1)
	li	IMW0(PCREL(l75))
		add	r7
l77: # 
				// freereg r3
				// freereg r4
				// freereg r5
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
l64:
	.byte	65
	.byte	114
	.byte	101
	.byte	110
	.byte	97
	.byte	32
	.byte	104
	.byte	101
	.byte	97
	.byte	100
	.byte	101
	.byte	114
	.byte	32
	.byte	97
	.byte	116
	.byte	32
	.byte	37
	.byte	120
	.byte	44
	.byte	32
	.byte	116
	.byte	121
	.byte	112
	.byte	101
	.byte	32
	.byte	37
	.byte	120
	.byte	44
	.byte	32
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	32
	.byte	37
	.byte	120
	.byte	10
	.byte	0
l71:
	.byte	65
	.byte	114
	.byte	101
	.byte	110
	.byte	97
	.byte	32
	.byte	104
	.byte	101
	.byte	97
	.byte	100
	.byte	101
	.byte	114
	.byte	32
	.byte	97
	.byte	116
	.byte	32
	.byte	37
	.byte	120
	.byte	44
	.byte	32
	.byte	116
	.byte	121
	.byte	112
	.byte	101
	.byte	32
	.byte	37
	.byte	120
	.byte	44
	.byte	32
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	32
	.byte	37
	.byte	120
	.byte	10
	.byte	0
l60:
	.byte	65
	.byte	108
	.byte	108
	.byte	32
	.byte	99
	.byte	104
	.byte	117
	.byte	110
	.byte	107
	.byte	115
	.byte	10
	.byte	0
l67:
	.byte	70
	.byte	114
	.byte	101
	.byte	101
	.byte	32
	.byte	99
	.byte	104
	.byte	117
	.byte	110
	.byte	107
	.byte	115
	.byte	10
	.byte	0
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_availmem
_availmem:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// allocreg r4
				// allocreg r3

	//../../Lib//malloc.c, line 267
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib//malloc.c, line 268
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) //static not varadr
				//statictotemp
	ldinc	r7
	.int	l1+16
	//static deref
	ldt
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 269
// code 0x44
					// (test)
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	and	r3

	//../../Lib//malloc.c, line 269
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l86)-1)
	li	IMW0(PCREL(l86))
		add	r7

	//../../Lib//malloc.c, line 269
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r3
	mr	r1
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 269
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l86)-1)
	li	IMW0(PCREL(l86))
		add	r7
l85: # 
				// allocreg r2

	//../../Lib//malloc.c, line 271
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 271
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 3, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  deref 
	//(offset 8)
	//(val 0)
	ld	r2
	add	r4
					// (save result) isreg
				// freereg r2
				// allocreg r2

	//../../Lib//malloc.c, line 274
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 274
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
	//(offset 24)
	//(val 0)
	ld	r2
					// (save temp) isreg
	mr	r3
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 269
// code 0x44
					// (test)
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	and	r3

	//../../Lib//malloc.c, line 269
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l86)-1)
	li	IMW0(PCREL(l86))
		add	r7

	//../../Lib//malloc.c, line 269
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 4)
	//(val 0)
	ld	r3
	mr	r1
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 269
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l85)-1)
	li	IMW0(PCREL(l85))
		add	r7
l86: # 

	//../../Lib//malloc.c, line 276
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r4, offset 0, val 0
	mt	r4
	mr	r0
				// freereg r3
				// freereg r4
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.ctors.100
	.int	__initMem
	.section	.text.0
	.global	__initMem
__initMem:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// constant: 10 in 1 chunks
	li	IMW0(16)
	sub	r6
				// allocreg r5
				// allocreg r4
				// allocreg r3

	//../../Lib//malloc.c, line 289
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	__end
// extern pe is varadr
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 293
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r5
				//save_temp done

	//../../Lib//malloc.c, line 294
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 40 in 2 chunks
	li	IMW1(64)
	li	IMW0(64)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 296
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 13 in 1 chunks
	li	IMW0(19)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 297
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	__end
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 55aa44bb in 6 chunks
	li	IMW5(1437222075)
	li	IMW4(1437222075)
	li	IMW3(1437222075)
	li	IMW2(1437222075)
	li	IMW1(1437222075)
	li	IMW0(1437222075)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 298
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 12 in 1 chunks
	li	IMW0(18)
					// (save temp) isreg
	mr	r4
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
					// (save temp) store
	st	r1
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r4, offset 12, val 0
	mt	r4
					// (save temp) store
	st	r1
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 55aa44bb in 6 chunks
	li	IMW5(1437222075)
	li	IMW4(1437222075)
	li	IMW3(1437222075)
	li	IMW2(1437222075)
	li	IMW1(1437222075)
	li	IMW0(1437222075)
					// (save temp) isreg
	mr	r3
				//save_temp done
l89: # 
				// allocreg r2

	//../../Lib//malloc.c, line 300
// code 0x1d
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset 4, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 300
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 3, 3
					// (objtotemp)  reg r2, offset 36, val 0
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 300
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r3, offset 5, val 0
	mt	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2

	//../../Lib//malloc.c, line 301
// code 0x19
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 299
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 10 in 1 chunks
	li	IMW0(16)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//malloc.c, line 299
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	mr	r1
					// (objtotemp)  const
				// constant: 19 in 1 chunks
	li	IMW0(25)
	sgn
	cmp	r1

	//../../Lib//malloc.c, line 299
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l89)-1)
	li	IMW0(PCREL(l89))
		add	r7

	//../../Lib//malloc.c, line 307
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//malloc.c, line 308
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// var FIXME - deref? reg 
	ld	r6
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: f0e1d2c3 in 5 chunks
	li	IMW4(-253635901)
	li	IMW3(-253635901)
	li	IMW2(-253635901)
	li	IMW1(-253635901)
	li	IMW0(-253635901)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib//malloc.c, line 309
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r4
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
					// (save temp) store
	st	r1
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: f0e1d2c3 in 5 chunks
	li	IMW4(-253635901)
	li	IMW3(-253635901)
	li	IMW2(-253635901)
	li	IMW1(-253635901)
	li	IMW0(-253635901)
					// (save temp) isreg
	mr	r5
				//save_temp done
l93: # 
				// allocreg r2

	//../../Lib//malloc.c, line 311
// code 0x1d
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 311
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 3, 3
					// (objtotemp)  reg r2, offset 36, val 0
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 311
// code 0x4d
					// (compare) (q1 unsigned) (q2 unsigned)					// (objtotemp)  deref 
	//(offset 40)
	//(val 0)
	ld	r2
	mr	r1
					// (objtotemp)  reg r5, offset 10, val 0
	mt	r5
	cmp	r1
				// freereg r2

	//../../Lib//malloc.c, line 311
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l98)-1)
	li	IMW0(PCREL(l98))
		add	r7

	//../../Lib//malloc.c, line 312
// code 0x10
					// (bitwise) loadreg
	//ops: 4, 0, 1
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
	mr	r0
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	or	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
l98: # 

	//../../Lib//malloc.c, line 313
// code 0x19
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r3
					// (save result) isreg

	//../../Lib//malloc.c, line 310
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg

	//../../Lib//malloc.c, line 310
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 19 in 1 chunks
	li	IMW0(25)
	sgn
	cmp	r4

	//../../Lib//malloc.c, line 310
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l93)-1)
	li	IMW0(PCREL(l93))
		add	r7
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
					// (save temp) isreg
	mr	r5
				//save_temp done

	//../../Lib//malloc.c, line 316
// code 0x19
					// (bitwise) loadreg
	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	shl	r5
					// (save result) isreg

	//../../Lib//malloc.c, line 318
// code 0x44
					// (test)
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	and	r5

	//../../Lib//malloc.c, line 318
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l108)-1)
	li	IMW0(PCREL(l108))
		add	r7
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 3ffffff in 5 chunks
	li	IMW4(67108863)
	li	IMW3(67108863)
	li	IMW2(67108863)
	li	IMW1(67108863)
	li	IMW0(67108863)
					// (save temp) isreg
	mr	r3
				//save_temp done
l99: # 
				// allocreg r2

	//../../Lib//malloc.c, line 320
// code 0x19
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 320
// code 0x12
					// (bitwise) loadreg
	//ops: 3, 4, 6
					// (objtotemp)  reg r2, offset 60, val 0
	mt	r2
	mr	r5
					// (objtotemp)  reg r3, offset 12, val 0
	mt	r3
	and	r5
					// (save result) isreg
				// freereg r2

	//../../Lib//malloc.c, line 321
// code 0x1a
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shr	r0
					// (save result) store reg
// Store_reg to type 0x103
					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//malloc.c, line 318
// code 0x44
					// (test)
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	and	r5

	//../../Lib//malloc.c, line 318
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l99)-1)
	li	IMW0(PCREL(l99))
		add	r7
l108: # 

	//../../Lib//malloc.c, line 323
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//../../Lib//malloc.c, line 323
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l102+0
	stdec	r6

	//../../Lib//malloc.c, line 323
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//malloc.c, line 325
// code 0x1d
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 100000 in 4 chunks
	li	IMW3(1048576)
	li	IMW2(1048576)
	li	IMW1(1048576)
	li	IMW0(1048576)
	mul	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 325
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 3, 3
					// (objtotemp)  reg r2, offset 76, val 0
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x103
	ld	r6
	add	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 326
// code 0x12
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: ffff0000 in 3 chunks
	li	IMW2(-65536)
	li	IMW1(-65536)
	li	IMW0(-65536)
	and	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 327
// code 0x1c
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  extern
	ldinc	r7
	.int	__end
		//sizemod based on type 0x3
	sub	r2
					// (save result) isreg

	//../../Lib//malloc.c, line 327
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 104, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//../../Lib//malloc.c, line 327
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	__end
		//sizemod based on type 0xa
	stdec	r6

	//../../Lib//malloc.c, line 327
// code 0x2a
					//call
	ldinc	r7
	.int	_malloc_add
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// freereg r3
				// freereg r4
				// freereg r5
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7

// stacksize=0+??
l102:
	.byte	83
	.byte	68
	.byte	82
	.byte	65
	.byte	77
	.byte	32
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	32
	.byte	40
	.byte	97
	.byte	115
	.byte	115
	.byte	117
	.byte	109
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	110
	.byte	111
	.byte	32
	.byte	97
	.byte	100
	.byte	100
	.byte	114
	.byte	101
	.byte	115
	.byte	115
	.byte	32
	.byte	102
	.byte	97
	.byte	117
	.byte	108
	.byte	116
	.byte	115
	.byte	41
	.byte	32
	.byte	105
	.byte	115
	.byte	32
	.byte	48
	.byte	120
	.byte	37
	.byte	100
	.byte	32
	.byte	109
	.byte	101
	.byte	103
	.byte	97
	.byte	98
	.byte	121
	.byte	116
	.byte	101
	.byte	115
	.byte	10
	.byte	0
	.globl	_small_printf
	.globl	__end
	.section	.data
	.align	4
l1:
	.int	2
	.int	0
// Declaring from tree
// static
	.int	l1
// Declaring from tree
// static
	.int	l1
// Declaring from tree
// static
	.int	l1
// Declaring from tree
// static
	.int	l1
