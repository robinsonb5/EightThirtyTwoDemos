#include "assembler.pp"

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

	//boot.c, line 34
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
l9: # 
				// allocreg r2

	//boot.c, line 36
// code 0x1a
					// (bitwise) loadreg
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

	//boot.c, line 36
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: f in 1 chunks
	li	IMW0(15)
	and	r3
					// (save result) isreg
				// freereg r2

	//boot.c, line 37
// code 0x19
					// (bitwise) loadreg
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

	//boot.c, line 38
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 9 in 1 chunks
	li	IMW0(9)
	sgn
	cmp	r3

	//boot.c, line 38
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l7)-1)
	li	IMW0(PCREL(l7))
		add	r7

	//boot.c, line 39
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 37 in 2 chunks
	li	IMW1(55)
	li	IMW0(55)
	add	r3
					// (save result) isreg

	//boot.c, line 41
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l8)-1)
	li	IMW0(PCREL(l8))
	add	r7
l7: # 

	//boot.c, line 41
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	add	r3
					// (save result) isreg
l8: # 

	//boot.c, line 42
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r3
	mt	r3
					// (save temp) store
	byt
	st	r5
				//save_temp done

	//boot.c, line 42
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg

	//boot.c, line 35
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg

	//boot.c, line 35
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	sgn
	cmp	r4

	//boot.c, line 35
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l9)-1)
	li	IMW0(PCREL(l9))
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
	.section	.text.0
	.global	_main
_main:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// constant: c in 1 chunks
	li	IMW0(12)
	sub	r6
				// allocreg r5
				// allocreg r4
				// allocreg r3

	//boot.c, line 52
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l12
	stdec	r6

	//boot.c, line 52
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 53
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_init
	exg	r7

				// allocreg r2

	//boot.c, line 53
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 53
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 53
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
		add	r7

	//boot.c, line 55
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l15
	stdec	r6

	//boot.c, line 55
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//boot.c, line 56
// code 0x2a
					//call
	ldinc	r7
	.int	_FindDrive
	exg	r7

				// allocreg r2

	//boot.c, line 56
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 56
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 56
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l17)-1)
	li	IMW0(PCREL(l17))
		add	r7

	//boot.c, line 60
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_prg_start
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 60
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l20
	stdec	r6

	//boot.c, line 60
// code 0x2a
					//call
	ldinc	r7
	.int	_LoadFile
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 60
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r3

	//boot.c, line 60
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//boot.c, line 60
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
		add	r7

	//boot.c, line 63
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
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 64
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

	//boot.c, line 65
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	add	r3
					// (save result) isreg

	//boot.c, line 66
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: fffffffc in 1 chunks
	li	IMW0(-4)
	and	r3
					// (save result) isreg

	//boot.c, line 67
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_prg_start
		//sizemod based on type 0x3
	mr	r4
					// (objtotemp)  reg r3
	mt	r3
	add	r4
					// (save result) isreg

	//boot.c, line 68
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r4
	mt	r4
	stdec	r6

	//boot.c, line 68
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l23
	stdec	r6

	//boot.c, line 68
// code 0x2a
					//call
	ldinc	r7
	.int	_LoadFile
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//boot.c, line 68
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 68
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//boot.c, line 68
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
		add	r7

	//boot.c, line 70
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1ff in 2 chunks
	li	IMW1(511)
	li	IMW0(511)
	sgn
	cmp	r3

	//boot.c, line 70
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
		add	r7
l36: # 

	//boot.c, line 72
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	stdec	r6
				// allocreg r2

	//boot.c, line 72
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r2
					// (objtotemp)  reg r5
	mt	r5
	add	r2
					// (save result) isreg

	//boot.c, line 72
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//boot.c, line 72
// code 0x2a
					//call
	ldinc	r7
	.int	_checksum
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//boot.c, line 72
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//boot.c, line 72
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done
				// freereg r2

	//boot.c, line 73
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ldinc	r4
					// (save temp) store
	st	r1
				//save_temp done

	//boot.c, line 74
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	add	r5
					// (save result) isreg

	//boot.c, line 75
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	sub	r3
					// (save result) isreg

	//boot.c, line 76
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r1
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sgn
	cmp	r1

	//boot.c, line 76
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l28)-1)
	li	IMW0(PCREL(l28))
		add	r7

	//boot.c, line 79
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 79
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//boot.c, line 79
// code 0x2a
					//call
	ldinc	r7
	.int	_cvx
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 80
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 8)
	ldinc	r7
	.int	_printbuf + 8
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

	//boot.c, line 81
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf + 9
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 81
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//boot.c, line 81
// code 0x2a
					//call
	ldinc	r7
	.int	_cvx
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 82
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 17)
	ldinc	r7
	.int	_printbuf + 17
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

	//boot.c, line 83
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf + 18
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 83
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//boot.c, line 83
// code 0x2a
					//call
	ldinc	r7
	.int	_cvx
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//boot.c, line 84
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 26)
	ldinc	r7
	.int	_printbuf + 26
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done

	//boot.c, line 85
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_printbuf
		//sizemod based on type 0xa
	stdec	r6

	//boot.c, line 85
// code 0x2a
					//call
	ldinc	r7
	.int	_BootPrint
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l28: # 

	//boot.c, line 70
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1ff in 2 chunks
	li	IMW1(511)
	li	IMW0(511)
	sgn
	cmp	r3

	//boot.c, line 70
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l36)-1)
	li	IMW0(PCREL(l36))
		add	r7

	//boot.c, line 99
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
	add	r7
l17: # 

	//boot.c, line 101
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l32
	stdec	r6

	//boot.c, line 101
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l37: # 

	//boot.c, line 106
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
	add	r7
				// freereg r3
				// freereg r4
				// freereg r5
				// constant: c in 1 chunks
	li	IMW0(12)
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
	.section	.rodata
l23:
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
l20:
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
l32:
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
l15:
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
l12:
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
	.globl	_spi_init
	.globl	_FindDrive
	.globl	_LoadFile
	.globl	_checksum
	.globl	_prg_start
	.globl	_printbuf
	.section	.bss
	.global	_printbuf
	.lcomm	_printbuf,32
	.globl	_puts
	.globl	_BootPrint
