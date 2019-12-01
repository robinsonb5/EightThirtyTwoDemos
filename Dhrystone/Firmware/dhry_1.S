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

	//dhry_1.c, line 78
					//setreturn
					// (load_temp - type 4) not varadr
					// (objtotemp) const/deref # FIXME deal with different data sizes when dereferencing
					// (prepobj r0) const/deref
				// constant: ffffffc8 in 2 chunks
	li	IMW1(-56)
	li	IMW0(-56)
	mr	r0
	ld	r0
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
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
					// (save temp) isreg
	mr	r4
				//save_temp done
				// allocreg r2

	//dhry_1.c, line 116
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Next_Ptr_Glob
	mr	r1
					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec1
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 117
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ptr_Glob
	mr	r1
					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec2
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 119
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_rec2
	mr	r1
					// (load_temp - type 10)					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_rec1
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 120
					// (a/p assign)
					// (prepobj r1) extern (offset 4)
	ldinc	r7
	.int	_rec2 + 4
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 121
					// (a/p assign)
					// (prepobj r1) extern (offset 8)
	ldinc	r7
	.int	_rec2 + 8
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 122
					// (a/p assign)
					// (prepobj r1) extern (offset 12)
	ldinc	r7
	.int	_rec2 + 12
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 28 in 2 chunks
	li	IMW1(40)
	li	IMW0(40)
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 124
					// (a/p assign)
					// (prepobj r1) extern (offset 16)
	ldinc	r7
	.int	_rec2 + 16
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 31 bytes to rec2
					// (load_temp - type 1) not varadr
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l3
	mr	r0
	mt	r2
	stdec	r6
				// constant: 1f in 1 chunks
	li	IMW0(31)
	addt	r1
	mr	r2
.cpyrec2loop0:
	ldbinc	r0
	stbinc	r1
	mt	r1
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpyrec2loop0))
		add	r7
	ldinc	r6
	mr	r2

	//dhry_1.c, line 125
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Str_1_Loc
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 31 bytes to Str_1_Loc
					// (load_temp - type 1) not varadr
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l4
	mr	r0
	mt	r2
	stdec	r6
				// constant: 1f in 1 chunks
	li	IMW0(31)
	addt	r1
	mr	r2
.cpyStr_1_Locloop1:
	ldbinc	r0
	stbinc	r1
	mt	r1
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpyStr_1_Locloop1))
		add	r7
	ldinc	r6
	mr	r2

	//dhry_1.c, line 127
					// (a/p assign)
					// (prepobj r1) extern (offset 1628)
	ldinc	r7
	.int	_Arr_2_Glob + 1628
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: a in 1 chunks
	li	IMW0(10)
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 132
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l5
	stdec	r6

	//dhry_1.c, line 132
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 133
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l6
	stdec	r6

	//dhry_1.c, line 133
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 134
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l7
	stdec	r6

	//dhry_1.c, line 134
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 135
					// (test)
					// (objtotemp) extern
	ldinc	r7
	.int	_Reg
	ldt

	//dhry_1.c, line 135
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l9)-1)
	li	IMW0(PCREL(l9))
		add	r7

	//dhry_1.c, line 137
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l10
	stdec	r6

	//dhry_1.c, line 137
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 138
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l11
	stdec	r6

	//dhry_1.c, line 138
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 141
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l12)-1)
	li	IMW0(PCREL(l12))
	add	r7
l9: # 

	//dhry_1.c, line 142
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l13
	stdec	r6

	//dhry_1.c, line 142
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 143
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l14
	stdec	r6

	//dhry_1.c, line 143
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

l12: # 

	//dhry_1.c, line 147
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Number_Of_Runs
	ldt
	stdec	r6

	//dhry_1.c, line 147
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l15
	stdec	r6

	//dhry_1.c, line 147
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 162
					//call
	ldinc	r7
	.int	__readMilliseconds
	exg	r7
				// constant: 0 in 1 chunks
	li	IMW0(0)
	add	r6


	//dhry_1.c, line 162
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Begin_Time
	stmpdec	r0

	//dhry_1.c, line 163
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Begin_Time
	ldt
	stdec	r6

	//dhry_1.c, line 163
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l16
	stdec	r6

	//dhry_1.c, line 163
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 164
					//call
	ldinc	r7
	.int	__readMilliseconds
	exg	r7
				// constant: 0 in 1 chunks
	li	IMW0(0)
	add	r6


	//dhry_1.c, line 164
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Begin_Time
	stmpdec	r0

	//dhry_1.c, line 166
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r5
				//save_temp done

	//dhry_1.c, line 167
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) extern
	ldinc	r7
	.int	_Number_Of_Runs
	ldt
	mr	r1
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	sgn
	cmp	r1

	//dhry_1.c, line 167
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l102)-1)
	li	IMW0(PCREL(l102))
		add	r7
				// freereg r2
l99: # 

	//dhry_1.c, line 168
					//call
	ldinc	r7
	.int	_Proc_5
	exg	r7
				// constant: 0 in 1 chunks
	li	IMW0(0)
	add	r6


	//dhry_1.c, line 169
					//call
	ldinc	r7
	.int	_Proc_4
	exg	r7
				// constant: 0 in 1 chunks
	li	IMW0(0)
	add	r6


	//dhry_1.c, line 171
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 2 in 1 chunks
	li	IMW0(2)
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 172
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 3 in 1 chunks
	li	IMW0(3)
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_1.c, line 173
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 31 bytes to Str_2_Loc
					// (load_temp - type 1) not varadr
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l21
	mr	r0
	mt	r2
	stdec	r6
				// constant: 1f in 1 chunks
	li	IMW0(31)
	addt	r1
	mr	r2
.cpyStr_2_Locloop2:
	ldbinc	r0
	stbinc	r1
	mt	r1
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpyStr_2_Locloop2))
		add	r7
	ldinc	r6
	mr	r2

	//dhry_1.c, line 174
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r1

					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 175
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Str_2_Loc
	stdec	r6

	//dhry_1.c, line 175
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Str_1_Loc
	stdec	r6

	//dhry_1.c, line 175
					//call
	ldinc	r7
	.int	_Func_2
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 175
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_1.c, line 175
					// (test)
					// (objtotemp) reg r2
	mt	r2
	and	r2
				// freereg r2

	//dhry_1.c, line 175
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l22)-1)
	li	IMW0(PCREL(l22))
		add	r7
				// allocreg r2

	//dhry_1.c, line 175
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_1.c, line 175
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l23)-1)
	li	IMW0(PCREL(l23))
	add	r7
l22: # 

	//dhry_1.c, line 175
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r2
				//save_temp done
l23: # 

	//dhry_1.c, line 175
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) reg r2
	mt	r2
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 177
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp) reg r4
	mt	r4
	sgn
	cmp	r1

	//dhry_1.c, line 177
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l103)-1)
	li	IMW0(PCREL(l103))
		add	r7
				// freereg r2
l100: # 
				// allocreg r2

	//dhry_1.c, line 179
					// (bitwise) loadreg
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r2
					// (objtotemp) const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	mul	r2
					// (save result) isreg

	//dhry_1.c, line 179
					// (bitwise) loadreg
					// (objtotemp) reg r2
	mt	r2
	mr	r0
					// (objtotemp) reg r4
	mt	r4
	sub	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) var, auto|reg
				// constant: 10 in 1 chunks
	li	IMW0(16)
	addt	r6
	stmpdec	r0
				// freereg r2
				// allocreg r2

	//dhry_1.c, line 181
					// (address)
					// (prepobj r2) var, auto|reg
				// constant: c in 1 chunks
	li	IMW0(12)
	addt	r6
	mr	r2

					// (save result) isreg

	//dhry_1.c, line 181
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 181
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) reg r4
	mt	r4
	stdec	r6

	//dhry_1.c, line 181
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 181
					//call
	ldinc	r7
	.int	_Proc_7
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//dhry_1.c, line 183
					// (bitwise) loadreg
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r0
					// (objtotemp) const
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

	//dhry_1.c, line 177
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mr	r1
					// (objtotemp) reg r4
	mt	r4
	sgn
	cmp	r1

	//dhry_1.c, line 177
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l100)-1)
	li	IMW0(PCREL(l100))
		add	r7
l103: # 

	//dhry_1.c, line 186
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 186
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 186
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Arr_2_Glob
	stdec	r6

	//dhry_1.c, line 186
					// (a/p push)
					// a: pushed 12, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Arr_1_Glob
	stdec	r6

	//dhry_1.c, line 186
					//call
	ldinc	r7
	.int	_Proc_8
	exg	r7
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r6


	//dhry_1.c, line 188
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	stdec	r6

	//dhry_1.c, line 188
					//call
	ldinc	r7
	.int	_Proc_1
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 189
					// (a/p assign)
					// (prepobj r1) var, auto|reg
				// constant: 4 in 1 chunks
	li	IMW0(4)
	addt	r6
	mr	r1

					// (load_temp - type 1) not varadr
					// (objtotemp) const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) store prepped reg
	stbinc	r1
//Disposable, postinc doesn't matter
				//save_temp done
				// allocreg r2

	//dhry_1.c, line 191
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Ch_2_Glob
	byt
	ldt
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 191
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) reg r2
	mt	r2
	mr	r1
					// (objtotemp) const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r1
				// freereg r2

	//dhry_1.c, line 191
	cond	SLT
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l104)-1)
	li	IMW0(PCREL(l104))
		add	r7
l101: # 

	//dhry_1.c, line 192
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 43 in 2 chunks
	li	IMW1(67)
	li	IMW0(67)
	stdec	r6
				// allocreg r2

	//dhry_1.c, line 192
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 192
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 192
					//call
	ldinc	r7
	.int	_Func_1
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 192
					// (getreturn)					// (save result) isreg
	mt	r0
	mr	r2

	//dhry_1.c, line 192
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	mr	r1
					// (objtotemp) reg r2
	mt	r2
	sgn
	cmp	r1
				// freereg r2

	//dhry_1.c, line 192
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l33)-1)
	li	IMW0(PCREL(l33))
		add	r7
				// allocreg r2

	//dhry_1.c, line 195
					// (address)
					// (prepobj r2) var, auto|reg
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	mr	r2

					// (save result) isreg

	//dhry_1.c, line 195
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 195
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 195
					//call
	ldinc	r7
	.int	_Proc_6
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 196
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Str_2_Loc
	mr	r1
// (char with size!=1 -> array of unknown type)
// Copying 31 bytes to Str_2_Loc
					// (load_temp - type 1) not varadr
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l34
	mr	r0
	mt	r2
	stdec	r6
				// constant: 1f in 1 chunks
	li	IMW0(31)
	addt	r1
	mr	r2
.cpyStr_2_Locloop3:
	ldbinc	r0
	stbinc	r1
	mt	r1
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpyStr_2_Locloop3))
		add	r7
	ldinc	r6
	mr	r2

	//dhry_1.c, line 197
					// (a/p assign)
					// (prepobj r1) reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) reg r5
	mt	r5
					// (save temp) isreg
	mr	r4
				//save_temp done

	//dhry_1.c, line 198
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Int_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) reg r5
	mt	r5
					// (save temp) store prepped reg
	st	r1
				//save_temp done
l33: # 

	//dhry_1.c, line 191
					// (bitwise) loadreg
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r0
					// (objtotemp) const
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

	//dhry_1.c, line 191
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x1
	byt
				// constant: 4 in 1 chunks
	li	IMW0(4)
	ldidx	r6
	mr	r3
	li	24
	shl	r3
	sgn
	shr	r3
					// (save result) isreg
				// allocreg r2

	//dhry_1.c, line 191
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Ch_2_Glob
	byt
	ldt
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 191
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) reg r3
	mt	r3
	mr	r1
					// (objtotemp) reg r2
	mt	r2
	sgn
	cmp	r1
				// freereg r3
				// freereg r2

	//dhry_1.c, line 191
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l101)-1)
	li	IMW0(PCREL(l101))
		add	r7
l104: # 

	//dhry_1.c, line 202
					// (bitwise) loadreg
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	mul	r4
					// (save result) isreg

	//dhry_1.c, line 203
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp) reg r4
	mt	r4
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp) var, auto|reg
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
				// allocreg r2

	//dhry_1.c, line 204
					// (bitwise) loadreg
					// (objtotemp) reg r4
	mt	r4
	mr	r2
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	sub	r2
					// (save result) isreg

	//dhry_1.c, line 204
					// (bitwise) loadreg
					// (objtotemp) const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	mul	r2
					// (save result) isreg

	//dhry_1.c, line 204
					// (bitwise) loadreg
					// (objtotemp) reg r2
	mt	r2
	mr	r4
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	sub	r4
					// (save result) isreg
				// freereg r2
				// allocreg r2

	//dhry_1.c, line 206
					// (address)
					// (prepobj r2) var, auto|reg
	mt	r6
	mr	r2
					// (save result) isreg

	//dhry_1.c, line 206
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 206
					//call
	ldinc	r7
	.int	_Proc_2
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 167
					// (bitwise) loadreg
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	add	r5
					// (save result) isreg

	//dhry_1.c, line 167
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) reg r5
	mt	r5
	mr	r1
					// (objtotemp) extern
	ldinc	r7
	.int	_Number_Of_Runs
	ldt
	sgn
	cmp	r1

	//dhry_1.c, line 167
	cond	LE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l99)-1)
	li	IMW0(PCREL(l99))
		add	r7
l102: # 

	//dhry_1.c, line 224
					//call
	ldinc	r7
	.int	__readMilliseconds
	exg	r7
				// constant: 0 in 1 chunks
	li	IMW0(0)
	add	r6


	//dhry_1.c, line 224
					// (getreturn)					// (save result) store reg
// Store_reg to type 0x4
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_End_Time
	stmpdec	r0

	//dhry_1.c, line 225
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_End_Time
	ldt
	stdec	r6

	//dhry_1.c, line 225
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l35
	stdec	r6

	//dhry_1.c, line 225
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 229
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l36
	stdec	r6

	//dhry_1.c, line 229
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 230
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l37
	stdec	r6

	//dhry_1.c, line 230
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 231
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l38
	stdec	r6

	//dhry_1.c, line 231
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 232
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l39
	stdec	r6

	//dhry_1.c, line 232
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 233
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Int_Glob
	ldt
	stdec	r6

	//dhry_1.c, line 233
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l40
	stdec	r6

	//dhry_1.c, line 233
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 234
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	stdec	r6

	//dhry_1.c, line 234
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l41
	stdec	r6

	//dhry_1.c, line 234
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 235
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Bool_Glob
	ldt
	stdec	r6

	//dhry_1.c, line 235
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l42
	stdec	r6

	//dhry_1.c, line 235
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 236
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 236
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l43
	stdec	r6

	//dhry_1.c, line 236
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 237
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Ch_1_Glob
	byt
	ldt
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 237
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 237
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l44
	stdec	r6

	//dhry_1.c, line 237
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 238
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	stdec	r6

	//dhry_1.c, line 238
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l45
	stdec	r6

	//dhry_1.c, line 238
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 239
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Ch_2_Glob
	byt
	ldt
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 239
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 239
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l46
	stdec	r6

	//dhry_1.c, line 239
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 240
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
	stdec	r6

	//dhry_1.c, line 240
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l47
	stdec	r6

	//dhry_1.c, line 240
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 241
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Arr_1_Glob + 32
	ldt
	stdec	r6

	//dhry_1.c, line 241
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l48
	stdec	r6

	//dhry_1.c, line 241
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 242
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	stdec	r6

	//dhry_1.c, line 242
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l49
	stdec	r6

	//dhry_1.c, line 242
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 243
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Arr_2_Glob + 1628
	ldt
	stdec	r6

	//dhry_1.c, line 243
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l50
	stdec	r6

	//dhry_1.c, line 243
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 244
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l51
	stdec	r6

	//dhry_1.c, line 244
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 245
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l52
	stdec	r6

	//dhry_1.c, line 245
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 246
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0x3
	ldt
//marker 2
	stdec	r6

	//dhry_1.c, line 246
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l53
	stdec	r6

	//dhry_1.c, line 246
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 247
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l54
	stdec	r6

	//dhry_1.c, line 247
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_1.c, line 248
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 248
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 248
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l55
	stdec	r6

	//dhry_1.c, line 248
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 249
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 249
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l56
	stdec	r6

	//dhry_1.c, line 249
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 250
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 250
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 250
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l57
	stdec	r6

	//dhry_1.c, line 250
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 251
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 2 in 1 chunks
	li	IMW0(2)
	stdec	r6

	//dhry_1.c, line 251
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l58
	stdec	r6

	//dhry_1.c, line 251
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 252
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 252
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 252
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l59
	stdec	r6

	//dhry_1.c, line 252
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 253
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 11 in 1 chunks
	li	IMW0(17)
	stdec	r6

	//dhry_1.c, line 253
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l60
	stdec	r6

	//dhry_1.c, line 253
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 254
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 254
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 254
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l61
	stdec	r6

	//dhry_1.c, line 254
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 255
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l62
	stdec	r6

	//dhry_1.c, line 255
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 256
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l63
	stdec	r6

	//dhry_1.c, line 256
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 257
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? FIXME - deref?
	ldinc	r7
	.int	_Next_Ptr_Glob
		//sizemod based on type 0x3
	ldt
//marker 2
	stdec	r6

	//dhry_1.c, line 257
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l64
	stdec	r6

	//dhry_1.c, line 257
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 258
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l65
	stdec	r6

	//dhry_1.c, line 258
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_1.c, line 259
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Next_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 259
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 259
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l66
	stdec	r6

	//dhry_1.c, line 259
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 260
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
	stdec	r6

	//dhry_1.c, line 260
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l67
	stdec	r6

	//dhry_1.c, line 260
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 261
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Next_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 261
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 261
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l68
	stdec	r6

	//dhry_1.c, line 261
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 262
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 262
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l69
	stdec	r6

	//dhry_1.c, line 262
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 263
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Next_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 263
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 263
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l70
	stdec	r6

	//dhry_1.c, line 263
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 264
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 12 in 1 chunks
	li	IMW0(18)
	stdec	r6

	//dhry_1.c, line 264
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l71
	stdec	r6

	//dhry_1.c, line 264
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6

				// allocreg r2

	//dhry_1.c, line 266
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Next_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: 10 in 1 chunks
	li	IMW0(16)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 266
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 266
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l72
	stdec	r6

	//dhry_1.c, line 266
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 267
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l73
	stdec	r6

	//dhry_1.c, line 267
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 268
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6
	stdec	r6

	//dhry_1.c, line 268
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l74
	stdec	r6

	//dhry_1.c, line 268
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 269
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 5 in 1 chunks
	li	IMW0(5)
	stdec	r6

	//dhry_1.c, line 269
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l75
	stdec	r6

	//dhry_1.c, line 269
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 270
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r4
	mt	r4
	stdec	r6

	//dhry_1.c, line 270
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l76
	stdec	r6

	//dhry_1.c, line 270
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 271
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: d in 1 chunks
	li	IMW0(13)
	stdec	r6

	//dhry_1.c, line 271
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l77
	stdec	r6

	//dhry_1.c, line 271
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 272
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: c in 1 chunks
	li	IMW0(12)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 272
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l78
	stdec	r6

	//dhry_1.c, line 272
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 273
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 7 in 1 chunks
	li	IMW0(7)
	stdec	r6

	//dhry_1.c, line 273
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l79
	stdec	r6

	//dhry_1.c, line 273
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 274
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 8 in 1 chunks
	li	IMW0(8)
	ldidx	r6
	stdec	r6

	//dhry_1.c, line 274
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l80
	stdec	r6

	//dhry_1.c, line 274
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 275
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	stdec	r6

	//dhry_1.c, line 275
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l81
	stdec	r6

	//dhry_1.c, line 275
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 276
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Str_1_Loc
	stdec	r6

	//dhry_1.c, line 276
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l82
	stdec	r6

	//dhry_1.c, line 276
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 277
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l83
	stdec	r6

	//dhry_1.c, line 277
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 278
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Str_2_Loc
	stdec	r6

	//dhry_1.c, line 278
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l84
	stdec	r6

	//dhry_1.c, line 278
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 279
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l85
	stdec	r6

	//dhry_1.c, line 279
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 280
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l86
	stdec	r6

	//dhry_1.c, line 280
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// allocreg r2

	//dhry_1.c, line 283
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_End_Time
	ldt
	mr	r2
					// (objtotemp) extern
	ldinc	r7
	.int	_Begin_Time
	ldt
	sub	r2
					// (save result) isreg
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_User_Time
	mr	r1
					// (load_temp - type 4) not varadr
					// (objtotemp) reg r2
	mt	r2
					// (save temp) store prepped reg
	st	r1
				//save_temp done

	//dhry_1.c, line 284
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 284
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l87
	stdec	r6

	//dhry_1.c, line 284
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 286
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) extern
	ldinc	r7
	.int	_User_Time
	ldt
	mr	r1
					// (objtotemp) const
				// constant: 78 in 2 chunks
	li	IMW1(120)
	li	IMW0(120)
	sgn
	cmp	r1

	//dhry_1.c, line 286
	cond	GE
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l89)-1)
	li	IMW0(PCREL(l89))
		add	r7
				// allocreg r2

	//dhry_1.c, line 288
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l90
	stdec	r6

	//dhry_1.c, line 288
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 289
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l91
	stdec	r6

	//dhry_1.c, line 289
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 290
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l92
	stdec	r6

	//dhry_1.c, line 290
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6

				// freereg r2
				// freereg r4
l89: # 
				// allocreg r2
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 4) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_User_Time
	ldt
					// (save temp) isreg
	mr	r2
				//save_temp done
				// allocreg r3

	//dhry_1.c, line 308
					// (bitwise) loadreg
					// (objtotemp) reg r2
	mt	r2
	mr	r3
					// (objtotemp) const
				// constant: 3e8 in 2 chunks
	li	IMW1(1000)
	li	IMW0(1000)
	mul	r3
					// (save result) isreg

	//dhry_1.c, line 308
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp) reg r3
	mt	r3
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Number_Of_Runs
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
	.int	_Microseconds
	stmpdec	r0
				// freereg r3
				// allocreg r3
					// (a/p assign)
					// (prepobj r1) reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Number_Of_Runs
	ldt
					// (save temp) isreg
	mr	r3
				//save_temp done
				// allocreg r4

	//dhry_1.c, line 309
					// (bitwise) loadreg
					// (objtotemp) reg r3
	mt	r3
	mr	r4
					// (objtotemp) const
				// constant: 3e8 in 2 chunks
	li	IMW1(1000)
	li	IMW0(1000)
	mul	r4
					// (save result) isreg

	//dhry_1.c, line 309
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp) reg r4
	mt	r4
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp) reg r2
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
	.int	_Dhrystones_Per_Second
	stmpdec	r0
				// freereg r4

	//dhry_1.c, line 310
					// (bitwise) loadreg
					// (objtotemp) const
				// constant: 239 in 2 chunks
	li	IMW1(569)
	li	IMW0(569)
	mul	r3
					// (save result) isreg

	//dhry_1.c, line 310
					// (bitwise) loadreg
	//Call division routine
					// (objtotemp) reg r3
	mt	r3
	mr	r1
	mt	r2
	stdec	r6
					// (objtotemp) reg r2
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
	.int	_Vax_Mips
	stmpdec	r0
				// freereg r3
				// freereg r2

	//dhry_1.c, line 312
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l93
	stdec	r6

	//dhry_1.c, line 312
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 313
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Microseconds
	ldt
	stdec	r6

	//dhry_1.c, line 313
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l94
	stdec	r6

	//dhry_1.c, line 313
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 314
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l95
	stdec	r6

	//dhry_1.c, line 314
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 315
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Dhrystones_Per_Second
	ldt
	stdec	r6

	//dhry_1.c, line 315
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l96
	stdec	r6

	//dhry_1.c, line 315
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 316
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Vax_Mips
	ldt
	stdec	r6

	//dhry_1.c, line 316
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l97
	stdec	r6

	//dhry_1.c, line 316
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 317
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp)//static
				//statictotemp
	ldinc	r7
	.int	l98
	stdec	r6

	//dhry_1.c, line 317
					//call
	ldinc	r7
	.int	_small_printf
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 320
					//setreturn
					// (load_temp - type 3) not varadr
					// (objtotemp) const
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
l34:
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
l21:
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
l90:
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
l91:
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
l92:
	.byte	10
	.byte	0
l93:
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
l94:
	.byte	37
	.byte	100
	.byte	32
	.byte	10
	.byte	0
l95:
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
l96:
	.byte	37
	.byte	100
	.byte	32
	.byte	10
	.byte	0
l97:
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
l98:
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
l16:
	.byte	66
	.byte	101
	.byte	103
	.byte	105
	.byte	110
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
l35:
	.byte	69
	.byte	110
	.byte	100
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
l36:
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
l37:
	.byte	10
	.byte	0
l38:
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
l39:
	.byte	10
	.byte	0
l40:
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
	.byte	100
	.byte	10
	.byte	0
l44:
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
	.byte	99
	.byte	10
	.byte	0
l48:
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
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l50:
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
l51:
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
l52:
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
l53:
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
l55:
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
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l61:
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
l62:
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
l63:
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
l64:
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
l66:
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
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l72:
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
l74:
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
	.byte	37
	.byte	100
	.byte	10
	.byte	0
l82:
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
l84:
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
l85:
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
l86:
	.byte	10
	.byte	0
l87:
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

	//dhry_1.c, line 330
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	addt	r6
	ldt
//marker 1
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_1.c, line 330
					// (a/p assign)
					// (prepobj r1) reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) reg r2
	mt	r2
					// (save temp) isreg
	mr	r5
				//save_temp done

	//dhry_1.c, line 335
					// (a/p assign)
					// (prepobj r1) deref  reg r2 - no need to prep
			//Swapping dest and counter registers
// Copying 48 bytes to 
					// (load_temp - type 12) not varadr
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0xc
	ldt
//marker 2
	mr	r0
	mt	r2
	stdec	r6
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	addt	r2
	mr	r1
.cpyloop4:
	ldbinc	r0
	stbinc	r2
	mt	r2
	cmp	r1
	cond	NEQ
		li	IMW0(PCREL(.cpyloop4))
		add	r7
	ldinc	r6
	mr	r2
				// allocreg r4

	//dhry_1.c, line 336
					// (bitwise) loadreg
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 14 in 1 chunks
	li	IMW0(20)
	ldidx	r6
	mr	r4
					// (objtotemp) const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r4
					// (save result) isreg

	//dhry_1.c, line 336
					// (a/p assign)
					// (prepobj r1) deref  reg r4 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 5 in 1 chunks
	li	IMW0(5)
					// (save temp) store reg
	st	r4
				//save_temp done
				// allocreg r3

	//dhry_1.c, line 338
					// (bitwise) loadreg
					// (objtotemp) reg r2
	mt	r2
	mr	r3
					// (objtotemp) const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r3
					// (save result) isreg

	//dhry_1.c, line 338
					// (a/p assign)
					// (prepobj r1) deref  reg r3 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) deref 
	ld	r4
					// (save temp) store reg
	st	r3
				//save_temp done
				// freereg r4
				// freereg r3

	//dhry_1.c, line 339
					// (a/p assign)
					// (prepobj r1) deref  reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	addt	r6
	ldt
//marker 1
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store reg
	st	r2
				//save_temp done

	//dhry_1.c, line 340
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6

	//dhry_1.c, line 340
					//call
	ldinc	r7
	.int	_Proc_3
	exg	r7
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r6


	//dhry_1.c, line 343
					// (bitwise) loadreg
					// (objtotemp) const
				// constant: 4 in 1 chunks
	li	IMW0(4)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 343
					// (test)
					// (objtotemp) deref 
	ld	r2
	and	r2
				// freereg r2

	//dhry_1.c, line 343
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l107)-1)
	li	IMW0(PCREL(l107))
		add	r7
				// allocreg r3

	//dhry_1.c, line 346
					// (bitwise) loadreg
					// (objtotemp) reg r5
	mt	r5
	mr	r3
					// (objtotemp) const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r3
					// (save result) isreg
				// allocreg r2

	//dhry_1.c, line 346
					// (bitwise) loadreg
					// (objtotemp) reg r5
	mt	r5
	mr	r2
					// (objtotemp) const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 346
					// (a/p assign)
					// (prepobj r1) deref  reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 6 in 1 chunks
	li	IMW0(6)
					// (save temp) store reg
	st	r2
				//save_temp done

	//dhry_1.c, line 348
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r3
	mt	r3
	stdec	r6
				// freereg r3
				// allocreg r3

	//dhry_1.c, line 348
					// (bitwise) loadreg
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
				// constant: 18 in 1 chunks
	li	IMW0(24)
	ldidx	r6
	mr	r3
					// (objtotemp) const
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r3
					// (save result) isreg

	//dhry_1.c, line 348
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) deref 
	ld	r3
	stdec	r6
				// freereg r3

	//dhry_1.c, line 348
					//call
	ldinc	r7
	.int	_Proc_6
	exg	r7
				// constant: 8 in 1 chunks
	li	IMW0(8)
	add	r6


	//dhry_1.c, line 349
					// (a/p assign)
					// (prepobj r1) deref  reg r5 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store reg
	st	r5
				//save_temp done

	//dhry_1.c, line 351
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6

	//dhry_1.c, line 351
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) const
				// constant: a in 1 chunks
	li	IMW0(10)
	stdec	r6

	//dhry_1.c, line 351
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) deref 
	ld	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 351
					//call
	ldinc	r7
	.int	_Proc_7
	exg	r7
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r6


	//dhry_1.c, line 354
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l108)-1)
	li	IMW0(PCREL(l108))
	add	r7
l107: # 
				// allocreg r2

	//dhry_1.c, line 354
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 10) not varadr
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	addt	r6
	ldt
//marker 1
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_1.c, line 354
					// (a/p assign)
					// (prepobj r1) deref  var FIXME - deref? reg 
				// constant: 14 in 1 chunks
	li	IMW0(20)
	addt	r6
	ldt
//marker 1
	mr	r1
// Copying 48 bytes to Ptr_Val_Par
					// (load_temp - type 12) not varadr
					// (objtotemp) deref 
//FIXME - unhandled type 12
	mr	r0
	mt	r2
	stdec	r6
				// constant: 30 in 2 chunks
	li	IMW1(48)
	li	IMW0(48)
	addt	r1
	mr	r2
.cpyPtr_Val_Parloop5:
	ldbinc	r0
	stbinc	r1
	mt	r1
	cmp	r2
	cond	NEQ
		li	IMW0(PCREL(.cpyPtr_Val_Parloop5))
		add	r7
	ldinc	r6
	mr	r2
				// freereg r2
l108: # 
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
		//r4: no
		//r5: no
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
	exg	r6
	stdec	r6	// quickest way to decrement sp by 4
				// allocreg r3

	//dhry_1.c, line 368
					// (bitwise) loadreg
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? reg 
				// constant: 10 in 1 chunks
	li	IMW0(16)
	addt	r6
	ldt
//marker 1
		//sizemod based on type 0x3
	ldt
//marker 2
	mr	r3
					// (objtotemp) const
				// constant: a in 1 chunks
	li	IMW0(10)
	add	r3
					// (save result) isreg
l115: # 
				// allocreg r2

	//dhry_1.c, line 370
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Ch_1_Glob
	byt
	ldt
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 370
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) reg r2
	mt	r2
	mr	r1
					// (objtotemp) const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r1
				// freereg r2

	//dhry_1.c, line 370
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l114)-1)
	li	IMW0(PCREL(l114))
		add	r7

	//dhry_1.c, line 373
					// (bitwise) loadreg
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
	sub	r3
					// (save result) isreg

	//dhry_1.c, line 374
					// (bitwise) loadreg
					// (objtotemp) reg r3
	mt	r3
	mr	r0
					// (objtotemp) extern
	ldinc	r7
	.int	_Int_Glob
	ldt
	sub	r0
					// (save result) deref
					// (load_temp - type 10) not varadr
					// (objtotemp) var, auto|reg
		//sizemod based on type 0xa
				// constant: 10 in 1 chunks
	li	IMW0(16)
	ldidx	r6
	mr	r1
				// store reg
// Store_reg to type 0x3
					// (prepobj tmp) deref 	mt	r1
	stmpdec	r0

	//dhry_1.c, line 375
					// (a/p assign)
					// (prepobj r1) var, auto|reg
	mt	r6
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store prepped reg
	st	r1
				//save_temp done
l114: # 

	//dhry_1.c, line 377
					// (test)
					// (objtotemp) var, auto|reg
		//sizemod based on type 0x3
	ld	r6

	//dhry_1.c, line 377
	cond	NEQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l115)-1)
	li	IMW0(PCREL(l115))
		add	r7
				// freereg r3
	ldinc	r6	// quickest way to add 4 to sp
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

	//dhry_1.c, line 389
					// (test)
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt

	//dhry_1.c, line 389
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l119)-1)
	li	IMW0(PCREL(l119))
		add	r7

	//dhry_1.c, line 391
					// (a/p assign)
					// (prepobj r1) deref  var FIXME - deref? reg 
				// constant: 8 in 1 chunks
	li	IMW0(8)
	addt	r6
	ldt
//marker 1
	mr	r1
					// (load_temp - type 10) not varadr
					// (objtotemp) deref 
					// (prepobj tmp) deref  var FIXME - deref? FIXME - deref?
	ldinc	r7
	.int	_Ptr_Glob
		//sizemod based on type 0xa
	ldt
//marker 2
					// (save temp) store prepped reg
	st	r1
				//save_temp done
l119: # 
				// allocreg r2

	//dhry_1.c, line 392
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Ptr_Glob
	ldt
	mr	r2
					// (objtotemp) const
				// constant: c in 1 chunks
	li	IMW0(12)
	add	r2
					// (save result) isreg

	//dhry_1.c, line 392
					// (a/p push)
					// a: pushed 0, regnames[sp] r6
					// (objtotemp) reg r2
	mt	r2
	stdec	r6
				// freereg r2

	//dhry_1.c, line 392
					// (a/p push)
					// a: pushed 4, regnames[sp] r6
					// (objtotemp) extern
	ldinc	r7
	.int	_Int_Glob
	ldt
	stdec	r6

	//dhry_1.c, line 392
					// (a/p push)
					// a: pushed 8, regnames[sp] r6
					// (objtotemp) const
				// constant: a in 1 chunks
	li	IMW0(10)
	stdec	r6

	//dhry_1.c, line 392
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

	//dhry_1.c, line 402
					//FIXME convert
					// (load_temp - type 1) not varadr
					// (objtotemp) extern
	ldinc	r7
	.int	_Ch_1_Glob
	byt
	ldt
	mr	r2
	li	24
	shl	r2
	sgn
	shr	r2
					// (save result) isreg

	//dhry_1.c, line 402
					// (compare) (q1 signed) (q2 signed)					// (objtotemp) reg r2
	mt	r2
	mr	r1
					// (objtotemp) const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
	sgn
	cmp	r1
				// freereg r2

	//dhry_1.c, line 402
	cond	EQ
					//conditional branch 			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l121)-1)
	li	IMW0(PCREL(l121))
		add	r7
				// allocreg r2

	//dhry_1.c, line 402
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) isreg
	mr	r2
				//save_temp done

	//dhry_1.c, line 402
			//pcreltotemp - FIXME - might need more bits; we currently only support 12-bit signed offset.
	li	IMW1(PCREL(l122)-1)
	li	IMW0(PCREL(l122))
	add	r7
l121: # 

	//dhry_1.c, line 402
					// (a/p assign)
					// (prepobj r1) reg r2 - no need to prep
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 1 in 1 chunks
	li	IMW0(1)
					// (save temp) isreg
	mr	r2
				//save_temp done
l122: # 

	//dhry_1.c, line 403
					// (bitwise) loadreg
					// (objtotemp) extern
	ldinc	r7
	.int	_Bool_Glob
	ldt
	mr	r0
					// (objtotemp) reg r2
	mt	r2
	or	r0
					// (save result) store reg
// Store_reg to type 0x3
					// (prepobj tmp) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob
	stmpdec	r0

	//dhry_1.c, line 404
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ch_2_Glob
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp) const
				// constant: 42 in 2 chunks
	li	IMW1(66)
	li	IMW0(66)
					// (save temp) store prepped reg
	stbinc	r1
//Disposable, postinc doesn't matter
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

	//dhry_1.c, line 412
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Ch_1_Glob
	mr	r1
					// (load_temp - type 1) not varadr
					// (objtotemp) const
				// constant: 41 in 2 chunks
	li	IMW1(65)
	li	IMW0(65)
					// (save temp) store prepped reg
	stbinc	r1
//Disposable, postinc doesn't matter
				//save_temp done

	//dhry_1.c, line 413
					// (a/p assign)
					// (prepobj r1) extern (offset 0)
	ldinc	r7
	.int	_Bool_Glob
	mr	r1
					// (load_temp - type 3) not varadr
					// (objtotemp) const
				// constant: 0 in 1 chunks
	li	IMW0(0)
					// (save temp) store prepped reg
	st	r1
				//save_temp done
	ldinc	r6
	mr	r7

// stacksize=0+??
	.globl	_Reg
	.section	.data
	.align	2
_Reg:
	.int	0
	.globl	_Number_Of_Runs
	.align	2
_Number_Of_Runs:
	.int	25000
	.globl	_Ptr_Glob
	.section	.bss
	.global	_Ptr_Glob
	.comm	_Ptr_Glob,4
	.globl	_Next_Ptr_Glob
	.global	_Next_Ptr_Glob
	.comm	_Next_Ptr_Glob,4
	.globl	_Int_Glob
	.global	_Int_Glob
	.comm	_Int_Glob,4
	.globl	_Bool_Glob
	.global	_Bool_Glob
	.comm	_Bool_Glob,4
	.globl	_Arr_1_Glob
	.global	_Arr_1_Glob
	.comm	_Arr_1_Glob,200
	.globl	_Arr_2_Glob
	.global	_Arr_2_Glob
	.comm	_Arr_2_Glob,10000
	.globl	_Begin_Time
	.global	_Begin_Time
	.comm	_Begin_Time,4
	.globl	_End_Time
	.global	_End_Time
	.comm	_End_Time,4
	.globl	_User_Time
	.global	_User_Time
	.comm	_User_Time,4
	.globl	_Microseconds
	.global	_Microseconds
	.comm	_Microseconds,4
	.globl	_Dhrystones_Per_Second
	.global	_Dhrystones_Per_Second
	.comm	_Dhrystones_Per_Second,4
	.globl	_Vax_Mips
	.global	_Vax_Mips
	.comm	_Vax_Mips,4
	.globl	_rec1
	.global	_rec1
	.comm	_rec1,48
	.globl	_rec2
	.global	_rec2
	.comm	_rec2,48
	.globl	_strcpy
	.globl	_small_printf
	.globl	_Ch_1_Glob
	.global	_Ch_1_Glob
	.comm	_Ch_1_Glob,1
	.globl	_Ch_2_Glob
	.global	_Ch_2_Glob
	.comm	_Ch_2_Glob,1
	.globl	_Func_1
	.globl	_Str_1_Loc
	.global	_Str_1_Loc
	.comm	_Str_1_Loc,31
	.globl	_Str_2_Loc
	.global	_Str_2_Loc
	.comm	_Str_2_Loc,31
	.globl	_Func_2
	.globl	_Proc_7
	.globl	_Proc_8
	.globl	_Proc_6
