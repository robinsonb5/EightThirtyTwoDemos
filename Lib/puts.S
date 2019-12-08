#include "assembler.pp"

#include "uart.h"

Puts:	// Sends the string pointed to by r0 to the UART
	stdec	r6
	mt	r1
	stdec	r6
	mt	r2
	stdec	r6

	li	IMW1(UARTBASE)	// UART register
	li	IMW0(UARTBASE)
	mr	r1

.txwait:
	ld	r1
	mr	r2
	li	IMW1(UART_F_TXREADY)	// TX Ready flag
	li	IMW0(UART_F_TXREADY)
	and	r2
	cond	EQ
		li	IMW0(PCREL(.txwait))
		add	r7

	ldbinc	r0
	cond	NEQ
		st	r1
		li	IMW0(PCREL(.txwait))
		add	r7

	ldinc	r6
	mr	r2
	ldinc	r6
	mr	r1
	ldinc	r6
	mr	r7	// 27 bytes

