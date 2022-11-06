#ifndef BLITTER_H
#define BLITTER_H

/* Blitter hardware registers */

struct BlitterChannel
{
	int ROWS;
	int ACTIVE;
	int FUNCTION;
	int PAD[9];
	void *ADDRESS;
	int MODULO;
	int SPAN;
	int DATA;
};	/* 64 bytes long */

#define BLITTERBASE 0xFFFFFB00
#define REG_BLITTER ((volatile struct BlitterChannel *)BLITTERBASE)

#define BLITTER_CTRL 0
#define BLITTER_DEST 0
#define BLITTER_SRC1 1
#define BLITTER_SRC2 2

#define BLITTER_ACTIVE_NONE 0
#define BLITTER_ACTIVE_SRC1 2
#define BLITTER_ACTIVE_SRC2 4

#define BLITTER_FUNC_A 0
#define BLITTER_FUNC_A_XOR_B 1
#define BLITTER_FUNC_A_PLUS_B 2
#define BLITTER_FUNC_A_PLUS_B_CLAMPED 3

#define BLITTER_FUNC_WORDWISE 128
#define BLITTER_FUNC_BYTEWISE 0
#define BLITTER_FUNC_SHIFTRIGHT 64

#endif

