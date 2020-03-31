#include "assembler.pp"

#define UARTBASE 0xFFFFFFC0
#define HW_UART(x) *(volatile unsigned int *)(UARTBASE+x)

#define REG_UART 0x0
#define REG_UART_RXINT 9
#define REG_UART_TXREADY 8

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
	li	IMW1((1<<REG_UART_TXREADY))	// TX Ready flag
	li	IMW0((1<<REG_UART_TXREADY))
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

