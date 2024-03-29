#include <hw/uart.h>
#include <hw/interrupts.h>

static struct InterruptHandler *intchain;
static int enabled;

static void inthandler()
{
	struct InterruptHandler *handler;
	int interrupts;
	DisableInterrupts();
	interrupts=GetInterrupts();
	handler=intchain;
	while(handler)
	{
		if(interrupts & (1<<handler->bit))
			handler->handler(handler->userdata);
		handler=handler->next;
	}
	AcknowledgeInterrupts();	/* Acknowledge interrupts signalled so far */
	EnableInterrupts();
}


void AddInterruptHandler(struct InterruptHandler *handler)
{
	struct InterruptHandler *chain=intchain;
	int wasenabled;
	wasenabled=DisableInterrupts();
	if(!chain)
		intchain=handler;
	else
	{
		while(chain)
		{
			struct InterruptHandler *t=chain->next;
			if(!chain->next)
				chain->next=handler;
			chain=t;
		}
	}
	if(wasenabled)
		EnableInterrupts();
}


void CallInterruptHandler(struct InterruptHandler *handler)
{
	if(handler)
	{
		int wasenabled=DisableInterrupts();

		handler->handler(handler->userdata);
		
		if(wasenabled)
			EnableInterrupts();
	}
}


void RemoveInterruptHandler(struct InterruptHandler *handler)
{
	struct InterruptHandler *chain=intchain;
	int wasenabled=DisableInterrupts();
	if(chain==handler)
	{
		intchain=chain->next;
		chain=0;
	}
	while(chain)
	{
		if(chain->next==handler)
			chain->next=handler->next;
		chain=chain->next;
	}
	if(wasenabled)
		EnableInterrupts();
}


volatile int GetInterrupts()
{
	return(HW_INTERRUPT(REG_INTERRUPT_CTRL));
}

void AcknowledgeInterrupts()
{
	enabled=1;
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=INTERRUPT_ENABLE_F | INTERRUPT_ACKNOWLEDGE_F;
}

void EnableInterrupts()
{
	enabled=1;
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=INTERRUPT_ENABLE_F;
}

void EnableInterruptsAndSleep()
{
	enabled=1;
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=INTERRUPT_ENABLE_F;
	__asm("\tcond nex\n\tmr r0\n");
}


int DisableInterrupts()
{
	int result;
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=0;
	result=enabled;
	enabled=0;
	return(result);
}


/* Constructor dependencies:  none */

__constructor(100.interrupts) void intconstructor()
{
	puts("In interrupt constructor\n");
	DisableInterrupts();
	intchain=0;
	enabled=0;
	*(void **)13=(void *)inthandler;
}

__destructor(100.interrupts) void intdestructor()
{
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=0;
}

