#include <stdio.h>

#include <hw/interrupts.h>
#include <hw/ps2.h>
#include <hw/keyboard.h>
#include <hw/uart.h>
#include <hw/timer.h>

int MouseX=0,MouseY=0,MouseZ=0,MouseButtons=0;
int mouseactive=0;

void PS2Handler(void *userdata);

char ledmsg[2]={0xed,0x00};


unsigned char initmouse[]=
{	
	0x1,0xff, // Send 1 byte reset sequence
	0x82,	// Wait for two bytes in return (in addition to the normal acknowledge byte)
//	1,0xf4,0, // Uncomment this line to leave the mouse in 3-byte mode
	8,0xf3,200,0xf3,100,0xf3,80,0xf2,1, // Send PS/2 wheel mode knock sequence...
	0x81,	// Receive device ID (should be 3 for wheel mice)
	1,0xf4,0	// Enable reporting.
};

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
				printf("Received %x\n",q);
				--rxcount;
			}
			else if(CheckTimer(timeout))
			{
				/* Clear the mouse buffer on timeout, to avoid blocking if no mouse if connected */
//				hw_ringbuffer_init(&mousebuffer);
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
//			printf("%d, %d\n",mousebuffer.out_hw,mousebuffer.out_cpu);
//			printf("%x\n",HW_PS2(REG_PS2_MOUSE));
//			printf("Sending %x\n",initmouse[idx]);
			PS2MouseWriteChar(initmouse[idx++]);
			--txcount;
			rxcount=1;
			timeout=GetTimer(3500);	//3.5 seconds
		}
	}
}

int main(int argc, char **argv)
{
	int key=0x2a;
	int a;
	int b;
	int led=0;
	int ledtimeout=0;


#if 0
	while(1)
	{
		key=HW_PS2(REG_PS2_KEYBOARD);
		if(key&(1<<BIT_PS2_CTS))
		{
			++a;
			if((a&255)==128)
				HW_PS2(REG_PS2_KEYBOARD)=0xED;
			if((a&255)==130)
				HW_PS2(REG_PS2_KEYBOARD)=++b&7;
		}
			
		printf("%x, %x\n",HW_PS2(REG_PS2_KEYBOARD),HW_PS2(REG_PS2_MOUSE));
	}
#endif

	puts("Enabling interrupts...\n");
	EnableInterrupts();

	// Initialise mouse...
///	while(PS2MouseRead()>-1)
//		; // Drain the buffer;
//	PS2MouseWriteChar(0xf4);

	// Turn off LEDs
	PS2KeyboardWriteChar(0xed);
	PS2KeyboardWriteChar(0x00);

	handlemouse(1);

	while(1)
	{
		int k;
		handlemouse(0);
		k=HandlePS2RawCodes();
		if(k)
			putchar(k);

		if(mouseactive)
		{
			while(PS2MouseBytesReady()>=3) // FIXME - institute some kind of timeout here to re-sync if sync lost.
			{
				int nx;
				int w1,w2,w3,w4;
				w1=PS2MouseRead();
				w2=PS2MouseRead();
				w3=PS2MouseRead();
				MouseButtons=w1&0x7;
				if(w1 & (1<<5))
					w3|=0xffffff00;
				if(w1 & (1<<4))
					w2|=0xffffff00;

				nx=MouseX+w2;
#if 0
				if(nx<0)
					nx=0;
				if(nx>639)
					nx=639;
#endif
				MouseX=nx;

				nx=MouseY-w3;
#if 0
				if(nx<0)
					nx=0;
				if(nx>479)
					nx=479;
#endif
				MouseY=nx;

				printf("%d %d %x\n",MouseX,MouseY,MouseButtons);
			}
		}
		else if(PS2MouseRead()==0xfa)
		{
			printf("Mouse ack received\n");
			mouseactive=1;
		}

	}
}

