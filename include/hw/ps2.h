#ifndef PS2_H
#define PS2_H

#include <hw/hw_ringbuffer.h>

#define PS2BASE 0xffffffe0
#define HW_PS2(x) *(volatile unsigned int *)(PS2BASE+x)

#define REG_PS2_KEYBOARD 0
#define REG_PS2_MOUSE 0x4

#define BIT_PS2_RECV 11
#define BIT_PS2_CTS 10

// Private

#ifdef __cplusplus
extern "C" {
#endif

extern struct hw_ringbuffer kbbuffer;
extern struct hw_ringbuffer mousebuffer;

#ifdef __cplusplus
}
#endif


void PS2MouseWrite(int x);
void PS2KeyboardWrite(int x);

#define PS2KeyboardRead(x) hw_ringbuffer_read(&kbbuffer)
#define PS2KeyboardBytesReady(x) hw_ringbuffer_count(&kbbuffer)

#define PS2MouseRead(x) hw_ringbuffer_read(&mousebuffer)
#define PS2MouseBytesReady(x) hw_ringbuffer_count(&mousebuffer)

#define PS2_INT 4

#endif
