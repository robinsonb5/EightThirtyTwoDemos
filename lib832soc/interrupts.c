#include <hw/uart.h>
#include <hw/interrupts.h>

static struct InterruptHandler *intchain;
static int enabled;

static void inthandler()
{
	struct InterruptHandler *handler;
	DisableInterrupts();
	handler=intchain;
	while(handler)
	{
		handler->handler(handler->userdata);
		handler=handler->next;
	}
	GetInterrupts();	/* Acknowledge interrupts signalled so far */
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


void RemoveInterruptHandler(struct InterruptHandler *handler)
{
	struct InterruptHandler *chain=intchain;
	int wasenabled=DisableInterrupts();
	while(chain)
	{
		if(chain->next==handler)
			chain->next=handler->next;
		chain=chain->next;
	}
	if(wasenabled)
		EnableInterrupts();
}


__constructor(100.interrupts) void intconstructor()
{
	puts("In interrupt constructor\n");
	DisableInterrupts();
	intchain=0;
	*(void **)13=(void *)inthandler;
}

__destructor(100.interrupts) void intdestructor()
{
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=0;
}


volatile int GetInterrupts()
{
	return(HW_INTERRUPT(REG_INTERRUPT_CTRL));
}


void EnableInterrupts()
{
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=1;
	enabled=1;
}


int DisableInterrupts()
{
	int result=enabled;
	HW_INTERRUPT(REG_INTERRUPT_CTRL)=0;
	enabled=0;
	return(result);
}

