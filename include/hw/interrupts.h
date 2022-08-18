#ifndef INTERRUPTS_H
#define INTERRUPTS_H

#define INTERRUPTBASE 0xffffffb0
#define HW_INTERRUPT(x) *(volatile unsigned int *)(INTERRUPTBASE+x)

// Interrupt control register
// Write a '1' to the low bit to enable interrupts, '0' to disable.
// Reading returns a set bit for each interrupt that has been triggered since
// the last read, and also clears the register.

#define REG_INTERRUPT_CTRL 0x0

#define INTERRUPT_ENABLE_B 0x00
#define INTERRUPT_ENABLE_F 0x01

#define INTERRUPT_ACKNOWLEDGE_B 0x08
#define INTERRUPT_ACKNOWLEDGE_F 0x100

#define INTERRUPT_PS2 1
#define INTERRUPT_SERIAL 0
#define INTERRUPT_TIMER 2
#define INTERRUPT_VBLANK 3
#define INTERRUPT_AUDIO 4

#ifdef __cplusplus
extern "C" {
#endif

struct InterruptHandler
{
	struct InterruptHandler *next;
	void (*handler)(void *);
	void *userdata;
	int bit;
};

void AddInterruptHandler(struct InterruptHandler *handler);
void RemoveInterruptHandler(struct InterruptHandler *handler);
void EnableInterrupts();
int DisableInterrupts();
volatile int GetInterrupts();
void AcknowledgeInterrupts();

#ifdef __cplusplus
}
#endif

#endif

