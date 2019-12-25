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
	.global	_SPI_PUMP_LE
_SPI_PUMP_LE:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	exg	r6
				// constant: 18 in 1 chunks
	li	IMW0(24)
	sub	r6
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib/spi_c.c, line 42
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done
				// allocreg r2

	//../../Lib/spi_c.c, line 43
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
					// (save temp) isreg
	mr	r2
				//save_temp done

	//../../Lib/spi_c.c, line 44
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 45
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 45
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 45
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6
	or	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 46
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 47
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 47
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 47
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	or	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 48
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 49
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  const
				// constant: 18 in 1 chunks
	li	IMW0(24)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 14 in 1 chunks
	li	IMW0(20)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 49
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 14 in 1 chunks
	li	IMW0(20)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 49
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	or	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 50
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
				// freereg r2
				// freereg r3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	add	r6
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
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_SPI_PUMP
_SPI_PUMP:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	exg	r6
				// constant: c in 1 chunks
	li	IMW0(12)
	sub	r6
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib/spi_c.c, line 56
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done
				// allocreg r2

	//../../Lib/spi_c.c, line 57
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
					// (save temp) isreg
	mr	r2
				//save_temp done

	//../../Lib/spi_c.c, line 58
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 59
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2
				// allocreg r2

	//../../Lib/spi_c.c, line 59
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6
	or	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 60
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 61
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2
				// allocreg r2

	//../../Lib/spi_c.c, line 61
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	or	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 62
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 63
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2
				// allocreg r2

	//../../Lib/spi_c.c, line 63
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	or	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 64
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
				// freereg r2
				// freereg r3
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6
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
	.global	_cmd_write
_cmd_write:
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
					// (objtotemp)  const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
				// allocreg r3

	//../../Lib/spi_c.c, line 74
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r0
					// (save result) store reg
// Store_reg to type 0x104
	mt	r0
	st	r5

	//../../Lib/spi_c.c, line 76
// code 0x44
					// (test)
					// (objtotemp)  extern
	ldinc	r7
	.int	_sd_is_sdhc
		//sizemod based on type 0x3
	ldt

	//../../Lib/spi_c.c, line 76
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5))
		add	r7

	//../../Lib/spi_c.c, line 77
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 9 in 1 chunks
	li	IMW0(9)
	shl	r0
					// (save result) store reg
// Store_reg to type 0x104
					// (prepobj tmp) var, auto|reg
				// constant: 1c in 1 chunks
	li	IMW0(28)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
l5: # 
				// allocreg r2

	//../../Lib/spi_c.c, line 81
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 18 in 1 chunks
	li	IMW0(24)
	shr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 81
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r0
					// (save result) store reg
// Store_reg to type 0x104
	mt	r0
	st	r5
				// freereg r2
				// allocreg r2

	//../../Lib/spi_c.c, line 82
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	shr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 82
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r0
					// (save result) store reg
// Store_reg to type 0x104
	mt	r0
	st	r5
				// freereg r2
				// allocreg r2

	//../../Lib/spi_c.c, line 83
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 83
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r0
					// (save result) store reg
// Store_reg to type 0x104
	mt	r0
	st	r5
				// freereg r2

	//../../Lib/spi_c.c, line 84
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r0
					// (save result) store reg
// Store_reg to type 0x104
	mt	r0
	st	r5
				// allocreg r2

	//../../Lib/spi_c.c, line 88
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	shr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 88
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r0
					// (save result) store reg
// Store_reg to type 0x104
	mt	r0
	st	r5
				// freereg r2

	//../../Lib/spi_c.c, line 92
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r5
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib/spi_c.c, line 93
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 9c3f in 3 chunks
	li	IMW2(39999)
	li	IMW1(39999)
	li	IMW0(39999)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib/spi_c.c, line 93
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	sgn
	cmp	r4

	//../../Lib/spi_c.c, line 93
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
		add	r7
				// allocreg r2
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) isreg
	mr	r2
				//save_temp done
l6: # 

	//../../Lib/spi_c.c, line 95
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r5
				//save_temp done

	//../../Lib/spi_c.c, line 96
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r5
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib/spi_c.c, line 93
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 93
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//../../Lib/spi_c.c, line 93
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
		add	r7

	//../../Lib/spi_c.c, line 93
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r4

	//../../Lib/spi_c.c, line 93
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l6)-1)
	li	IMW0(PCREL(l6))
		add	r7
l12: # 
				// freereg r2

	//../../Lib/spi_c.c, line 100
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r4
	mt	r4
	mr	r0
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
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_spi_spin
_spi_spin:
	stdec	r6
	mt	r2
	stdec	r6
				// allocreg r2

	//../../Lib/spi_c.c, line 108
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r2
				//save_temp done
l18: # 

	//../../Lib/spi_c.c, line 109
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 109
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 109
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: c8 in 2 chunks
	li	IMW1(200)
	li	IMW0(200)
	sgn
	cmp	r2

	//../../Lib/spi_c.c, line 109
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l18)-1)
	li	IMW0(PCREL(l18))
		add	r7
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
	.global	_wait_initV2
_wait_initV2:
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
					// (load_temp - type 4) not varadr
					// (objtotemp)  const
				// constant: ff0077 in 5 chunks
	li	IMW4(16711799)
	li	IMW3(16711799)
	li	IMW2(16711799)
	li	IMW1(16711799)
	li	IMW0(16711799)
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 4) not varadr
					// (objtotemp)  const
				// constant: 40000000 in 6 chunks
	li	IMW5(1073741824)
	li	IMW4(1073741824)
	li	IMW3(1073741824)
	li	IMW2(1073741824)
	li	IMW1(1073741824)
	li	IMW0(1073741824)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib/spi_c.c, line 118
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib/spi_c.c, line 119
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 4e1f in 3 chunks
	li	IMW2(19999)
	li	IMW1(19999)
	li	IMW0(19999)
					// (save temp) isreg
	mr	r4
				//save_temp done
l29: # 

	//../../Lib/spi_c.c, line 121
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib/spi_c.c, line 121
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib/spi_c.c, line 121
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib/spi_c.c, line 121
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 121
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib/spi_c.c, line 121
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l25)-1)
	li	IMW0(PCREL(l25))
		add	r7

	//../../Lib/spi_c.c, line 123
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 124
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib/spi_c.c, line 124
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: 870069 in 5 chunks
	li	IMW4(8847465)
	li	IMW3(8847465)
	li	IMW2(8847465)
	li	IMW1(8847465)
	li	IMW0(8847465)
	stdec	r6

	//../../Lib/spi_c.c, line 124
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib/spi_c.c, line 124
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 124
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib/spi_c.c, line 124
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l27)-1)
	li	IMW0(PCREL(l27))
		add	r7

	//../../Lib/spi_c.c, line 126
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 127
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib/spi_c.c, line 128
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l20)-1)
	li	IMW0(PCREL(l20))
	add	r7
l27: # 

	//../../Lib/spi_c.c, line 129
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7

l25: # 

	//../../Lib/spi_c.c, line 119
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 119
// code 0x44
					// (test)
					// (objtotemp)  reg r4
	mt	r4
	and	r4

	//../../Lib/spi_c.c, line 119
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l29)-1)
	li	IMW0(PCREL(l29))
		add	r7

	//../../Lib/spi_c.c, line 136
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l20: # 
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
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
	.global	_wait_init
_wait_init:
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
					// (load_temp - type 4) not varadr
					// (objtotemp)  const
				// constant: ff0041 in 5 chunks
	li	IMW4(16711745)
	li	IMW3(16711745)
	li	IMW2(16711745)
	li	IMW1(16711745)
	li	IMW0(16711745)
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3

	//../../Lib/spi_c.c, line 144
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 145
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l32
	stdec	r6

	//../../Lib/spi_c.c, line 145
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib/spi_c.c, line 146
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
l39: # 

	//../../Lib/spi_c.c, line 148
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib/spi_c.c, line 148
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r4
	mt	r4
	stdec	r6

	//../../Lib/spi_c.c, line 148
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib/spi_c.c, line 148
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 148
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib/spi_c.c, line 148
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
		add	r7

	//../../Lib/spi_c.c, line 151
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 152
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib/spi_c.c, line 153
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l31)-1)
	li	IMW0(PCREL(l31))
	add	r7
l37: # 

	//../../Lib/spi_c.c, line 158
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib/spi_c.c, line 146
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 146
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//../../Lib/spi_c.c, line 146
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39))
		add	r7

	//../../Lib/spi_c.c, line 160
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l31: # 
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
	.section	.rodata
l32:
	.byte	67
	.byte	77
	.byte	68
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
	.global	_is_sdhc
_is_sdhc:
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
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3

	//../../Lib/spi_c.c, line 168
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib/spi_c.c, line 170
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1aa in 2 chunks
	li	IMW1(426)
	li	IMW0(426)
	stdec	r6

	//../../Lib/spi_c.c, line 170
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: 870048 in 5 chunks
	li	IMW4(8847432)
	li	IMW3(8847432)
	li	IMW2(8847432)
	li	IMW1(8847432)
	li	IMW0(8847432)
	stdec	r6

	//../../Lib/spi_c.c, line 170
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib/spi_c.c, line 170
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 171
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//../../Lib/spi_c.c, line 171
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l42
	stdec	r6

	//../../Lib/spi_c.c, line 171
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 172
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib/spi_c.c, line 172
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l44)-1)
	li	IMW0(PCREL(l44))
		add	r7

	//../../Lib/spi_c.c, line 175
// code 0x2a
					//call
	ldinc	r7
	.int	_wait_init
	exg	r7


	//../../Lib/spi_c.c, line 177
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib/spi_c.c, line 178
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l44: # 

	//../../Lib/spi_c.c, line 180
// code 0x2a
					//call
	ldinc	r7
	.int	_SPI_PUMP
	exg	r7

				// allocreg r2

	//../../Lib/spi_c.c, line 180
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 181
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: ffff in 3 chunks
	li	IMW2(65535)
	li	IMW1(65535)
	li	IMW0(65535)
	and	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 181
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1aa in 2 chunks
	li	IMW1(426)
	li	IMW0(426)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib/spi_c.c, line 181
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l46)-1)
	li	IMW0(PCREL(l46))
		add	r7

	//../../Lib/spi_c.c, line 184
// code 0x2a
					//call
	ldinc	r7
	.int	_wait_init
	exg	r7


	//../../Lib/spi_c.c, line 186
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib/spi_c.c, line 187
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l46: # 

	//../../Lib/spi_c.c, line 189
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 196
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 31 in 2 chunks
	li	IMW1(49)
	li	IMW0(49)
					// (save temp) isreg
	mr	r5
				//save_temp done
l64: # 

	//../../Lib/spi_c.c, line 198
// code 0x2a
					//call
	ldinc	r7
	.int	_wait_initV2
	exg	r7

				// allocreg r2

	//../../Lib/spi_c.c, line 198
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 198
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib/spi_c.c, line 198
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l59)-1)
	li	IMW0(PCREL(l59))
		add	r7

	//../../Lib/spi_c.c, line 200
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib/spi_c.c, line 200
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: ff007a in 5 chunks
	li	IMW4(16711802)
	li	IMW3(16711802)
	li	IMW2(16711802)
	li	IMW1(16711802)
	li	IMW0(16711802)
	stdec	r6

	//../../Lib/spi_c.c, line 200
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 200
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r3

	//../../Lib/spi_c.c, line 200
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//../../Lib/spi_c.c, line 200
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l53)-1)
	li	IMW0(PCREL(l53))
		add	r7

	//../../Lib/spi_c.c, line 202
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib/spi_c.c, line 202
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l54
	stdec	r6

	//../../Lib/spi_c.c, line 202
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 203
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 204
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib/spi_c.c, line 205
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib/spi_c.c, line 205
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l55
	stdec	r6

	//../../Lib/spi_c.c, line 205
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 206
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 207
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 208
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 209
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r4
				//save_temp done
				// allocreg r2

	//../../Lib/spi_c.c, line 210
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r2
					// (objtotemp)  const
				// constant: 40 in 2 chunks
	li	IMW1(64)
	li	IMW0(64)
	and	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 210
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib/spi_c.c, line 210
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l57)-1)
	li	IMW0(PCREL(l57))
		add	r7

	//../../Lib/spi_c.c, line 213
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib/spi_c.c, line 214
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l57: # 

	//../../Lib/spi_c.c, line 218
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib/spi_c.c, line 219
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l53: # 

	//../../Lib/spi_c.c, line 222
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib/spi_c.c, line 222
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l60
	stdec	r6

	//../../Lib/spi_c.c, line 222
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

l59: # 

	//../../Lib/spi_c.c, line 224
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r5

	//../../Lib/spi_c.c, line 224
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l62)-1)
	li	IMW0(PCREL(l62))
		add	r7

	//../../Lib/spi_c.c, line 226
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l63
	stdec	r6

	//../../Lib/spi_c.c, line 226
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib/spi_c.c, line 227
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib/spi_c.c, line 228
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l62: # 

	//../../Lib/spi_c.c, line 196
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r5
					// (save result) isreg

	//../../Lib/spi_c.c, line 196
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//../../Lib/spi_c.c, line 196
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l64)-1)
	li	IMW0(PCREL(l64))
		add	r7

	//../../Lib/spi_c.c, line 230
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l41: # 
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
l54:
	.byte	67
	.byte	77
	.byte	68
	.byte	53
	.byte	56
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	32
	.byte	32
	.byte	0
l55:
	.byte	67
	.byte	77
	.byte	68
	.byte	53
	.byte	56
	.byte	95
	.byte	50
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	32
	.byte	32
	.byte	0
l60:
	.byte	67
	.byte	77
	.byte	68
	.byte	53
	.byte	56
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	32
	.byte	32
	.byte	0
l63:
	.byte	83
	.byte	68
	.byte	72
	.byte	67
	.byte	32
	.byte	73
	.byte	110
	.byte	105
	.byte	116
	.byte	105
	.byte	97
	.byte	108
	.byte	105
	.byte	122
	.byte	97
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	32
	.byte	101
	.byte	114
	.byte	114
	.byte	111
	.byte	114
	.byte	33
	.byte	10
	.byte	0
l42:
	.byte	99
	.byte	109
	.byte	100
	.byte	95
	.byte	67
	.byte	77
	.byte	68
	.byte	56
	.byte	32
	.byte	114
	.byte	101
	.byte	115
	.byte	112
	.byte	111
	.byte	110
	.byte	115
	.byte	101
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
	.section	.text.0
	.global	_spi_init
_spi_init:
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
					// (objtotemp)  const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 8000 in 3 chunks
	li	IMW2(32768)
	li	IMW1(32768)
	li	IMW0(32768)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib/spi_c.c, line 238
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_sd_is_sdhc
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 241
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l67
	stdec	r6

	//../../Lib/spi_c.c, line 241
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib/spi_c.c, line 243
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
					// (save temp) isreg
	mr	r5
				//save_temp done
l89: # 

	//../../Lib/spi_c.c, line 245
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r0
					// (objtotemp)  reg r3
	mt	r3
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 245
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 245
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l94)-1)
	li	IMW0(PCREL(l94))
		add	r7
l90: # 

	//../../Lib/spi_c.c, line 245
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r0
					// (objtotemp)  reg r3
	mt	r3
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 245
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 245
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l90)-1)
	li	IMW0(PCREL(l90))
		add	r7
l94: # 

	//../../Lib/spi_c.c, line 245
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 246
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib/spi_c.c, line 248
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r0
					// (objtotemp)  reg r3
	mt	r3
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 248
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 248
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l95)-1)
	li	IMW0(PCREL(l95))
		add	r7
l91: # 

	//../../Lib/spi_c.c, line 248
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r0
					// (objtotemp)  reg r3
	mt	r3
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 248
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 248
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l91)-1)
	li	IMW0(PCREL(l91))
		add	r7
l95: # 

	//../../Lib/spi_c.c, line 248
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

	//../../Lib/spi_c.c, line 249
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib/spi_c.c, line 249
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: 950040 in 5 chunks
	li	IMW4(9764928)
	li	IMW3(9764928)
	li	IMW2(9764928)
	li	IMW1(9764928)
	li	IMW0(9764928)
	stdec	r6

	//../../Lib/spi_c.c, line 249
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib/spi_c.c, line 249
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 249
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib/spi_c.c, line 249
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l78)-1)
	li	IMW0(PCREL(l78))
		add	r7

	//../../Lib/spi_c.c, line 250
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r5
				//save_temp done
l78: # 

	//../../Lib/spi_c.c, line 252
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r5

	//../../Lib/spi_c.c, line 252
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l80)-1)
	li	IMW0(PCREL(l80))
		add	r7

	//../../Lib/spi_c.c, line 254
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l81
	stdec	r6

	//../../Lib/spi_c.c, line 254
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib/spi_c.c, line 256
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib/spi_c.c, line 257
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l66)-1)
	li	IMW0(PCREL(l66))
	add	r7
l80: # 

	//../../Lib/spi_c.c, line 243
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r5
					// (save result) isreg

	//../../Lib/spi_c.c, line 243
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//../../Lib/spi_c.c, line 243
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l89)-1)
	li	IMW0(PCREL(l89))
		add	r7

	//../../Lib/spi_c.c, line 260
// code 0x2a
					//call
	ldinc	r7
	.int	_is_sdhc
	exg	r7


	//../../Lib/spi_c.c, line 260
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_sd_is_sdhc + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 261
// code 0x44
					// (test)
					// (objtotemp)  extern
	ldinc	r7
	.int	_sd_is_sdhc
		//sizemod based on type 0x3
	ldt

	//../../Lib/spi_c.c, line 261
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l84)-1)
	li	IMW0(PCREL(l84))
		add	r7

	//../../Lib/spi_c.c, line 266
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//../../Lib/spi_c.c, line 266
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: ff0050 in 5 chunks
	li	IMW4(16711760)
	li	IMW3(16711760)
	li	IMW2(16711760)
	li	IMW1(16711760)
	li	IMW0(16711760)
	stdec	r6

	//../../Lib/spi_c.c, line 266
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

l84: # 

	//../../Lib/spi_c.c, line 268
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 270
// code 0x2a
					//call
	ldinc	r7
	.int	_sd_get_size
	exg	r7


	//../../Lib/spi_c.c, line 270
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_sd_size + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 271
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_sd_size
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//../../Lib/spi_c.c, line 271
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l85
	stdec	r6

	//../../Lib/spi_c.c, line 271
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 274
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r0
					// (objtotemp)  reg r3
	mt	r3
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 274
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 274
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l96)-1)
	li	IMW0(PCREL(l96))
		add	r7
l92: # 

	//../../Lib/spi_c.c, line 274
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r0
					// (objtotemp)  reg r3
	mt	r3
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 274
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 274
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l92)-1)
	li	IMW0(PCREL(l92))
		add	r7
l96: # 

	//../../Lib/spi_c.c, line 274
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 275
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 278
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0
l66: # 
				// freereg r3
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
l81:
	.byte	73
	.byte	69
	.byte	82
	.byte	82
	.byte	0
l67:
	.byte	83
	.byte	80
	.byte	73
	.byte	0
l85:
	.byte	83
	.byte	68
	.byte	32
	.byte	99
	.byte	97
	.byte	114
	.byte	100
	.byte	32
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	32
	.byte	105
	.byte	115
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
	.section	.text.0
	.global	_sd_write_sector
_sd_write_sector:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r5
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r2

	//../../Lib/spi_c.c, line 286
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 287
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const/deref
					// (prepobj tmp) deref
			// const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp)  const
				// constant: 8000 in 3 chunks
	li	IMW2(32768)
	li	IMW1(32768)
	li	IMW0(32768)
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 287
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 287
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l119)-1)
	li	IMW0(PCREL(l119))
		add	r7
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 8000 in 3 chunks
	li	IMW2(32768)
	li	IMW1(32768)
	li	IMW0(32768)
					// (save temp) isreg
	mr	r2
				//save_temp done
l98: # 

	//../../Lib/spi_c.c, line 287
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const/deref
					// (prepobj tmp) deref
			// const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 287
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 287
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l98)-1)
	li	IMW0(PCREL(l98))
		add	r7
l119: # 
				// freereg r2

	//../../Lib/spi_c.c, line 287
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 101 in 2 chunks
	li	IMW1(257)
	li	IMW0(257)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 288
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 290
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	stdec	r6

	//../../Lib/spi_c.c, line 290
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: ff0058 in 5 chunks
	li	IMW4(16711768)
	li	IMW3(16711768)
	li	IMW2(16711768)
	li	IMW1(16711768)
	li	IMW0(16711768)
	stdec	r6

	//../../Lib/spi_c.c, line 290
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib/spi_c.c, line 290
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 291
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib/spi_c.c, line 291
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l102)-1)
	li	IMW0(PCREL(l102))
		add	r7
				// allocreg r2

	//../../Lib/spi_c.c, line 293
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l103
	stdec	r6

	//../../Lib/spi_c.c, line 293
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib/spi_c.c, line 295
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib/spi_c.c, line 296
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l97)-1)
	li	IMW0(PCREL(l97))
	add	r7
l102: # 

	//../../Lib/spi_c.c, line 298
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 299
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: fe in 2 chunks
	li	IMW1(254)
	li	IMW0(254)
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 302
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done
				// freereg r2
l116: # 
				// allocreg r2

	//../../Lib/spi_c.c, line 304
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? reg 
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
		//sizemod based on type 0x3
	ldt
//marker 2
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r3

	//../../Lib/spi_c.c, line 305
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: 18 in 1 chunks
	li	IMW0(24)
	sgn
	shr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 305
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r0
					// (objtotemp)  reg r5
	mt	r5
	and	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4
				// freereg r3
				// allocreg r3

	//../../Lib/spi_c.c, line 306
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	sgn
	shr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 306
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r0
					// (objtotemp)  reg r5
	mt	r5
	and	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4
				// freereg r3
				// allocreg r3

	//../../Lib/spi_c.c, line 307
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	sgn
	shr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 307
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r0
					// (objtotemp)  reg r5
	mt	r5
	and	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4
				// freereg r3

	//../../Lib/spi_c.c, line 308
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  reg r5
	mt	r5
	and	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4
				// freereg r2

	//../../Lib/spi_c.c, line 309
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r0
					// (save result) store reg
// Store_reg to type 0xa
					// (prepobj tmp) var, auto|reg
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 303
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 303
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp)  const
				// constant: 80 in 2 chunks
	li	IMW1(128)
	li	IMW0(128)
	sgn
	cmp	r1

	//../../Lib/spi_c.c, line 303
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l116)-1)
	li	IMW0(PCREL(l116))
		add	r7
				// allocreg r2

	//../../Lib/spi_c.c, line 312
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 313
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 314
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 316
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 186a0 in 3 chunks
	li	IMW2(100000)
	li	IMW1(100000)
	li	IMW0(100000)
					// (save temp) isreg
	mr	r2
				//save_temp done
l117: # 

	//../../Lib/spi_c.c, line 319
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 322
// code 0x44
					// (test)
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	and	r4

	//../../Lib/spi_c.c, line 322
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l121)-1)
	li	IMW0(PCREL(l121))
		add	r7

	//../../Lib/spi_c.c, line 322
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 322
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2

	//../../Lib/spi_c.c, line 322
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l117)-1)
	li	IMW0(PCREL(l117))
		add	r7
l121: # 

	//../../Lib/spi_c.c, line 323
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 324
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const/deref
					// (prepobj tmp) deref
			// const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp)  const
				// constant: 8000 in 3 chunks
	li	IMW2(32768)
	li	IMW1(32768)
	li	IMW0(32768)
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 324
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 324
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l122)-1)
	li	IMW0(PCREL(l122))
		add	r7
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 8000 in 3 chunks
	li	IMW2(32768)
	li	IMW1(32768)
	li	IMW0(32768)
					// (save temp) isreg
	mr	r2
				//save_temp done
l112: # 

	//../../Lib/spi_c.c, line 324
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const/deref
					// (prepobj tmp) deref
			// const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 324
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 324
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l112)-1)
	li	IMW0(PCREL(l112))
		add	r7
l122: # 

	//../../Lib/spi_c.c, line 324
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 325
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l97: # 
				// freereg r2
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
l103:
	.byte	87
	.byte	114
	.byte	105
	.byte	116
	.byte	101
	.byte	32
	.byte	102
	.byte	97
	.byte	105
	.byte	108
	.byte	101
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
	.section	.text.0
l123:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r5
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
					// (save temp) isreg
	mr	r5
				//save_temp done
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
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2

	//../../Lib/spi_c.c, line 335
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 337
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 16e35f in 4 chunks
	li	IMW3(1499999)
	li	IMW2(1499999)
	li	IMW1(1499999)
	li	IMW0(1499999)
					// (save temp) isreg
	mr	r2
				//save_temp done
l138: # 

	//../../Lib/spi_c.c, line 340
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r5
				//save_temp done

	//../../Lib/spi_c.c, line 343
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  deref 
	//(offset 0)
	ld	r5
	mr	r1
					// (objtotemp)  const
				// constant: fe in 2 chunks
	li	IMW1(254)
	li	IMW0(254)
	sgn
	cmp	r1

	//../../Lib/spi_c.c, line 343
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l129)-1)
	li	IMW0(PCREL(l129))
		add	r7

	//../../Lib/spi_c.c, line 349
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_spi_checksum
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 351
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sgn
	cmp	r3

	//../../Lib/spi_c.c, line 351
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l142)-1)
	li	IMW0(PCREL(l142))
		add	r7
				// freereg r2
l139: # 

	//../../Lib/spi_c.c, line 354
// code 0x2a
					//call
	ldinc	r7
	.int	_SPI_PUMP_LE
	exg	r7

				// allocreg r2

	//../../Lib/spi_c.c, line 354
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 355
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 357
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 358
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_spi_checksum
		//sizemod based on type 0x3
	ldt
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_spi_checksum + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2

	//../../Lib/spi_c.c, line 351
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sub	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 351
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sgn
	cmp	r3

	//../../Lib/spi_c.c, line 351
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l139)-1)
	li	IMW0(PCREL(l139))
		add	r7
l142: # 
				// allocreg r2

	//../../Lib/spi_c.c, line 361
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r3

	//../../Lib/spi_c.c, line 361
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l143)-1)
	li	IMW0(PCREL(l143))
		add	r7
				// freereg r2
l140: # 

	//../../Lib/spi_c.c, line 364
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r5
				//save_temp done
				// allocreg r2

	//../../Lib/spi_c.c, line 364
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r5
					// (save temp) isreg
	mr	r2
				//save_temp done

	//../../Lib/spi_c.c, line 365
// code 0x32
					//FIXME convert
					// (convert -> assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 1) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	byt
	st	r4
				//save_temp done

	//../../Lib/spi_c.c, line 365
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 367
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_spi_checksum
		//sizemod based on type 0x3
	ldt
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	add	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_spi_checksum + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2

	//../../Lib/spi_c.c, line 361
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 361
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r3

	//../../Lib/spi_c.c, line 361
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l140)-1)
	li	IMW0(PCREL(l140))
		add	r7
l143: # 
				// allocreg r2

	//../../Lib/spi_c.c, line 370
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r2
				//save_temp done

	//../../Lib/spi_c.c, line 371
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done
l129: # 

	//../../Lib/spi_c.c, line 337
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 337
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2

	//../../Lib/spi_c.c, line 337
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l138)-1)
	li	IMW0(PCREL(l138))
		add	r7

	//../../Lib/spi_c.c, line 374
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r5
				//save_temp done

	//../../Lib/spi_c.c, line 375
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
				// freereg r2
				// freereg r3
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
	.global	_sd_read_sector
_sd_read_sector:
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
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  const
				// constant: ffffffd0 in 2 chunks
	li	IMW1(-48)
	li	IMW0(-48)
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 8000 in 3 chunks
	li	IMW2(32768)
	li	IMW1(32768)
	li	IMW0(32768)
					// (save temp) isreg
	mr	r2
				//save_temp done

	//../../Lib/spi_c.c, line 380
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

	//../../Lib/spi_c.c, line 384
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 385
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 385
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 385
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l156)-1)
	li	IMW0(PCREL(l156))
		add	r7
l154: # 

	//../../Lib/spi_c.c, line 385
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 385
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 385
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l154)-1)
	li	IMW0(PCREL(l154))
		add	r7
l156: # 

	//../../Lib/spi_c.c, line 385
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 101 in 2 chunks
	li	IMW1(257)
	li	IMW0(257)
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib/spi_c.c, line 386
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
					// (save temp) store
	st	r1
				//save_temp done

	//../../Lib/spi_c.c, line 388
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	stdec	r6

	//../../Lib/spi_c.c, line 388
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: ff0051 in 5 chunks
	li	IMW4(16711761)
	li	IMW3(16711761)
	li	IMW2(16711761)
	li	IMW1(16711761)
	li	IMW0(16711761)
	stdec	r6

	//../../Lib/spi_c.c, line 388
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 388
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r5

	//../../Lib/spi_c.c, line 389
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//../../Lib/spi_c.c, line 389
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l149)-1)
	li	IMW0(PCREL(l149))
		add	r7

	//../../Lib/spi_c.c, line 391
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib/spi_c.c, line 391
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	stdec	r6

	//../../Lib/spi_c.c, line 391
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l150
	stdec	r6

	//../../Lib/spi_c.c, line 391
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//../../Lib/spi_c.c, line 393
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l144)-1)
	li	IMW0(PCREL(l144))
	add	r7
l149: # 

	//../../Lib/spi_c.c, line 394
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	stdec	r6

	//../../Lib/spi_c.c, line 394
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0xa
				// constant: 20 in 2 chunks
	li	IMW1(32)
	li	IMW0(32)
	ldidx	r6
	stdec	r6

	//../../Lib/spi_c.c, line 394
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l123)-1)
	li	IMW0(PCREL(l123))
	add	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 394
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r4

	//../../Lib/spi_c.c, line 396
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 396
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 396
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l157)-1)
	li	IMW0(PCREL(l157))
		add	r7
l155: # 

	//../../Lib/spi_c.c, line 396
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	and	r0
					// (save result) store reg
// Store_reg to type 0x503
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 396
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib/spi_c.c, line 396
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l155)-1)
	li	IMW0(PCREL(l155))
		add	r7
l157: # 

	//../../Lib/spi_c.c, line 396
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
l144: # 

	//../../Lib/spi_c.c, line 397
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r4
	mt	r4
	mr	r0
				// freereg r2
				// freereg r3
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
l150:
	.byte	82
	.byte	101
	.byte	97
	.byte	100
	.byte	32
	.byte	99
	.byte	111
	.byte	109
	.byte	109
	.byte	97
	.byte	110
	.byte	100
	.byte	32
	.byte	102
	.byte	97
	.byte	105
	.byte	108
	.byte	101
	.byte	100
	.byte	32
	.byte	97
	.byte	116
	.byte	32
	.byte	37
	.byte	100
	.byte	32
	.byte	40
	.byte	37
	.byte	100
	.byte	41
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
	.global	_sd_get_size
_sd_get_size:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r5
				// allocreg r2

	//../../Lib/spi_c.c, line 405
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib/spi_c.c, line 405
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: ff0049 in 5 chunks
	li	IMW4(16711753)
	li	IMW3(16711753)
	li	IMW2(16711753)
	li	IMW1(16711753)
	li	IMW0(16711753)
	stdec	r6

	//../../Lib/spi_c.c, line 405
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 407
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	stdec	r6

	//../../Lib/spi_c.c, line 407
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf
		//sizemod based on type 0xa
	stdec	r6

	//../../Lib/spi_c.c, line 407
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l123)-1)
	li	IMW0(PCREL(l123))
	add	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 408
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
l173: # 

	//../../Lib/spi_c.c, line 409
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg

	//../../Lib/spi_c.c, line 409
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	sgn
	cmp	r5

	//../../Lib/spi_c.c, line 409
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l173)-1)
	li	IMW0(PCREL(l173))
		add	r7
				// freereg r2
				// allocreg r2

	//../../Lib/spi_c.c, line 414
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf
		//sizemod based on type 0x1
	byt
	ldt
	mr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 414
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: c0 in 2 chunks
	li	IMW1(192)
	li	IMW0(192)
	and	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 414
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 40 in 2 chunks
	li	IMW1(64)
	li	IMW0(64)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib/spi_c.c, line 414
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l164)-1)
	li	IMW0(PCREL(l164))
		add	r7
				// allocreg r2

	//../../Lib/spi_c.c, line 416
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 7
		//sizemod based on type 0x1
	byt
	ldt
	mr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 416
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	shl	r2
					// (save result) isreg
				// allocreg r3

	//../../Lib/spi_c.c, line 416
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 8
		//sizemod based on type 0x1
	byt
	ldt
	mr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 416
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shl	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 416
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  reg r3
	mt	r3
	or	r2
					// (save result) isreg
				// freereg r3
				// allocreg r3

	//../../Lib/spi_c.c, line 416
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 9
		//sizemod based on type 0x1
	byt
	ldt
	mr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 416
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  reg r3
	mt	r3
	or	r2
					// (save result) isreg
				// freereg r3

	//../../Lib/spi_c.c, line 416
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 3fffff in 4 chunks
	li	IMW3(4194303)
	li	IMW2(4194303)
	li	IMW1(4194303)
	li	IMW0(4194303)
	and	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 416
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r5
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg
				// freereg r2

	//../../Lib/spi_c.c, line 417
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	shl	r5
					// (save result) isreg

	//../../Lib/spi_c.c, line 420
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l165)-1)
	li	IMW0(PCREL(l165))
	add	r7
l164: # 
				// allocreg r2

	//../../Lib/spi_c.c, line 421
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 9
		//sizemod based on type 0x1
	byt
	ldt
	mr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 421
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 421
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 6 in 1 chunks
	li	IMW0(6)
	and	r2
					// (save result) isreg
				// allocreg r3

	//../../Lib/spi_c.c, line 421
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 10
		//sizemod based on type 0x1
	byt
	ldt
	mr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 421
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	sgn
	shr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 421
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
					// (objtotemp)  reg r3
	mt	r3
	or	r2
					// (save result) isreg
				// freereg r3
				// allocreg r3

	//../../Lib/spi_c.c, line 422
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 5
		//sizemod based on type 0x1
	byt
	ldt
	mr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 422
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r0
					// (objtotemp)  const
				// constant: f in 1 chunks
	li	IMW0(15)
	and	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r3
				// allocreg r3

	//../../Lib/spi_c.c, line 423
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 6
		//sizemod based on type 0x1
	byt
	ldt
	mr	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	and	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	shl	r3
					// (save result) isreg
				// allocreg r4

	//../../Lib/spi_c.c, line 423
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 7
		//sizemod based on type 0x1
	byt
	ldt
	mr	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	shl	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r3
					// (objtotemp)  reg r4
	mt	r4
	or	r3
					// (save result) isreg
				// freereg r4
				// allocreg r4

	//../../Lib/spi_c.c, line 423
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf + 8
		//sizemod based on type 0x1
	byt
	ldt
	mr	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: c0 in 2 chunks
	li	IMW1(192)
	li	IMW0(192)
	and	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 6 in 1 chunks
	li	IMW0(6)
	sgn
	shr	r4
					// (save result) isreg

	//../../Lib/spi_c.c, line 423
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r3
					// (objtotemp)  reg r4
	mt	r4
	or	r3
					// (save result) isreg
				// freereg r4

	//../../Lib/spi_c.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib/spi_c.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//../../Lib/spi_c.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//../../Lib/spi_c.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l166
	stdec	r6

	//../../Lib/spi_c.c, line 424
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6


	//../../Lib/spi_c.c, line 425
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	add	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 425
// code 0x19
					// (bitwise) loadreg
		// WARNING - evading q2 and target collision - check code for correctness.
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	shl	r0
					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib/spi_c.c, line 426
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//../../Lib/spi_c.c, line 426
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l167
	stdec	r6

	//../../Lib/spi_c.c, line 426
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib/spi_c.c, line 427
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	shl	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib/spi_c.c, line 428
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r3
					// (save result) isreg

	//../../Lib/spi_c.c, line 428
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r5
					// (objtotemp)  reg r2
	mt	r2
	mul	r5
					// (save result) isreg
				// freereg r3
				// freereg r2

	//../../Lib/spi_c.c, line 429
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	stdec	r6

	//../../Lib/spi_c.c, line 429
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib/spi_c.c, line 429
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l168
	stdec	r6

	//../../Lib/spi_c.c, line 429
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//../../Lib/spi_c.c, line 430
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	sgn
	cmp	r1

	//../../Lib/spi_c.c, line 430
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l176)-1)
	li	IMW0(PCREL(l176))
		add	r7
				// allocreg r2
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
					// (save temp) isreg
	mr	r2
				//save_temp done
l169: # 

	//../../Lib/spi_c.c, line 432
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r5
					// (save result) isreg

	//../../Lib/spi_c.c, line 433
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	shr	r2
					// (save result) isreg

	//../../Lib/spi_c.c, line 430
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	sgn
	cmp	r2

	//../../Lib/spi_c.c, line 430
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l169)-1)
	li	IMW0(PCREL(l169))
		add	r7
l176: # 

	//../../Lib/spi_c.c, line 435
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib/spi_c.c, line 435
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l172
	stdec	r6

	//../../Lib/spi_c.c, line 435
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

l165: # 

	//../../Lib/spi_c.c, line 437
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
	mr	r0
				// freereg r2
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
l166:
	.byte	99
	.byte	95
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	95
	.byte	109
	.byte	117
	.byte	108
	.byte	116
	.byte	58
	.byte	32
	.byte	37
	.byte	100
	.byte	44
	.byte	32
	.byte	114
	.byte	101
	.byte	97
	.byte	100
	.byte	95
	.byte	98
	.byte	108
	.byte	95
	.byte	108
	.byte	101
	.byte	110
	.byte	58
	.byte	32
	.byte	37
	.byte	100
	.byte	44
	.byte	32
	.byte	99
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	58
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l167:
	.byte	77
	.byte	117
	.byte	108
	.byte	116
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l168:
	.byte	37
	.byte	100
	.byte	32
	.byte	98
	.byte	108
	.byte	111
	.byte	99
	.byte	107
	.byte	115
	.byte	32
	.byte	111
	.byte	102
	.byte	32
	.byte	115
	.byte	105
	.byte	122
	.byte	101
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l172:
	.byte	37
	.byte	100
	.byte	32
	.byte	98
	.byte	108
	.byte	111
	.byte	99
	.byte	107
	.byte	115
	.byte	32
	.byte	111
	.byte	102
	.byte	32
	.byte	53
	.byte	49
	.byte	50
	.byte	32
	.byte	98
	.byte	121
	.byte	116
	.byte	101
	.byte	115
	.byte	10
	.byte	0
	.globl	_spi_checksum
	.section	.bss
	.global	_spi_checksum
	.lcomm	_spi_checksum,4
	.globl	_sd_is_sdhc
	.global	_sd_is_sdhc
	.lcomm	_sd_is_sdhc,4
	.globl	_sd_size
	.global	_sd_size
	.lcomm	_sd_size,4
	.globl	_small_printf
	.globl	_SPI_R1
	.global	_SPI_R1
	.lcomm	_SPI_R1,6
	.globl	_puts
	.globl	_sizebuf
	.global	_sizebuf
	.lcomm	_sizebuf,18
