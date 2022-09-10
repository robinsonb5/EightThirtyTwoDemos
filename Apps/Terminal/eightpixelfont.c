#include "eightpixelfont.h"

/* 8-pixel font borrowed from Minimig's Amiga bootstrap. */

char eightpixelfont[]=
{
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, // SPACE
	0x18,0x18,0x18,0x18,0x18,0x00,0x18,0x00, // !
	0x6C,0x6C,0x00,0x00,0x00,0x00,0x00,0x00, // "
	0x6C,0x6C,0xFE,0x6C,0xFE,0x6C,0x6C,0x00, // #
	0x18,0x3E,0x60,0x3C,0x06,0x7C,0x18,0x00, // 0x
	0x00,0x66,0xAC,0xD8,0x36,0x6A,0xCC,0x00, // %
	0x38,0x6C,0x68,0x76,0xDC,0xCE,0x7B,0x00, // &
	0x18,0x18,0x30,0x00,0x00,0x00,0x00,0x00, // '
	0x0C,0x18,0x30,0x30,0x30,0x18,0x0C,0x00, // (
	0x30,0x18,0x0C,0x0C,0x0C,0x18,0x30,0x00, // )
	0x00,0x66,0x3C,0xFF,0x3C,0x66,0x00,0x00, // *
	0x00,0x18,0x18,0x7E,0x18,0x18,0x00,0x00, // +
	0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x30, // ,
	0x00,0x00,0x00,0x7E,0x00,0x00,0x00,0x00, // -
	0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x00, // .
	0x03,0x06,0x0C,0x18,0x30,0x60,0xC0,0x00, // /
	0x3C,0x66,0x6E,0x7E,0x76,0x66,0x3C,0x00, // 0
	0x18,0x38,0x78,0x18,0x18,0x18,0x18,0x00, // 1
	0x3C,0x66,0x06,0x0C,0x18,0x30,0x7E,0x00, // 2
	0x3C,0x66,0x06,0x1C,0x06,0x66,0x3C,0x00, // 3
	0x1C,0x3C,0x6C,0xCC,0xFE,0x0C,0x0C,0x00, // 4
	0x7E,0x60,0x7C,0x06,0x06,0x66,0x3C,0x00, // 5
	0x1C,0x30,0x60,0x7C,0x66,0x66,0x3C,0x00, // 6
	0x7E,0x06,0x06,0x0C,0x18,0x18,0x18,0x00, // 7
	0x3C,0x66,0x66,0x3C,0x66,0x66,0x3C,0x00, // 8
	0x3C,0x66,0x66,0x3E,0x06,0x0C,0x38,0x00, // 9
	0x00,0x18,0x18,0x00,0x00,0x18,0x18,0x00, // :
	0x00,0x18,0x18,0x00,0x00,0x18,0x18,0x30, //, //
	0x00,0x06,0x18,0x60,0x18,0x06,0x00,0x00, // <
	0x00,0x00,0x7E,0x00,0x7E,0x00,0x00,0x00, // =
	0x00,0x60,0x18,0x06,0x18,0x60,0x00,0x00, // >
	0x3C,0x66,0x06,0x0C,0x18,0x00,0x18,0x00, // ?
	0x7C,0xC6,0xDE,0xD6,0xDE,0xC0,0x78,0x00, // @
	0x3C,0x66,0x66,0x7E,0x66,0x66,0x66,0x00, // A
	0x7C,0x66,0x66,0x7C,0x66,0x66,0x7C,0x00, // B
	0x1E,0x30,0x60,0x60,0x60,0x30,0x1E,0x00, // C
	0x78,0x6C,0x66,0x66,0x66,0x6C,0x78,0x00, // D
	0x7E,0x60,0x60,0x78,0x60,0x60,0x7E,0x00, // E
	0x7E,0x60,0x60,0x78,0x60,0x60,0x60,0x00, // F
	0x3C,0x66,0x60,0x6E,0x66,0x66,0x3E,0x00, // G
	0x66,0x66,0x66,0x7E,0x66,0x66,0x66,0x00, // H
	0x3C,0x18,0x18,0x18,0x18,0x18,0x3C,0x00, // I
	0x06,0x06,0x06,0x06,0x06,0x66,0x3C,0x00, // J
	0xC6,0xCC,0xD8,0xF0,0xD8,0xCC,0xC6,0x00, // K
	0x60,0x60,0x60,0x60,0x60,0x60,0x7E,0x00, // L
	0xC6,0xEE,0xFE,0xD6,0xC6,0xC6,0xC6,0x00, // M
	0xC6,0xE6,0xF6,0xDE,0xCE,0xC6,0xC6,0x00, // N
	0x3C,0x66,0x66,0x66,0x66,0x66,0x3C,0x00, // O
	0x7C,0x66,0x66,0x7C,0x60,0x60,0x60,0x00, // P
	0x78,0xCC,0xCC,0xCC,0xCC,0xDC,0x7E,0x00, // Q
	0x7C,0x66,0x66,0x7C,0x6C,0x66,0x66,0x00, // R
	0x3C,0x66,0x70,0x3C,0x0E,0x66,0x3C,0x00, // S
	0x7E,0x18,0x18,0x18,0x18,0x18,0x18,0x00, // T
	0x66,0x66,0x66,0x66,0x66,0x66,0x3C,0x00, // U
	0x66,0x66,0x66,0x66,0x3C,0x3C,0x18,0x00, // V
	0xC6,0xC6,0xC6,0xD6,0xFE,0xEE,0xC6,0x00, // W
	0xC3,0x66,0x3C,0x18,0x3C,0x66,0xC3,0x00, // X
	0xC3,0x66,0x3C,0x18,0x18,0x18,0x18,0x00, // Y
	0xFE,0x0C,0x18,0x30,0x60,0xC0,0xFE,0x00, // Z
	0x3C,0x30,0x30,0x30,0x30,0x30,0x3C,0x00, // [
	0xC0,0x60,0x30,0x18,0x0C,0x06,0x03,0x00, // Backslash
	0x3C,0x0C,0x0C,0x0C,0x0C,0x0C,0x3C,0x00, // ]
	0x10,0x38,0x6C,0xC6,0x00,0x00,0x00,0x00, // ^
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFE, // _
	0x18,0x18,0x0C,0x00,0x00,0x00,0x00,0x00, // `
	0x00,0x00,0x3C,0x06,0x3E,0x66,0x3E,0x00, // a
	0x60,0x60,0x7C,0x66,0x66,0x66,0x7C,0x00, // b
	0x00,0x00,0x3C,0x60,0x60,0x60,0x3C,0x00, // c
	0x06,0x06,0x3E,0x66,0x66,0x66,0x3E,0x00, // d
	0x00,0x00,0x3C,0x66,0x7E,0x60,0x3C,0x00, // e
	0x1C,0x30,0x7C,0x30,0x30,0x30,0x30,0x00, // f
	0x00,0x00,0x3E,0x66,0x66,0x3E,0x06,0x3C, // g
	0x60,0x60,0x7C,0x66,0x66,0x66,0x66,0x00, // h
	0x18,0x00,0x18,0x18,0x18,0x18,0x0C,0x00, // i
	0x0C,0x00,0x0C,0x0C,0x0C,0x0C,0x0C,0x78, // j
	0x60,0x60,0x66,0x6C,0x78,0x6C,0x66,0x00, // k
	0x18,0x18,0x18,0x18,0x18,0x18,0x0C,0x00, // l
	0x00,0x00,0xEC,0xFE,0xD6,0xC6,0xC6,0x00, // m
	0x00,0x00,0x7C,0x66,0x66,0x66,0x66,0x00, // n
	0x00,0x00,0x3C,0x66,0x66,0x66,0x3C,0x00, // o
	0x00,0x00,0x7C,0x66,0x66,0x7C,0x60,0x60, // p
	0x00,0x00,0x3E,0x66,0x66,0x3E,0x06,0x06, // q
	0x00,0x00,0x7C,0x66,0x60,0x60,0x60,0x00, // r
	0x00,0x00,0x3C,0x60,0x3C,0x06,0x7C,0x00, // s
	0x30,0x30,0x7C,0x30,0x30,0x30,0x1C,0x00, // t
	0x00,0x00,0x66,0x66,0x66,0x66,0x3E,0x00, // u
	0x00,0x00,0x66,0x66,0x66,0x3C,0x18,0x00, // v
	0x00,0x00,0xC6,0xC6,0xD6,0xFE,0x6C,0x00, // w
	0x00,0x00,0xC6,0x6C,0x38,0x6C,0xC6,0x00, // x
	0x00,0x00,0x66,0x66,0x66,0x3C,0x18,0x30, // y
	0x00,0x00,0x7E,0x0C,0x18,0x30,0x7E,0x00, // z
	0x0E,0x18,0x18,0x70,0x18,0x18,0x0E,0x00, // {
	0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x00, // |
	0x70,0x18,0x18,0x0E,0x18,0x18,0x70,0x00, // }
	0x72,0x9C,0x00,0x00,0x00,0x00,0x00,0x00, // ~
	0xFE,0xFE,0xFE,0xFE,0xFE,0xFE,0xFE,0x00, //
};

char *eightpixelfont_getchar(char c)
{
	if(c<' ' || c>'~')
		return(0);
	c-=' ';
	return(&eightpixelfont[c*8]);
}
