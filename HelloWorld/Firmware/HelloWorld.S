#include	"assembler.pp"

start:
	.liabs message
	mr	r1
	.liconst 0xffffffc0
	mr	r0

_loop:
	.liconst 0x100
	mr	r2	// Flags
	ld	r0
	and	r2
	cond	EQ
	  .lipcrel _loop
	  add	r7

	ldbinc	r1
	cond	NEQ
	  st	r0
	  .lipcrel _loop
	  add	r7

.end:
	.lipcrel .end
	add	r7

message:
	.ascii	"Hello"
	.byte	32
	.ascii	"world!"
	.byte	10
	.byte	0

