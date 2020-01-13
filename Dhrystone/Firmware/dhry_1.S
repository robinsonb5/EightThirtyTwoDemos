#include "assembler.pp"

	//registers used:
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
// clearing tmp
// clearing r0

	//dhry_1.c, line 86
					//setreturn
					// (objtotemp) flags 21 // const/deref
					// (prepobj tmp)// deref
			// const
				// constant: ffffffc8 in 2 chunks
	li	IMW1(-56)
	li	IMW0(-56)
		//sizemod based on type 0x4
	ldt
	mr	r0
	ldinc	r6
	mr	r7

	//registers used:
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// constant: fffffff0 in 1 chunks
	li	IMW0(-16)
	add	r6
// clearing tmp
// clearing r0
				// allocreg r5
				// allocreg r4
				// allocreg r3
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 102 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r1

	//dhry_1.c, line 125
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_Next_Ptr_Glob
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec1
// clearing tmp
// extern pe is varadr
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 126
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec2
// clearing tmp
// extern pe is varadr
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 128
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_rec2
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec1
// clearing tmp
// extern pe is varadr
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 129
					// (a/p assign)
					// (prepobj r0) extern (offset 4)
	ldinc	r7
	.int	_rec2 + 4
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 130
					// (a/p assign)
					// (prepobj r0) extern (offset 8)
	ldinc	r7
	.int	_rec2 + 8
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 131
					// (a/p assign)
					// (prepobj r0) extern (offset 12)
	ldinc	r7
	.int	_rec2 + 12
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 28 in 2 chunks
	li	IMW1(40)
	li	IMW0(40)
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 135
					// (a/p assign)
// clearing r0
// clearing tmp
//using reg r2 for dst pointer
//using reg noreg for counter
					// (prepobj r2) extern (offset 16)
	ldinc	r7
	.int	_rec2 + 16
// clearing tmp
// extern pe not varadr
	mr	r2
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to rec2
					// (objtotemp) flags 2 //static not varadr
				//statictotemp
	ldinc	r7
	.int	l3+0
// clearing tmp
	mr	r0
// Copying 7 words to rec2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
// Copying 3 byte tail to rec2
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2

	//dhry_1.c, line 136
					// (a/p assign)
// clearing r0
// clearing tmp
//using reg r2 for dst pointer
//using reg noreg for counter
					// (prepobj r2) extern (offset 0)
	ldinc	r7
	.int	_Str_1_Loc
// clearing tmp
// extern pe not varadr
	mr	r2
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to Str_1_Loc
					// (objtotemp) flags 2 //static not varadr
				//statictotemp
	ldinc	r7
	.int	l4+0
// clearing tmp
	mr	r0
// Copying 7 words to Str_1_Loc
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
// Copying 3 byte tail to Str_1_Loc
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2

	//dhry_1.c, line 138
					// (a/p assign)
					// (prepobj r0) extern (offset 1628)
	ldinc	r7
	.int	_Arr_2_Glob + 1628
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: a in 1 chunks
	li	IMW0(10)
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 143
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l5+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 143
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 144
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l6+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 144
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 145
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l7+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 145
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 146
					// (test)
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Reg
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt

	//dhry_1.c, line 146
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l9)-1)
	li	IMW0(PCREL(l9)-0)
// clearing tmp
		add	r7
// clearing tmp

	//dhry_1.c, line 148
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l10+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 148
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 149
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l11+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 149
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 152
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12)-0)
// clearing tmp
// clearing tmp
	add	r7
l9: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 153
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l13+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 153
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 154
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l14+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 154
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
l12: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 158
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Number_Of_Runs
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 158
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l15+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 158
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 173
					//call
	ldinc	r7
	.int	__readMilliseconds
// clearing tmp
	exg	r7

// clearing tmp

	//dhry_1.c, line 173
					// (getreturn)					// (save result) // Store_reg to type 0x4
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Begin_Time + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp

	//dhry_1.c, line 175
					// (a/p assign)
					// (prepobj r0) reg r4 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_1.c, line 176
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Number_Of_Runs
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r0

	//dhry_1.c, line 176
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l100)-1)
	li	IMW0(PCREL(l100)-0)
// clearing tmp
		add	r7
// clearing tmp
				// freereg r1
l97: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 177
					//call
	ldinc	r7
	.int	_Proc_5
// clearing tmp
	exg	r7

// clearing tmp

	//dhry_1.c, line 178
					//call
	ldinc	r7
	.int	_Proc_4
// clearing tmp
	exg	r7

// clearing tmp

	//dhry_1.c, line 180
					// (a/p assign)
					// (prepobj r0) var, auto|reg
	mt	r6
// clearing tmp
	mr	r0

					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 181
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_1.c, line 182
					// (a/p assign)
// clearing r0
// clearing tmp
//using reg r2 for dst pointer
//using reg noreg for counter
					// (prepobj r2) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
// clearing tmp
// extern pe not varadr
	mr	r2
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to Str_2_Loc
					// (objtotemp) flags 2 //static not varadr
				//statictotemp
	ldinc	r7
	.int	l20+0
// clearing tmp
	mr	r0
// Copying 7 words to Str_2_Loc
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
// Copying 3 byte tail to Str_2_Loc
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2

	//dhry_1.c, line 183
					// (a/p assign)
					// (prepobj r0) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
// clearing tmp
	mr	r0

					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store
	st	r0
				//save_temp done

	//dhry_1.c, line 184
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
// clearing tmp
// extern pe is varadr
	stdec	r6

	//dhry_1.c, line 184
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Str_1_Loc
// clearing tmp
// extern pe is varadr
	stdec	r6

	//dhry_1.c, line 184
					//call
	ldinc	r7
	.int	_Func_2
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 184
					// (test)
					// (objtotemp) flags 4a // reg r0
	mt	r0
	and	r0
				// freereg r1

	//dhry_1.c, line 184
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l21)-1)
	li	IMW0(PCREL(l21)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_1.c, line 184
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r1
				//save_temp done

	//dhry_1.c, line 184
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l22)-1)
	li	IMW0(PCREL(l22)-0)
// clearing tmp
// clearing tmp
	add	r7
l21: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 184
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r1
				//save_temp done
l22: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 184
					// (a/p assign)
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob + 4
// clearing tmp
// extern pe not varadr
		//sizemod based on type 0x3
	stmpdec	r1
// clearing tmp

	//dhry_1.c, line 186
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sgn
	cmp	r3

	//dhry_1.c, line 186
	cond	LE
					//conditional branch reversed			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l101)-1)
	li	IMW0(PCREL(l101)-0)
// clearing tmp
		add	r7
// clearing tmp
				// freereg r1
l98: # 
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_1.c, line 188
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	mul	r1
					// (save result) // isreg

	//dhry_1.c, line 188
					// (bitwise) loadreg
	//ops: 2, 4, 1
					// (objtotemp) flags 4a // reg r1
	mt	r1
	mr	r0
					// (objtotemp) flags 42 // reg r3
	mt	r3
	sub	r0
					// (save result) // Store_reg to type 0x3
// clearing tmp
// clearing r0
					// (prepobj tmp) var, auto|reg
				// constant: 10 in 1 chunks
	li	IMW0(16)
	addt	r6
// clearing tmp
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp
				// freereg r1
				// allocreg r1

	//dhry_1.c, line 190
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
// clearing tmp
	stdec	r6
				// freereg r1

	//dhry_1.c, line 190
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 42 // reg r3
	mt	r3
	stdec	r6

	//dhry_1.c, line 190
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 190
					//call
	ldinc	r7
	.int	_Proc_7
// clearing tmp
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6

// clearing tmp

	//dhry_1.c, line 192
					// (bitwise) loadreg
	//ops: 0, 0, 1
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r0
					// (save result) // Store_reg to type 0x3
// clearing tmp
// clearing r0
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
// clearing tmp
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp

	//dhry_1.c, line 186
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sgn
	cmp	r3

	//dhry_1.c, line 186
	cond	SGT
					//conditional branch reversed			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l98)-1)
	li	IMW0(PCREL(l98)-0)
// clearing tmp
		add	r7
// clearing tmp
l101: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 195
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 195
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 195
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Arr_2_Glob
// clearing tmp
// extern pe is varadr
	stdec	r6

	//dhry_1.c, line 195
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Arr_1_Glob
// clearing tmp
// extern pe is varadr
	stdec	r6

	//dhry_1.c, line 195
					//call
	ldinc	r7
	.int	_Proc_8
// clearing tmp
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6

// clearing tmp

	//dhry_1.c, line 197
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0xa
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 197
					//call
	ldinc	r7
	.int	_Proc_1
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 198
					// (a/p assign)
					// (prepobj r0) reg r5 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r1

	//dhry_1.c, line 200
					//FIXME convert
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ch_2_Glob
// clearing tmp
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 200
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r1
				// freereg r1

	//dhry_1.c, line 200
	cond	SLT
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l102)-1)
	li	IMW0(PCREL(l102)-0)
// clearing tmp
		add	r7
// clearing tmp
l99: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 201
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 43 in 2 chunks
	li	IMW1(67)
	li	IMW0(67)
	stdec	r6
				// allocreg r1

	//dhry_1.c, line 201
					//FIXME convert
					// (objtotemp) flags 42 // reg r5
	mt	r5
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 201
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 201
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

	//dhry_1.c, line 201
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	cmp	r0
				// freereg r1

	//dhry_1.c, line 201
	cond	NEQ
					//conditional branch reversed			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l32)-1)
	li	IMW0(PCREL(l32)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_1.c, line 204
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
// clearing tmp
	stdec	r6
				// freereg r1

	//dhry_1.c, line 204
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 204
					//call
	ldinc	r7
	.int	_Proc_6
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 205
					// (a/p assign)
// clearing r0
// clearing tmp
//using reg r2 for dst pointer
//using reg noreg for counter
					// (prepobj r2) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
// clearing tmp
// extern pe not varadr
	mr	r2
// (char with size!=1 -> array of unknown type)
// Copying 7 words and 3 bytes to Str_2_Loc
					// (objtotemp) flags 2 //static not varadr
				//statictotemp
	ldinc	r7
	.int	l33+0
// clearing tmp
	mr	r0
// Copying 7 words to Str_2_Loc
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
	ldinc	r0
	stinc	r2
// Copying 3 byte tail to Str_2_Loc
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2
	ldbinc	r0
	stbinc	r2

	//dhry_1.c, line 206
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 42 // reg r4
	mt	r4
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_1.c, line 207
					// (a/p assign)
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob + 4
// clearing tmp
// extern pe not varadr
		//sizemod based on type 0x3
	stmpdec	r4
// clearing tmp
l32: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 200
					// (bitwise) loadreg
	//ops: 6, 0, 6
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) // isreg
				// allocreg r2

	//dhry_1.c, line 200
					//FIXME convert
					// (objtotemp) flags 42 // reg r5
	mt	r5
	mr	r2
// clearing tmp
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
					// (save result) // isreg
				// allocreg r1

	//dhry_1.c, line 200
					//FIXME convert
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ch_2_Glob
// clearing tmp
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 200
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 4a // reg r1
	mt	r1
	sgn
	cmp	r2
				// freereg r2
				// freereg r1

	//dhry_1.c, line 200
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l99)-1)
	li	IMW0(PCREL(l99)-0)
// clearing tmp
		add	r7
// clearing tmp
l102: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 211
					// (bitwise) loadreg
	//ops: 4, 0, 4
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mul	r3
					// (save result) // isreg

	//dhry_1.c, line 212
					// (bitwise) loadreg
	//ops: 4, 0, 1
	//Call division routine
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6
					// (objtotemp) flags 42 // reg r3
	mt	r3
	mr	r1
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r2
	ldinc	r7
	.int	_div_s32bys32
	exg	r7
// clearing r0
	ldinc	r6
	mr	r2
// clearing tmp
	ldinc	r6
	mr	r1
// clearing tmp
					// (save result) // Store_reg to type 0x3
// clearing tmp
// clearing r0
					// (prepobj tmp) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
// clearing tmp
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp
				// allocreg r1

	//dhry_1.c, line 213
					// (bitwise) loadreg
	//ops: 4, 0, 2
					// (objtotemp) flags 42 // reg r3
	mt	r3
	mr	r1
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	sub	r1
					// (save result) // isreg

	//dhry_1.c, line 213
					// (bitwise) loadreg
	//ops: 2, 0, 2
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	mul	r1
					// (save result) // isreg

	//dhry_1.c, line 213
					// (bitwise) loadreg
	//ops: 2, 0, 4
					// (objtotemp) flags 4a // reg r1
	mt	r1
	mr	r3
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sub	r3
					// (save result) // isreg
				// freereg r1
				// allocreg r1

	//dhry_1.c, line 215
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) var, auto|reg
	mt	r6
// clearing tmp
	stdec	r6
				// freereg r1

	//dhry_1.c, line 215
					//call
	ldinc	r7
	.int	_Proc_2
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 176
					// (bitwise) loadreg
	//ops: 5, 0, 5
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r4
					// (save result) // isreg

	//dhry_1.c, line 176
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Number_Of_Runs
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	sgn
	cmp	r4

	//dhry_1.c, line 176
	cond	LE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l97)-1)
	li	IMW0(PCREL(l97)-0)
// clearing tmp
		add	r7
// clearing tmp
l100: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 233
					//call
	ldinc	r7
	.int	__readMilliseconds
// clearing tmp
	exg	r7

// clearing tmp

	//dhry_1.c, line 233
					// (getreturn)					// (save result) // Store_reg to type 0x4
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_End_Time + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp

	//dhry_1.c, line 237
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l34+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 237
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 238
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l35+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 238
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 239
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l36+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 239
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 240
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l37+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 240
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 241
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Int_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 241
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l38+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 241
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 242
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	stdec	r6

	//dhry_1.c, line 242
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l39+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 242
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 243
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Bool_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 243
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l40+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 243
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 244
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 244
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l41+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 244
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 245
					//FIXME convert
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ch_1_Glob
// clearing tmp
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 245
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 245
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l42+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 245
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 246
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	stdec	r6

	//dhry_1.c, line 246
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l43+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 246
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 247
					//FIXME convert
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ch_2_Glob
// clearing tmp
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 247
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 247
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l44+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 247
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 248
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
	stdec	r6

	//dhry_1.c, line 248
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l45+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 248
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 249
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Arr_1_Glob + 32
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 249
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l46+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 249
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 250
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	stdec	r6

	//dhry_1.c, line 250
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l47+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 250
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 251
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Arr_2_Glob + 1628
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 251
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l48+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 251
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 252
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l49+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 252
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 253
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l50+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 253
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 254
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 22 // deref 
					// (prepobj tmp)// deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	stdec	r6

	//dhry_1.c, line 254
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l51+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 254
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 255
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l52+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 255
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 256
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 256
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 256
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l53+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 256
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 257
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 257
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l54+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 257
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 258
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 258
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 258
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l55+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 258
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 259
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	stdec	r6

	//dhry_1.c, line 259
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l56+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 259
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 260
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 260
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 260
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l57+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 260
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 261
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 11 in 1 chunks
	li	IMW0(17)
	stdec	r6

	//dhry_1.c, line 261
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l58+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 261
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 262
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 262
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 262
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l59+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 262
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 263
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l60+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 263
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 264
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l61+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 264
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 265
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 22 // deref 
					// (prepobj tmp)// deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Next_Ptr_Glob
// clearing tmp
	ldt
		//sizemod based on type 0x3
	ldt
//marker 2
	stdec	r6

	//dhry_1.c, line 265
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l62+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 265
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 266
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l63+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 266
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 267
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Next_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 267
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 267
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l64+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 267
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 268
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 268
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l65+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 268
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 269
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Next_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 269
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 269
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l66+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 269
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 270
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 270
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l67+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 270
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 271
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Next_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 271
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 271
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l68+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 271
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 272
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	stdec	r6

	//dhry_1.c, line 272
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l69+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 272
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 274
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Next_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 274
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 274
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l70+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 274
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 275
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l71+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 275
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 276
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	stdec	r6

	//dhry_1.c, line 276
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l72+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 276
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 277
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	stdec	r6

	//dhry_1.c, line 277
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l73+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 277
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 278
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 42 // reg r3
	mt	r3
	stdec	r6

	//dhry_1.c, line 278
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l74+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 278
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 279
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: d in 1 chunks
	li	IMW0(13)
	stdec	r6

	//dhry_1.c, line 279
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l75+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 279
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 280
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 280
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l76+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 280
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 281
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	stdec	r6

	//dhry_1.c, line 281
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l77+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 281
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 282
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 282
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l78+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 282
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 283
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 283
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l79+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 283
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 284
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Str_1_Loc
// clearing tmp
// extern pe is varadr
	stdec	r6

	//dhry_1.c, line 284
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l80+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 284
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 285
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l81+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 285
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 286
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
// clearing tmp
// extern pe is varadr
	stdec	r6

	//dhry_1.c, line 286
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l82+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 286
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 287
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l83+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 287
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 288
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l84+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 288
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 291
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_End_Time
// clearing tmp
		//sizemod based on type 0x4
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Begin_Time
// clearing tmp
		//sizemod based on type 0x4
	//extern deref
	ldt
	sub	r1
					// (save result) // isreg
					// (a/p assign)
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_User_Time + 4
// clearing tmp
// extern pe not varadr
		//sizemod based on type 0x4
	stmpdec	r1
// clearing tmp

	//dhry_1.c, line 292
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 292
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l85+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 292
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 294
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_User_Time
// clearing tmp
		//sizemod based on type 0x4
	//extern deref
	ldt
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 78 in 2 chunks
	li	IMW1(120)
	li	IMW0(120)
	sgn
	cmp	r0

	//dhry_1.c, line 294
	cond	GE
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l87)-1)
	li	IMW0(PCREL(l87)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_1.c, line 296
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l88+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 296
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 297
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l89+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 297
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 298
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l90+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 298
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
				// freereg r1
				// freereg r3
l87: # 
// clearing tmp
// clearing r0
				// allocreg r1
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_User_Time
// clearing tmp
		//sizemod based on type 0x4
	//extern deref
	ldt
					// (save temp) isreg
	mr	r1
				//save_temp done
				// allocreg r2

	//dhry_1.c, line 316
					// (bitwise) loadreg
	//ops: 2, 0, 3
					// (objtotemp) flags 4a // reg r1
	mt	r1
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: 3e8 in 2 chunks
	li	IMW1(1000)
	li	IMW0(1000)
	mul	r2
					// (save result) // isreg

	//dhry_1.c, line 316
					// (bitwise) loadreg
	//ops: 3, 0, 1
	//Call division routine
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6
					// (objtotemp) flags 4a // reg r2
	mt	r2
	mr	r1
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Number_Of_Runs
// clearing tmp
		//sizemod based on type 0x4
	//extern deref
	ldt
	mr	r2
	ldinc	r7
	.int	_div_s32bys32
	exg	r7
// clearing r0
	ldinc	r6
	mr	r2
// clearing tmp
	ldinc	r6
	mr	r1
// clearing tmp
					// (save result) // Store_reg to type 0x4
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Microseconds + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp
				// freereg r2
				// allocreg r2
					// (a/p assign)
					// (prepobj r0) reg r2 - no need to prep
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Number_Of_Runs
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r3

	//dhry_1.c, line 317
					// (bitwise) loadreg
	//ops: 3, 0, 4
					// (objtotemp) flags 4a // reg r2
	mt	r2
	mr	r3
					// (objtotemp) flags 1 // const
				// constant: 3e8 in 2 chunks
	li	IMW1(1000)
	li	IMW0(1000)
	mul	r3
					// (save result) // isreg

	//dhry_1.c, line 317
					// (bitwise) loadreg
	//ops: 4, 2, 1
	//Call division routine
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6
					// (objtotemp) flags 4a // reg r3
	mt	r3
	exg	r1
	mr	r2
	ldinc	r7
	.int	_div_s32bys32
	exg	r7
// clearing r0
	ldinc	r6
	mr	r2
// clearing tmp
	ldinc	r6
	mr	r1
// clearing tmp
					// (save result) // Store_reg to type 0x4
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Dhrystones_Per_Second + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp
				// freereg r3

	//dhry_1.c, line 318
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 239 in 2 chunks
	li	IMW1(569)
	li	IMW0(569)
	mul	r2
					// (save result) // isreg

	//dhry_1.c, line 318
					// (bitwise) loadreg
	//ops: 3, 2, 1
	//Call division routine
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6
					// (objtotemp) flags 4a // reg r2
	mt	r2
	exg	r1
	mr	r2
	ldinc	r7
	.int	_div_s32bys32
	exg	r7
// clearing r0
	ldinc	r6
	mr	r2
// clearing tmp
	ldinc	r6
	mr	r1
// clearing tmp
					// (save result) // Store_reg to type 0x4
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Vax_Mips + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp
				// freereg r2
				// freereg r1

	//dhry_1.c, line 320
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l91+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 320
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 321
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Microseconds
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 321
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l92+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 321
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 322
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l93+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 322
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 323
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Dhrystones_Per_Second
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 323
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l94+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 323
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 324
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Vax_Mips
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 324
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l95+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 324
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 325
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 82 					// (prepobj tmp) static
	ldinc	r7
	.int	l96+0
// static pe is varadr
	stdec	r6

	//dhry_1.c, line 325
					//call
	ldinc	r7
	.int	_printf
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp

	//dhry_1.c, line 328
					//setreturn
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	mr	r0
				// freereg r4
				// freereg r5
				// constant: fffffff0 in 1 chunks
	li	IMW0(-16)
	sub	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
// clearing tmp
// clearing r0
				// allocreg r5
					// (a/p assign)
					// (prepobj r0) reg r5 - no need to prep
					// (objtotemp) flags 102 // var, auto|reg
		//sizemod based on type 0xa
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
				// allocreg r3

	//dhry_1.c, line 338
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 62 // deref 
	ld	r5
					// (save temp) isreg
	mr	r3
				//save_temp done

	//dhry_1.c, line 338
					// (a/p assign)
					// (prepobj r0) reg r4 - no need to prep
					// (objtotemp) flags 4a // reg r3
	mt	r3
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_1.c, line 343
					// (a/p assign)
// clearing r0
// clearing tmp
//using reg r2 for dst pointer
	mt	r3
	stdec	r6
//using reg r3 for counter
					// (prepobj r2)// deref
				// reg r3 - no need to prep
			//Swapping dest and counter registers
// Copying 12 words and 0 bytes to 
					// (objtotemp) flags 22 // deref 
					// (prepobj tmp)// deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
	ldt
	mr	r0
// Copying 12 words to 
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	addt	r3
	mr	r2
.cpywordloop4:
	ldinc	r0
	stinc	r3
	mt	r3
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpywordloop4))
		add	r7
	ldinc	r6
	mr	r2
				// allocreg r2

	//dhry_1.c, line 344
					// (bitwise) loadreg
	//ops: 6, 0, 3
					// (objtotemp) flags 42 // reg r5
	mt	r5
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) // isreg

	//dhry_1.c, line 344
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r2 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) store
	st	r2
				//save_temp done
				// allocreg r1

	//dhry_1.c, line 346
					// (bitwise) loadreg
	//ops: 4, 0, 2
					// (objtotemp) flags 4a // reg r3
	mt	r3
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 346
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

	//dhry_1.c, line 347
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 62 // deref 
	ld	r5
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_1.c, line 348
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r3
	mt	r3
	stdec	r6

	//dhry_1.c, line 348
					//call
	ldinc	r7
	.int	_Proc_3
// clearing tmp
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

// clearing tmp
				// allocreg r1

	//dhry_1.c, line 351
					// (bitwise) loadreg
	//ops: 4, 0, 2
					// (objtotemp) flags 4a // reg r3
	mt	r3
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r1
					// (save result) // isreg
				// freereg r3

	//dhry_1.c, line 351
					// (test)
					// (objtotemp) flags 6a // deref 
	ld	r1
				// freereg r1

	//dhry_1.c, line 351
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l105)-1)
	li	IMW0(PCREL(l105)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_1.c, line 354
					// (bitwise) loadreg
	//ops: 5, 0, 2
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r1
					// (save result) // isreg
				// allocreg r3

	//dhry_1.c, line 354
					// (bitwise) loadreg
	//ops: 5, 0, 4
					// (objtotemp) flags 42 // reg r4
	mt	r4
	mr	r3
					// (objtotemp) flags 1 // const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r3
					// (save result) // isreg

	//dhry_1.c, line 354
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r3 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 6 in 1 chunks
	li	IMW0(6)
					// (save temp) store
	st	r3
				//save_temp done

	//dhry_1.c, line 356
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1
				// allocreg r1

	//dhry_1.c, line 356
					// (bitwise) loadreg
	//ops: 6, 0, 2
					// (objtotemp) flags 42 // reg r5
	mt	r5
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 356
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 356
					//call
	ldinc	r7
	.int	_Proc_6
// clearing tmp
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

// clearing tmp

	//dhry_1.c, line 357
					// (a/p assign)
					// (prepobj r0)// deref
				// reg r4 - no need to prep
					// (objtotemp) flags 22 // deref 
					// (prepobj tmp)// deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
	ldt
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store
	st	r4
				//save_temp done

	//dhry_1.c, line 359
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r3
	mt	r3
	stdec	r6

	//dhry_1.c, line 359
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: a in 1 chunks
	li	IMW0(10)
	stdec	r6

	//dhry_1.c, line 359
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 6a // deref 
	ld	r3
	stdec	r6
				// freereg r3

	//dhry_1.c, line 359
					//call
	ldinc	r7
	.int	_Proc_7
// clearing tmp
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6

// clearing tmp

	//dhry_1.c, line 362
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l106)-1)
	li	IMW0(PCREL(l106)-0)
// clearing tmp
// clearing tmp
	add	r7
l105: # 
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_1.c, line 362
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 62 // deref 
	ld	r5
					// (save temp) isreg
	mr	r1
				//save_temp done

	//dhry_1.c, line 362
					// (a/p assign)
// clearing r0
// clearing tmp
//using reg r2 for dst pointer
//using reg r3 for counter
					// (prepobj r2)// deref
				// reg r5 - no need to prep
	mt	r5
	mr	r2
// Copying 12 words and 0 bytes to Ptr_Val_Par
					// (objtotemp) flags 6a // deref 
//FIXME - unhandled type 12
	mr	r0
// Copying 12 words to Ptr_Val_Par
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	addt	r2
	mr	r3
.cpyPtr_Val_Parwordloop5:
	ldinc	r0
	stinc	r2
	mt	r2
	cmp	r3
	cond	NEQ
		li	IMW0(PCREL(.cpyPtr_Val_Parwordloop5))
		add	r7
				// freereg r1
l106: # 
// clearing tmp
// clearing r0
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
	stmpdec	r3
	stmpdec	r4
	stmpdec	r5
	exg	r6
				// constant: fffffffc in 1 chunks
	li	IMW0(-4)
	add	r6
// clearing tmp
// clearing r0
				// allocreg r5
					// (a/p assign)
					// (prepobj r0) reg r5 - no need to prep
					// (objtotemp) flags 102 // extern
	ldinc	r7
	.int	_Ch_1_Glob
// clearing tmp
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
					// (save temp) isreg
	mr	r5
				//save_temp done
				// allocreg r4
					// (a/p assign)
					// (prepobj r0) reg r4 - no need to prep
					// (objtotemp) flags 102 // var, auto|reg
		//sizemod based on type 0x3
	ld	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r3
					// (a/p assign)
					// (prepobj r0) reg r3 - no need to prep
					// (objtotemp) flags 102 // var, auto|reg
		//sizemod based on type 0xa
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r2

	//dhry_1.c, line 376
					// (bitwise) loadreg
	//ops: 4, 0, 3
					// (objtotemp) flags 62 // deref 
	ld	r3
	mr	r2
					// (objtotemp) flags 1 // const
				// constant: a in 1 chunks
	li	IMW0(10)
	add	r2
					// (save result) // isreg
l113: # 
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_1.c, line 378
					//FIXME convert
					// (objtotemp) flags 42 // reg r5
	mt	r5
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 378
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	cmp	r1
				// freereg r1

	//dhry_1.c, line 378
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l112)-1)
	li	IMW0(PCREL(l112)-0)
// clearing tmp
		add	r7
// clearing tmp

	//dhry_1.c, line 381
					// (bitwise) loadreg
	//ops: 3, 0, 3
		// WARNING - q1 and target collision - check code for correctness.
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r2
					// (save result) // isreg

	//dhry_1.c, line 382
					// (bitwise) loadreg
	//ops: 3, 0, 1
					// (objtotemp) flags 42 // reg r2
	mt	r2
	mr	r0
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Int_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	sub	r0
					// (save result) // Store_reg to type 0x3
	mt	r0
	st	r3

	//dhry_1.c, line 383
					// (a/p assign)
					// (prepobj r0) reg r4 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r4
				//save_temp done
l112: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 385
					// (test)
					// (objtotemp) flags 42 // reg r4
	mt	r4
	and	r4

	//dhry_1.c, line 385
	cond	NEQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l113)-1)
	li	IMW0(PCREL(l113)-0)
// clearing tmp
		add	r7
// clearing tmp
					// (a/p assign)
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob + 4
// clearing tmp
// extern pe not varadr
		//sizemod based on type 0x1
	byt
	stmpdec	r5
// clearing tmp
				// freereg r2
				// freereg r3
				// freereg r4
				// freereg r5
				// constant: fffffffc in 1 chunks
	li	IMW0(-4)
	sub	r6
	ldinc	r6
	mr	r5
	ldinc	r6
	mr	r4
	ldinc	r6
	mr	r3
	ldinc	r6
	mr	r7

	//registers used:
		//r2: no
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
// clearing tmp
// clearing r0

	//dhry_1.c, line 397
					// (test)
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0xa
	//extern deref
	ldt

	//dhry_1.c, line 397
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l117)-1)
	li	IMW0(PCREL(l117)-0)
// clearing tmp
		add	r7
// clearing tmp

	//dhry_1.c, line 399
					// (a/p assign)
					// (prepobj r0)// deref
				// var FIXME - deref?// reg 
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
// clearing tmp
	mr	r0
// clearing r0
					// (objtotemp) flags 22 // deref 
					// (prepobj tmp)// deref
				// var FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
	ldt
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store
	st	r0
				//save_temp done
l117: # 
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_1.c, line 400
					// (bitwise) loadreg
	//ops: 0, 0, 2
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ptr_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r1
					// (objtotemp) flags 1 // const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r1
					// (save result) // isreg

	//dhry_1.c, line 400
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) flags 4a // reg r1
	mt	r1
	stdec	r6
				// freereg r1

	//dhry_1.c, line 400
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Int_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	stdec	r6

	//dhry_1.c, line 400
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) flags 1 // const
				// constant: a in 1 chunks
	li	IMW0(10)
	stdec	r6

	//dhry_1.c, line 400
					//call
	ldinc	r7
	.int	_Proc_7
// clearing tmp
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6

// clearing tmp
	ldinc	r6
	mr	r7

	//registers used:
		//r2: no
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
// clearing tmp
// clearing r0
				// allocreg r1

	//dhry_1.c, line 410
					//FIXME convert
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Ch_1_Glob
// clearing tmp
		//sizemod based on type 0x1
	byt
	//extern deref
	ldt
	mr	r1
// clearing tmp
				// constant: 1000000 in 5 chunks
	li	IMW4(16777216)
	li	IMW3(16777216)
	li	IMW2(16777216)
	li	IMW1(16777216)
	li	IMW0(16777216)
	mul	r1
				// constant: 100 in 2 chunks
	li	IMW1(256)
	li	IMW0(256)
	sgn
	mul	r1
	mr	r1
					// (save result) // isreg

	//dhry_1.c, line 410
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	cmp	r1
				// freereg r1

	//dhry_1.c, line 410
	cond	EQ
					//conditional branch regular			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l119)-1)
	li	IMW0(PCREL(l119)-0)
// clearing tmp
		add	r7
// clearing tmp
				// allocreg r1

	//dhry_1.c, line 410
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r1
				//save_temp done

	//dhry_1.c, line 410
			//pcreltotemp - reach of 12 bits
	li	IMW1(PCREL(l120)-1)
	li	IMW0(PCREL(l120)-0)
// clearing tmp
// clearing tmp
	add	r7
l119: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 410
					// (a/p assign)
					// (prepobj r0) reg r1 - no need to prep
					// (objtotemp) flags 1 // const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r1
				//save_temp done
l120: # 
// clearing tmp
// clearing r0

	//dhry_1.c, line 411
					// (bitwise) loadreg
	//ops: 0, 2, 1
					// (objtotemp) flags 2 // extern
	ldinc	r7
	.int	_Bool_Glob
// clearing tmp
		//sizemod based on type 0x3
	//extern deref
	ldt
	mr	r0
					// (objtotemp) flags 42 // reg r1
	mt	r1
	or	r0
					// (save result) // Store_reg to type 0x3
// clearing tmp
// clearing r0
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob + 4
// clearing tmp
// extern pe not varadr
	stmpdec	r0
 // WARNING - check that 4 has been added.
// clearing tmp

	//dhry_1.c, line 412
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_Ch_2_Glob
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done
				// freereg r1
	ldinc	r6
	mr	r7

	//registers used:
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
// clearing tmp
// clearing r0

	//dhry_1.c, line 420
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) store
	stbinc	r0
//Disposable, postinc doesn't matter.
				//save_temp done

	//dhry_1.c, line 421
					// (a/p assign)
					// (prepobj r0) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob
// clearing tmp
// extern pe not varadr
	mr	r0
					// (objtotemp) flags 1 // const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store
	st	r0
				//save_temp done
	ldinc	r6
	mr	r7

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
	.globl	_printf
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
