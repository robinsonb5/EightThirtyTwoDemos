#include <hw/interrupts.h>
#include <signals.h>

static int signals;

void SetSignal(int signalbit)
{
	int reenable=DisableInterrupts();

	signals|=(1<<signalbit);

	if(reenable)
		EnableInterrupts();
}


int WaitSignal(int signalmask)
{
	int sig;
	do {
		DisableInterrupts();
		sig=signals & signalmask;
		signals=signals & ~signalmask;
		if(!sig)
			EnableInterruptsAndSleep();
	} while(!sig)
	EnableInterrupts();
	return(sig);
}


int TestSignal(int signalmask)
{
	int sig;
	int reenable=DisableInterrupts();
	sig=signals & signalmask;
	signals=signals & ~signalmask;
	if(reenable)
		EnableInterrupts();
	return(sig);
}


