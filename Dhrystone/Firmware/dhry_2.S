#include "assembler.pp"

// clearing tmp
// clearing r0
	//registers used:
		//r2: no
		//r3: yes
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_Proc_6
_Proc_6:
	stdec	r6
	mt	r3
	stdec	r6
				// allocreg r3
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 102 // var, auto|reg
		//sizemod based on type 0xa
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_2.c, line 62
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 63
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// required value found in tmp
	stdec	r6

	//dhry_2.c, line 63
					//call
	ldinc	r7
	.int	_Func_3
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_2.c, line 63
					// (test)
					// (objtotemp) flags 4a // reg r0
	mt	r0
	and	r0
				// freereg r1

	//dhry_2.c, line 63
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l3)-1)
	li	IMW0(PCREL(l3)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_2.c, line 65
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) store
	st	r3
				//save_temp done
l3: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 67
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
					// (save temp) isreg
	mr	r1
				//save_temp done
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 
// required value found in tmp
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	cmp	r0
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5)-0)
// clearing tmp
		add	r7
// clearing tmp
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	cmp	r1
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l6)-1)
	li	IMW0(PCREL(l6)-0)
// clearing tmp
		add	r7
// clearing tmp
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	cmp	r1
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l10)-1)
	li	IMW0(PCREL(l10)-0)
// clearing tmp
		add	r7
// clearing tmp
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	cmp	r1
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
// clearing tmp
		add	r7
// clearing tmp
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	cmp	r1
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12)-0)
// clearing tmp
		add	r7
// clearing tmp
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
// clearing tmp
// clearing tmp
	add	r7
l5: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 69
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 70
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
// clearing tmp
// clearing tmp
	add	r7
l6: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 72
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Int_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 64 in 2 chunks
	li	IMW1(100)
	li	IMW0(100)
	sgn
	cmp	r0

	//dhry_2.c, line 72
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l8)-1)
	li	IMW0(PCREL(l8)-0)
// clearing tmp
		add	r7
// clearing tmp

	//dhry_2.c, line 74
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 75
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
// clearing tmp
// clearing tmp
	add	r7
l8: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 75
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 76
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
// clearing tmp
// clearing tmp
	add	r7
l10: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 78
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_2.c, line 79
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4)-0)
// clearing tmp
// clearing tmp
	add	r7
l12: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 82
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store
	st	r3
				//save_temp done
l4: # 
// clearing tmp
// clearing r0
				// freereg r1
				// freereg r3
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

// clearing tmp
// clearing r0
	//registers used:
		//r2: no
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
				// allocreg r1

	//dhry_2.c, line 103
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	add	r1
					// (save result) // isreg

	//dhry_2.c, line 104
					// (bitwise) loadreg
	//ops: 0, 2, 1
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r0
					// (objtotemp) flags 4a // reg r1
	mt	r1
	add	r0
					// (save result) // Store_reg to type 0x3
// clearing tmp
// clearing r0
					// (prepobj tmp)// deref
				// var FIXME - deref?// reg 
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
// clearing tmp
	exg	r0
	st	r0
	exg	r0
				// freereg r1
	ldinc	r6
	mr	r7

// clearing tmp
// clearing r0
	//registers used:
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
				// allocreg r4

	//dhry_2.c, line 120
					// (bitwise) loadreg
	//ops: 0, 0, 5
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r4
					// (objtotemp) flags 1 // const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	add	r4
					// (save result) // isreg
				// allocreg r3

	//dhry_2.c, line 121
					// (bitwise) loadreg
	//ops: 5, 0, 4
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r3
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r3
					// (save result) // isreg

	//dhry_2.c, line 121
					// (bitwise) loadreg
	//ops: 0, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	add	r3
					// (save result) // isreg

	//dhry_2.c, line 121
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
					// (save temp) store
	st	r3
				//save_temp done
				// allocreg r1

	//dhry_2.c, line 122
					// (bitwise) loadreg
	//ops: 5, 0, 2
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r1
					// (save result) // isreg
				// allocreg r2

	//dhry_2.c, line 122
					// (bitwise) loadreg
	//ops: 2, 0, 3
					// (objtotemp) flags 4a // reg r1
	mt	r1
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) // isreg

	//dhry_2.c, line 122
					// (bitwise) loadreg
	//ops: 0, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	add	r2
					// (save result) // isreg

	//dhry_2.c, line 122
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r2 - no need to prep
					// (objtotemp) flags 6a // deref 
	ld	r3
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2
				// allocreg r2

	//dhry_2.c, line 123
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: 1e in 1 chunks
	li	IMW0(30)
	add	r2
					// (save result) // isreg

	//dhry_2.c, line 123
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) // isreg

	//dhry_2.c, line 123
					// (bitwise) loadreg
	//ops: 0, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	add	r2
					// (save result) // isreg

	//dhry_2.c, line 123
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r2 - no need to prep
					// (objtotemp) flags 42 // reg r4
	mt	r4
					// (save temp) store
	st	r2
				//save_temp done
				// freereg r2

	//dhry_2.c, line 124
					// (a/p assign)
					// (prepobj r0) reg r5 - no need to prep
					// (objtotemp) flags 42 
// required value found in tmp
					// (save temp) isreg
	mr	r5
				//save_temp done

	//dhry_2.c, line 125
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 4a // reg r1
	mt	r1
	sgn
	cmp	r4
				// freereg r1

	//dhry_2.c, line 125
	cond	SGT
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l20)-1)
	li	IMW0(PCREL(l20)-0)
// clearing tmp
		add	r7
// clearing tmp
l19: # 
// clearing tmp
// clearing r0
				// allocreg r2

	//dhry_2.c, line 126
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r2
					// (save result) // isreg

	//dhry_2.c, line 126
					// (bitwise) loadreg
	//ops: 0, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	add	r2
					// (save result) // isreg
				// allocreg r1

	//dhry_2.c, line 126
					// (bitwise) loadreg
	//ops: 6, 0, 2
					// (objtotemp) flags 42 // reg r5
	mt	r5
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r1
					// (save result) // isreg

	//dhry_2.c, line 126
					// (bitwise) loadreg
	//ops: 3, 2, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a // reg r2
	mt	r2
	add	r1
					// (save result) // isreg
				// freereg r2

	//dhry_2.c, line 126
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r1 - no need to prep
					// (objtotemp) flags 42 // reg r4
	mt	r4
					// (save temp) store
	st	r1
				//save_temp done
				// freereg r1

	//dhry_2.c, line 125
					// (bitwise) loadreg
	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) // isreg
				// allocreg r1

	//dhry_2.c, line 125
					// (bitwise) loadreg
	//ops: 5, 0, 2
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r1
					// (save result) // isreg

	//dhry_2.c, line 125
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 4a // reg r1
	mt	r1
	sgn
	cmp	r5
				// freereg r1

	//dhry_2.c, line 125
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l19)-1)
	li	IMW0(PCREL(l19)-0)
// clearing tmp
		add	r7
// clearing tmp
l20: # 
// clearing tmp
// clearing r0
				// allocreg r2

	//dhry_2.c, line 128
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r2
					// (save result) // isreg

	//dhry_2.c, line 128
					// (bitwise) loadreg
	//ops: 0, 3, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	add	r2
					// (save result) // isreg
				// allocreg r1

	//dhry_2.c, line 128
					// (bitwise) loadreg
	//ops: 5, 0, 2
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r1
					// (save result) // isreg

	//dhry_2.c, line 128
					// (bitwise) loadreg
	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r1
					// (save result) // isreg

	//dhry_2.c, line 128
					// (bitwise) loadreg
	//ops: 3, 2, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a // reg r2
	mt	r2
	add	r1
					// (save result) // isreg
				// freereg r2

	//dhry_2.c, line 128
					// (bitwise) loadreg
	//ops: 2, 0, 1
					// (objtotemp) flags 6a // deref 
	ld	r1
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) // Store_reg to type 0x3
	mt	r0
	st	r1
				// freereg r1
				// allocreg r1

	//dhry_2.c, line 129
					// (bitwise) loadreg
	//ops: 5, 0, 2
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r1
					// (save result) // isreg
				// allocreg r2

	//dhry_2.c, line 129
					// (bitwise) loadreg
	//ops: 0, 2, 3
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r2
					// (objtotemp) flags 4a // reg r1
	mt	r1
	add	r2
					// (save result) // isreg
				// allocreg r3

	//dhry_2.c, line 129
					// (bitwise) loadreg
	//ops: 5, 0, 4
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r3
					// (objtotemp) flags 1 // const
				// constant: 14 in 1 chunks
	li	IMW0(20)
	add	r3
					// (save result) // isreg

	//dhry_2.c, line 129
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r3
					// (save result) // isreg

	//dhry_2.c, line 129
					// (bitwise) loadreg
	//ops: 0, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x4
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	add	r3
					// (save result) // isreg

	//dhry_2.c, line 129
					// (bitwise) loadreg
	//ops: 4, 2, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a // reg r3
	mt	r3
	add	r1
					// (save result) // isreg
				// freereg r3

	//dhry_2.c, line 129
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r1 - no need to prep
					// (objtotemp) flags 6a // deref 
	ld	r2
					// (save temp) store
	st	r1
				//save_temp done
				// freereg r2
				// freereg r1

	//dhry_2.c, line 130
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) store
	st	r0
				//save_temp done
				// freereg r4
				// freereg r5
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

// clearing tmp
// clearing r0
	//registers used:
		//r2: yes
		//r3: yes
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_Func_1
_Func_1:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	exg	r6
				// allocreg r3

	//dhry_2.c, line 147
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2

	//dhry_2.c, line 148
					// (a/p assign)
					// (prepobj r0) reg r2 - no need to prep
					// (objtotemp) flags 42 // reg r3
	mt	r3
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_2.c, line 149
					//FIXME convert
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r2
	cond	GE
		or	r2
	cond	SLT
		xor	r2
	cond	EX
					// (save result) // isreg
				// allocreg r1

	//dhry_2.c, line 149
					//FIXME convert
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	mr	r1
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r1
	cond	GE
		or	r1
	cond	SLT
		xor	r1
	cond	EX
					// (save result) // isreg

	//dhry_2.c, line 149
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 4a // reg r1
	mt	r1
	sgn
	cmp	r2
				// freereg r2
				// freereg r1

	//dhry_2.c, line 149
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l23)-1)
	li	IMW0(PCREL(l23)-0)
// clearing tmp
		add	r7
// clearing tmp

	//dhry_2.c, line 151
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//dhry_2.c, line 152
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l24)-1)
	li	IMW0(PCREL(l24)-0)
// clearing tmp
// clearing tmp
	add	r7
l23: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 154
					// (a/p assign)
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob + 4
// clearing tmp
// extern pe not varadr
		//sizemod based on type 0x1
	byt
	stmpdec	r3
// clearing tmp

	//dhry_2.c, line 155
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0
l24: # 
// clearing tmp
// clearing r0
				// freereg r3
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

// clearing tmp
// clearing r0
	//registers used:
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
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// constant: fffffffc in 1 chunks
	li	IMW0(-4)
	add	r6
				// allocreg r4
					// (a/p assign)
					// (prepobj r0) reg r4 - no need to prep
					// (objtotemp) flags 102 // var, auto|reg
		//sizemod based on type 0x1
	byt
	ld	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
				// allocreg r2
				// allocreg r1

	//dhry_2.c, line 171
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) isreg
	mr	r3
				//save_temp done
				// freereg r1
l40: # 
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_2.c, line 174
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r1
					// (save result) // isreg

	//dhry_2.c, line 174
					// (bitwise) loadreg
	//ops: 2, 4, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 42 // reg r3
	mt	r3
	add	r1
					// (save result) // isreg

	//dhry_2.c, line 174
					//FIXME convert
					// (objtotemp) flags 6a // deref 
	byt
	ld	r1
	mr	r1
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r1
	cond	GE
		or	r1
	cond	SLT
		xor	r1
	cond	EX
					// (save result) // isreg

	//dhry_2.c, line 174
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1
				// allocreg r1

	//dhry_2.c, line 174
					// (bitwise) loadreg
	//ops: 0, 4, 2
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r1
					// (objtotemp) flags 42 // reg r3
	mt	r3
	add	r1
					// (save result) // isreg

	//dhry_2.c, line 174
					//FIXME convert
					// (objtotemp) flags 6a // deref 
	byt
	ld	r1
	mr	r1
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r1
	cond	GE
		or	r1
	cond	SLT
		xor	r1
	cond	EX
					// (save result) // isreg

	//dhry_2.c, line 174
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_2.c, line 174
					//call
	ldinc	r7
	.int	_Func_1
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_2.c, line 174
					// (test)
					// (objtotemp) flags 4a // reg r0
	mt	r0
	and	r0
				// freereg r1

	//dhry_2.c, line 174
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l30)-1)
	li	IMW0(PCREL(l30)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_2.c, line 177
					// (a/p assign)
					// (prepobj r0) reg r4 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_2.c, line 178
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r3
					// (save result) // isreg
l30: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 172
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r3

	//dhry_2.c, line 172
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l40)-1)
	li	IMW0(PCREL(l40)-0)
// clearing tmp
		add	r7
// clearing tmp
				// freereg r1
				// allocreg r1

	//dhry_2.c, line 180
					//FIXME convert
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r1
	cond	GE
		or	r1
	cond	SLT
		xor	r1
	cond	EX
					// (save result) // isreg

	//dhry_2.c, line 180
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 57 in 2 chunks
	li	IMW1(87)
	li	IMW0(87)
	sgn
	cmp	r1
				// freereg r1

	//dhry_2.c, line 180
	cond	SLT
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_2.c, line 180
					//FIXME convert
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r1
	cond	GE
		or	r1
	cond	SLT
		xor	r1
	cond	EX
					// (save result) // isreg

	//dhry_2.c, line 180
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 5a in 2 chunks
	li	IMW1(90)
	li	IMW0(90)
	sgn
	cmp	r1
				// freereg r1

	//dhry_2.c, line 180
	cond	GE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_2.c, line 182
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 7 in 1 chunks
	li	IMW0(7)
					// (save temp) isreg
	mr	r3
				//save_temp done
				// freereg r1
l32: # 
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_2.c, line 183
					//FIXME convert
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
				// constant: ffffff80 in 2 chunks
	li	IMW1(-128)
	li	IMW0(-128)
	add	r1
	cond	GE
		or	r1
	cond	SLT
		xor	r1
	cond	EX
					// (save result) // isreg

	//dhry_2.c, line 183
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 52 in 2 chunks
	li	IMW1(82)
	li	IMW0(82)
	cmp	r1
				// freereg r1

	//dhry_2.c, line 183
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l35)-1)
	li	IMW0(PCREL(l35)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_2.c, line 185
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 186
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39)-0)
// clearing tmp
// clearing tmp
	add	r7
				// freereg r1
				// freereg r2
l35: # 
// clearing tmp
// clearing r0
				// allocreg r2

	//dhry_2.c, line 188
					// (a/p assign)
					// (prepobj r0) reg r2 - no need to prep
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0xa
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r1

	//dhry_2.c, line 188
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0xa
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
					// (save temp) isreg
	mr	r1
				//save_temp done

	//dhry_2.c, line 188
					//call
	ldinc	r7
	.int	_strcmp
// clearing tmp
	exg	r7

// clearing tmp
				// freereg r2
				// freereg r1
				// allocreg r1

	//dhry_2.c, line 188
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r0
				// freereg r1

	//dhry_2.c, line 188
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l38)-1)
	li	IMW0(PCREL(l38)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r2
				// allocreg r1

	//dhry_2.c, line 191
					// (bitwise) loadreg
	//ops: 4, 0, 1
					// (objtotemp) flags 42 // reg r3
	mt	r3
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	add	r0
					// (save result) // Store_reg to type 0x3
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp

	//dhry_2.c, line 193
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 194
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39)-0)
// clearing tmp
// clearing tmp
	add	r7
l38: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 196
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l39: # 
// clearing tmp
// clearing r0
				// freereg r1
				// freereg r2
				// freereg r3
				// freereg r4
				// constant: fffffffc in 1 chunks
	li	IMW0(-4)
	sub	r6
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

// clearing tmp
// clearing r0
	//registers used:
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
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	cmp	r0

	//dhry_2.c, line 210
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l44)-1)
	li	IMW0(PCREL(l44)-0)
// clearing tmp
		add	r7
// clearing tmp

	//dhry_2.c, line 212
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 213
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l45)-1)
	li	IMW0(PCREL(l45)-0)
// clearing tmp
// clearing tmp
	add	r7
l44: # 
// clearing tmp
// clearing r0

	//dhry_2.c, line 214
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l45: # 
// clearing tmp
// clearing r0
	ldinc	r6
	mr	r7

	.globl	_strcmp
	.globl	_Int_Glob
	.globl	_Ch_1_Glob
