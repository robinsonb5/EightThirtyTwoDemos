	.section	.text.thread2boot
	.global	_thread2boot
_thread2boot:
	stdec r6
	.liconst	0x40000000	// The zero and carry flags are encoded into the top two bits of an address
	or	r1
	mt	r1
	exg	r7
	ldinc	r6
	mr	r7

