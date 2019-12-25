#include "assembler.pp"

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
	.section	.text.373213
	.global	__boot
__boot:
	stdec	r6

	//boot.c, line 50
// code 0x2a
					//call
	ldinc	r7
	.int	_prg_start
	exg	r7

l5: # 

	//boot.c, line 51
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5))
	add	r7
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
	.section	.text.373213
	.global	_DoDecode
_DoDecode:
	stdec	r6
	mt	r2
	stdec	r6
				// allocreg r2
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

	//boot.c, line 57
// code 0x12
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: df in 2 chunks
	li	IMW1(223)
	li	IMW0(223)
	and	r2
					// (save result) isreg

	//boot.c, line 58
// code 0x1c
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 37 in 2 chunks
	li	IMW1(55)
	li	IMW0(55)
	sub	r2
					// (save result) isreg

	//boot.c, line 59
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r2

	//boot.c, line 59
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l9)-1)
	li	IMW0(PCREL(l9))
		add	r7

	//boot.c, line 60
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 27 in 2 chunks
	li	IMW1(39)
	li	IMW0(39)
	add	r2
					// (save result) isreg
l9: # 

	//boot.c, line 61
// code 0x19
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 62
// code 0x10
					// (bitwise) loadreg
	//ops: 0, 3, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r0
					// (objtotemp)  reg r2, offset -8, val 0
	mt	r2
	or	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 63
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r0
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
	.section	.text.373213
	.global	_HandleByte
_HandleByte:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
				// allocreg r4
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: da8000 in 5 chunks
	li	IMW4(14319616)
	li	IMW3(14319616)
	li	IMW2(14319616)
	li	IMW1(14319616)
	li	IMW0(14319616)
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3

	//boot.c, line 68
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COLUMN
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_SREC_COLUMN + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// allocreg r2

	//boot.c, line 70
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

	//boot.c, line 70
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 53 in 2 chunks
	li	IMW1(83)
	li	IMW0(83)
	sgn
	cmp	r2
				// freereg r2

	//boot.c, line 70
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
		add	r7

	//boot.c, line 72
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_COLUMN
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 73
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_ADDR
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 74
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_BYTECOUNT
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 75
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_TYPE
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 76
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 53 in 2 chunks
	li	IMW1(83)
	li	IMW0(83)
					// (save temp) store
	st	r4
				//save_temp done

	//boot.c, line 79
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l12: # 

	//boot.c, line 80
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COLUMN
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r1

	//boot.c, line 80
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l15)-1)
	li	IMW0(PCREL(l15))
		add	r7

	//boot.c, line 83
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 74 in 2 chunks
	li	IMW1(116)
	li	IMW0(116)
					// (save temp) store
	st	r4
				//save_temp done
				// allocreg r2

	//boot.c, line 84
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

	//boot.c, line 84
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 8, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 84
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//boot.c, line 84
// code 0x2a
					//call
	ldinc	r7
	.int	_DoDecode
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 84
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_SREC_TYPE + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 84
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
					// (save temp) isreg
	mr	r5
				//save_temp done

	//boot.c, line 86
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	sgn
	cmp	r5

	//boot.c, line 86
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l17)-1)
	li	IMW0(PCREL(l17))
		add	r7

	//boot.c, line 87
// code 0x1c
					// (bitwise) loadreg
	//ops: 0, 6, 6
		// WARNING - evading q2 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	mr	r0
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	sub	r0
					// (save result) isreg
	mt	r0
	mr	r5
l17: # 
				// allocreg r2

	//boot.c, line 89
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//boot.c, line 89
// code 0x19
					// (bitwise) loadreg
	//ops: 3, 0, 1
					// (objtotemp)  reg r2, offset 20, val 0
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_SREC_ADDRSIZE + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2

	//boot.c, line 92
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 1
					// (objtotemp)  reg r5, offset 4, val 0
	mt	r5
	mr	r0
					// (objtotemp)  const
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4

	//boot.c, line 94
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l15: # 

	//boot.c, line 94
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 9 in 1 chunks
	li	IMW0(9)
	sgn
	cmp	r1

	//boot.c, line 94
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
		add	r7

	//boot.c, line 94
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r1

	//boot.c, line 94
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
		add	r7

	//boot.c, line 96
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp)  const
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4

	//boot.c, line 97
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COLUMN
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	sgn
	cmp	r1

	//boot.c, line 97
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l23)-1)
	li	IMW0(PCREL(l23))
		add	r7
				// allocreg r2

	//boot.c, line 99
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

	//boot.c, line 99
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 12, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 99
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_BYTECOUNT
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//boot.c, line 99
// code 0x2a
					//call
	ldinc	r7
	.int	_DoDecode
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 99
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_SREC_BYTECOUNT + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 102
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l23: # 
				// allocreg r2

	//boot.c, line 102
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDRSIZE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	add	r2
					// (save result) isreg

	//boot.c, line 102
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COLUMN
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  reg r2, offset 12, val 0
	mt	r2
	sgn
	cmp	r1
				// freereg r2

	//boot.c, line 102
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l26)-1)
	li	IMW0(PCREL(l26))
		add	r7
				// allocreg r2

	//boot.c, line 104
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

	//boot.c, line 104
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 16, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 104
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//boot.c, line 104
// code 0x2a
					//call
	ldinc	r7
	.int	_DoDecode
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 104
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_SREC_ADDR + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 105
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_COUNTER
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 108
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l26: # 

	//boot.c, line 108
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r1

	//boot.c, line 108
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l29)-1)
	li	IMW0(PCREL(l29))
		add	r7

	//boot.c, line 108
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	sgn
	cmp	r1

	//boot.c, line 108
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l29)-1)
	li	IMW0(PCREL(l29))
		add	r7
				// allocreg r2

	//boot.c, line 110
// code 0x19
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_BYTECOUNT
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r2
					// (save result) isreg

	//boot.c, line 110
// code 0x1b
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//boot.c, line 110
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COLUMN
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  reg r2, offset 20, val 0
	mt	r2
	sgn
	cmp	r1
				// freereg r2

	//boot.c, line 110
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32))
		add	r7
				// allocreg r2

	//boot.c, line 117
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

	//boot.c, line 117
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 24, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 117
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TEMP
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//boot.c, line 117
// code 0x2a
					//call
	ldinc	r7
	.int	_DoDecode
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 117
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_SREC_TEMP + 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// allocreg r2

	//boot.c, line 118
// code 0x1c
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COUNTER
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r2
					// (save result) isreg
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_COUNTER
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2, offset 124, val 0
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 119
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r2
				// freereg r2

	//boot.c, line 119
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
		add	r7
				// allocreg r2

	//boot.c, line 123
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDR
		//sizemod based on type 0xa
	//extern deref
	ldt
					// (save temp) isreg
	mr	r2
				//save_temp done

	//boot.c, line 123
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TEMP
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
					// (save temp) store
	stbinc	r2
//Disposable, postinc doesn't matter.
				//save_temp done
				// freereg r2
				// allocreg r2

	//boot.c, line 125
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_ADDR
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2, offset 136, val 0
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 126
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_MAX_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	sgn
	cmp	r2
				// freereg r2

	//boot.c, line 126
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l36)-1)
	li	IMW0(PCREL(l36))
		add	r7

	//boot.c, line 127
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_MAX_ADDR
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
					// (save temp) store
	st	r1
				//save_temp done
l36: # 

	//boot.c, line 128
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_COUNTER
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 132
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l32: # 

	//boot.c, line 138
// code 0x44
					// (test)
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_COUNTER
		//sizemod based on type 0x3
	//extern deref
	ldt

	//boot.c, line 138
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
		add	r7
				// freereg r3
				// allocreg r3

	//boot.c, line 140
// code 0x19
					// (bitwise) loadreg
	//ops: 0, 0, 4
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TEMP
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r3
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	shl	r3
					// (save result) isreg
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_TEMP
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r3, offset 152, val 0
	mt	r3
					// (save temp) store
	st	r1
				//save_temp done
				// allocreg r2

	//boot.c, line 142
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDR
		//sizemod based on type 0xa
	//extern deref
	ldt
					// (save temp) isreg
	mr	r2
				//save_temp done

	//boot.c, line 142
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r3, offset 152, val 0
	mt	r3
					// (save temp) store
	stbinc	r2
//Disposable, postinc doesn't matter.
				//save_temp done
				// freereg r3
				// freereg r2

	//boot.c, line 148
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l29: # 
				// allocreg r3

	//boot.c, line 148
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	sgn
	cmp	r1

	//boot.c, line 148
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l42)-1)
	li	IMW0(PCREL(l42))
		add	r7

	//boot.c, line 150
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//boot.c, line 151
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffb4 in 2 chunks
	li	IMW1(-76)
	li	IMW0(-76)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 153
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_ADDR
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 154
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_MAX_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r1

	//boot.c, line 154
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l50)-1)
	li	IMW0(PCREL(l50))
		add	r7
l49: # 

	//boot.c, line 154
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref?
	ldinc	r7
	.int	_SREC_ADDR
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	add	r3
					// (save result) isreg
				// allocreg r2

	//boot.c, line 154
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_ADDR
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2, offset 176, val 0
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 154
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_MAX_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	sgn
	cmp	r2
				// freereg r2

	//boot.c, line 154
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l49)-1)
	li	IMW0(PCREL(l49))
		add	r7
l50: # 

	//boot.c, line 155
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3, offset 16, val 0
	mt	r3
	stdec	r6

	//boot.c, line 155
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_MAX_ADDR
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//boot.c, line 155
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l47+0
	stdec	r6

	//boot.c, line 155
// code 0x2a
					//call
	ldinc	r7
	.int	_tiny_printf
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//boot.c, line 156
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
					// (save temp) store
	st	r4
				//save_temp done

	//boot.c, line 161
// code 0x2a
					//call
	ldinc	r7
	.int	_prg_start
	ldt	// deref function ptr
	exg	r7


	//boot.c, line 165
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l48)-1)
	li	IMW0(PCREL(l48))
	add	r7
l42: # 

	//boot.c, line 165
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  extern
	ldinc	r7
	.int	_SREC_TYPE
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp)  const
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4
l48: # 
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
	.section	.rodata
l47:
	.byte	67
	.byte	104
	.byte	101
	.byte	99
	.byte	107
	.byte	115
	.byte	117
	.byte	109
	.byte	32
	.byte	116
	.byte	111
	.byte	32
	.byte	37
	.byte	100
	.byte	58
	.byte	32
	.byte	37
	.byte	100
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
	.section	.text.373213
	.global	_cvx
_cvx:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
				// allocreg r3

	//boot.c, line 176
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
l59: # 
				// allocreg r2

	//boot.c, line 178
// code 0x1a
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 1c in 1 chunks
	li	IMW0(28)
	sgn
	shr	r2
					// (save result) isreg

	//boot.c, line 178
// code 0x12
					// (bitwise) loadreg
	//ops: 3, 0, 4
					// (objtotemp)  reg r2, offset 8, val 0
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: f in 1 chunks
	li	IMW0(15)
	and	r3
					// (save result) isreg
				// freereg r2

	//boot.c, line 179
// code 0x19
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 18 in 1 chunks
	li	IMW0(24)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 180
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 9 in 1 chunks
	li	IMW0(9)
	sgn
	cmp	r3

	//boot.c, line 180
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l57)-1)
	li	IMW0(PCREL(l57))
		add	r7

	//boot.c, line 181
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 37 in 2 chunks
	li	IMW1(55)
	li	IMW0(55)
	add	r3
					// (save result) isreg

	//boot.c, line 183
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l58)-1)
	li	IMW0(PCREL(l58))
	add	r7
l57: # 

	//boot.c, line 183
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	add	r3
					// (save result) isreg
l58: # 

	//boot.c, line 184
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r3, offset 4, val 0
	mt	r3
					// (save temp) store
	byt
	st	r5
				//save_temp done

	//boot.c, line 184
// code 0x1b
					// (bitwise) loadreg
	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg

	//boot.c, line 177
// code 0x1b
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg

	//boot.c, line 177
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	sgn
	cmp	r4

	//boot.c, line 177
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l59)-1)
	li	IMW0(PCREL(l59))
		add	r7
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
	.section	.text.373213
	.global	_main
_main:
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

	//boot.c, line 194
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l62+0
	stdec	r6

	//boot.c, line 194
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 195
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_init
	exg	r7

				// allocreg r2

	//boot.c, line 195
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 195
// code 0x44
					// (test)
					// (objtotemp)  reg r2, offset 8, val 0
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 195
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l81)-1)
	li	IMW0(PCREL(l81))
		add	r7

	//boot.c, line 197
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l65+0
	stdec	r6

	//boot.c, line 197
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 198
// code 0x2a
					//call
	ldinc	r7
	.int	_FindDrive
	exg	r7

				// allocreg r2

	//boot.c, line 198
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 198
// code 0x44
					// (test)
					// (objtotemp)  reg r2, offset 16, val 0
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 198
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l67)-1)
	li	IMW0(PCREL(l67))
		add	r7

	//boot.c, line 202
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_prg_start
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 202
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l70+0
	stdec	r6

	//boot.c, line 202
// code 0x2a
					//call
	ldinc	r7
	.int	_LoadFile
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 202
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r3

	//boot.c, line 202
// code 0x44
					// (test)
					// (objtotemp)  reg r3, offset 20, val 0
	mt	r3
	and	r3

	//boot.c, line 202
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l81)-1)
	li	IMW0(PCREL(l81))
		add	r7

	//boot.c, line 204
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 205
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	mr	r1

					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_prg_start
// extern pe is varadr
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 206
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 207
// code 0x1b
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	add	r3
					// (save result) isreg

	//boot.c, line 208
// code 0x12
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: fffffffc in 1 chunks
	li	IMW0(-4)
	and	r3
					// (save result) isreg

	//boot.c, line 209
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 4, 6
					// (objtotemp)  extern
	ldinc	r7
	.int	_prg_start
		//sizemod based on type 0x3
	mr	r5
					// (objtotemp)  reg r3, offset 20, val 0
	mt	r3
	add	r5
					// (save result) isreg

	//boot.c, line 210
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5, offset 24, val 0
	mt	r5
	stdec	r6

	//boot.c, line 210
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l73+0
	stdec	r6

	//boot.c, line 210
// code 0x2a
					//call
	ldinc	r7
	.int	_LoadFile
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//boot.c, line 210
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 210
// code 0x44
					// (test)
					// (objtotemp)  reg r2, offset 64, val 0
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 210
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l95)-1)
	li	IMW0(PCREL(l95))
		add	r7

	//boot.c, line 212
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1ff in 2 chunks
	li	IMW1(511)
	li	IMW0(511)
	sgn
	cmp	r3

	//boot.c, line 212
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l95)-1)
	li	IMW0(PCREL(l95))
		add	r7
l92: # 

	//boot.c, line 214
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	stdec	r6
				// allocreg r2

	//boot.c, line 214
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 3
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	add	r2
					// (save result) isreg

	//boot.c, line 214
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r2, offset 72, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 214
// code 0x2a
					//call
	ldinc	r7
	.int	_checksum
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//boot.c, line 214
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 214
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2, offset 76, val 0
	mt	r2
					// (save temp) isreg
	mr	r4
				//save_temp done
				// freereg r2

	//boot.c, line 215
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 24)
	//(val 0)
	ldinc	r5
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 216
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
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 10 in 1 chunks
	li	IMW0(16)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 217
// code 0x1c
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	sub	r3
					// (save result) isreg

	//boot.c, line 218
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sgn
	cmp	r4

	//boot.c, line 218
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l78)-1)
	li	IMW0(PCREL(l78))
		add	r7

	//boot.c, line 220
// code 0x1b
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//boot.c, line 221
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 221
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	stdec	r6

	//boot.c, line 221
// code 0x2a
					//call
	ldinc	r7
	.int	_cvx
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 222
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 8)
	ldinc	r7
	.int	_printbuf + 8
// extern pe not varadr
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done

	//boot.c, line 223
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf + 9
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 223
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r4, offset 68, val 0
	mt	r4
	stdec	r6

	//boot.c, line 223
// code 0x2a
					//call
	ldinc	r7
	.int	_cvx
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 224
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 17)
	ldinc	r7
	.int	_printbuf + 17
// extern pe not varadr
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done

	//boot.c, line 225
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf + 18
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 225
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//boot.c, line 225
// code 0x2a
					//call
	ldinc	r7
	.int	_cvx
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 226
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 26)
	ldinc	r7
	.int	_printbuf + 26
// extern pe not varadr
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done

	//boot.c, line 227
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 227
// code 0x2a
					//call
	ldinc	r7
	.int	_BootPrint
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l78: # 

	//boot.c, line 212
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1ff in 2 chunks
	li	IMW1(511)
	li	IMW0(511)
	sgn
	cmp	r3

	//boot.c, line 212
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l92)-1)
	li	IMW0(PCREL(l92))
		add	r7
l95: # 

	//boot.c, line 231
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6

	//boot.c, line 231
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l81)-1)
	li	IMW0(PCREL(l81))
		add	r7

	//boot.c, line 233
// code 0x2a
					//call
	ldinc	r7
	.int	_prg_start
	ldt	// deref function ptr
	exg	r7


	//boot.c, line 241
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l81)-1)
	li	IMW0(PCREL(l81))
	add	r7
l67: # 

	//boot.c, line 243
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l82+0
	stdec	r6

	//boot.c, line 243
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l81: # 

	//boot.c, line 249
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static varadr
				//statictotemp
	ldinc	r7
	.int	l83+0
	stdec	r6

	//boot.c, line 249
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 250
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_SREC_MAX_ADDR
// extern pe not varadr
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: da8000 in 5 chunks
	li	IMW4(14319616)
	li	IMW3(14319616)
	li	IMW2(14319616)
	li	IMW1(14319616)
	li	IMW0(14319616)
					// (save temp) isreg
	mr	r5
				//save_temp done
l84: # 

	//boot.c, line 255
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 2e in 2 chunks
	li	IMW1(46)
	li	IMW0(46)
	stdec	r6

	//boot.c, line 255
// code 0x2a
					//call
	ldinc	r7
	.int	_putchar
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 256
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: f423f in 4 chunks
	li	IMW3(999999)
	li	IMW2(999999)
	li	IMW1(999999)
	li	IMW0(999999)
					// (save temp) isreg
	mr	r3
				//save_temp done
l94: # 

	//boot.c, line 258
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 22)
	//(val 0)
	ld	r5
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r2

	//boot.c, line 259
// code 0x12
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset 124, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	and	r2
					// (save result) isreg

	//boot.c, line 259
// code 0x44
					// (test)
					// (objtotemp)  reg r2, offset 132, val 0
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 259
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l91)-1)
	li	IMW0(PCREL(l91))
		add	r7
				// allocreg r2

	//boot.c, line 261
// code 0x12
					// (bitwise) loadreg
	//ops: 5, 0, 3
					// (objtotemp)  reg r4, offset 124, val 0
	mt	r4
	mr	r2
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r2
					// (save result) isreg

	//boot.c, line 262
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2, offset 108, val 0
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 262
// code 0x2a
					//call
	ldinc	r7
	.int	_HandleByte
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 263
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: f4240 in 4 chunks
	li	IMW3(1000000)
	li	IMW2(1000000)
	li	IMW1(1000000)
	li	IMW0(1000000)
					// (save temp) isreg
	mr	r3
				//save_temp done
l91: # 
				// allocreg r2

	//boot.c, line 256
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r3, offset 112, val 0
	mt	r3
					// (save temp) isreg
	mr	r2
				//save_temp done

	//boot.c, line 256
// code 0x1c
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//boot.c, line 256
// code 0x44
					// (test)
					// (objtotemp)  reg r2, offset 124, val 0
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 256
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l94)-1)
	li	IMW0(PCREL(l94))
		add	r7

	//boot.c, line 251
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l84)-1)
	li	IMW0(PCREL(l84))
	add	r7
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
l73:
	.byte	67
	.byte	72
	.byte	69
	.byte	67
	.byte	75
	.byte	83
	.byte	85
	.byte	77
	.byte	66
	.byte	73
	.byte	78
	.byte	0
l70:
	.byte	79
	.byte	83
	.byte	68
	.byte	56
	.byte	51
	.byte	50
	.byte	48
	.byte	49
	.byte	83
	.byte	89
	.byte	83
	.byte	0
l82:
	.byte	85
	.byte	110
	.byte	97
	.byte	98
	.byte	108
	.byte	101
	.byte	32
	.byte	116
	.byte	111
	.byte	32
	.byte	108
	.byte	111
	.byte	99
	.byte	97
	.byte	116
	.byte	101
	.byte	32
	.byte	112
	.byte	97
	.byte	114
	.byte	116
	.byte	105
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	10
	.byte	0
l65:
	.byte	72
	.byte	117
	.byte	110
	.byte	116
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	102
	.byte	111
	.byte	114
	.byte	32
	.byte	112
	.byte	97
	.byte	114
	.byte	116
	.byte	105
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	10
	.byte	0
l62:
	.byte	73
	.byte	110
	.byte	105
	.byte	116
	.byte	105
	.byte	97
	.byte	108
	.byte	105
	.byte	122
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	83
	.byte	68
	.byte	32
	.byte	99
	.byte	97
	.byte	114
	.byte	100
	.byte	10
	.byte	0
l83:
	.byte	66
	.byte	111
	.byte	111
	.byte	116
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	102
	.byte	114
	.byte	111
	.byte	109
	.byte	32
	.byte	82
	.byte	83
	.byte	50
	.byte	51
	.byte	50
	.byte	46
	.byte	0
	.globl	_putchar
	.globl	_puts
	.globl	_spi_init
	.globl	_FindDrive
	.globl	_LoadFile
	.globl	_checksum
	.globl	_tiny_printf
	.globl	_prg_start
	.globl	_printbuf
	.section	.bss
	.global	_printbuf
	.lcomm	_printbuf,32
	.globl	_SREC_COLUMN
	.global	_SREC_COLUMN
	.lcomm	_SREC_COLUMN,4
	.globl	_SREC_ADDR
	.global	_SREC_ADDR
	.lcomm	_SREC_ADDR,4
	.globl	_SREC_ADDRSIZE
	.global	_SREC_ADDRSIZE
	.lcomm	_SREC_ADDRSIZE,4
	.globl	_SREC_BYTECOUNT
	.global	_SREC_BYTECOUNT
	.lcomm	_SREC_BYTECOUNT,4
	.globl	_SREC_TYPE
	.global	_SREC_TYPE
	.lcomm	_SREC_TYPE,4
	.globl	_SREC_COUNTER
	.global	_SREC_COUNTER
	.lcomm	_SREC_COUNTER,4
	.globl	_SREC_TEMP
	.global	_SREC_TEMP
	.lcomm	_SREC_TEMP,4
	.globl	_SREC_MAX_ADDR
	.global	_SREC_MAX_ADDR
	.lcomm	_SREC_MAX_ADDR,4
	.globl	_BootPrint
