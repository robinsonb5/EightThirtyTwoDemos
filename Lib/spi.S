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
	.global	_SPI_PUMP_LE

_sd_is_sdhc:
	.int 0

_SPI_PUMP_LE:
	stdec	r6
	mt	r5
	stdec	r6

	li	IMW1(0xffffffd4)
	li	IMW0(0xffffffd4)
	mr	r5

	li	IMW1(255)
	li	IMW0(255)
	mr	r1

	st	r5	// 10 bytes - Write 0xff to SPI register

	ld	r5
	mr	r0
	li	8
	ror	r0

	mt	r1
	st	r5

	ld	r5
	or	r0
	li	8
	ror	r0

	mt	r1
	st	r5

	ld	r5
	or	r0
	li	8
	ror	r0

	mt	r1
	st	r5

	ld	r5
	or	r0
	li	8
	ror	r0

	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r7	// 36 bytes  -  reduced from 116 bytes

#if 0
_SPI_PUMP_LE:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	exg	r6

	li	IMW1(36)
	li	IMW0(36)
	sub	r6

	li	IMW1(255)
	li	IMW0(255)
	mr	r4

	li	IMW1(-44)
	li	IMW0(-44)
	mr	r3

	mt	r4
	st	r3

	ld	r3
	mr	r2

	mt	r4 // 20
	and	r2

	mt	r4
	st	r3

	ld	r3
	mr	r0

	mt	r4
	and	r0

	li	IMW0(4)
	addt	r6
	stmpdec	r0

	ld	r6
	mr	r0

	li	IMW0(8)
	shl	r0

	li	IMW0(8)
	addt	r6
	stmpdec	r0

	li	IMW0(8)
	addt	r6
	mr	r1  //40 

	mt	r2
	st	r1

	mt	r2
	mr	r2

	li	IMW0(4)
	ldidx	r6
	or	r2

	mt	r4
	st	r3

	ld	r3
	mr	r0

	mt	r4
	and	r0

	li	IMW0(16)
	addt	r6
	stmpdec	r0

	li	IMW0(12)
	ldidx	r6
	mr	r0

	li	IMW0(16)  //60
	shl	r0

	li	IMW0(20)
	addt	r6
	stmpdec	r0

	li	IMW0(20)
	addt	r6
	mr	r1

	mt	r2

	st	r1

	mt	r2
	mr	r2

	li	IMW0(16)
	ldidx	r6
	or	r2

	mt	r4
	st	r3

	ld	r3
	mr	r0

	mt	r4
	and	r0 // 80

	li	IMW0(28)
	addt	r6
	stmpdec	r0

	li	IMW0(24)
	ldidx	r6
	mr	r0

	li	IMW0(24)
	shl	r0

	li	IMW1(32)
	li	IMW0(32)
	addt	r6
	stmpdec	r0

	li	IMW1(32)
	li	IMW0(32)
	addt	r6
	mr	r1


	mt	r2

	st	r1

	mt	r2
	mr	r2  // 100

	li	IMW0(28)
	ldidx	r6
	or	r2

	mt	r2
	mr	r0

	li	IMW1(36)
	li	IMW0(36)
	add	r6
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7  // 116
#endif


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
	.global	_SPI_PUMP
_SPI_PUMP:
	stdec	r6
	mt	r5
	stdec	r6

	li	IMW1(0xffffffd4)
	li	IMW0(0xffffffd4)
	mr	r5

	li	IMW1(255)
	li	IMW0(255)
	mr	r1

	st	r5	// 10 bytes - Write 0xff to SPI register

	ld	r5
	mr	r0
	li	8
	shl	r0

	mt	r1
	st	r5

	ld	r5
	or	r0
	li	8
	shl	r0

	mt	r1
	st	r5

	ld	r5
	or	r0
	li	8
	shl	r0

	mt	r1
	st	r5

	ld	r5
	or	r0

	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r7	// 34 bytes  -  reduced from 94 bytes  (70 bytes removing unneccesary and from C code)


#if 0
// Manually optimising the compiled C code...
_SPI_PUMP:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	exg	r6

	li	IMW0(12)
	sub	r6

	li	IMW1(-44)
	li	IMW0(-44)

	mr	r3 // 10

	li	IMW1(255)
	li	IMW0(255)

	st	r3

	ld	r3

	mr	r2

	li	IMW1(255)
	li	IMW0(255)

	st	r3

//	mt	r2
//	mr	r0 // 20

	li	IMW0(8)
	shl	r2

//	li	IMW0(4)
//	addt	r6
//	stmpdec	r0

	ld	r3
	or	r2

//	ld	r6
//	or	r2

	li	IMW1(255) // 30
	li	IMW0(255)

	st	r3

	mt	r2
	mr	r0

	li	IMW0(8)
	shl	r0

	li	IMW0(8)
	addt	r6
	stmpdec	r0 // 40

	ld	r3
	mr	r2

	li	IMW0(4)
	ldidx	r6
	or	r2

	li	IMW1(255)
	li	IMW0(255)

	st	r3

	mt	r2
	mr	r0 // 50

	li	IMW0(8)
	shl	r0

	li	IMW0(12)
	addt	r6
	stmpdec	r0

	ld	r3
	mr	r2

	li	IMW0(8)
	ldidx	r6
	or	r2 // 60

	mt	r2
	mr	r0

	li	IMW0(12)
	add	r6
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7 // 70

#endif

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
	stdec	r6
	mt	r5
	stdec	r6

	li	IMW1(0xffffffd4)
	li	IMW0(0xffffffd4)
	mr	r5

	li	12
	ldidx	r6
	mr	r1

	li	8	// 10
	ldidx	r6
	mr	r0

	st	r5	// SPI(cmd&255); // Assume only low 8 bits are active.

	// FIXME - better to do this only for read / write commands
	li	IMW1(PCREL(_sd_is_sdhc-1))
	li	IMW0(PCREL(_sd_is_sdhc))
	ldidx r7

	cond	EQ
		li	9
		shl	r1	// Multiply LBA by 512 if we have a standard SD card.
		cond	EX	// 21 bytes
	

	li	IMW0(24)
	ror	r1	// Rotate left 8 bits -  BBCCDDAA
	exg	r1
	st	r5	// LBA high bits

	exg	r1
	ror	r1	// CCDDAABB
	exg	r1
	st	r5	// LBA 23 - 16

	exg	r1
	ror	r1	// DDAABBCC
	exg	r1
	st	r5	// LBA 15-8

	exg	r1
	ror	r1	// AABBCCDD
	exg	r1	
	st	r5	// LBA low byte

	li	16
	ror	r0
	mt	r0
	st	r5	// CRC byte, if necessary.	//  40 bytes
	li	IMW2(40000)
	li	IMW1(40000)
	li	IMW0(40000)
	mr	r1
	li	IMW1(255)
	li	IMW0(255)
	mr	r0
.loop:
	ld	r5
	exg	r0
	cmp	r0
	cond	NEQ
		li	IMW0(PCREL(.done))
		add	r7	// 54 bytes

	exg	r0
	st	r5

	li	1
	sub	r1
	cond	NEQ
		li	IMW0(PCREL(.loop))
		add	r7

.done:
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r7	// 64 bytes  -  GCC compiled ZPU equivalent 128 bytes


#if 0

_cmd_write:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6

	li	IMW1(-44)
	li	IMW0(-44)

	mr	r5 // 10

	li	IMW0(20)
	ldidx	r6
	mr	r0

	li	IMW1(255)
	li	IMW0(255)
	and	r0

	mt	r0
	st	r5


	ldinc	r7
	.int	_sd_is_sdhc // 20

	ldt


	cond	NEQ

	li	IMW1(PCREL(l5)-1)
	li	IMW0(PCREL(l5))
		add	r7

	li	IMW0(24)
	ldidx	r6
	mr	r0

	li	IMW0(9)
	shl	r0 // 30

	li	IMW0(28)
	addt	r6
	stmpdec	r0

l5: # 

	li	IMW0(24)
	ldidx	r6
	mr	r2

	li	IMW0(24)
	shr	r2

	mt	r2
	mr	r0 // 40

	li	IMW1(255)
	li	IMW0(255)
	and	r0

	mt	r0
	st	r5

	li	IMW0(24)
	ldidx	r6
	mr	r2

	li	IMW0(16)
	shr	r2 // 50

	mt	r2
	mr	r0

	li	IMW1(255)
	li	IMW0(255)
	and	r0

	mt	r0
	st	r5

	li	IMW0(24)
	ldidx	r6
	mr	r2  //60

	li	IMW0(8)
	shr	r2

	mt	r2
	mr	r0

	li	IMW1(255)
	li	IMW0(255)
	and	r0

	mt	r0
	st	r5

	li	IMW0(24) // 80
	ldidx	r6
	mr	r0

	li	IMW1(255)
	li	IMW0(255)
	and	r0

	mt	r0
	st	r5

	li	IMW0(20)
	ldidx	r6
	mr	r2 // 90

	li	IMW0(16)
	shr	r2

	mt	r2
	mr	r0

	li	IMW1(255)
	li	IMW0(255)
	and	r0

	mt	r0
	st	r5

	ld	r5  // 100
	mr	r4

	li	IMW1(255)
	li	IMW0(255)
	and	r4

	li	IMW2(39999)
	li	IMW1(39999)
	li	IMW0(39999)

	mr	r3

	li	IMW1(255)
	li	IMW0(255)  //110 
	sgn
	cmp	r4


	cond	NEQ

	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
		add	r7

	li	IMW1(255)
	li	IMW0(255)

	mr	r2

l6: # 


	mt	r2  // 120

	st	r5

	ld	r5
	mr	r4

	mt	r2
	and	r4

	li	IMW0(1)
	sub	r3

	mt	r3
	and	r3

	cond	EQ  //130 

	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
		add	r7

	mt	r2
	sgn
	cmp	r4

	cond	EQ

	li	IMW1(PCREL(l6)-1)
	li	IMW0(PCREL(l6))
		add	r7  //140
l12: # 

	mt	r4
	mr	r0

	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r2  // 150
	ldinc	r6
	mr	r7  // 152
#endif

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


_spi_spin:	// vbcc compiled equivalent, 25 bytes
	stdec	r6
	li	IMW1(0xffffffd4)
	li	IMW0(0xffffffd4)
	mr	r1
	li	IMW1(200)
	li	IMW0(200)
	mr	r0
.spinloop:
	li	IMW0(-1)
	st	r1
	add	r0
	cond	NEQ
		li	IMW0(PCREL(.spinloop))
		add	r7

	ldinc	r6
	mr	r7	// 15 bytes

#if 0
_spi_spin:
	stdec	r6
	mt	r2
	stdec	r6

	li	IMW0(0)

	mr	r2

l18: # 

	li	IMW1(-44)
	li	IMW0(-44)
	mr	r1

	li	IMW1(255)
	li	IMW0(255)	// 10

	st	r1

	li	IMW0(1)
	add	r2

	li	IMW1(200)
	li	IMW0(200)
	sgn
	cmp	r2

	cond	SLT
	li	IMW1(PCREL(l18)-1)
	li	IMW0(PCREL(l18)) // 20
		add	r7

	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r7  //25
#endif

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
#if 0

		// GCC ZPU equivalent: 120 bytes
_wait_initV2:	// r0 is 1 on success, 0 on failure.
	stdec	r6
	mt	r5
	stdec	r6
	mt	r2
	stdec	r6

	li	IMW1(0xffffffd4)
	li	IMW0(0xffffffd4)
	mr	r1

	li	IMW0(PCREL(_spi_spin))
	add	r7

	li	IMW3(20000)
	li	IMW1(20000)
	li	IMW0(20000)
	mr	r2	// 11
.initv2loop:
	li	1
	sub	r2
	cond	EQ
	  li	0
	  mr	r0
	  li	IMW1(PCREL(.initv2done-1))
	  li	IMW0(PCREL(.initv2done))
	  mr	r7	// Escape loop

	li	0
	stdec	r6
	li	IMW2(cmd_CMD55)
	li	IMW1(cmd_CMD55)
	li	IMW0(cmd_CMD55)
	stdec	r6
	li	IMW1(PCREL(_spi_writecmd-1))
	li	IMW0(PCREL(_spi_writecmd))
	add	r7
	li	8
	add	r6
	li	1
	cmp	r0
	cond	NEQ	// If we didn't get a 1, loop
	  li	IMW0(PCREL(.initv2loop))
	  mr	r7	// 20  ->  31

	// CMD55 succeeded - try CMD41

	li	-1
	st	r5

	li	IMW2(cmd_CMD41)
	li	IMW1(cmd_CMD41)
	li	IMW0(cmd_CMD41)
	mr	r0

	li	IMW0(lba_CMD41>>28)
	mr	r1
	li	28
	shl	r1

	li	IMW1(PCREL(SPI_Send-1))
	li	IMW0(PCREL(SPI_Send))
	add	r7

	li	0
	cmp	r0
	li	-1
	cond	EQ	// 17 -> 48

	  st	r5
	  sub	r0
	  li	IMW0(PCREL(.initv2done))
	  mr	r7	// 52

	li	IMW1(PCREL(SPI_Spin-1))
	li	IMW0(PCREL(SPI_Spin))
	add	r7

	li	IMW0(PCREL(.initv2loop))
	mr	r7	// 57 bytes


.initv2done:
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r7	// 63 bytes

#endif

#if 1

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

	//../../Lib//spi.c, line 118
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib//spi.c, line 119
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

	//../../Lib//spi.c, line 121
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib//spi.c, line 121
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib//spi.c, line 121
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//spi.c, line 121
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 121
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//spi.c, line 121
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l25)-1)
	li	IMW0(PCREL(l25))
		add	r7

	//../../Lib//spi.c, line 123
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

	//../../Lib//spi.c, line 124
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib//spi.c, line 124
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

	//../../Lib//spi.c, line 124
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//spi.c, line 124
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 124
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib//spi.c, line 124
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l27)-1)
	li	IMW0(PCREL(l27))
		add	r7

	//../../Lib//spi.c, line 126
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

	//../../Lib//spi.c, line 127
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib//spi.c, line 128
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l20)-1)
	li	IMW0(PCREL(l20))
	add	r7
l27: # 

	//../../Lib//spi.c, line 129
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7

l25: # 

	//../../Lib//spi.c, line 119
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r4
					// (save result) isreg

	//../../Lib//spi.c, line 119
// code 0x44
					// (test)
					// (objtotemp)  reg r4
	mt	r4
	and	r4

	//../../Lib//spi.c, line 119
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l29)-1)
	li	IMW0(PCREL(l29))
		add	r7

	//../../Lib//spi.c, line 136
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

#endif

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

	//../../Lib//spi.c, line 144
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

	//../../Lib//spi.c, line 145
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l32
	stdec	r6

	//../../Lib//spi.c, line 145
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//spi.c, line 146
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

	//../../Lib//spi.c, line 148
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib//spi.c, line 148
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r4
	mt	r4
	stdec	r6

	//../../Lib//spi.c, line 148
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//spi.c, line 148
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 148
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib//spi.c, line 148
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l37)-1)
	li	IMW0(PCREL(l37))
		add	r7

	//../../Lib//spi.c, line 151
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

	//../../Lib//spi.c, line 152
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib//spi.c, line 153
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l31)-1)
	li	IMW0(PCREL(l31))
	add	r7
l37: # 

	//../../Lib//spi.c, line 158
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib//spi.c, line 146
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//../../Lib//spi.c, line 146
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//../../Lib//spi.c, line 146
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l39)-1)
	li	IMW0(PCREL(l39))
		add	r7

	//../../Lib//spi.c, line 160
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
				// allocreg r3

	//../../Lib//spi.c, line 168
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib//spi.c, line 170
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1aa in 2 chunks
	li	IMW1(426)
	li	IMW0(426)
	stdec	r6

	//../../Lib//spi.c, line 170
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

	//../../Lib//spi.c, line 170
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//spi.c, line 170
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 171
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//../../Lib//spi.c, line 171
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l42
	stdec	r6

	//../../Lib//spi.c, line 171
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 172
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//spi.c, line 172
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l44)-1)
	li	IMW0(PCREL(l44))
		add	r7

	//../../Lib//spi.c, line 175
// code 0x2a
					//call
	ldinc	r7
	.int	_wait_init
	exg	r7


	//../../Lib//spi.c, line 177
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib//spi.c, line 178
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l44: # 

	//../../Lib//spi.c, line 180
// code 0x2a
					//call
	ldinc	r7
	.int	_SPI_PUMP
	exg	r7

				// allocreg r2

	//../../Lib//spi.c, line 180
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 181
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: ffff in 3 chunks
	li	IMW2(65535)
	li	IMW1(65535)
	li	IMW0(65535)
	and	r2
					// (save result) isreg

	//../../Lib//spi.c, line 181
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1aa in 2 chunks
	li	IMW1(426)
	li	IMW0(426)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//spi.c, line 181
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l46)-1)
	li	IMW0(PCREL(l46))
		add	r7

	//../../Lib//spi.c, line 184
// code 0x2a
					//call
	ldinc	r7
	.int	_wait_init
	exg	r7


	//../../Lib//spi.c, line 186
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib//spi.c, line 187
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l46: # 

	//../../Lib//spi.c, line 189
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

	//../../Lib//spi.c, line 196
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 31 in 2 chunks
	li	IMW1(49)
	li	IMW0(49)
					// (save temp) store
	st	r1
				//save_temp done
l64: # 

	//../../Lib//spi.c, line 198
// code 0x2a
					//call
	ldinc	r7
	.int	_wait_initV2
	exg	r7

				// allocreg r2

	//../../Lib//spi.c, line 198
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 198
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib//spi.c, line 198
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l59)-1)
	li	IMW0(PCREL(l59))
		add	r7

	//../../Lib//spi.c, line 200
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib//spi.c, line 200
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

	//../../Lib//spi.c, line 200
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 200
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r3

	//../../Lib//spi.c, line 200
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//../../Lib//spi.c, line 200
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l53)-1)
	li	IMW0(PCREL(l53))
		add	r7

	//../../Lib//spi.c, line 202
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib//spi.c, line 202
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l54
	stdec	r6

	//../../Lib//spi.c, line 202
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 203
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

	//../../Lib//spi.c, line 204
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r3
					// (objtotemp)  reg r5
	mt	r5
	and	r3
					// (save result) isreg

	//../../Lib//spi.c, line 205
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib//spi.c, line 205
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l55
	stdec	r6

	//../../Lib//spi.c, line 205
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 206
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

	//../../Lib//spi.c, line 207
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

	//../../Lib//spi.c, line 208
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

	//../../Lib//spi.c, line 209
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
				// allocreg r2

	//../../Lib//spi.c, line 210
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

	//../../Lib//spi.c, line 210
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib//spi.c, line 210
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l57)-1)
	li	IMW0(PCREL(l57))
		add	r7

	//../../Lib//spi.c, line 213
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib//spi.c, line 214
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l57: # 

	//../../Lib//spi.c, line 218
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib//spi.c, line 219
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l53: # 

	//../../Lib//spi.c, line 222
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib//spi.c, line 222
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l60
	stdec	r6

	//../../Lib//spi.c, line 222
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

l59: # 

	//../../Lib//spi.c, line 224
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r1

	//../../Lib//spi.c, line 224
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l62)-1)
	li	IMW0(PCREL(l62))
		add	r7

	//../../Lib//spi.c, line 226
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l63
	stdec	r6

	//../../Lib//spi.c, line 226
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//spi.c, line 227
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib//spi.c, line 228
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l41)-1)
	li	IMW0(PCREL(l41))
	add	r7
l62: # 

	//../../Lib//spi.c, line 196
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi.c, line 196
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6

	//../../Lib//spi.c, line 196
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l64)-1)
	li	IMW0(PCREL(l64))
		add	r7

	//../../Lib//spi.c, line 230
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

	//../../Lib//spi.c, line 238
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

	//../../Lib//spi.c, line 241
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l67
	stdec	r6

	//../../Lib//spi.c, line 241
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//spi.c, line 243
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

	//../../Lib//spi.c, line 245
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

	//../../Lib//spi.c, line 245
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 245
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l94)-1)
	li	IMW0(PCREL(l94))
		add	r7
l90: # 

	//../../Lib//spi.c, line 245
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

	//../../Lib//spi.c, line 245
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 245
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l90)-1)
	li	IMW0(PCREL(l90))
		add	r7
l94: # 

	//../../Lib//spi.c, line 245
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

	//../../Lib//spi.c, line 246
// code 0x2a
					//call
	ldinc	r7
	.int	_spi_spin
	exg	r7


	//../../Lib//spi.c, line 248
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

	//../../Lib//spi.c, line 248
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 248
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l95)-1)
	li	IMW0(PCREL(l95))
		add	r7
l91: # 

	//../../Lib//spi.c, line 248
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

	//../../Lib//spi.c, line 248
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 248
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l91)-1)
	li	IMW0(PCREL(l91))
		add	r7
l95: # 

	//../../Lib//spi.c, line 248
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

	//../../Lib//spi.c, line 249
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib//spi.c, line 249
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

	//../../Lib//spi.c, line 249
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//spi.c, line 249
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 249
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//spi.c, line 249
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l78)-1)
	li	IMW0(PCREL(l78))
		add	r7

	//../../Lib//spi.c, line 250
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

	//../../Lib//spi.c, line 252
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	sgn
	cmp	r5

	//../../Lib//spi.c, line 252
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l80)-1)
	li	IMW0(PCREL(l80))
		add	r7

	//../../Lib//spi.c, line 254
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l81
	stdec	r6

	//../../Lib//spi.c, line 254
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//spi.c, line 256
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0

	//../../Lib//spi.c, line 257
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l66)-1)
	li	IMW0(PCREL(l66))
	add	r7
l80: # 

	//../../Lib//spi.c, line 243
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r5
					// (save result) isreg

	//../../Lib//spi.c, line 243
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//../../Lib//spi.c, line 243
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l89)-1)
	li	IMW0(PCREL(l89))
		add	r7

	//../../Lib//spi.c, line 260
// code 0x2a
					//call
	ldinc	r7
	.int	_is_sdhc
	exg	r7


	//../../Lib//spi.c, line 260
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_sd_is_sdhc + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi.c, line 261
// code 0x44
					// (test)
					// (objtotemp)  extern
	ldinc	r7
	.int	_sd_is_sdhc
		//sizemod based on type 0x3
	ldt

	//../../Lib//spi.c, line 261
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l84)-1)
	li	IMW0(PCREL(l84))
		add	r7

	//../../Lib//spi.c, line 266
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//../../Lib//spi.c, line 266
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

	//../../Lib//spi.c, line 266
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

l84: # 

	//../../Lib//spi.c, line 268
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

	//../../Lib//spi.c, line 270
// code 0x2a
					//call
	ldinc	r7
	.int	_sd_get_size
	exg	r7


	//../../Lib//spi.c, line 270
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_sd_size + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi.c, line 271
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_sd_size
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//../../Lib//spi.c, line 271
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l85
	stdec	r6

	//../../Lib//spi.c, line 271
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 274
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

	//../../Lib//spi.c, line 274
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 274
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l96)-1)
	li	IMW0(PCREL(l96))
		add	r7
l92: # 

	//../../Lib//spi.c, line 274
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

	//../../Lib//spi.c, line 274
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 274
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l92)-1)
	li	IMW0(PCREL(l92))
		add	r7
l96: # 

	//../../Lib//spi.c, line 274
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

	//../../Lib//spi.c, line 275
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

	//../../Lib//spi.c, line 278
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
				// allocreg r3

	//../../Lib//spi.c, line 286
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

	//../../Lib//spi.c, line 287
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

	//../../Lib//spi.c, line 287
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 287
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l119)-1)
	li	IMW0(PCREL(l119))
		add	r7
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
l98: # 

	//../../Lib//spi.c, line 287
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

	//../../Lib//spi.c, line 287
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 287
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l98)-1)
	li	IMW0(PCREL(l98))
		add	r7
l119: # 
				// freereg r2

	//../../Lib//spi.c, line 287
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

	//../../Lib//spi.c, line 288
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

	//../../Lib//spi.c, line 290
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	stdec	r6

	//../../Lib//spi.c, line 290
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

	//../../Lib//spi.c, line 290
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//../../Lib//spi.c, line 290
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 291
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib//spi.c, line 291
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l102)-1)
	li	IMW0(PCREL(l102))
		add	r7

	//../../Lib//spi.c, line 293
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l103
	stdec	r6

	//../../Lib//spi.c, line 293
// code 0x2a
					//call
	ldinc	r7
	.int	_puts
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//../../Lib//spi.c, line 295
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	mr	r0

	//../../Lib//spi.c, line 296
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l97)-1)
	li	IMW0(PCREL(l97))
	add	r7
l102: # 

	//../../Lib//spi.c, line 298
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

	//../../Lib//spi.c, line 299
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

	//../../Lib//spi.c, line 302
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
				// freereg r3
l116: # 
				// allocreg r2

	//../../Lib//spi.c, line 304
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

	//../../Lib//spi.c, line 305
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

	//../../Lib//spi.c, line 305
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

	//../../Lib//spi.c, line 306
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

	//../../Lib//spi.c, line 306
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

	//../../Lib//spi.c, line 307
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

	//../../Lib//spi.c, line 307
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

	//../../Lib//spi.c, line 308
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

	//../../Lib//spi.c, line 309
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

	//../../Lib//spi.c, line 303
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

	//../../Lib//spi.c, line 303
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

	//../../Lib//spi.c, line 303
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l116)-1)
	li	IMW0(PCREL(l116))
		add	r7
				// allocreg r3

	//../../Lib//spi.c, line 312
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

	//../../Lib//spi.c, line 313
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

	//../../Lib//spi.c, line 314
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

	//../../Lib//spi.c, line 316
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 186a0 in 3 chunks
	li	IMW2(100000)
	li	IMW1(100000)
	li	IMW0(100000)
					// (save temp) isreg
	mr	r3
				//save_temp done
l117: # 

	//../../Lib//spi.c, line 319
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
				// allocreg r2

	//../../Lib//spi.c, line 320
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r2
					// (objtotemp)  reg r5
	mt	r5
	and	r2
					// (save result) isreg

	//../../Lib//spi.c, line 322
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//../../Lib//spi.c, line 322
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l121)-1)
	li	IMW0(PCREL(l121))
		add	r7

	//../../Lib//spi.c, line 322
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//../../Lib//spi.c, line 322
// code 0x44
					// (test)
					// (objtotemp)  reg r3
	mt	r3
	and	r3

	//../../Lib//spi.c, line 322
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l117)-1)
	li	IMW0(PCREL(l117))
		add	r7
l121: # 

	//../../Lib//spi.c, line 323
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

	//../../Lib//spi.c, line 324
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

	//../../Lib//spi.c, line 324
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 324
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l122)-1)
	li	IMW0(PCREL(l122))
		add	r7
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
l112: # 

	//../../Lib//spi.c, line 324
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

	//../../Lib//spi.c, line 324
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 324
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l112)-1)
	li	IMW0(PCREL(l112))
		add	r7
l122: # 
				// freereg r2

	//../../Lib//spi.c, line 324
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

	//../../Lib//spi.c, line 325
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
l97: # 
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

	//../../Lib//spi.c, line 335
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

	//../../Lib//spi.c, line 337
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 16e35f in 4 chunks
	li	IMW3(1499999)
	li	IMW2(1499999)
	li	IMW1(1499999)
	li	IMW0(1499999)
					// (save temp) isreg
	mr	r5
				//save_temp done
l138: # 

	//../../Lib//spi.c, line 340
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
				// allocreg r2

	//../../Lib//spi.c, line 342
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const/deref
					// (prepobj tmp) deref
			// const
				// constant: ffffffd4 in 2 chunks
	li	IMW1(-44)
	li	IMW0(-44)
		//sizemod based on type 0x503
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: ff in 2 chunks
	li	IMW1(255)
	li	IMW0(255)
	and	r2
					// (save result) isreg

	//../../Lib//spi.c, line 343
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: fe in 2 chunks
	li	IMW1(254)
	li	IMW0(254)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//spi.c, line 343
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l129)-1)
	li	IMW0(PCREL(l129))
		add	r7

	//../../Lib//spi.c, line 349
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

	//../../Lib//spi.c, line 351
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sgn
	cmp	r3

	//../../Lib//spi.c, line 351
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l142)-1)
	li	IMW0(PCREL(l142))
		add	r7
l139: # 

	//../../Lib//spi.c, line 354
// code 0x2a
					//call
	ldinc	r7
	.int	_SPI_PUMP_LE
	exg	r7

				// allocreg r2

	//../../Lib//spi.c, line 354
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//../../Lib//spi.c, line 355
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

	//../../Lib//spi.c, line 357
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r4
					// (save result) isreg

	//../../Lib//spi.c, line 358
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

	//../../Lib//spi.c, line 351
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sub	r3
					// (save result) isreg

	//../../Lib//spi.c, line 351
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	sgn
	cmp	r3

	//../../Lib//spi.c, line 351
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l139)-1)
	li	IMW0(PCREL(l139))
		add	r7
l142: # 

	//../../Lib//spi.c, line 361
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r3

	//../../Lib//spi.c, line 361
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l143)-1)
	li	IMW0(PCREL(l143))
		add	r7
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
l134: # 

	//../../Lib//spi.c, line 364
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

	//../../Lib//spi.c, line 364
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

	//../../Lib//spi.c, line 365
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

	//../../Lib//spi.c, line 365
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) isreg

	//../../Lib//spi.c, line 367
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

	//../../Lib//spi.c, line 361
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//../../Lib//spi.c, line 361
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r3

	//../../Lib//spi.c, line 361
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l134)-1)
	li	IMW0(PCREL(l134))
		add	r7
l143: # 

	//../../Lib//spi.c, line 370
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

	//../../Lib//spi.c, line 371
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

	//../../Lib//spi.c, line 337
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r5
					// (save result) isreg

	//../../Lib//spi.c, line 337
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//../../Lib//spi.c, line 337
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l138)-1)
	li	IMW0(PCREL(l138))
		add	r7

	//../../Lib//spi.c, line 374
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

	//../../Lib//spi.c, line 375
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
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

	//../../Lib//spi.c, line 380
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

	//../../Lib//spi.c, line 384
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

	//../../Lib//spi.c, line 385
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

	//../../Lib//spi.c, line 385
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 385
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l156)-1)
	li	IMW0(PCREL(l156))
		add	r7
l154: # 

	//../../Lib//spi.c, line 385
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

	//../../Lib//spi.c, line 385
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 385
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l154)-1)
	li	IMW0(PCREL(l154))
		add	r7
l156: # 

	//../../Lib//spi.c, line 385
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

	//../../Lib//spi.c, line 386
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

	//../../Lib//spi.c, line 388
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	stdec	r6

	//../../Lib//spi.c, line 388
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

	//../../Lib//spi.c, line 388
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 388
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r5

	//../../Lib//spi.c, line 389
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//../../Lib//spi.c, line 389
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l149)-1)
	li	IMW0(PCREL(l149))
		add	r7

	//../../Lib//spi.c, line 391
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib//spi.c, line 391
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x104
				// constant: 1c in 1 chunks
	li	IMW0(28)
	ldidx	r6
	stdec	r6

	//../../Lib//spi.c, line 391
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l150
	stdec	r6

	//../../Lib//spi.c, line 391
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//../../Lib//spi.c, line 393
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l144)-1)
	li	IMW0(PCREL(l144))
	add	r7
l149: # 

	//../../Lib//spi.c, line 394
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	stdec	r6

	//../../Lib//spi.c, line 394
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

	//../../Lib//spi.c, line 394
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l123)-1)
	li	IMW0(PCREL(l123))
	add	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 394
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r4

	//../../Lib//spi.c, line 396
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

	//../../Lib//spi.c, line 396
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 396
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l157)-1)
	li	IMW0(PCREL(l157))
		add	r7
l155: # 

	//../../Lib//spi.c, line 396
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

	//../../Lib//spi.c, line 396
// code 0x44
					// (test)
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi.c, line 396
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l155)-1)
	li	IMW0(PCREL(l155))
		add	r7
l157: # 

	//../../Lib//spi.c, line 396
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

	//../../Lib//spi.c, line 397
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

	//../../Lib//spi.c, line 405
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//../../Lib//spi.c, line 405
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

	//../../Lib//spi.c, line 405
// code 0x2a
					//call
	ldinc	r7
	.int	_cmd_write
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 407
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	stdec	r6

	//../../Lib//spi.c, line 407
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_sizebuf
		//sizemod based on type 0xa
	stdec	r6

	//../../Lib//spi.c, line 407
// code 0x2a
					//call
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l123)-1)
	li	IMW0(PCREL(l123))
	add	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 408
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

	//../../Lib//spi.c, line 409
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg

	//../../Lib//spi.c, line 409
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	sgn
	cmp	r5

	//../../Lib//spi.c, line 409
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l173)-1)
	li	IMW0(PCREL(l173))
		add	r7
				// freereg r2
				// allocreg r2

	//../../Lib//spi.c, line 414
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

	//../../Lib//spi.c, line 414
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: c0 in 2 chunks
	li	IMW1(192)
	li	IMW0(192)
	and	r2
					// (save result) isreg

	//../../Lib//spi.c, line 414
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 40 in 2 chunks
	li	IMW1(64)
	li	IMW0(64)
	sgn
	cmp	r2
				// freereg r2

	//../../Lib//spi.c, line 414
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l164)-1)
	li	IMW0(PCREL(l164))
		add	r7
				// allocreg r2

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 416
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	shl	r2
					// (save result) isreg
				// allocreg r3

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 416
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	shl	r3
					// (save result) isreg

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 416
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

	//../../Lib//spi.c, line 417
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	shl	r5
					// (save result) isreg

	//../../Lib//spi.c, line 420
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l165)-1)
	li	IMW0(PCREL(l165))
	add	r7
l164: # 
				// allocreg r2

	//../../Lib//spi.c, line 421
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

	//../../Lib//spi.c, line 421
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r2
					// (save result) isreg

	//../../Lib//spi.c, line 421
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 6 in 1 chunks
	li	IMW0(6)
	and	r2
					// (save result) isreg
				// allocreg r3

	//../../Lib//spi.c, line 421
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

	//../../Lib//spi.c, line 421
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	sgn
	shr	r3
					// (save result) isreg

	//../../Lib//spi.c, line 421
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

	//../../Lib//spi.c, line 422
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

	//../../Lib//spi.c, line 422
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

	//../../Lib//spi.c, line 423
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

	//../../Lib//spi.c, line 423
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
	and	r3
					// (save result) isreg

	//../../Lib//spi.c, line 423
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	shl	r3
					// (save result) isreg
				// allocreg r4

	//../../Lib//spi.c, line 423
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

	//../../Lib//spi.c, line 423
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	shl	r4
					// (save result) isreg

	//../../Lib//spi.c, line 423
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

	//../../Lib//spi.c, line 423
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

	//../../Lib//spi.c, line 423
// code 0x12
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: c0 in 2 chunks
	li	IMW1(192)
	li	IMW0(192)
	and	r4
					// (save result) isreg

	//../../Lib//spi.c, line 423
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 6 in 1 chunks
	li	IMW0(6)
	sgn
	shr	r4
					// (save result) isreg

	//../../Lib//spi.c, line 423
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

	//../../Lib//spi.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6

	//../../Lib//spi.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//../../Lib//spi.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//../../Lib//spi.c, line 424
// code 0x4e
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l166
	stdec	r6

	//../../Lib//spi.c, line 424
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6


	//../../Lib//spi.c, line 425
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	add	r2
					// (save result) isreg

	//../../Lib//spi.c, line 425
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

	//../../Lib//spi.c, line 426
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//../../Lib//spi.c, line 426
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l167
	stdec	r6

	//../../Lib//spi.c, line 426
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//../../Lib//spi.c, line 427
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

	//../../Lib//spi.c, line 428
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r3
					// (save result) isreg

	//../../Lib//spi.c, line 428
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

	//../../Lib//spi.c, line 429
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	stdec	r6

	//../../Lib//spi.c, line 429
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib//spi.c, line 429
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l168
	stdec	r6

	//../../Lib//spi.c, line 429
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//../../Lib//spi.c, line 430
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

	//../../Lib//spi.c, line 430
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

	//../../Lib//spi.c, line 432
// code 0x19
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	shl	r5
					// (save result) isreg

	//../../Lib//spi.c, line 433
// code 0x1a
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sgn
	shr	r2
					// (save result) isreg

	//../../Lib//spi.c, line 430
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 200 in 2 chunks
	li	IMW1(512)
	li	IMW0(512)
	sgn
	cmp	r2

	//../../Lib//spi.c, line 430
	cond	SGT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l169)-1)
	li	IMW0(PCREL(l169))
		add	r7
l176: # 

	//../../Lib//spi.c, line 435
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r5
	mt	r5
	stdec	r6

	//../../Lib//spi.c, line 435
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l172
	stdec	r6

	//../../Lib//spi.c, line 435
// code 0x2a
					//call
	ldinc	r7
	.int	_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

l165: # 

	//../../Lib//spi.c, line 437
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
	.globl	_sd_size
	.global	_sd_size
	.lcomm	_sd_size,4
	.globl	_printf
	.globl	_SPI_R1
	.global	_SPI_R1
	.lcomm	_SPI_R1,6
	.globl	_puts
	.globl	_sizebuf
	.global	_sizebuf
	.lcomm	_sizebuf,18
