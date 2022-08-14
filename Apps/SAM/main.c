#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include <signals.h>
#include <hw/interrupts.h>

#include "reciter.h"
#include "sam.h"
#include "debug.h"

#include "hw/soundhw.h"
#include "hw/uart.h"

#ifdef USESDL
#include <SDL.h>
#include <SDL_audio.h>
#endif

int debug=0;

int readline(char *buf,int len)
{
	int cr=0;
	int i=0;
	while(!cr)
	{
		int c=HW_UART(REG_UART);
		if(c&(1<<REG_UART_RXINT))
		{
			c&=0xff;
			if(c==13) // Enter
				cr=1;
			else if(c==8) // Backspace
				--i;
			else if (c!=10)
				buf[i++]=c;
			if(i<0)
				i=0;
			if(i>=len-1)
				i=len-2;		
		}
	}
	buf[i]=0;
	return (i);
}

int pos=0;
int MixAudio(void *ud, short *stream, int len)
{
    int bufferpos = GetBufferLength();
    char *buffer = GetBuffer();
    int i;
    printf("Pos %d\n, Audio asking for %d bytes, have %d\n",pos,len,bufferpos);
    if (pos >= bufferpos) return(0);
    if ((bufferpos-pos) < len) len = (bufferpos-pos);
    for(i=0; i<len; i++)
    {
        stream[i] = buffer[pos]<<8;
        pos++;
    }
    printf("Supplied %d bytes\n",len);
    return(len);
}


struct intdata {
	char *buffer;
	int buflen;
	int idx;
	int signal;
};


static void inthandler_func(void *ud)
{
	struct intdata *id=(struct intdata *)ud;
	if(id)
	{
		int l=id->buflen-id->idx;
		if(l>65536)
			l=65536;

		if(l)
		{
			printf("Setting buffer to %x, len %x\n",id->buffer+id->idx,l);
			REG_SOUNDCHANNEL[0].PERIOD=160;	
			REG_SOUNDCHANNEL[0].VOL=0x40;
			REG_SOUNDCHANNEL[0].FORMAT=SOUND_FORMAT_MONO_S8;
			REG_SOUNDCHANNEL[0].LEN=l/2;
			REG_SOUNDCHANNEL[0].DAT=id->buffer+id->idx;
			REG_SOUNDCHANNEL[0].MODE=SOUND_MODE_INT_F; /* Enable interrupt */	
		}
		else
		{
			printf("Signalling main task to end\n");
			SetSignal(id->signal);
		}
		id->idx+=l;
	}
}

struct InterruptHandler inth;	
struct intdata intd;

static int init=0;
void OutputSound() {
	int i;
	intd.buffer=GetBuffer();
	intd.buflen=GetBufferLength()/50;
	intd.idx=0;
	intd.signal=0;
	printf("Buffer at %x, length %x\n",intd.buffer,intd.buflen);
	for (i=0;i<intd.buflen;++i)
		intd.buffer[i]^=0x80;

	inth.next=0;
	inth.bit=INTERRUPT_AUDIO;
	inth.userdata=&intd;
	inth.handler=inthandler_func;

	if(!init)
		AddInterruptHandler(&inth);
	init=1;
	EnableInterrupts();
	inthandler_func(&intd);
	REG_SOUNDCHANNEL[0].TRIGGER=1;
	inthandler_func(&intd);
	if(!TestSignal(1))
		WaitSignal(1);
	WaitSignal(1);
	printf("Main task ended\n");
	REG_SOUNDCHANNEL[0].MODE=0; /* Enable interrupt */	
	REG_SOUNDCHANNEL[0].VOL=0;
	REG_SOUNDCHANNEL[0].LEN=2;
	DisableInterrupts();
	RemoveInterruptHandler(&inth);
	init=0;
}


char input[256]="Welcome";

int main(int argc, char **argv)
{
	printf("Enter a phrase to be narrated...\n");

	while(1)
	{
		int i;
        if (TextToPhonemes((unsigned char *)input))
        {
        	printf("%s\n",input);
			SetInput(input);
			if (SAMMain())
				OutputSound();
		}
		for(i=0;i<256;++i)
			input[i]=0;
		while (!readline(input,256))
			;
	}

    return 0;

}
