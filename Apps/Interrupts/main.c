#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/ps2.h>
#include <hw/timer.h>
#include <hw/interrupts.h>
#include <hw/soundhw.h>
#include <hw/hw_ringbuffer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <signals.h>

volatile int framecounter=0;



void vblankhandler(void *ud)
{
	int *p=(int *)ud;
	*p = *p+1;
//	SetSignal(0);
}


void timerhandler(void *ud)
{
	SetSignal(1);
}

void audiohandler(void *ud)
{
	SetSignal(2);
}

void ps2handler(void *ud)
{
	putchar('.');
//	SetSignal(3);
}

void serhandler(void *ud)
{
	SetSignal(4);
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

unsigned char initmouse[]=
{	
	0x1,0xff, // Send 1 byte reset sequence
	0x82,	// Wait for two bytes in return (in addition to the normal acknowledge byte)
//	1,0xf4,0, // Uncomment this line to leave the mouse in 3-byte mode
	8,0xf3,200,0xf3,100,0xf3,80,0xf2,1, // Send PS/2 wheel mode knock sequence...
	0x81,	// Receive device ID (should be 3 for wheel mice)
	1,0xf4,0	// Enable reporting.
};


int GetTimer(int offset)
{
	return(HW_TIMER(REG_MILLISECONDS)+offset);
}

int CheckTimer(int time)
{
	return((HW_TIMER(REG_MILLISECONDS)-time)>0 ? 0 : 1);
}

void WaitTimer(int time)
{
	while(!CheckTimer(time))
		;
}


void handlemouse(int reset)
{
	int byte;
	static int delay=0;
	static int timeout;
	static int init=0;
	static int idx=0;
	static int txcount=0;
	static int rxcount=0;
	if(reset)
		idx=0;

	if(!CheckTimer(delay))
		return;
	delay=GetTimer(20);

	if(!idx)
	{
		while(PS2MouseRead()>-1)
			; // Drain the buffer;
		txcount=initmouse[idx++];
		rxcount=0;
	}
	else
	{
		if(rxcount)
		{
			int q=PS2MouseRead();
			if(q>-1)
			{
//				printf("Received %x\n",q);
				--rxcount;
			}
			else if(CheckTimer(timeout))
			{
				/* Clear the mouse buffer on timeout, to avoid blocking if no mouse if connected */
				hw_ringbuffer_init(&mousebuffer);
				idx=0;
			}
	
			if(!txcount && !rxcount)
			{
				int next=initmouse[idx++];
				if(next&0x80)
				{
					rxcount=next&0x7f;
//					printf("Receiving %x bytes",rxcount);
				}
				else
				{
					txcount=next;
//					printf("Sending %x bytes",txcount);
				}
			}
		}
		else if(txcount)
		{
			PS2MouseWrite(initmouse[idx++]);
			--txcount;
			rxcount=1;
			timeout=GetTimer(3500);	//3.5 seconds
		}
	}
}


int main(int argc, char **argv)
{
    int i;
   	int key;
   	int timestamp;

	CreateInterruptHandler(INTERRUPT_VBLANK,vblankhandler,&framecounter);
	CreateInterruptHandler(INTERRUPT_SERIAL,serhandler,&framecounter);
	CreateInterruptHandler(INTERRUPT_TIMER,timerhandler,&framecounter);
	CreateInterruptHandler(INTERRUPT_AUDIO,audiohandler,&framecounter);
	CreateInterruptHandler(INTERRUPT_PS2,ps2handler,&framecounter);

	HW_TIMER(REG_TIMER_INDEX)=0;
	HW_TIMER(REG_TIMER_COUNTER)=250000;
	HW_TIMER(REG_TIMER_ENABLE)=1;

	REG_SOUNDCHANNEL[0].DAT=0;
	REG_SOUNDCHANNEL[0].LEN=32768;
	REG_SOUNDCHANNEL[0].VOL=16;
	REG_SOUNDCHANNEL[0].PERIOD=256;
	REG_SOUNDCHANNEL[0].FORMAT=1;
	REG_SOUNDCHANNEL[0].MODE=SOUND_MODE_INT_F; /* Enable interrupt */
	REG_SOUNDCHANNEL[0].TRIGGER=1;	

	AcknowledgeInterrupts();
	EnableInterrupts();

//	handlemouse(1);

	HW_PS2(REG_PS2_KEYBOARD)=0xff;
	do {
		key=HW_PS2(REG_PS2_KEYBOARD);
	} while (!key&(1<<BIT_PS2_RECV));
	printf("Got %x\n",key&0xff);

	timestamp=GetTimer(100);

	while(0)
	{
		int ts;
		int a,b;
//		int sig=WaitSignal(0x1f);
//		printf("Timestamp %d, Check %d\n",ts,CheckTimer(ts));		
		if(CheckTimer(timestamp))
		{
			key=HW_PS2(REG_PS2_KEYBOARD);
			if(key&(1<<BIT_PS2_CTS))
			{
				HW_PS2(REG_PS2_KEYBOARD)=0xED;
				do {
					key=HW_PS2(REG_PS2_KEYBOARD);
				} while (!key&(1<<BIT_PS2_RECV));

				WaitTimer(GetTimer(10));		
				
				HW_PS2(REG_PS2_KEYBOARD)=++b&7;
				do {
					key=HW_PS2(REG_PS2_KEYBOARD);
				} while (!key&(1<<BIT_PS2_RECV));
			}
			timestamp=GetTimer(100);
		}
//		printf("%x, %x\n",HW_PS2(REG_PS2_KEYBOARD),HW_PS2(REG_PS2_MOUSE));
	}
	
	while(1)
	{
		int sig=WaitSignal(0x1f);
		int key;
		if(sig&2)
			printf("Timer int at: %d\n",framecounter);
		if(sig&4)
			printf("Audio int at: %d\n",framecounter);
		if(sig&8)
			printf("PS/2 int at: %d\n",framecounter);
		if(sig&0x10)
			printf("Serial int at: %d\n",framecounter);
//		handlemouse(0);
		while(!(HW_PS2(REG_PS2_KEYBOARD)&BIT_PS2_CTS))
			;
		HW_PS2(REG_PS2_KEYBOARD)=0xED;

		WaitTimer(GetTimer(50));		

		while(!(HW_PS2(REG_PS2_KEYBOARD)&BIT_PS2_CTS))
			;
		HW_PS2(REG_PS2_KEYBOARD)=++i&7;
//		PS2KeyboardWrite(0xED);
//		PS2KeyboardWrite(++i&7);
	}

    return 0;
}

