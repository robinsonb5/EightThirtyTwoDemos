#include "assembler.pp"

	//registers used:
		//r0: yes
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_Proc_6
_Proc_6:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	exg	r6
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_2.c, line 62
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 63
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_2.c, line 63
// code 0x2a
					//call
	ldinc	r7
	.int	_Func_3
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_2.c, line 63
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_2.c, line 63
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//dhry_2.c, line 63
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l3)-1)
	li	IMW0(PCREL(l3)-0)
		add	r7
				// allocreg r2

	//dhry_2.c, line 65
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) store
	st	r3
				//save_temp done
l3: # 

	//dhry_2.c, line 67
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
					// (save temp) isreg
	mr	r2
				//save_temp done
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	mr	r1
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	cmp	r1
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5)-0)
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	cmp	r2
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l6)-1)
	li	IMW0(PCREL(l6)-0)
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	cmp	r2
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l10)-1)
	li	IMW0(PCREL(l10)-0)
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	cmp	r2
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	cmp	r2
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12)-0)
		add	r7
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
	add	r7
l5: # 

	//dhry_2.c, line 69
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 70
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
	add	r7
l6: # 

	//dhry_2.c, line 72
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_Int_Glob
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 64 in 2 chunks
	li	IMW1(100)
	li	IMW0(100)
	sgn
	cmp	r1

	//dhry_2.c, line 72
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l8)-1)
	li	IMW0(PCREL(l8)-0)
		add	r7

	//dhry_2.c, line 74
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 75
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
	add	r7
l8: # 

	//dhry_2.c, line 75
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 76
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
	add	r7
l10: # 

	//dhry_2.c, line 78
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

	//dhry_2.c, line 79
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
	add	r7
l12: # 

	//dhry_2.c, line 82
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store
	st	r3
				//save_temp done
l4: # 
				// freereg r2
				// freereg r3
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
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_Proc_7
_Proc_7:
	stdec	r6
	mt	r2
	stdec	r6
				// allocreg r2

	//dhry_2.c, line 103
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	add	r2
					// (save result) isreg

	//dhry_2.c, line 104
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 3, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	add	r0
					// (save result) deref
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r1
				// store reg
// Store_reg to type 0x3
	mt	r0
	st	r1
				// freereg r2
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
	.global	_Proc_8
_Proc_8:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r5

	//dhry_2.c, line 120
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
	mr	r5
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	add	r5
					// (save result) isreg
				// allocreg r4

	//dhry_2.c, line 121
// code 0x1d
					// (bitwise) loadreg
	//ops: 6, 0, 5
					// (objtotemp)  reg r5
	mt	r5
	mr	r4
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r4
					// (save result) isreg

	//dhry_2.c, line 121
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 5, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	add	r4
					// (save result) isreg

	//dhry_2.c, line 121
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 24 in 2 chunks
	li	IMW1(36)
	li	IMW0(36)
	ldidx	r6
					// (save temp) store
	st	r4
				//save_temp done
				// allocreg r2

	//dhry_2.c, line 122
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg
				// allocreg r3

	//dhry_2.c, line 122
// code 0x1d
					// (bitwise) loadreg
	//ops: 3, 0, 4
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r3
					// (save result) isreg

	//dhry_2.c, line 122
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	add	r3
					// (save result) isreg

	//dhry_2.c, line 122
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	ld	r4
					// (save temp) store
	st	r3
				//save_temp done
				// freereg r4
				// freereg r3
				// allocreg r3

	//dhry_2.c, line 123
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 4
					// (objtotemp)  reg r5
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: 1e in 1 chunks
	li	IMW0(30)
	add	r3
					// (save result) isreg

	//dhry_2.c, line 123
// code 0x1d
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r3
					// (save result) isreg

	//dhry_2.c, line 123
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	add	r3
					// (save result) isreg

	//dhry_2.c, line 123
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r3
				//save_temp done
				// freereg r3

	//dhry_2.c, line 124
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_2.c, line 125
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r5
				// freereg r2

	//dhry_2.c, line 125
	cond	SGT
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l20)-1)
	li	IMW0(PCREL(l20)-0)
		add	r7
				// allocreg r4
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
l15: # 
				// allocreg r3

	//dhry_2.c, line 126
// code 0x1d
					// (bitwise) loadreg
	//ops: 6, 0, 4
					// (objtotemp)  reg r5
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r3
					// (save result) isreg

	//dhry_2.c, line 126
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	add	r3
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 126
// code 0x1d
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg

	//dhry_2.c, line 126
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  reg r3
	mt	r3
	add	r2
					// (save result) isreg
				// freereg r3

	//dhry_2.c, line 126
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2

	//dhry_2.c, line 125
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 125
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//dhry_2.c, line 125
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r4
				// freereg r2

	//dhry_2.c, line 125
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l15)-1)
	li	IMW0(PCREL(l15)-0)
		add	r7
l20: # 
				// freereg r4
				// allocreg r3

	//dhry_2.c, line 128
// code 0x1d
					// (bitwise) loadreg
	//ops: 6, 0, 4
					// (objtotemp)  reg r5
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r3
					// (save result) isreg

	//dhry_2.c, line 128
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	add	r3
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 128
// code 0x1c
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r2
					// (save result) isreg

	//dhry_2.c, line 128
// code 0x1d
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg

	//dhry_2.c, line 128
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  reg r3
	mt	r3
	add	r2
					// (save result) isreg
				// freereg r3

	//dhry_2.c, line 128
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 1
					// (objtotemp)  deref 
	ld	r2
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r2
				// freereg r2
				// allocreg r2

	//dhry_2.c, line 129
// code 0x1d
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg
				// allocreg r3

	//dhry_2.c, line 129
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 3, 4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r3
					// (objtotemp)  reg r2
	mt	r2
	add	r3
					// (save result) isreg
				// allocreg r4

	//dhry_2.c, line 129
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 5
					// (objtotemp)  reg r5
	mt	r5
	mr	r4
					// (objtotemp)  const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r4
					// (save result) isreg

	//dhry_2.c, line 129
// code 0x1d
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r4
					// (save result) isreg

	//dhry_2.c, line 129
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 5, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x4
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	add	r4
					// (save result) isreg

	//dhry_2.c, line 129
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  reg r4
	mt	r4
	add	r2
					// (save result) isreg
				// freereg r4

	//dhry_2.c, line 129
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	ld	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2

	//dhry_2.c, line 130
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) store
	st	r1
				//save_temp done
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
	.global	_Func_1
_Func_1:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// allocreg r4

	//dhry_2.c, line 147
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3

	//dhry_2.c, line 148
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_2.c, line 149
// code 0x32
					//FIXME convert
					// (load_temp - type 1)
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r3
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r3
	mr	r3
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 149
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r2
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r2
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r2
	mr	r2
					// (save result) isreg

	//dhry_2.c, line 149
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r3
				// freereg r3
				// freereg r2

	//dhry_2.c, line 149
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l23)-1)
	li	IMW0(PCREL(l23)-0)
		add	r7

	//dhry_2.c, line 151
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//dhry_2.c, line 152
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l24)-1)
	li	IMW0(PCREL(l24)-0)
	add	r7
l23: # 

	//dhry_2.c, line 154
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob
// extern pe not varadr
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done

	//dhry_2.c, line 155
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0
l24: # 
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
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_Func_2
_Func_2:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r4
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x1
	byt
	ld	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
				// allocreg r2

	//dhry_2.c, line 171
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) isreg
	mr	r3
				//save_temp done
				// freereg r2
l40: # 
				// allocreg r2

	//dhry_2.c, line 174
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
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//dhry_2.c, line 174
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 4, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  reg r3
	mt	r3
	add	r2
					// (save result) isreg

	//dhry_2.c, line 174
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  deref 
	byt
	ld	r2
	mr	r2
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r2
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r2
	mr	r2
					// (save result) isreg

	//dhry_2.c, line 174
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2
				// allocreg r2

	//dhry_2.c, line 174
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 4, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r2
					// (objtotemp)  reg r3
	mt	r3
	add	r2
					// (save result) isreg

	//dhry_2.c, line 174
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  deref 
	byt
	ld	r2
	mr	r2
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r2
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r2
	mr	r2
					// (save result) isreg

	//dhry_2.c, line 174
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_2.c, line 174
// code 0x2a
					//call
	ldinc	r7
	.int	_Func_1
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_2.c, line 174
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_2.c, line 174
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//dhry_2.c, line 174
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l30)-1)
	li	IMW0(PCREL(l30)-0)
		add	r7
				// allocreg r2

	//dhry_2.c, line 177
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_2.c, line 178
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r3
					// (save result) isreg
l30: # 

	//dhry_2.c, line 172
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r3

	//dhry_2.c, line 172
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l40)-1)
	li	IMW0(PCREL(l40)-0)
		add	r7
				// freereg r2
				// allocreg r2

	//dhry_2.c, line 180
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
	mr	r2
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r2
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r2
	mr	r2
					// (save result) isreg

	//dhry_2.c, line 180
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 57 in 2 chunks
	li	IMW1(87)
	li	IMW0(87)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 180
	cond	SLT
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32)-0)
		add	r7
				// allocreg r2

	//dhry_2.c, line 180
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
	mr	r2
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r2
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r2
	mr	r2
					// (save result) isreg

	//dhry_2.c, line 180
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 5a in 2 chunks
	li	IMW1(90)
	li	IMW0(90)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 180
	cond	GE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32)-0)
		add	r7
				// allocreg r2

	//dhry_2.c, line 182
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
					// (save temp) isreg
	mr	r3
				//save_temp done
				// freereg r2
l32: # 
				// allocreg r2

	//dhry_2.c, line 183
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
	mr	r2
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r2
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r2
	mr	r2
					// (save result) isreg

	//dhry_2.c, line 183
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 52 in 2 chunks
	li	IMW1(82)
	li	IMW0(82)
	cmp	r2
				// freereg r2

	//dhry_2.c, line 183
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l35)-1)
	li	IMW0(PCREL(l35)-0)
		add	r7
				// allocreg r2

	//dhry_2.c, line 185
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 186
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39)-0)
	add	r7
				// freereg r2
l35: # 
				// allocreg r2

	//dhry_2.c, line 188
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r1

	//dhry_2.c, line 188
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r1 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
					// (save temp) isreg
	mr	r1
				//save_temp done

	//dhry_2.c, line 188
// code 0x2a
					//call
	ldinc	r7
	.int	_strcmp
	exg	r7

				// freereg r2
				// freereg r1
				// allocreg r2

	//dhry_2.c, line 188
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_2.c, line 188
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 188
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l38)-1)
	li	IMW0(PCREL(l38)-0)
		add	r7
				// allocreg r2

	//dhry_2.c, line 191
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 1
					// (objtotemp)  reg r3
	mt	r3
	mr	r0
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//dhry_2.c, line 193
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 194
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39)-0)
	add	r7
l38: # 

	//dhry_2.c, line 196
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l39: # 
				// freereg r2
				// freereg r3
				// freereg r4
	ldinc	r6	// quickest way to add 4 to sp
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
	.global	_Func_3
_Func_3:
	stdec	r6

	//dhry_2.c, line 210
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	cmp	r1

	//dhry_2.c, line 210
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l44)-1)
	li	IMW0(PCREL(l44)-0)
		add	r7

	//dhry_2.c, line 212
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 213
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l45)-1)
	li	IMW0(PCREL(l45)-0)
	add	r7
l44: # 

	//dhry_2.c, line 214
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l45: # 
	ldinc	r6
	mr	r7

// stacksize=0+??
	.globl	_strcmp
	.globl	_Int_Glob
	.globl	_Ch_1_Glob
