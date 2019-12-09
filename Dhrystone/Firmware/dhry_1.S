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
	.section	.text.d1e2353
	.global	__readMilliseconds
__readMilliseconds:
	stdec	r6

	//dhry_1.c, line 86
// code 0x5e
					//setreturn
					// (load_temp - type 4) not varadr
					// (objtotemp)  const/deref
					// (prepobj tmp) deref
			// const
				// constant: ffffffc8 in 2 chunks
	li	IMW1(-56)
	li	IMW0(-56)
		//sizemod based on type 0x4
	ldt
	mr	r0
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
	.section	.text.d1e2353
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
				// allocreg r2

	//dhry_1.c, line 125
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Next_Ptr_Glob
	mr	r1
					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec1
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 126
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ptr_Glob
	mr	r1
					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec2
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 128
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_rec2
	mr	r1
					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec1
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 129
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 4)
	ldinc	r7
	.int	_rec2 + 4
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 130
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 8)
	ldinc	r7
	.int	_rec2 + 8
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 131
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 12)
	ldinc	r7
	.int	_rec2 + 12
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 28 in 2 chunks
	li	IMW1(40)
	li	IMW0(40)
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 135
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 16)
	ldinc	r7
	.int	_rec2 + 16
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to rec2
					// (load_temp - type 1) not varadr
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l3
	mr	r0
	mt	r2
	stdec	r6
// Copying 1 words to rec2
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
// Copying 3 byte tail to rec2
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldinc	r6
	mr	r2

	//dhry_1.c, line 136
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Str_1_Loc
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to Str_1_Loc
					// (load_temp - type 1) not varadr
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l4
	mr	r0
	mt	r2
	stdec	r6
// Copying 1 words to Str_1_Loc
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
// Copying 3 byte tail to Str_1_Loc
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldinc	r6
	mr	r2

	//dhry_1.c, line 138
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 1628)
	ldinc	r7
	.int	_Arr_2_Glob + 1628
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 143
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l5
	stdec	r6

	//dhry_1.c, line 143
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 144
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l6
	stdec	r6

	//dhry_1.c, line 144
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 145
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l7
	stdec	r6

	//dhry_1.c, line 145
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 146
// code 0x44
					// (test)
					// (objtotemp)  extern
	ldinc	r7
	.int	_Reg
		//sizemod based on type 0x3
	ldt

	//dhry_1.c, line 146
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l9)-1)
	li	IMW0(PCREL(l9))
		add	r7

	//dhry_1.c, line 148
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l10
	stdec	r6

	//dhry_1.c, line 148
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 149
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l11
	stdec	r6

	//dhry_1.c, line 149
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 152
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
	add	r7
l9: # 

	//dhry_1.c, line 153
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l13
	stdec	r6

	//dhry_1.c, line 153
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 154
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l14
	stdec	r6

	//dhry_1.c, line 154
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l12: # 

	//dhry_1.c, line 158
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Number_Of_Runs
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 158
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l15
	stdec	r6

	//dhry_1.c, line 158
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 173
// code 0x2a
					//call
	ldinc	r7
	.int	__readMilliseconds
	exg	r7


	//dhry_1.c, line 173
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Begin_Time + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//dhry_1.c, line 175
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

	//dhry_1.c, line 176
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_Number_Of_Runs
		//sizemod based on type 0x3
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r1

	//dhry_1.c, line 176
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l100)-1)
	li	IMW0(PCREL(l100))
		add	r7
				// freereg r2
l97: # 

	//dhry_1.c, line 177
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_5
	exg	r7


	//dhry_1.c, line 178
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_4
	exg	r7


	//dhry_1.c, line 180
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 181
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_1.c, line 182
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to Str_2_Loc
					// (load_temp - type 1) not varadr
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l20
	mr	r0
	mt	r2
	stdec	r6
// Copying 1 words to Str_2_Loc
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
// Copying 3 byte tail to Str_2_Loc
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldinc	r6
	mr	r2

	//dhry_1.c, line 183
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 184
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Str_2_Loc
		//sizemod based on type 0xa
	stdec	r6

	//dhry_1.c, line 184
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Str_1_Loc
		//sizemod based on type 0xa
	stdec	r6

	//dhry_1.c, line 184
// code 0x2a
					//call
	ldinc	r7
	.int	_Func_2
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 184
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_1.c, line 184
// code 0x44
					// (test)
					// (objtotemp)  reg r2
	mt	r2
	and	r2
				// freereg r2

	//dhry_1.c, line 184
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l21)-1)
	li	IMW0(PCREL(l21))
		add	r7
				// allocreg r2

	//dhry_1.c, line 184
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

	//dhry_1.c, line 184
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l22)-1)
	li	IMW0(PCREL(l22))
	add	r7
l21: # 

	//dhry_1.c, line 184
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
l22: # 

	//dhry_1.c, line 184
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 186
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp)  reg r4
	mt	r4
	sgn
	cmp	r1

	//dhry_1.c, line 186
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l101)-1)
	li	IMW0(PCREL(l101))
		add	r7
				// freereg r2
l98: # 
				// allocreg r2

	//dhry_1.c, line 188
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r2
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	mul	r2
					// (save result) isreg

	//dhry_1.c, line 188
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r0
					// (objtotemp)  reg r4
	mt	r4
	sub	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 10 in 1 chunks
	li	IMW0(16)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r2
				// allocreg r2

	//dhry_1.c, line 190
// code 0x28
					// (address)
					// (prepobj r2) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	mr	r2

					// (save result) isreg

	//dhry_1.c, line 190
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 190
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r4
	mt	r4
	stdec	r6

	//dhry_1.c, line 190
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 190
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_7
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//dhry_1.c, line 192
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

	//dhry_1.c, line 186
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp)  reg r4
	mt	r4
	sgn
	cmp	r1

	//dhry_1.c, line 186
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l98)-1)
	li	IMW0(PCREL(l98))
		add	r7
l101: # 

	//dhry_1.c, line 195
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 195
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 195
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Arr_2_Glob
		//sizemod based on type 0xa
	stdec	r6

	//dhry_1.c, line 195
// code 0x4e
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Arr_1_Glob
		//sizemod based on type 0xa
	stdec	r6

	//dhry_1.c, line 195
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_8
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6


	//dhry_1.c, line 197
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0xa
	ldt
	stdec	r6

	//dhry_1.c, line 197
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_1
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 198
// code 0x2
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	mr	r1

					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done
				// allocreg r2

	//dhry_1.c, line 200
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ch_2_Glob
		//sizemod based on type 0x1
	byt
	ldt
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

	//dhry_1.c, line 200
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r2
				// freereg r2

	//dhry_1.c, line 200
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l102)-1)
	li	IMW0(PCREL(l102))
		add	r7
l99: # 

	//dhry_1.c, line 201
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 43 in 2 chunks
	li	IMW1(67)
	li	IMW0(67)
	stdec	r6
				// allocreg r2

	//dhry_1.c, line 201
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 8 in 1 chunks
	li	IMW0(8)
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

	//dhry_1.c, line 201
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 201
// code 0x2a
					//call
	ldinc	r7
	.int	_Func_1
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 201
// code 0x5d
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_1.c, line 201
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r1
					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r1
				// freereg r2

	//dhry_1.c, line 201
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32))
		add	r7
				// allocreg r2

	//dhry_1.c, line 204
// code 0x28
					// (address)
					// (prepobj r2) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r2

					// (save result) isreg

	//dhry_1.c, line 204
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 204
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 204
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_6
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 205
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to Str_2_Loc
					// (load_temp - type 1) not varadr
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l33
	mr	r0
	mt	r2
	stdec	r6
// Copying 1 words to Str_2_Loc
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
	ldinc	r0
	stinc	r1
// Copying 3 byte tail to Str_2_Loc
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldbinc	r0
	stbinc	r1
	ldinc	r6
	mr	r2

	//dhry_1.c, line 206
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_1.c, line 207
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  reg r5
	mt	r5
					// (save temp) store
	st	r1
				//save_temp done
l32: # 

	//dhry_1.c, line 200
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r0
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) store reg
// Store_reg to type 0x1
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	exg	r0
	stbinc	r0	//WARNING - pointer / reg not restored, might cause trouble!
				// allocreg r3

	//dhry_1.c, line 200
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r3
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

	//dhry_1.c, line 200
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ch_2_Glob
		//sizemod based on type 0x1
	byt
	ldt
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

	//dhry_1.c, line 200
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  reg r2
	mt	r2
	sgn
	cmp	r3
				// freereg r3
				// freereg r2

	//dhry_1.c, line 200
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l99)-1)
	li	IMW0(PCREL(l99))
		add	r7
l102: # 

	//dhry_1.c, line 211
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mul	r4
					// (save result) isreg

	//dhry_1.c, line 212
// code 0x1e
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp)  reg r4
	mt	r4
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r2
	ldinc	r7
	.int	_div_u32byu32
	exg	r7
	ldinc	r6
	mr	r2
	mt	r0
	mr	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// allocreg r2

	//dhry_1.c, line 213
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  reg r4
	mt	r4
	mr	r2
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	sub	r2
					// (save result) isreg

	//dhry_1.c, line 213
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	mul	r2
					// (save result) isreg

	//dhry_1.c, line 213
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r4
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sub	r4
					// (save result) isreg
				// freereg r2
				// allocreg r2

	//dhry_1.c, line 215
// code 0x28
					// (address)
					// (prepobj r2) var, auto|reg
	mt	r6
	mr	r2

					// (save result) isreg

	//dhry_1.c, line 215
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 215
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_2
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 176
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg

	//dhry_1.c, line 176
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_Number_Of_Runs
		//sizemod based on type 0x3
	ldt
	sgn
	cmp	r5

	//dhry_1.c, line 176
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l97)-1)
	li	IMW0(PCREL(l97))
		add	r7
l100: # 

	//dhry_1.c, line 233
// code 0x2a
					//call
	ldinc	r7
	.int	__readMilliseconds
	exg	r7


	//dhry_1.c, line 233
// code 0x5d
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_End_Time + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//dhry_1.c, line 237
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l34
	stdec	r6

	//dhry_1.c, line 237
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 238
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l35
	stdec	r6

	//dhry_1.c, line 238
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 239
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l36
	stdec	r6

	//dhry_1.c, line 239
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 240
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l37
	stdec	r6

	//dhry_1.c, line 240
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 241
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Int_Glob
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 241
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l38
	stdec	r6

	//dhry_1.c, line 241
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 242
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	stdec	r6

	//dhry_1.c, line 242
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l39
	stdec	r6

	//dhry_1.c, line 242
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 243
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Bool_Glob
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 243
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l40
	stdec	r6

	//dhry_1.c, line 243
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 244
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 244
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l41
	stdec	r6

	//dhry_1.c, line 244
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 245
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ch_1_Glob
		//sizemod based on type 0x1
	byt
	ldt
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

	//dhry_1.c, line 245
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 245
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l42
	stdec	r6

	//dhry_1.c, line 245
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 246
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	stdec	r6

	//dhry_1.c, line 246
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l43
	stdec	r6

	//dhry_1.c, line 246
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 247
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ch_2_Glob
		//sizemod based on type 0x1
	byt
	ldt
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

	//dhry_1.c, line 247
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 247
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l44
	stdec	r6

	//dhry_1.c, line 247
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 248
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
	stdec	r6

	//dhry_1.c, line 248
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l45
	stdec	r6

	//dhry_1.c, line 248
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 249
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Arr_1_Glob + 32
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 249
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l46
	stdec	r6

	//dhry_1.c, line 249
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 250
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	stdec	r6

	//dhry_1.c, line 250
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l47
	stdec	r6

	//dhry_1.c, line 250
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 251
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Arr_2_Glob + 1628
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 251
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l48
	stdec	r6

	//dhry_1.c, line 251
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 252
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l49
	stdec	r6

	//dhry_1.c, line 252
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 253
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l50
	stdec	r6

	//dhry_1.c, line 253
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 254
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	stdec	r6

	//dhry_1.c, line 254
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l51
	stdec	r6

	//dhry_1.c, line 254
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 255
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l52
	stdec	r6

	//dhry_1.c, line 255
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_1.c, line 256
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 256
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 256
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l53
	stdec	r6

	//dhry_1.c, line 256
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 257
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 257
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l54
	stdec	r6

	//dhry_1.c, line 257
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 258
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 258
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 258
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l55
	stdec	r6

	//dhry_1.c, line 258
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 259
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	stdec	r6

	//dhry_1.c, line 259
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l56
	stdec	r6

	//dhry_1.c, line 259
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 260
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 260
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 260
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l57
	stdec	r6

	//dhry_1.c, line 260
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 261
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 11 in 1 chunks
	li	IMW0(17)
	stdec	r6

	//dhry_1.c, line 261
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l58
	stdec	r6

	//dhry_1.c, line 261
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 262
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 262
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 262
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l59
	stdec	r6

	//dhry_1.c, line 262
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 263
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l60
	stdec	r6

	//dhry_1.c, line 263
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 264
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l61
	stdec	r6

	//dhry_1.c, line 264
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 265
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Next_Ptr_Glob
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	stdec	r6

	//dhry_1.c, line 265
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l62
	stdec	r6

	//dhry_1.c, line 265
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 266
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l63
	stdec	r6

	//dhry_1.c, line 266
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_1.c, line 267
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Next_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 267
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 267
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l64
	stdec	r6

	//dhry_1.c, line 267
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 268
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 268
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l65
	stdec	r6

	//dhry_1.c, line 268
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 269
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Next_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 269
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 269
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l66
	stdec	r6

	//dhry_1.c, line 269
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 270
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 270
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l67
	stdec	r6

	//dhry_1.c, line 270
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 271
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Next_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 271
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 271
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l68
	stdec	r6

	//dhry_1.c, line 271
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 272
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	stdec	r6

	//dhry_1.c, line 272
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l69
	stdec	r6

	//dhry_1.c, line 272
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 274
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Next_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 274
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 274
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l70
	stdec	r6

	//dhry_1.c, line 274
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 275
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l71
	stdec	r6

	//dhry_1.c, line 275
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 276
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	stdec	r6

	//dhry_1.c, line 276
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l72
	stdec	r6

	//dhry_1.c, line 276
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 277
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	stdec	r6

	//dhry_1.c, line 277
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l73
	stdec	r6

	//dhry_1.c, line 277
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 278
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r4
	mt	r4
	stdec	r6

	//dhry_1.c, line 278
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l74
	stdec	r6

	//dhry_1.c, line 278
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 279
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: d in 1 chunks
	li	IMW0(13)
	stdec	r6

	//dhry_1.c, line 279
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l75
	stdec	r6

	//dhry_1.c, line 279
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 280
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 280
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l76
	stdec	r6

	//dhry_1.c, line 280
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 281
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	stdec	r6

	//dhry_1.c, line 281
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l77
	stdec	r6

	//dhry_1.c, line 281
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 282
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 282
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l78
	stdec	r6

	//dhry_1.c, line 282
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 283
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 283
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l79
	stdec	r6

	//dhry_1.c, line 283
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 284
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Str_1_Loc
		//sizemod based on type 0xa
	stdec	r6

	//dhry_1.c, line 284
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l80
	stdec	r6

	//dhry_1.c, line 284
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 285
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l81
	stdec	r6

	//dhry_1.c, line 285
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 286
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Str_2_Loc
		//sizemod based on type 0xa
	stdec	r6

	//dhry_1.c, line 286
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l82
	stdec	r6

	//dhry_1.c, line 286
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 287
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l83
	stdec	r6

	//dhry_1.c, line 287
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 288
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l84
	stdec	r6

	//dhry_1.c, line 288
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_1.c, line 291
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_End_Time
		//sizemod based on type 0x4
	ldt
	mr	r2
					// (objtotemp)  extern
	ldinc	r7
	.int	_Begin_Time
		//sizemod based on type 0x4
	ldt
	sub	r2
					// (save result) isreg
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_User_Time
	mr	r1
					// (load_temp - type 4) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) store
	st	r1
				//save_temp done

	//dhry_1.c, line 292
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 292
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l85
	stdec	r6

	//dhry_1.c, line 292
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 294
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  extern
	ldinc	r7
	.int	_User_Time
		//sizemod based on type 0x4
	ldt
	mr	r1
					// (objtotemp)  const
				// constant: 78 in 2 chunks
	li	IMW1(120)
	li	IMW0(120)
	sgn
	cmp	r1

	//dhry_1.c, line 294
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l87)-1)
	li	IMW0(PCREL(l87))
		add	r7
				// allocreg r2

	//dhry_1.c, line 296
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l88
	stdec	r6

	//dhry_1.c, line 296
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 297
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l89
	stdec	r6

	//dhry_1.c, line 297
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 298
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l90
	stdec	r6

	//dhry_1.c, line 298
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// freereg r2
				// freereg r4
l87: # 
				// allocreg r2
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 4) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_User_Time
		//sizemod based on type 0x4
	ldt
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r3

	//dhry_1.c, line 316
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: 3e8 in 2 chunks
	li	IMW1(1000)
	li	IMW0(1000)
	mul	r3
					// (save result) isreg

	//dhry_1.c, line 316
// code 0x1e
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp)  reg r3
	mt	r3
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Number_Of_Runs
		//sizemod based on type 0x4
	ldt
	mr	r2
	ldinc	r7
	.int	_div_u32byu32
	exg	r7
	ldinc	r6
	mr	r2
	mt	r0
	mr	r0
					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Microseconds + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r3
				// allocreg r3
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Number_Of_Runs
		//sizemod based on type 0x3
	ldt
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r4

	//dhry_1.c, line 317
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r4
					// (objtotemp)  const
				// constant: 3e8 in 2 chunks
	li	IMW1(1000)
	li	IMW0(1000)
	mul	r4
					// (save result) isreg

	//dhry_1.c, line 317
// code 0x1e
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp)  reg r4
	mt	r4
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
	ldinc	r7
	.int	_div_u32byu32
	exg	r7
	ldinc	r6
	mr	r2
	mt	r0
	mr	r0
					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Dhrystones_Per_Second + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r4

	//dhry_1.c, line 318
// code 0x1d
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 239 in 2 chunks
	li	IMW1(569)
	li	IMW0(569)
	mul	r3
					// (save result) isreg

	//dhry_1.c, line 318
// code 0x1e
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp)  reg r3
	mt	r3
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp)  reg r2
	mt	r2
	mr	r2
	ldinc	r7
	.int	_div_u32byu32
	exg	r7
	ldinc	r6
	mr	r2
	mt	r0
	mr	r0
					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Vax_Mips + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.
				// freereg r3
				// freereg r2

	//dhry_1.c, line 320
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l91
	stdec	r6

	//dhry_1.c, line 320
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 321
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Microseconds
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 321
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l92
	stdec	r6

	//dhry_1.c, line 321
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 322
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l93
	stdec	r6

	//dhry_1.c, line 322
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 323
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Dhrystones_Per_Second
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 323
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l94
	stdec	r6

	//dhry_1.c, line 323
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 324
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Vax_Mips
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 324
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l95
	stdec	r6

	//dhry_1.c, line 324
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 325
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) //static
				//statictotemp
	ldinc	r7
	.int	l96
	stdec	r6

	//dhry_1.c, line 325
// code 0x2a
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 328
// code 0x5e
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
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
	.section	.rodata
l10:
	.byte	80
	.byte	114
	.byte	111
	.byte	103
	.byte	114
	.byte	97
	.byte	109
	.byte	32
	.byte	99
	.byte	111
	.byte	109
	.byte	112
	.byte	105
	.byte	108
	.byte	101
	.byte	100
	.byte	32
	.byte	119
	.byte	105
	.byte	116
	.byte	104
	.byte	32
	.byte	39
	.byte	114
	.byte	101
	.byte	103
	.byte	105
	.byte	115
	.byte	116
	.byte	101
	.byte	114
	.byte	39
	.byte	32
	.byte	97
	.byte	116
	.byte	116
	.byte	114
	.byte	105
	.byte	98
	.byte	117
	.byte	116
	.byte	101
	.byte	10
	.byte	0
l11:
	.byte	10
	.byte	0
l13:
	.byte	80
	.byte	114
	.byte	111
	.byte	103
	.byte	114
	.byte	97
	.byte	109
	.byte	32
	.byte	99
	.byte	111
	.byte	109
	.byte	112
	.byte	105
	.byte	108
	.byte	101
	.byte	100
	.byte	32
	.byte	119
	.byte	105
	.byte	116
	.byte	104
	.byte	111
	.byte	117
	.byte	116
	.byte	32
	.byte	39
	.byte	114
	.byte	101
	.byte	103
	.byte	105
	.byte	115
	.byte	116
	.byte	101
	.byte	114
	.byte	39
	.byte	32
	.byte	97
	.byte	116
	.byte	116
	.byte	114
	.byte	105
	.byte	98
	.byte	117
	.byte	116
	.byte	101
	.byte	10
	.byte	0
l14:
	.byte	10
	.byte	0
l33:
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	51
	.byte	39
	.byte	82
	.byte	68
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	0
l20:
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	50
	.byte	39
	.byte	78
	.byte	68
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	0
l88:
	.byte	77
	.byte	101
	.byte	97
	.byte	115
	.byte	117
	.byte	114
	.byte	101
	.byte	100
	.byte	32
	.byte	116
	.byte	105
	.byte	109
	.byte	101
	.byte	32
	.byte	116
	.byte	111
	.byte	111
	.byte	32
	.byte	115
	.byte	109
	.byte	97
	.byte	108
	.byte	108
	.byte	32
	.byte	116
	.byte	111
	.byte	32
	.byte	111
	.byte	98
	.byte	116
	.byte	97
	.byte	105
	.byte	110
	.byte	32
	.byte	109
	.byte	101
	.byte	97
	.byte	110
	.byte	105
	.byte	110
	.byte	103
	.byte	102
	.byte	117
	.byte	108
	.byte	32
	.byte	114
	.byte	101
	.byte	115
	.byte	117
	.byte	108
	.byte	116
	.byte	115
	.byte	10
	.byte	0
l89:
	.byte	80
	.byte	108
	.byte	101
	.byte	97
	.byte	115
	.byte	101
	.byte	32
	.byte	105
	.byte	110
	.byte	99
	.byte	114
	.byte	101
	.byte	97
	.byte	115
	.byte	101
	.byte	32
	.byte	110
	.byte	117
	.byte	109
	.byte	98
	.byte	101
	.byte	114
	.byte	32
	.byte	111
	.byte	102
	.byte	32
	.byte	114
	.byte	117
	.byte	110
	.byte	115
	.byte	10
	.byte	0
l90:
	.byte	10
	.byte	0
l91:
	.byte	77
	.byte	105
	.byte	99
	.byte	114
	.byte	111
	.byte	115
	.byte	101
	.byte	99
	.byte	111
	.byte	110
	.byte	100
	.byte	115
	.byte	32
	.byte	102
	.byte	111
	.byte	114
	.byte	32
	.byte	111
	.byte	110
	.byte	101
	.byte	32
	.byte	114
	.byte	117
	.byte	110
	.byte	32
	.byte	116
	.byte	104
	.byte	114
	.byte	111
	.byte	117
	.byte	103
	.byte	104
	.byte	32
	.byte	68
	.byte	104
	.byte	114
	.byte	121
	.byte	115
	.byte	116
	.byte	111
	.byte	110
	.byte	101
	.byte	58
	.byte	32
	.byte	0
l92:
	.byte	37
	.byte	100
	.byte	32
	.byte	10
	.byte	0
l93:
	.byte	68
	.byte	104
	.byte	114
	.byte	121
	.byte	115
	.byte	116
	.byte	111
	.byte	110
	.byte	101
	.byte	115
	.byte	32
	.byte	112
	.byte	101
	.byte	114
	.byte	32
	.byte	83
	.byte	101
	.byte	99
	.byte	111
	.byte	110
	.byte	100
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	0
l94:
	.byte	37
	.byte	100
	.byte	32
	.byte	10
	.byte	0
l95:
	.byte	86
	.byte	65
	.byte	88
	.byte	32
	.byte	77
	.byte	73
	.byte	80
	.byte	83
	.byte	32
	.byte	114
	.byte	97
	.byte	116
	.byte	105
	.byte	110
	.byte	103
	.byte	32
	.byte	42
	.byte	32
	.byte	49
	.byte	48
	.byte	48
	.byte	48
	.byte	32
	.byte	61
	.byte	32
	.byte	37
	.byte	100
	.byte	32
	.byte	10
	.byte	0
l96:
	.byte	10
	.byte	0
l3:
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	83
	.byte	79
	.byte	77
	.byte	69
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	0
l4:
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	49
	.byte	39
	.byte	83
	.byte	84
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	0
l5:
	.byte	10
	.byte	0
l6:
	.byte	68
	.byte	104
	.byte	114
	.byte	121
	.byte	115
	.byte	116
	.byte	111
	.byte	110
	.byte	101
	.byte	32
	.byte	66
	.byte	101
	.byte	110
	.byte	99
	.byte	104
	.byte	109
	.byte	97
	.byte	114
	.byte	107
	.byte	44
	.byte	32
	.byte	86
	.byte	101
	.byte	114
	.byte	115
	.byte	105
	.byte	111
	.byte	110
	.byte	32
	.byte	50
	.byte	46
	.byte	49
	.byte	32
	.byte	40
	.byte	76
	.byte	97
	.byte	110
	.byte	103
	.byte	117
	.byte	97
	.byte	103
	.byte	101
	.byte	58
	.byte	32
	.byte	67
	.byte	41
	.byte	10
	.byte	0
l7:
	.byte	10
	.byte	0
l15:
	.byte	69
	.byte	120
	.byte	101
	.byte	99
	.byte	117
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	32
	.byte	115
	.byte	116
	.byte	97
	.byte	114
	.byte	116
	.byte	115
	.byte	44
	.byte	32
	.byte	37
	.byte	100
	.byte	32
	.byte	114
	.byte	117
	.byte	110
	.byte	115
	.byte	32
	.byte	116
	.byte	104
	.byte	114
	.byte	111
	.byte	117
	.byte	103
	.byte	104
	.byte	32
	.byte	68
	.byte	104
	.byte	114
	.byte	121
	.byte	115
	.byte	116
	.byte	111
	.byte	110
	.byte	101
	.byte	10
	.byte	0
l34:
	.byte	69
	.byte	120
	.byte	101
	.byte	99
	.byte	117
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	32
	.byte	101
	.byte	110
	.byte	100
	.byte	115
	.byte	10
	.byte	0
l35:
	.byte	10
	.byte	0
l36:
	.byte	70
	.byte	105
	.byte	110
	.byte	97
	.byte	108
	.byte	32
	.byte	118
	.byte	97
	.byte	108
	.byte	117
	.byte	101
	.byte	115
	.byte	32
	.byte	111
	.byte	102
	.byte	32
	.byte	116
	.byte	104
	.byte	101
	.byte	32
	.byte	118
	.byte	97
	.byte	114
	.byte	105
	.byte	97
	.byte	98
	.byte	108
	.byte	101
	.byte	115
	.byte	32
	.byte	117
	.byte	115
	.byte	101
	.byte	100
	.byte	32
	.byte	105
	.byte	110
	.byte	32
	.byte	116
	.byte	104
	.byte	101
	.byte	32
	.byte	98
	.byte	101
	.byte	110
	.byte	99
	.byte	104
	.byte	109
	.byte	97
	.byte	114
	.byte	107
	.byte	58
	.byte	10
	.byte	0
l37:
	.byte	10
	.byte	0
l38:
	.byte	73
	.byte	110
	.byte	116
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l39:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l40:
	.byte	66
	.byte	111
	.byte	111
	.byte	108
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l41:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l42:
	.byte	67
	.byte	104
	.byte	95
	.byte	49
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	99
	.byte	10
	.byte	0
l43:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	99
	.byte	10
	.byte	0
l44:
	.byte	67
	.byte	104
	.byte	95
	.byte	50
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	99
	.byte	10
	.byte	0
l45:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	99
	.byte	10
	.byte	0
l46:
	.byte	65
	.byte	114
	.byte	114
	.byte	95
	.byte	49
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	91
	.byte	56
	.byte	93
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l47:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l48:
	.byte	65
	.byte	114
	.byte	114
	.byte	95
	.byte	50
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	91
	.byte	56
	.byte	93
	.byte	91
	.byte	55
	.byte	93
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l49:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	78
	.byte	117
	.byte	109
	.byte	98
	.byte	101
	.byte	114
	.byte	95
	.byte	79
	.byte	102
	.byte	95
	.byte	82
	.byte	117
	.byte	110
	.byte	115
	.byte	32
	.byte	43
	.byte	32
	.byte	49
	.byte	48
	.byte	10
	.byte	0
l50:
	.byte	80
	.byte	116
	.byte	114
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	45
	.byte	62
	.byte	10
	.byte	0
l51:
	.byte	32
	.byte	32
	.byte	80
	.byte	116
	.byte	114
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l52:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	40
	.byte	105
	.byte	109
	.byte	112
	.byte	108
	.byte	101
	.byte	109
	.byte	101
	.byte	110
	.byte	116
	.byte	97
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	45
	.byte	100
	.byte	101
	.byte	112
	.byte	101
	.byte	110
	.byte	100
	.byte	101
	.byte	110
	.byte	116
	.byte	41
	.byte	10
	.byte	0
l53:
	.byte	32
	.byte	32
	.byte	68
	.byte	105
	.byte	115
	.byte	99
	.byte	114
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l54:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l55:
	.byte	32
	.byte	32
	.byte	69
	.byte	110
	.byte	117
	.byte	109
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l56:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l57:
	.byte	32
	.byte	32
	.byte	73
	.byte	110
	.byte	116
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l58:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l59:
	.byte	32
	.byte	32
	.byte	83
	.byte	116
	.byte	114
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	115
	.byte	10
	.byte	0
l60:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	83
	.byte	79
	.byte	77
	.byte	69
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	10
	.byte	0
l61:
	.byte	78
	.byte	101
	.byte	120
	.byte	116
	.byte	95
	.byte	80
	.byte	116
	.byte	114
	.byte	95
	.byte	71
	.byte	108
	.byte	111
	.byte	98
	.byte	45
	.byte	62
	.byte	10
	.byte	0
l62:
	.byte	32
	.byte	32
	.byte	80
	.byte	116
	.byte	114
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l63:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	40
	.byte	105
	.byte	109
	.byte	112
	.byte	108
	.byte	101
	.byte	109
	.byte	101
	.byte	110
	.byte	116
	.byte	97
	.byte	116
	.byte	105
	.byte	111
	.byte	110
	.byte	45
	.byte	100
	.byte	101
	.byte	112
	.byte	101
	.byte	110
	.byte	100
	.byte	101
	.byte	110
	.byte	116
	.byte	41
	.byte	44
	.byte	32
	.byte	115
	.byte	97
	.byte	109
	.byte	101
	.byte	32
	.byte	97
	.byte	115
	.byte	32
	.byte	97
	.byte	98
	.byte	111
	.byte	118
	.byte	101
	.byte	10
	.byte	0
l64:
	.byte	32
	.byte	32
	.byte	68
	.byte	105
	.byte	115
	.byte	99
	.byte	114
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l65:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l66:
	.byte	32
	.byte	32
	.byte	69
	.byte	110
	.byte	117
	.byte	109
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l67:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l68:
	.byte	32
	.byte	32
	.byte	73
	.byte	110
	.byte	116
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l69:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l70:
	.byte	32
	.byte	32
	.byte	83
	.byte	116
	.byte	114
	.byte	95
	.byte	67
	.byte	111
	.byte	109
	.byte	112
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	115
	.byte	10
	.byte	0
l71:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	83
	.byte	79
	.byte	77
	.byte	69
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	10
	.byte	0
l72:
	.byte	73
	.byte	110
	.byte	116
	.byte	95
	.byte	49
	.byte	95
	.byte	76
	.byte	111
	.byte	99
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l73:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l74:
	.byte	73
	.byte	110
	.byte	116
	.byte	95
	.byte	50
	.byte	95
	.byte	76
	.byte	111
	.byte	99
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l75:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l76:
	.byte	73
	.byte	110
	.byte	116
	.byte	95
	.byte	51
	.byte	95
	.byte	76
	.byte	111
	.byte	99
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l77:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l78:
	.byte	69
	.byte	110
	.byte	117
	.byte	109
	.byte	95
	.byte	76
	.byte	111
	.byte	99
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l79:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l80:
	.byte	83
	.byte	116
	.byte	114
	.byte	95
	.byte	49
	.byte	95
	.byte	76
	.byte	111
	.byte	99
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	115
	.byte	10
	.byte	0
l81:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	49
	.byte	39
	.byte	83
	.byte	84
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	10
	.byte	0
l82:
	.byte	83
	.byte	116
	.byte	114
	.byte	95
	.byte	50
	.byte	95
	.byte	76
	.byte	111
	.byte	99
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	37
	.byte	115
	.byte	10
	.byte	0
l83:
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	32
	.byte	115
	.byte	104
	.byte	111
	.byte	117
	.byte	108
	.byte	100
	.byte	32
	.byte	98
	.byte	101
	.byte	58
	.byte	32
	.byte	32
	.byte	32
	.byte	68
	.byte	72
	.byte	82
	.byte	89
	.byte	83
	.byte	84
	.byte	79
	.byte	78
	.byte	69
	.byte	32
	.byte	80
	.byte	82
	.byte	79
	.byte	71
	.byte	82
	.byte	65
	.byte	77
	.byte	44
	.byte	32
	.byte	50
	.byte	39
	.byte	78
	.byte	68
	.byte	32
	.byte	83
	.byte	84
	.byte	82
	.byte	73
	.byte	78
	.byte	71
	.byte	10
	.byte	0
l84:
	.byte	10
	.byte	0
l85:
	.byte	85
	.byte	115
	.byte	101
	.byte	114
	.byte	32
	.byte	116
	.byte	105
	.byte	109
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
	.section	.text.d1e2353
	.global	_Proc_1
_Proc_1:
	exg	r6
	stmpdec	r6
	stmpdec	r2
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// allocreg r5
				// allocreg r2

	//dhry_1.c, line 338
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_1.c, line 338
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  reg r2
	mt	r2
					// (save temp) isreg
	mr	r5
				//save_temp done

	//dhry_1.c, line 343
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
			//Swapping dest and counter registers
// Copying 12 words and 0 bytes to 
					// (load_temp - type 12) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	mr	r0
	mt	r2
	stdec	r6
// Copying 12 words to 
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	addt	r2
	mr	r1
.cpywordloop4:
	ldinc	r0
	stinc	r2
	mt	r2
	cmp	r1
	cond	NEQ
		li	IMW0(PCREL(.cpywordloop4))
		add	r7
	ldinc	r6
	mr	r2
				// allocreg r4

	//dhry_1.c, line 344
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r4
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r4
					// (save result) isreg

	//dhry_1.c, line 344
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) store
	st	r4
				//save_temp done
				// allocreg r3

	//dhry_1.c, line 346
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r2
	mt	r2
	mr	r3
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r3
					// (save result) isreg

	//dhry_1.c, line 346
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
					// (save temp) store
	st	r3
				//save_temp done
				// freereg r4
				// freereg r3

	//dhry_1.c, line 347
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store
	st	r2
				//save_temp done

	//dhry_1.c, line 348
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//dhry_1.c, line 348
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_3
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 351
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 351
// code 0x44
					// (test)
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	and	r2
				// freereg r2

	//dhry_1.c, line 351
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l105)-1)
	li	IMW0(PCREL(l105))
		add	r7
				// allocreg r3

	//dhry_1.c, line 354
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r3
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r3
					// (save result) isreg
				// allocreg r2

	//dhry_1.c, line 354
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  reg r5
	mt	r5
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 354
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 6 in 1 chunks
	li	IMW0(6)
					// (save temp) store
	st	r2
				//save_temp done

	//dhry_1.c, line 356
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r3
	mt	r3
	stdec	r6
				// freereg r3
				// allocreg r3

	//dhry_1.c, line 356
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r3
					// (objtotemp)  const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r3
					// (save result) isreg

	//dhry_1.c, line 356
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r3
	stdec	r6
				// freereg r3

	//dhry_1.c, line 356
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_6
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 357
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
	ldt
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store
	st	r5
				//save_temp done

	//dhry_1.c, line 359
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6

	//dhry_1.c, line 359
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	stdec	r6

	//dhry_1.c, line 359
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  deref 
	//(offset 0)
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 359
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_7
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//dhry_1.c, line 362
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l106)-1)
	li	IMW0(PCREL(l106))
	add	r7
l105: # 
				// allocreg r2

	//dhry_1.c, line 362
// code 0x2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_1.c, line 362
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r1
// Copying 12 words and 0 bytes to Ptr_Val_Par
					// (load_temp - type 12) not varadr
					// (objtotemp)  deref 
//FIXME - unhandled type 12
	mr	r0
	mt	r2
	stdec	r6
// Copying 12 words to Ptr_Val_Par
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	addt	r1
	mr	r2
.cpyPtr_Val_Parwordloop5:
	ldinc	r0
	stinc	r1
	mt	r1
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpyPtr_Val_Parwordloop5))
		add	r7
	ldinc	r6
	mr	r2
				// freereg r2
l106: # 
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
	.section	.text.d1e2353
	.global	_Proc_2
_Proc_2:
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
					// (objtotemp)  var, auto|reg
		//sizemod based on type 0x3
	ld	r6
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

	//dhry_1.c, line 376
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  deref 
	//(offset 0)
	ld	r4
	mr	r3
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	add	r3
					// (save result) isreg
l113: # 
				// allocreg r2

	//dhry_1.c, line 378
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ch_1_Glob
		//sizemod based on type 0x1
	byt
	ldt
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

	//dhry_1.c, line 378
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r2
				// freereg r2

	//dhry_1.c, line 378
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l112)-1)
	li	IMW0(PCREL(l112))
		add	r7

	//dhry_1.c, line 381
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//dhry_1.c, line 382
// code 0x1c
					// (bitwise) loadreg
					// (objtotemp)  reg r3
	mt	r3
	mr	r0
					// (objtotemp)  extern
	ldinc	r7
	.int	_Int_Glob
		//sizemod based on type 0x3
	ldt
	sub	r0
					// (save result) store reg
// Store_reg to type 0x3
	mt	r0
	st	r4

	//dhry_1.c, line 383
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
l112: # 

	//dhry_1.c, line 385
// code 0x44
					// (test)
					// (objtotemp)  reg r5
	mt	r5
	and	r5

	//dhry_1.c, line 385
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l113)-1)
	li	IMW0(PCREL(l113))
		add	r7
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
		//r3: no
		//r4: no
		//r5: no
		//r6: yes
		//r7: yes
		//tmp: yes
	.section	.text.d1e2353
	.global	_Proc_3
_Proc_3:
	stdec	r6
	mt	r2
	stdec	r6

	//dhry_1.c, line 397
// code 0x44
					// (test)
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0xa
	ldt

	//dhry_1.c, line 397
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l117)-1)
	li	IMW0(PCREL(l117))
		add	r7

	//dhry_1.c, line 399
// code 0x2
					// (a/p assign)
					// (prepobj r1) deref
				// var FIXME - deref? reg 
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r1
					// (load_temp - type 10) not varadr
					// (objtotemp)  deref 
					// (prepobj tmp) deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
	ldt
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store
	st	r1
				//save_temp done
l117: # 
				// allocreg r2

	//dhry_1.c, line 400
// code 0x1b
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0x3
	ldt
	mr	r2
					// (objtotemp)  const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 400
// code 0x4e
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)  reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 400
// code 0x4e
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)  extern
	ldinc	r7
	.int	_Int_Glob
		//sizemod based on type 0x3
	ldt
	stdec	r6

	//dhry_1.c, line 400
// code 0x4e
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp)  const
				// constant: a in 1 chunks
	li	IMW0(10)
	stdec	r6

	//dhry_1.c, line 400
// code 0x2a
					//call
	ldinc	r7
	.int	_Proc_7
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6

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
	.section	.text.d1e2353
	.global	_Proc_4
_Proc_4:
	stdec	r6
	mt	r2
	stdec	r6
				// allocreg r2

	//dhry_1.c, line 410
// code 0x32
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp)  extern
	ldinc	r7
	.int	_Ch_1_Glob
		//sizemod based on type 0x1
	byt
	ldt
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

	//dhry_1.c, line 410
// code 0x4d
					// (compare) (q1 signed) (q2 signed)					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r2
				// freereg r2

	//dhry_1.c, line 410
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l119)-1)
	li	IMW0(PCREL(l119))
		add	r7
				// allocreg r2

	//dhry_1.c, line 410
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

	//dhry_1.c, line 410
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l120)-1)
	li	IMW0(PCREL(l120))
	add	r7
l119: # 

	//dhry_1.c, line 410
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
l120: # 

	//dhry_1.c, line 411
// code 0x10
					// (bitwise) loadreg
					// (objtotemp)  extern
	ldinc	r7
	.int	_Bool_Glob
		//sizemod based on type 0x3
	ldt
	mr	r0
					// (objtotemp)  reg r2
	mt	r2
	or	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob + 4
	stmpdec	r0
 // WARNING - check that 4 has been added.

	//dhry_1.c, line 412
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ch_2_Glob
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done
				// freereg r2
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
	.section	.text.d1e2353
	.global	_Proc_5
_Proc_5:
	stdec	r6

	//dhry_1.c, line 420
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp)  const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) store
	stbinc	r1
//Disposable, postinc doesn't matter.
				//save_temp done

	//dhry_1.c, line 421
// code 0x2
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp)  const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r1
				//save_temp done
	ldinc	r6
	mr	r7

// stacksize=0+??
	.globl	_Reg
	.section	.data
	.align	4
_Reg:
	.int	0
	.globl	_Number_Of_Runs
	.align	4
_Number_Of_Runs:
	.int	25000
	.globl	_strcpy
	.globl	_small_printf
	.globl	_Ptr_Glob
	.section	.bss
	.global	_Ptr_Glob
	.lcomm	_Ptr_Glob,4
	.globl	_Next_Ptr_Glob
	.global	_Next_Ptr_Glob
	.lcomm	_Next_Ptr_Glob,4
	.globl	_Int_Glob
	.global	_Int_Glob
	.lcomm	_Int_Glob,4
	.globl	_Bool_Glob
	.global	_Bool_Glob
	.lcomm	_Bool_Glob,4
	.globl	_Ch_1_Glob
	.global	_Ch_1_Glob
	.lcomm	_Ch_1_Glob,1
	.globl	_Ch_2_Glob
	.global	_Ch_2_Glob
	.lcomm	_Ch_2_Glob,1
	.globl	_Arr_1_Glob
	.global	_Arr_1_Glob
	.lcomm	_Arr_1_Glob,200
	.globl	_Arr_2_Glob
	.global	_Arr_2_Glob
	.lcomm	_Arr_2_Glob,10000
	.globl	_Func_1
	.globl	_Begin_Time
	.global	_Begin_Time
	.lcomm	_Begin_Time,4
	.globl	_End_Time
	.global	_End_Time
	.lcomm	_End_Time,4
	.globl	_User_Time
	.global	_User_Time
	.lcomm	_User_Time,4
	.globl	_Microseconds
	.global	_Microseconds
	.lcomm	_Microseconds,4
	.globl	_Dhrystones_Per_Second
	.global	_Dhrystones_Per_Second
	.lcomm	_Dhrystones_Per_Second,4
	.globl	_Vax_Mips
	.global	_Vax_Mips
	.lcomm	_Vax_Mips,4
	.globl	_rec1
	.global	_rec1
	.lcomm	_rec1,48
	.globl	_rec2
	.global	_rec2
	.lcomm	_rec2,48
	.globl	_Str_1_Loc
	.global	_Str_1_Loc
	.lcomm	_Str_1_Loc,31
	.globl	_Str_2_Loc
	.global	_Str_2_Loc
	.lcomm	_Str_2_Loc,31
	.globl	_Func_2
	.globl	_Proc_7
	.globl	_Proc_8
	.globl	_Proc_6
