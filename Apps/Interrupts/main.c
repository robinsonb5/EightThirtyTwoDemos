#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>
#include <hw/interrupts.h>
#include <hw/soundhw.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <signals.h>

volatile int framecounter=0;



void vblankhandler(void *ud)
{
	int *p=(int *)ud;
	*p = *p+1;
	SetSignal(0);
}


void timerhandler(void *ud)
{
	SetSignal(1);
}

void audiohandler(void *ud)
{
	SetSignal(2);
}


struct InterruptHandler *CreateInterruptHandler(int bit,void (*handler)(void *ud),void *userdata)
{
	struct InterruptHandler *result=(struct InterruptHandler *)malloc(sizeof(struct InterruptHandler));
	if(result)
	{
		result->next=0;
		result->handler=handler;
		result->userdata=userdata;
		result->bit=bit;	
		AddInterruptHandler(result);
	}
	return(result);
}


int main(int argc, char **argv)
{
    int i;

	CreateInterruptHandler(INTERRUPT_VBLANK,vblankhandler,&framecounter);
	CreateInterruptHandler(INTERRUPT_TIMER,timerhandler,&framecounter);
	CreateInterruptHandler(INTERRUPT_AUDIO,audiohandler,&framecounter);

	HW_TIMER(REG_TIMER_INDEX)=0;
	HW_TIMER(REG_TIMER_COUNTER)=250000;
	HW_TIMER(REG_TIMER_ENABLE)=1;
	AcknowledgeInterrupts();
	EnableInterrupts();

	REG_SOUNDCHANNEL[0].DAT=0;
	REG_SOUNDCHANNEL[0].LEN=32768;
	REG_SOUNDCHANNEL[0].VOL=16;
	REG_SOUNDCHANNEL[0].PERIOD=256;
	REG_SOUNDCHANNEL[0].FORMAT=1;
	REG_SOUNDCHANNEL[0].MODE=SOUND_MODE_INT_F; /* Enable interrupt */
	REG_SOUNDCHANNEL[0].TRIGGER=1;	

	while(1)
	{
		int sig=WaitSignal(0x07);
		if(sig&2)
			printf("Timer int at: %d\n",framecounter);
		if(sig&4)
			printf("Audio int at: %d\n",framecounter);
	}

    return 0;
}

