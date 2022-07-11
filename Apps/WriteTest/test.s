	//registers used:
		//r1: yes
		//r2: yes
		//r3: yes
		//r4: yes
		//r5: yes
		//r6: no
		//r7: no
		//tmp: no
	.section	.text.1
	.global	_testfunc
_testfunc:
	stdec r6

	.liconst	0x55
	stinc r1
	stinc r1
	stinc r1
	stinc r1

	stinc r1
	stinc r1
	stinc r1
	stinc r1

	stinc r1
	stinc r1
	stinc r1
	stinc r1

	stinc r1
	stinc r1
	stinc r1
	stinc r1

	.liconst 0xaa
	stbinc r1
	stbinc r1
	stbinc r1
	stbinc r1

	stbinc r1
	stbinc r1
	stbinc r1
	stbinc r1

	stbinc r1
	stbinc r1
	stbinc r1
	stbinc r1

	stbinc r1
	stbinc r1
	stbinc r1
	stbinc r1

	ldinc	r6
	mr	r7

