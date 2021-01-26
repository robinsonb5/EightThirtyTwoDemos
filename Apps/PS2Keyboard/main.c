#include <stdio.h>

#include <hw/interrupts.h>
#include <hw/ps2.h>
#include <hw/keyboard.h>

int MouseX=0,MouseY=0,MouseZ=0,MouseButtons=0;
int mouseactive=0;

int main(int argc, char **argv)
{
	int key=0x2a;
	int a;

	puts("Enabling interrupts...\n");
	EnableInterrupts();

	// Initialise mouse...
	while(PS2MouseRead()>-1)
		; // Drain the buffer;
	PS2MouseWrite(0xf4);

	while(1)
	{
		int k;
		k=HandlePS2RawCodes();
//		printf("%x, %x, %x, %x, %x, %x\n",keytable[0],keytable[1],keytable[2],keytable[3],keytable[4],keytable[5]);
		if(k)
			putchar(k);

		; // Read the acknowledge byte
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

				printf("%d %d %x\n",MouseX,MouseY,MouseButtons,w1,w2,w3);
			}
		}
		else if(PS2MouseRead()==0xfa)
		{
			printf("Mouse ack received\n");
			mouseactive=1;
		}

	}
}

