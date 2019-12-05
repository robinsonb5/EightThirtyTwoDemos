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

	//dhry_2.c, line 61
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
					// (save temp) store reg
	st	r3
				//save_temp done

	//dhry_2.c, line 62
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_2.c, line 62
// code 0x2a
					//call
	ldinc	r7
	.int	_Func_3
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_2.c, line 62
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_2.c, line 62
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//dhry_2.c, line 62
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l3)-1)
	li	IMW0(PCREL(l3))
		add	r7
				// allocreg r2

	//dhry_2.c, line 64
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) store reg
	st	r3
				//save_temp done
l3: # 

	//dhry_2.c, line 66
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
	sgn
	cmp	r1
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5))
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l6)-1)
	li	IMW0(PCREL(l6))
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r2
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l10)-1)
	li	IMW0(PCREL(l10))
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	sgn
	cmp	r2
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4))
		add	r7
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sgn
	cmp	r2
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
		add	r7
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4))
	add	r7
l5: # 

	//dhry_2.c, line 68
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store reg
	st	r3
				//save_temp done

	//dhry_2.c, line 69
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4))
	add	r7
l6: # 

	//dhry_2.c, line 71
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_Int_Glob
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 64 in 2 chunks
	li	IMW1(100)
	li	IMW0(100)
	sgn
	cmp	r1

	//dhry_2.c, line 71
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l8)-1)
	li	IMW0(PCREL(l8))
		add	r7

	//dhry_2.c, line 73
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store reg
	st	r3
				//save_temp done

	//dhry_2.c, line 74
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4))
	add	r7
l8: # 

	//dhry_2.c, line 74
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) store reg
	st	r3
				//save_temp done

	//dhry_2.c, line 75
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4))
	add	r7
l10: # 

	//dhry_2.c, line 77
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store reg
	st	r3
				//save_temp done

	//dhry_2.c, line 78
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l4)-1)
	li	IMW0(PCREL(l4))
	add	r7
l12: # 

	//dhry_2.c, line 81
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store reg
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

	//dhry_2.c, line 102
// code 0x1b
					// (bitwise) loadreg
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

	//dhry_2.c, line 103
// code 0x1b
					// (bitwise) loadreg
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
				// allocreg r5
				// allocreg r4

	//dhry_2.c, line 119
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r5
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	add	r5
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 120
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg

	//dhry_2.c, line 120
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	add	r2
					// (save result) isreg

	//dhry_2.c, line 120
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
					// (save temp) store reg
	st	r2
				//save_temp done
				// allocreg r3

	//dhry_2.c, line 121
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r3
					// (save result) isreg

	//dhry_2.c, line 121
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
					// (save temp) store reg
	st	r3
				//save_temp done
				// freereg r3

	//dhry_2.c, line 122
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 78 in 2 chunks
	li	IMW1(120)
	li	IMW0(120)
	add	r2
					// (save result) isreg

	//dhry_2.c, line 122
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store reg
	st	r2
				//save_temp done
				// freereg r2

	//dhry_2.c, line 123
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r2

	//dhry_2.c, line 124
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//dhry_2.c, line 124
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r5
				// freereg r2

	//dhry_2.c, line 124
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l20)-1)
	li	IMW0(PCREL(l20))
		add	r7
l19: # 
				// allocreg r3

	//dhry_2.c, line 125
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r3
					// (save result) isreg

	//dhry_2.c, line 125
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	add	r3
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 125
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r4
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg

	//dhry_2.c, line 125
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  reg r3
	mt	r3
	add	r2
					// (save result) isreg
				// freereg r3

	//dhry_2.c, line 125
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store reg
	st	r2
				//save_temp done
				// freereg r2

	//dhry_2.c, line 124
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 124
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//dhry_2.c, line 124
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r4
				// freereg r2

	//dhry_2.c, line 124
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l19)-1)
	li	IMW0(PCREL(l19))
		add	r7
l20: # 
				// freereg r4
				// allocreg r4

	//dhry_2.c, line 127
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r4
					// (objtotemp)  const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	mul	r4
					// (save result) isreg

	//dhry_2.c, line 127
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r4
	mt	r4
	mr	r4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	add	r4
					// (save result) isreg
				// allocreg r2

	//dhry_2.c, line 127
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	mul	r2
					// (save result) isreg
				// allocreg r3

	//dhry_2.c, line 127
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r4
	mt	r4
	mr	r3
					// (objtotemp)  reg r2
	mt	r2
	add	r3
					// (save result) isreg

	//dhry_2.c, line 127
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sub	r3
					// (save result) isreg

	//dhry_2.c, line 127
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r3
				// freereg r3
				// allocreg r3

	//dhry_2.c, line 128
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r3
					// (objtotemp)  reg r2
	mt	r2
	add	r3
					// (save result) isreg

	//dhry_2.c, line 128
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: fa0 in 3 chunks
	li	IMW2(4000)
	li	IMW1(4000)
	li	IMW0(4000)
	add	r4
					// (save result) isreg

	//dhry_2.c, line 128
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  reg r4
	mt	r4
	add	r2
					// (save result) isreg
				// freereg r4

	//dhry_2.c, line 128
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
					// (save temp) store reg
	st	r2
				//save_temp done
				// freereg r3
				// freereg r2

	//dhry_2.c, line 129
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) store prepped reg
	st	r1
				//save_temp done
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

	//dhry_2.c, line 146
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

	//dhry_2.c, line 147
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_2.c, line 148
// code 0x32
					//FIXME convert
					// (load_temp - type 1) nop
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

	//dhry_2.c, line 148
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

	//dhry_2.c, line 148
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r3
				// freereg r3
				// freereg r2

	//dhry_2.c, line 148
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l23)-1)
	li	IMW0(PCREL(l23))
		add	r7

	//dhry_2.c, line 150
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//dhry_2.c, line 151
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l24)-1)
	li	IMW0(PCREL(l24))
	add	r7
l23: # 

	//dhry_2.c, line 153
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r4
	mt	r4
					// (save temp) store prepped reg
	stbinc	r1
//Disposable, postinc doesn't matter
				//save_temp done

	//dhry_2.c, line 154
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

	//dhry_2.c, line 170
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

	//dhry_2.c, line 173
// code 0x1b
					// (bitwise) loadreg
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

	//dhry_2.c, line 173
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	add	r2
					// (save result) isreg

	//dhry_2.c, line 173
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

	//dhry_2.c, line 173
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2
				// allocreg r2

	//dhry_2.c, line 173
// code 0x1b
					// (bitwise) loadreg
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

	//dhry_2.c, line 173
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

	//dhry_2.c, line 173
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_2.c, line 173
// code 0x2a
					//call
	ldinc	r7
	.int	_Func_1
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_2.c, line 173
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_2.c, line 173
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//dhry_2.c, line 173
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l30)-1)
	li	IMW0(PCREL(l30))
		add	r7
				// allocreg r2

	//dhry_2.c, line 176
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

	//dhry_2.c, line 177
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r3
					// (save result) isreg
l30: # 

	//dhry_2.c, line 171
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r3

	//dhry_2.c, line 171
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l40)-1)
	li	IMW0(PCREL(l40))
		add	r7
				// freereg r2
				// allocreg r2

	//dhry_2.c, line 179
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

	//dhry_2.c, line 179
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 57 in 2 chunks
	li	IMW1(87)
	li	IMW0(87)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 179
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32))
		add	r7
				// allocreg r2

	//dhry_2.c, line 179
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

	//dhry_2.c, line 179
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 5a in 2 chunks
	li	IMW1(90)
	li	IMW0(90)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 179
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32))
		add	r7
				// allocreg r2

	//dhry_2.c, line 181
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

	//dhry_2.c, line 182
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

	//dhry_2.c, line 182
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 52 in 2 chunks
	li	IMW1(82)
	li	IMW0(82)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 182
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l35)-1)
	li	IMW0(PCREL(l35))
		add	r7
				// allocreg r2

	//dhry_2.c, line 184
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 185
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39))
	add	r7
				// freereg r2
l35: # 
				// allocreg r2

	//dhry_2.c, line 187
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

	//dhry_2.c, line 187
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

	//dhry_2.c, line 187
// code 0x2a
					//call
	ldinc	r7
	.int	_strcmp
	exg	r7

				// freereg r2
				// freereg r1
				// allocreg r2

	//dhry_2.c, line 187
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_2.c, line 187
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r2
				// freereg r2

	//dhry_2.c, line 187
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l38)-1)
	li	IMW0(PCREL(l38))
		add	r7
				// allocreg r2

	//dhry_2.c, line 190
// code 0x1b
					// (bitwise) loadreg
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
	stmpdec	r0
 // WARNING - check that 4 has been added.
	//dhry_2.c, line 192
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 193
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39))
	add	r7
l38: # 

	//dhry_2.c, line 195
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

	//dhry_2.c, line 209
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
	sgn
	cmp	r1

	//dhry_2.c, line 209
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l44)-1)
	li	IMW0(PCREL(l44))
		add	r7

	//dhry_2.c, line 211
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//dhry_2.c, line 212
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l45)-1)
	li	IMW0(PCREL(l45))
	add	r7
l44: # 

	//dhry_2.c, line 213
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
	.globl	___extension__
	.section	.bss
	.global	___extension__
	.lcomm	___extension__,4
	.globl	_strcmp
	.globl	_Int_Glob
	.globl	_Ch_1_Glob
