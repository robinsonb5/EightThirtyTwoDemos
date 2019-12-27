#include "interrupts.h"

void enable_irq(int irq);
void disable_irq(int irq);

static void dummy_handler()
{
	GetInterrupts();
}


void SetIntHandler(void(*handler)())
{
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=0;
	*(void **)11=(void *)handler;
	puts("Set handler\n");
}

__constructor void intconstructor()
{
	puts("In interrupt constructor\n");
	SetIntHandler(dummy_handler);
//	enable_irq(2);
}


int GetInterrupts()
{
	return(HW_INTERRUPT(REG_INTERRUPT_CTRL));
}


void EnableInterrupts()
{
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=1;
//	enable_irq(2);
}


void DisableInterrupts()
{
//	disable_irq(2);
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=0;
}

