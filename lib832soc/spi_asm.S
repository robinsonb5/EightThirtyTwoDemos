
	.equ cmd_reset,0x950040 // Use SPI mode
	.equ cmd_init,0xff0041
	.equ cmd_read,0xff0051
	.equ cmd_CMD8,0x870048
	.equ lba_CMD8,0x1AA
	.equ cmd_CMD16,0xFF0050
	.equ cmd_CMD41,0x870069
	.equ lba_CMD41,0x40000000
	.equ cmd_CMD55,0xff0077
	.equ cmd_CMD58,0xff007A


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

	.liconst 0xffffffd4
	mr	r5

	.liconst 255
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

	.liconst	0xffffffd4
	mr	r5

	.liconst	255
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
	mr	r7	// 34 bytes  -  reduced from 94 bytes  (70 bytes removing unneccesary boilerplate from C code)



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

	.liconst	0xffffffd4
	mr	r5

	li	12
	ldidx	r6
	mr	r1

	li	8	// 10
	ldidx	r6
	mr	r0

	st	r5	// SPI(cmd&255); // Assume only low 8 bits are active.

	// FIXME - better to do this only for read / write commands
	.lipcrel	_sd_is_sdhc
	ldidx r7

	cond	EQ
		li	9
		shl	r1	// Multiply LBA by 512 if we have a standard SD card.
		cond	EX	// 21 bytes
	

	li	24
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
	.liconst	40000
	mr	r1
	.liconst	255
	mr	r0
.loop:
	ld	r5
	exg	r0
	cmp	r0
	cond	NEQ
		.lipcrel	.done
		add	r7	// 54 bytes

	exg	r0
	st	r5

	li	1
	sub	r1
	cond	NEQ
		.lipcrel	.loop
		add	r7

.done:
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r7	// 64 bytes  -  GCC compiled ZPU equivalent 128 bytes



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
	.liconst	0xffffffd4
	mr	r1
	.liconst	200
	mr	r0
.spinloop:
	li	-1
	st	r1
	add	r0
	cond	NEQ
		.lipcrel	.spinloop
		add	r7

	ldinc	r6
	mr	r7	// 15 bytes


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

// Assembly version not yet working?

		// GCC ZPU equivalent: 120 bytes
_asm_wait_initV2:	// r0 is 1 on success, 0 on failure.
	stdec	r6
	mt	r5
	stdec	r6
	mt	r2
	stdec	r6

	.liconst	0xffffffd4
	mr	r1

	.lipcrel	_spi_spin
	add	r7

	.liconst	20000
	mr	r2	// 11
.initv2loop:
	li	1
	sub	r2
	cond	EQ
	  li	0
	  mr	r0
	  .lipcrel	.initv2done
	  mr	r7	// Escape loop

	li	0
	stdec	r6
	.liconst	cmd_CMD55
	stdec	r6
	.lipcrel	_cmd_write
	add	r7
	li	8
	add	r6
	li	1
	cmp	r0
	cond	NEQ	// If we didn't get a 1, loop
	  .lipcrel	.initv2loop
	  mr	r7	// 20  ->  31

	// CMD55 succeeded - try CMD41

	li	-1
	st	r5

	.liconst cmd_CMD41
	mr	r0

	.liconst lba_CMD41>>28
	mr	r1
	li	28
	shl	r1

	.lipcrel _cmd_write
	add	r7

	li	0
	cmp	r0
	li	-1
	cond	EQ	// 17 -> 48

	  st	r5
	  sub	r0
	  .lipcrel .initv2done
	  add	r7	// 52

	.lipcrel _spi_spin
	add	r7

	.lipcrel .initv2loop
	add	r7	// 57 bytes


.initv2done:
	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r7	// 63 bytes


// C version

_wait_initV2:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	16711799
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
				// allocreg r3
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	1073741824
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//spi_c.c, line 118
					//call
			//pcreltotemp
	.lipcrel	_spi_spin
	add	r7


	//../../Lib//spi_c.c, line 119
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	19999
					// (save temp) isreg
	mr	r4
				//save_temp done
l34: # 

	//../../Lib//spi_c.c, line 121
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	0
	stdec	r6

	//../../Lib//spi_c.c, line 121
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 240 
// reg r5 - don't bother matching
	mt	r5
	stdec	r6

	//../../Lib//spi_c.c, line 121
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//../../Lib//spi_c.c, line 121
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	1
	cmp	r0
				// freereg r1

	//../../Lib//spi_c.c, line 121
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l30
		add	r7

	//../../Lib//spi_c.c, line 123
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 124
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 124
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	8847465
	stdec	r6

	//../../Lib//spi_c.c, line 124
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//../../Lib//spi_c.c, line 124
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//../../Lib//spi_c.c, line 124
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l32
		add	r7
	.liconst	-44
	mr	r0
	.liconst	255
	st	r0
	.liconst	1
	mr	r0
	.lipcrel	l24
	add	r7
l32: # 
	.lipcrel	_spi_spin
	add	r7

l30: # 

	.liconst	1
	sub	r4
	mt	r4
	and	r4

	cond	NEQ
	.lipcrel	l34
		add	r7

	.liconst	0
	mr	r0
l24: # 
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7



	//registers used:
		//r1: yes
		//r2: no
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
	stmpdec	r3
	stmpdec	r4
	exg	r6
				// allocreg r4
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	16711745
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3

	//../../Lib//spi_c.c, line 144
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 145
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l38,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 145
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//../../Lib//spi_c.c, line 146
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	19
					// (save temp) isreg
	mr	r3
				//save_temp done
l45: # 

	//../../Lib//spi_c.c, line 148
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	0
	stdec	r6

	//../../Lib//spi_c.c, line 148
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
	stdec	r6

	//../../Lib//spi_c.c, line 148
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//../../Lib//spi_c.c, line 148
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//../../Lib//spi_c.c, line 148
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l43
		add	r7

	//../../Lib//spi_c.c, line 151
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 152
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0

	//../../Lib//spi_c.c, line 153
			//pcreltotemp
	.lipcrel	l36
	add	r7
l43: # 

	//../../Lib//spi_c.c, line 158
					//call
			//pcreltotemp
	.lipcrel	_spi_spin
	add	r7


	//../../Lib//spi_c.c, line 146
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r3
					// (save result) // isreg

	//../../Lib//spi_c.c, line 146
					// (test)
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	and	r3

	//../../Lib//spi_c.c, line 146
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l45
		add	r7

	//../../Lib//spi_c.c, line 160
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0
l36: # 
				// freereg r3
				// freereg r4
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

	.section	.rodata
l38:
	.byte	67
	.byte	77
	.byte	68
	.byte	0
	//registers used:
		//r1: yes
		//r2: no
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
				// allocreg r4
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	-44
					// (save temp) isreg
	mr	r4
				//save_temp done

	//../../Lib//spi_c.c, line 168
					//call
			//pcreltotemp
	.lipcrel	_spi_spin
	add	r7


	//../../Lib//spi_c.c, line 170
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	426
	stdec	r6

	//../../Lib//spi_c.c, line 170
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	8847432
	stdec	r6

	//../../Lib//spi_c.c, line 170
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

				// allocreg r3

	//../../Lib//spi_c.c, line 170
					// (getreturn)					// (save result) // isreg
	mt	r0
	mr	r3

	//../../Lib//spi_c.c, line 171
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 171
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l49,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 171
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 172
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	1
	cmp	r3
				// freereg r3

	//../../Lib//spi_c.c, line 172
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l51
		add	r7
				// allocreg r3

	//../../Lib//spi_c.c, line 175
					//call
			//pcreltotemp
	.lipcrel	_wait_init
	add	r7


	//../../Lib//spi_c.c, line 177
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//../../Lib//spi_c.c, line 178
			//pcreltotemp
	.lipcrel	l47
	add	r7
l51: # 

	//../../Lib//spi_c.c, line 180
					//call
			//pcreltotemp
	.lipcrel	_SPI_PUMP
	add	r7

				// allocreg r1

	//../../Lib//spi_c.c, line 180
					// (getreturn)					// (save result) // isreg
	mt	r0
	mr	r1

	//../../Lib//spi_c.c, line 181
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	65535
	and	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 181
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	426
	cmp	r1
				// freereg r1

	//../../Lib//spi_c.c, line 181
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l53
		add	r7

	//../../Lib//spi_c.c, line 184
					//call
			//pcreltotemp
	.lipcrel	_wait_init
	add	r7


	//../../Lib//spi_c.c, line 186
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//../../Lib//spi_c.c, line 187
			//pcreltotemp
	.lipcrel	l47
	add	r7
l53: # 

	//../../Lib//spi_c.c, line 189
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 196
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	49
					// (save temp) isreg
	mr	r5
				//save_temp done
l71: # 

	//../../Lib//spi_c.c, line 198
					//call
			//pcreltotemp
	.lipcrel	_wait_initV2
	add	r7

				// allocreg r1

	//../../Lib//spi_c.c, line 198
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//../../Lib//spi_c.c, line 198
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l66
		add	r7

	//../../Lib//spi_c.c, line 200
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	0
	stdec	r6

	//../../Lib//spi_c.c, line 200
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	16711802
	stdec	r6

	//../../Lib//spi_c.c, line 200
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 200
					// (getreturn)					// (save result) // isreg
	mt	r0
	mr	r3

	//../../Lib//spi_c.c, line 200
					// (test)
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	and	r3

	//../../Lib//spi_c.c, line 200
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l60
		add	r7

	//../../Lib//spi_c.c, line 202
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 202
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l61,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 202
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 203
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 204
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 260 
// deref 
	ld	r4
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//spi_c.c, line 205
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 205
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l62,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 205
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 206
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 207
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 

// required value found in tmp
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 208
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 

// required value found in tmp
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 209
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 

// required value found in tmp
					// (save temp) store
	st	r4
				//save_temp done
				// allocreg r1

	//../../Lib//spi_c.c, line 210
					// (bitwise/arithmetic) 	//ops: 4, 0, 2
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	mr	r1
					// (objtotemp) flags 1 
// const
	.liconst	64
	and	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 210
					// (test)
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	and	r1
				// freereg r1

	//../../Lib//spi_c.c, line 210
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l64
		add	r7

	//../../Lib//spi_c.c, line 213
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0

	//../../Lib//spi_c.c, line 214
			//pcreltotemp
	.lipcrel	l47
	add	r7
l64: # 

	//../../Lib//spi_c.c, line 218
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//../../Lib//spi_c.c, line 219
			//pcreltotemp
	.lipcrel	l47
	add	r7
l60: # 

	//../../Lib//spi_c.c, line 222
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 222
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l67,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 222
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6

l66: # 

	//../../Lib//spi_c.c, line 224
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	2
	cmp	r5

	//../../Lib//spi_c.c, line 224
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l69
		add	r7

	//../../Lib//spi_c.c, line 226
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l70,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 226
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	4
	add	r6


	//../../Lib//spi_c.c, line 227
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//../../Lib//spi_c.c, line 228
			//pcreltotemp
	.lipcrel	l47
	add	r7
l69: # 

	//../../Lib//spi_c.c, line 196
					// (bitwise/arithmetic) 	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r5
					// (save result) // isreg

	//../../Lib//spi_c.c, line 196
					// (test)
					// (objtotemp) flags 42 
// reg r5 - don't bother matching
	mt	r5
	and	r5

	//../../Lib//spi_c.c, line 196
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l71
		add	r7

	//../../Lib//spi_c.c, line 230
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0
l47: # 
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
	mr	r7

l61:
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
l62:
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
l67:
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
l70:
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
l49:
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
		//r1: yes
		//r2: no
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	.liconst	-4
	add	r6
				// allocreg r5
				// allocreg r4
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	-48
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	32768
					// (save temp) isreg
	mr	r3
				//save_temp done

	//../../Lib//spi_c.c, line 238
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 0)
	.liabs	_sd_is_sdhc
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	1
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 241
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l75,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 241
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//../../Lib//spi_c.c, line 243
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	7
					// (save temp) isreg
	mr	r5
				//save_temp done
l97: # 

	//../../Lib//spi_c.c, line 245
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 245
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 245
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l102
		add	r7
l98: # 

	//../../Lib//spi_c.c, line 245
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 245
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 245
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l98
		add	r7
l102: # 

	//../../Lib//spi_c.c, line 245
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 246
					//call
			//pcreltotemp
	.lipcrel	_spi_spin
	add	r7


	//../../Lib//spi_c.c, line 248
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 248
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 248
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l103
		add	r7
l99: # 

	//../../Lib//spi_c.c, line 248
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 248
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 248
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l99
		add	r7
l103: # 

	//../../Lib//spi_c.c, line 248
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	1
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 249
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	0
	stdec	r6

	//../../Lib//spi_c.c, line 249
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	9764928
	stdec	r6

	//../../Lib//spi_c.c, line 249
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//../../Lib//spi_c.c, line 249
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	1
	cmp	r0
				// freereg r1

	//../../Lib//spi_c.c, line 249
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l86
		add	r7

	//../../Lib//spi_c.c, line 250
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	1
					// (save temp) isreg
	mr	r5
				//save_temp done
l86: # 

	//../../Lib//spi_c.c, line 252
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	2
	cmp	r5

	//../../Lib//spi_c.c, line 252
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l88
		add	r7

	//../../Lib//spi_c.c, line 254
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l89,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 254
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//../../Lib//spi_c.c, line 256
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	0
	mr	r0

	//../../Lib//spi_c.c, line 257
			//pcreltotemp
	.lipcrel	l73
	add	r7
l88: # 

	//../../Lib//spi_c.c, line 243
					// (bitwise/arithmetic) 	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r5
					// (save result) // isreg

	//../../Lib//spi_c.c, line 243
					// (test)
					// (objtotemp) flags 42 
// reg r5 - don't bother matching
	mt	r5
	and	r5

	//../../Lib//spi_c.c, line 243
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l97
		add	r7

	//../../Lib//spi_c.c, line 260
					//call
			//pcreltotemp
	.lipcrel	_is_sdhc
	add	r7


	//../../Lib//spi_c.c, line 260
					// (getreturn)					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_sd_is_sdhc, 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 261
					// (test)
					// (objtotemp) flags 2 
// extern
	.liabs	_sd_is_sdhc
		//sizemod based on type 0x3
	//extern deref
	ldt

	//../../Lib//spi_c.c, line 261
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l92
		add	r7

	//../../Lib//spi_c.c, line 266
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	1
	stdec	r6

	//../../Lib//spi_c.c, line 266
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	16711760
	stdec	r6

	//../../Lib//spi_c.c, line 266
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

l92: # 

	//../../Lib//spi_c.c, line 268
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 270
					//call
			//pcreltotemp
	.lipcrel	_sd_get_size
	add	r7


	//../../Lib//spi_c.c, line 270
					// (getreturn)					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_sd_size, 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 271
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// extern
	.liabs	_sd_size
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//../../Lib//spi_c.c, line 271
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l93,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 271
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 274
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 274
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 274
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l104
		add	r7
l100: # 

	//../../Lib//spi_c.c, line 274
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 274
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 274
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l100
		add	r7
l104: # 

	//../../Lib//spi_c.c, line 274
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 275
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 278
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0
l73: # 
				// freereg r3
				// freereg r4
				// freereg r5
	.liconst	-4
	sub	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

l89:
	.byte	73
	.byte	69
	.byte	82
	.byte	82
	.byte	0
l75:
	.byte	83
	.byte	80
	.byte	73
	.byte	0
l93:
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	.liconst	-4
	add	r6
				// allocreg r5
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	32768
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	-44
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r1

	//../../Lib//spi_c.c, line 286
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 287
					// (bitwise/arithmetic) 	//ops: 0, 6, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 240 
// reg r5 - don't bother matching
	mt	r5
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 287
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 287
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l128
		add	r7
l124: # 

	//../../Lib//spi_c.c, line 287
					// (bitwise/arithmetic) 	//ops: 0, 6, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 240 
// reg r5 - don't bother matching
	mt	r5
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 287
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 287
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l124
		add	r7
l128: # 
				// freereg r1

	//../../Lib//spi_c.c, line 287
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-48
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	257
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 288
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 290
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x104
	.liconst	20
	ldidx	r6
	stdec	r6

	//../../Lib//spi_c.c, line 290
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	16711768
	stdec	r6

	//../../Lib//spi_c.c, line 290
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6

				// allocreg r1

	//../../Lib//spi_c.c, line 291
					// (test)
					// (objtotemp) flags 4a 
// reg r0 - don't bother matching
	mt	r0
	and	r0
				// freereg r1

	//../../Lib//spi_c.c, line 291
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l111
		add	r7
				// allocreg r1

	//../../Lib//spi_c.c, line 293
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l112,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 293
					//call
			//pcreltotemp
	.lipcrel	_puts
	add	r7
	.liconst	4
	add	r6


	//../../Lib//spi_c.c, line 295
					//setreturn
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0

	//../../Lib//spi_c.c, line 296
			//pcreltotemp
	.lipcrel	l105
	add	r7
l111: # 

	//../../Lib//spi_c.c, line 298
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 299
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	254
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 302
					// (a/p assign)
					// (prepobj r0)
 // var, auto|reg
	mt	r6
	mr	r0

					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r0
				//save_temp done
				// freereg r1
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 102 
// var, auto|reg
		//sizemod based on type 0xa
	.liconst	24
	ldidx	r6
					// (save temp) isreg
	mr	r5
				//save_temp done
l113: # 
				// allocreg r1

	//../../Lib//spi_c.c, line 304
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 62 
// deref 
	ldinc	r5
					// (save temp) isreg
	mr	r1
				//save_temp done
				// allocreg r2

	//../../Lib//spi_c.c, line 305
					// (bitwise/arithmetic) 	//ops: 2, 0, 3
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r2
					// (objtotemp) flags 1 
// const
	.liconst	24
	sgn
	shr	r2
					// (save result) // isreg

	//../../Lib//spi_c.c, line 305
					// (bitwise/arithmetic) 	//ops: 3, 5, 1
					// (objtotemp) flags 4a 
// reg r2 - don't bother matching
	mt	r2
	mr	r0
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
	and	r0
					// (save result) // Store_reg to type 0x3
	mt	r0
	st	r3
				// freereg r2
				// allocreg r2

	//../../Lib//spi_c.c, line 306
					// (bitwise/arithmetic) 	//ops: 2, 0, 3
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r2
					// (objtotemp) flags 1 
// const
	.liconst	16
	sgn
	shr	r2
					// (save result) // isreg

	//../../Lib//spi_c.c, line 306
					// (bitwise/arithmetic) 	//ops: 3, 5, 1
					// (objtotemp) flags 4a 
// reg r2 - don't bother matching
	mt	r2
	mr	r0
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
	and	r0
					// (save result) // Store_reg to type 0x3
	mt	r0
	st	r3
				// freereg r2
				// allocreg r2

	//../../Lib//spi_c.c, line 307
					// (bitwise/arithmetic) 	//ops: 2, 0, 3
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r2
					// (objtotemp) flags 1 
// const
	.liconst	8
	sgn
	shr	r2
					// (save result) // isreg

	//../../Lib//spi_c.c, line 307
					// (bitwise/arithmetic) 	//ops: 3, 5, 1
					// (objtotemp) flags 4a 
// reg r2 - don't bother matching
	mt	r2
	mr	r0
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
	and	r0
					// (save result) // Store_reg to type 0x3
	mt	r0
	st	r3
				// freereg r2

	//../../Lib//spi_c.c, line 308
					// (bitwise/arithmetic) 	//ops: 2, 5, 1
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r0
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
	and	r0
					// (save result) // Store_reg to type 0x3
	mt	r0
	st	r3
				// freereg r1

	//../../Lib//spi_c.c, line 303
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r0
					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 303
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	128
	sgn
	cmp	r0

	//../../Lib//spi_c.c, line 303
	cond	SLT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l113
		add	r7
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	32768
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r1

	//../../Lib//spi_c.c, line 312
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 313
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 314
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 316
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	100000
					// (save temp) isreg
	mr	r1
				//save_temp done
l126: # 

	//../../Lib//spi_c.c, line 319
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 322
					// (test)
					// (objtotemp) flags 260 
// deref 
	ld	r3

	//../../Lib//spi_c.c, line 322
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l130
		add	r7

	//../../Lib//spi_c.c, line 322
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 322
					// (test)
					// (objtotemp) flags 42 
// reg r1 - don't bother matching
	mt	r1
	and	r1

	//../../Lib//spi_c.c, line 322
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l126
		add	r7
l130: # 

	//../../Lib//spi_c.c, line 323
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 240 
// reg r4 - don't bother matching
	mt	r4
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 324
					// (bitwise/arithmetic) 	//ops: 0, 6, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 240 
// reg r5 - don't bother matching
	mt	r5
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 324
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 324
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l131
		add	r7
l127: # 

	//../../Lib//spi_c.c, line 324
					// (bitwise/arithmetic) 	//ops: 0, 6, 1
					// (objtotemp) flags 21 
// const/deref
					// (prepobj tmp)
 // deref
			// const
	.liconst	-48
		//sizemod based on type 0x503
	ldt
	mr	r0
					// (objtotemp) flags 240 
// reg r5 - don't bother matching
	mt	r5
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 324
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 324
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l127
		add	r7
l131: # 

	//../../Lib//spi_c.c, line 324
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-48
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 325
					//setreturn
					// (objtotemp) flags 1 

// required value found in tmp
	mr	r0
l105: # 
				// freereg r1
				// freereg r3
				// freereg r4
				// freereg r5
	.liconst	-4
	sub	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

l112:
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
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.0
l132:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	-44
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 102 
// var, auto|reg
		//sizemod based on type 0x3
	.liconst	20
	ldidx	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 102 
// var, auto|reg
		//sizemod based on type 0xa
	.liconst	16
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2
				// allocreg r1

	//../../Lib//spi_c.c, line 335
					// (a/p assign)
					// (prepobj r0)
 // reg r2 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r2
				//save_temp done

	//../../Lib//spi_c.c, line 337
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	1499999
					// (save temp) isreg
	mr	r1
				//save_temp done
l148: # 

	//../../Lib//spi_c.c, line 340
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done

	//../../Lib//spi_c.c, line 343
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 260 
// deref 
	ld	r5
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	254
	cmp	r0

	//../../Lib//spi_c.c, line 343
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l139
		add	r7

	//../../Lib//spi_c.c, line 349
					// (a/p assign)
					// (prepobj r0)
 // extern (offset 0)
	.liabs	_spi_checksum
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 351
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	4
	sgn
	cmp	r4

	//../../Lib//spi_c.c, line 351
	cond	SLT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l152
		add	r7
				// freereg r1
l149: # 

	//../../Lib//spi_c.c, line 354
					//call
			//pcreltotemp
	.lipcrel	_SPI_PUMP_LE
	add	r7

				// allocreg r1

	//../../Lib//spi_c.c, line 354
					// (getreturn)					// (save result) // isreg
	mt	r0
	mr	r1

	//../../Lib//spi_c.c, line 355
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
					// (save temp) store
	st	r3
				//save_temp done

	//../../Lib//spi_c.c, line 357
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	4
	add	r3
					// (save result) // isreg

	//../../Lib//spi_c.c, line 358
					// (bitwise/arithmetic) 	//ops: 0, 2, 1
					// (objtotemp) flags 2 
// extern
	.liabs	_spi_checksum
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	add	r0
					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_spi_checksum, 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r1

	//../../Lib//spi_c.c, line 351
					// (bitwise/arithmetic) 	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	4
	sub	r4
					// (save result) // isreg

	//../../Lib//spi_c.c, line 351
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 

// required value found in tmp
	sgn
	cmp	r4

	//../../Lib//spi_c.c, line 351
	cond	GE
					//conditional branch regular			//pcreltotemp
	.lipcrel	l149
		add	r7
l152: # 
				// allocreg r1

	//../../Lib//spi_c.c, line 361
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	0
	sgn
	cmp	r4

	//../../Lib//spi_c.c, line 361
	cond	LE
					//conditional branch regular			//pcreltotemp
	.lipcrel	l153
		add	r7
				// freereg r1
l150: # 

	//../../Lib//spi_c.c, line 364
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done
				// allocreg r1

	//../../Lib//spi_c.c, line 364
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 260 
// deref 
	ld	r5
					// (save temp) isreg
	mr	r1
				//save_temp done

	//../../Lib//spi_c.c, line 365
					//FIXME convert
					// (convert - reducing type 3 to 101
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
					// (save temp) store
	byt
	st	r3
				//save_temp done
	.liconst	255
	and	r0

	//../../Lib//spi_c.c, line 365
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r3
					// (save result) // isreg

	//../../Lib//spi_c.c, line 367
					// (bitwise/arithmetic) 	//ops: 0, 2, 1
					// (objtotemp) flags 2 
// extern
	.liabs	_spi_checksum
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	add	r0
					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_spi_checksum, 4
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r1

	//../../Lib//spi_c.c, line 361
					// (bitwise/arithmetic) 	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r4
					// (save result) // isreg

	//../../Lib//spi_c.c, line 361
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	0
	sgn
	cmp	r4

	//../../Lib//spi_c.c, line 361
	cond	SGT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l150
		add	r7
l153: # 
				// allocreg r1

	//../../Lib//spi_c.c, line 370
					// (a/p assign)
					// (prepobj r0)
 // reg r1 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	1
					// (save temp) isreg
	mr	r1
				//save_temp done

	//../../Lib//spi_c.c, line 371
					// (a/p assign)
					// (prepobj r0)
 // reg r2 - no need to prep
					// (objtotemp) flags 1 

// required value found in tmp
					// (save temp) isreg
	mr	r2
				//save_temp done
l139: # 

	//../../Lib//spi_c.c, line 337
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	sub	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 337
					// (test)
					// (objtotemp) flags 42 
// reg r1 - don't bother matching
	mt	r1
	and	r1

	//../../Lib//spi_c.c, line 337
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l148
		add	r7

	//../../Lib//spi_c.c, line 374
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r5
				//save_temp done

	//../../Lib//spi_c.c, line 375
					//setreturn
					// (objtotemp) flags 42 
// reg r2 - don't bother matching
	mt	r2
	mr	r0
				// freereg r1
				// freereg r2
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
	mr	r7

	//registers used:
		//r1: yes
		//r2: no
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	.liconst	-4
	add	r6
				// allocreg r5
				// allocreg r4
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	-48
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	32768
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r1

	//../../Lib//spi_c.c, line 380
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r5
				//save_temp done

	//../../Lib//spi_c.c, line 384
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 385
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 385
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 385
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l167
		add	r7
l165: # 

	//../../Lib//spi_c.c, line 385
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 385
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 385
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l165
		add	r7
l167: # 

	//../../Lib//spi_c.c, line 385
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	257
					// (save temp) store
	st	r4
				//save_temp done

	//../../Lib//spi_c.c, line 386
					// (a/p assign)
					// (prepobj r0)
 // deref
			// const
	.liconst	-44
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	255
					// (save temp) store
	st	r0
				//save_temp done

	//../../Lib//spi_c.c, line 388
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x104
	.liconst	20
	ldidx	r6
	stdec	r6

	//../../Lib//spi_c.c, line 388
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	16711761
	stdec	r6

	//../../Lib//spi_c.c, line 388
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 388
					// (getreturn)					// (save result) // isreg
	mt	r0
	mr	r1

	//../../Lib//spi_c.c, line 389
					// (test)
					// (objtotemp) flags 42 
// reg r1 - don't bother matching
	mt	r1
	and	r1

	//../../Lib//spi_c.c, line 389
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l160
		add	r7

	//../../Lib//spi_c.c, line 391
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r1 - don't bother matching
	mt	r1
	stdec	r6

	//../../Lib//spi_c.c, line 391
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x104
	.liconst	24
	ldidx	r6
	stdec	r6

	//../../Lib//spi_c.c, line 391
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l161,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 391
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	12
	add	r6


	//../../Lib//spi_c.c, line 393
			//pcreltotemp
	.lipcrel	l154
	add	r7
l160: # 

	//../../Lib//spi_c.c, line 394
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	512
	stdec	r6

	//../../Lib//spi_c.c, line 394
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0xa
	.liconst	28
	ldidx	r6
	stdec	r6

	//../../Lib//spi_c.c, line 394
					//call
			//pcreltotemp
	.lipcrel	l132
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 394
					// (getreturn)					// (save result) // isreg
	mt	r0
	mr	r5

	//../../Lib//spi_c.c, line 396
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 396
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 396
	cond	EQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l168
		add	r7
l166: # 

	//../../Lib//spi_c.c, line 396
					// (bitwise/arithmetic) 	//ops: 5, 4, 1
					// (objtotemp) flags 260 
// deref 
	ld	r4
	mr	r0
					// (objtotemp) flags 240 
// reg r3 - don't bother matching
	mt	r3
	and	r0
					// (save result) // Store_reg to type 0x503
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//../../Lib//spi_c.c, line 396
					// (test)
					// (objtotemp) flags a 
// var, auto|reg
		//sizemod based on type 0x503
	ld	r6

	//../../Lib//spi_c.c, line 396
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l166
		add	r7
l168: # 

	//../../Lib//spi_c.c, line 396
					// (a/p assign)
					// (prepobj r0)
 // reg r4 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) store
	st	r4
				//save_temp done
l154: # 

	//../../Lib//spi_c.c, line 397
					//setreturn
					// (objtotemp) flags 42 
// reg r5 - don't bother matching
	mt	r5
	mr	r0
				// freereg r1
				// freereg r3
				// freereg r4
				// freereg r5
	.liconst	-4
	sub	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

l161:
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
_c_sd_get_size:
	exg	r6
	stmpdec	r6
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
	.liconst	-4
	add	r6
				// allocreg r5
				// allocreg r3

	//../../Lib//spi_c.c, line 405
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	0
	stdec	r6

	//../../Lib//spi_c.c, line 405
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	16711753
	stdec	r6

	//../../Lib//spi_c.c, line 405
					//call
			//pcreltotemp
	.lipcrel	_cmd_write
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 407
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 
// const
	.liconst	18
	stdec	r6

	//../../Lib//spi_c.c, line 407
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // extern (offset 0)
	.liabs	_sizebuf
// extern pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 407
					//call
			//pcreltotemp
	.lipcrel	l132
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 408
					// (a/p assign)
					// (prepobj r0)
 // reg r5 - no need to prep
					// (objtotemp) flags 1 
// const
	.liconst	0
					// (save temp) isreg
	mr	r5
				//save_temp done
l185: # 

	//../../Lib//spi_c.c, line 409
					// (bitwise/arithmetic) 	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r5
					// (save result) // isreg

	//../../Lib//spi_c.c, line 409
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	18
	sgn
	cmp	r5

	//../../Lib//spi_c.c, line 409
	cond	SLT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l185
		add	r7
				// allocreg r1

	//../../Lib//spi_c.c, line 414
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r1
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 414
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	192
	and	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 414
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	64
	cmp	r1
				// freereg r1

	//../../Lib//spi_c.c, line 414
	cond	NEQ
					//conditional branch regular			//pcreltotemp
	.lipcrel	l176
		add	r7
				// allocreg r1

	//../../Lib//spi_c.c, line 416
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 7
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r1
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 416
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	16
	shl	r1
					// (save result) // isreg
				// allocreg r2

	//../../Lib//spi_c.c, line 416
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 8
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r2
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 416
					// (bitwise/arithmetic) 	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	8
	shl	r2
					// (save result) // isreg

	//../../Lib//spi_c.c, line 416
					// (bitwise/arithmetic) 	//ops: 3, 2, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a 
// reg r2 - don't bother matching
	mt	r2
	or	r1
					// (save result) // isreg
				// freereg r2
				// allocreg r2

	//../../Lib//spi_c.c, line 416
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 9
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r2
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 416
					// (bitwise/arithmetic) 	//ops: 3, 2, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a 
// reg r2 - don't bother matching
	mt	r2
	or	r1
					// (save result) // isreg
				// freereg r2

	//../../Lib//spi_c.c, line 416
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	4194303
	and	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 416
					// (bitwise/arithmetic) 	//ops: 2, 0, 6
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r5
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r5
					// (save result) // isreg
				// freereg r1

	//../../Lib//spi_c.c, line 417
					// (bitwise/arithmetic) 	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	10
	shl	r5
					// (save result) // isreg

	//../../Lib//spi_c.c, line 420
			//pcreltotemp
	.lipcrel	l177
	add	r7
				// freereg r3
l176: # 
				// allocreg r3

	//../../Lib//spi_c.c, line 421
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 9
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r3
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 421
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	shl	r3
					// (save result) // isreg

	//../../Lib//spi_c.c, line 421
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	6
	and	r3
					// (save result) // isreg
				// allocreg r1

	//../../Lib//spi_c.c, line 421
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 10
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r1
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 421
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	7
	sgn
	shr	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 421
					// (bitwise/arithmetic) 	//ops: 2, 4, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	or	r3
					// (save result) // isreg
				// freereg r1
				// allocreg r1

	//../../Lib//spi_c.c, line 422
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 5
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r1
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 422
					// (bitwise/arithmetic) 	//ops: 2, 0, 1
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	15
	and	r0
					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r1
				// allocreg r4

	//../../Lib//spi_c.c, line 423
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 6
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r4
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	3
	and	r4
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	10
	shl	r4
					// (save result) // isreg
				// allocreg r1

	//../../Lib//spi_c.c, line 423
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 7
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r1
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	2
	shl	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 2, 5, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	or	r4
					// (save result) // isreg
				// freereg r1
				// allocreg r1

	//../../Lib//spi_c.c, line 423
					//FIXME convert
	//Converting to wider type...
					// (objtotemp) flags 2 
// extern
	.liabs	_sizebuf, 8
		//sizemod based on type 0x101
	byt
	//extern deref
	ldt
	mr	r1
	//But unsigned, so no need to extend
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	192
	and	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	6
	sgn
	shr	r1
					// (save result) // isreg

	//../../Lib//spi_c.c, line 423
					// (bitwise/arithmetic) 	//ops: 2, 5, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	or	r4
					// (save result) // isreg
				// freereg r1

	//../../Lib//spi_c.c, line 424
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a 
// reg r4 - don't bother matching
	mt	r4
	stdec	r6

	//../../Lib//spi_c.c, line 424
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	.liconst	4
	ldidx	r6
	stdec	r6

	//../../Lib//spi_c.c, line 424
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 4a 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 424
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l178,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 424
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	16
	add	r6


	//../../Lib//spi_c.c, line 425
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	2
	add	r3
					// (save result) // isreg

	//../../Lib//spi_c.c, line 425
					// (bitwise/arithmetic) 	//ops: 0, 4, 4
		// WARNING - evading q2 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0
					// (objtotemp) flags 4a 
// reg r3 - don't bother matching
	mt	r3
	shl	r0
					// (save result) // isreg
	mt	r0
	mr	r3

	//../../Lib//spi_c.c, line 426
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a 
// reg r3 - don't bother matching
	mt	r3
	stdec	r6

	//../../Lib//spi_c.c, line 426
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l179,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 426
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6


	//../../Lib//spi_c.c, line 427
					// (bitwise/arithmetic) 	//ops: 0, 0, 1
					// (objtotemp) flags 1 
// const
	.liconst	1
	mr	r0
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	shl	r0
					// (save result) // Store_reg to type 0x3
					// (prepobj tmp)
 // var, auto|reg
	.liconst	4
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// allocreg r1

	//../../Lib//spi_c.c, line 428
					// (bitwise/arithmetic) 	//ops: 5, 0, 2
					// (objtotemp) flags 4a 
// reg r4 - don't bother matching
	mt	r4
	mr	r1
					// (objtotemp) flags 1 
// const
	.liconst	1
	add	r1
					// (save result) // isreg
				// freereg r4

	//../../Lib//spi_c.c, line 428
					// (bitwise/arithmetic) 	//ops: 2, 4, 6
					// (objtotemp) flags 4a 
// reg r1 - don't bother matching
	mt	r1
	mr	r5
					// (objtotemp) flags 4a 
// reg r3 - don't bother matching
	mt	r3
	sgn
	mul	r5
					// (save result) // isreg
				// freereg r1
				// freereg r3

	//../../Lib//spi_c.c, line 429
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	stdec	r6

	//../../Lib//spi_c.c, line 429
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r5 - don't bother matching
	mt	r5
	stdec	r6

	//../../Lib//spi_c.c, line 429
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l180,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 429
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	12
	add	r6


	//../../Lib//spi_c.c, line 430
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 
// var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp) flags 1 
// const
	.liconst	512
	sgn
	cmp	r0

	//../../Lib//spi_c.c, line 430
	cond	LE
					//conditional branch regular			//pcreltotemp
	.lipcrel	l188
		add	r7
				// allocreg r3
					// (a/p assign)
					// (prepobj r0)
 // reg r3 - no need to prep
					// (objtotemp) flags 102 
// var, auto|reg
		//sizemod based on type 0x3
	ld	r6
					// (save temp) isreg
	mr	r3
				//save_temp done
l181: # 

	//../../Lib//spi_c.c, line 432
					// (bitwise/arithmetic) 	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 
// const
	.liconst	1
	shl	r5
					// (save result) // isreg

	//../../Lib//spi_c.c, line 433
					// (bitwise/arithmetic) 	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 

// required value found in tmp
	sgn
	shr	r3
					// (save result) // isreg

	//../../Lib//spi_c.c, line 430
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 
// const
	.liconst	512
	sgn
	cmp	r3

	//../../Lib//spi_c.c, line 430
	cond	SGT
					//conditional branch regular			//pcreltotemp
	.lipcrel	l181
		add	r7
l188: # 

	//../../Lib//spi_c.c, line 435
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 
// reg r5 - don't bother matching
	mt	r5
	stdec	r6

	//../../Lib//spi_c.c, line 435
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 
					// (prepobj tmp)
 // static
	.liabs	l184,0
// static pe is varadr
	stdec	r6

	//../../Lib//spi_c.c, line 435
					//call
			//pcreltotemp
	.lipcrel	_printf
	add	r7
	.liconst	8
	add	r6

l177: # 

	//../../Lib//spi_c.c, line 437
					//setreturn
					// (objtotemp) flags 42 
// reg r5 - don't bother matching
	mt	r5
	mr	r0
				// freereg r3
				// freereg r5
	.liconst	-4
	sub	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7


///////////////////////////




	.global _sd_get_size
_sd_get_size:
	exg	r6	// Save regs r3 to r5.  (r0-r2 are scratch)
	stdec 	r6
	stdec	r3
	stdec	r4
	stdec	r5
	exg	r6

	.liconst	18
	sub	r6	// Reserve space for sizebuf
	mt	r6
	mr	r5
				//	r=cmd_CMD9();
	li	0
	stdec	r6
	.liconst	cmd_CMD9
	stdec	r6
	.lipcrel	_cmd_write
	add	r7

				//	sd_read(sizebuf,18);
	.liconst	18
	stdec	r6
	mt	r5
	stdec	r6
	.lipcrel	_sd_read
	add	r7

	li	16
	add	r6	// Restore stack

	//	if((sizebuf[0]&0xc0)==0x40)	// V2 CSD?
	.liconst	0xc0
	mr	r0
	byte
	ld	r5
	and	r0
	.liconst	0x40
	cmp	r0

	cond EQ	// Have a V2 CSD	// 32 bytes so far
						// r=1+(((sizebuf[7]<<16)|(sizebuf[8]<<8)|sizebuf[9])&0x3fffff);
						// r<<=10;	// Scale to the number of 512-byte blocks
		li 7
		addt	r5
		mr	r2
		ldbinc	r2
		mr	r0
		li	8
		shl	r0
		ldbinc	r2
		or	r0
		li	8
		shl	r0
		ldbinc	r2
		or	r0
		li	1
		add	r0
		li	10
		shl	r0
		.lipcrel	.done
		add	r7		// 43 bytes

		// V1 CSD - oh deep joy.  Whatever were they smoking when they designed the V1 CSD?

	li 9
	addt	r5
	mr	r2
	ldbinc	r2
	mr	r0
	li	3
	and	r0
	li	8
	shl	r0
	ldbinc	r2
	or	r0
	li	7
	shr	r0		// int c_size_mult=((sizebuf[9]<<1)&6)|(sizebuf[10]>>7);
				
	li	1
	mr	r4
	li	2
	addt	r0
	shl	r4		// c_size_mult=1<<(2+c_size_mult);

	li	5
	byte
	ldidx	r5
	mr	r3
	li	15
	and	r3		// int read_bl_len=sizebuf[5]&15;  // 67 bytes

//	li	1
//	exg	r3
//	shl	r3		//  read_bl_len=1<<(read_bl_len);

	li	6
	addt	r5
	mr	r2
	ldbinc	r2
	mr	r1
	li	3
	and	r1
	li	8
	shl	r1

	ldbinc	r2
	or	r1
	li	8
	shl	r1

	ldbinc	r2
	or	r1
	li	6
	shr	r1  // int csize=((sizebuf[6]&3)<<10) | sizebuf[7]<<2 | ((sizebuf[8]&0xc0)>>6);

	li	1
	addt	r1
	mul	r4	// r=(csize+1)*c_size_mult;

	mr	r0

	li	10
	sub	r3	// read_bl_len>512?
	cond	SGT
		mt	r3
		shl	r0	//  r<<=1; read_bl_len>>=1;
		cond EX		// 94 bytes

.done:
	.liconst	18
	add	r6	// Deallocate sizebuf

	ldinc	r6	// Restore regs
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7	// Return  // 104 bytes


///////////////





l178:
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
l179:
	.byte	77
	.byte	117
	.byte	108
	.byte	116
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l180:
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
l184:
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
	.section	.bss
	.global	_spi_checksum
	.comm	_spi_checksum,4
	.global	_sd_is_sdhc
	.comm	_sd_is_sdhc,4
	.global	_sd_size
	.comm	_sd_size,4
	.global	_SPI_R1
	.comm	_SPI_R1,6
	.global	_sizebuf
	.comm	_sizebuf,18
