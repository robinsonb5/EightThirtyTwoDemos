#ifndef PS2_H
#define PS2_H

#include <hw/hw_ringbuffer.h>

#define PS2BASE 0xffffffe0
#define HW_PS2(x) *(volatile unsigned int *)(PS2BASE+x)

#define REG_PS2_KEYBOARD 0
#define REG_PS2_MOUSE 0x4

#define BIT_PS2_RECV 11
#define BIT_PS2_CTS 10

#define PS2_BAT 0xaa
#define PS2_ACK 0xfa
#define PS2_ERROR 0xfc
#define PS2_RESEND 0xfe

#define PS2_FLAG_BAT 0x1
#define PS2_FLAG_ACK 0x2
#define PS2_FLAG_ERROR 0x4
#define PS2_FLAG_RESEND 0x8
#define PS2_FLAG_WAITACK 0x100 /* Bit 8 so it can be combined with a byte */

// Private

#ifdef __cplusplus
extern "C" {
#endif

extern struct hw_ringbuffer kbbuffer;
extern struct hw_ringbuffer mousebuffer;

#ifdef __cplusplus
}
#endif

// void PS2KeyboardWrite(int x);
void PS2KeyboardWrite(char *msg,int len);
void PS2KeyboardWriteChar(char x);
int PS2Keyboard_TestFlags(int flags);

void PS2MouseWriteChar(int x);
int PS2Mouse_TestFlags(int flags);

#define PS2KeyboardRead(x) hw_ringbuffer_read(&kbbuffer)
#define PS2KeyboardBytesReady(x) hw_ringbuffer_count(&kbbuffer)

#define PS2MouseRead(x) hw_ringbuffer_read(&mousebuffer)
#define PS2MouseBytesReady(x) hw_ringbuffer_count(&mousebuffer)

#define PS2_INT 4

#endif
