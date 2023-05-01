#include <stdio.h>
#include <hw/soundhw.h>
#include <hw/interrupts.h>
#include <hw/uart.h>
#include <signals.h>

/* It would be interesting to be able to play
   multiple streams simultaneously, so we'll
   include support for all four audio channels. */
#define CHANNELS 4

/* Declare a signal bit to be used in interrupts */
#define SIGNAL_BIT_AUDIO 0

/* Audio buffer */
#define BUFFER_SIZE 1024
char buffer[CHANNELS][BUFFER_SIZE];

void putbyte(int channel,int c)
{
	static int ptr[CHANNELS]={0,0,0,0};

	/* If this is channel 0 and we're about to cross a
	   buffer boundary, wait for an audio interrupt */
	if(!channel && (ptr[channel]&(BUFFER_SIZE/2-1))
			==(BUFFER_SIZE/2-1))
		WaitSignal(1<<SIGNAL_BIT_AUDIO);

	/* When we start writing to one half of the buffer
	   we start playing the other half. */
	if((ptr[channel]&(BUFFER_SIZE/2-1))==0)
	{
		REG_SOUNDCHANNEL[channel].DAT=buffer[channel]
			+(ptr[channel]^(BUFFER_SIZE/2));
		REG_SOUNDCHANNEL[channel].PERIOD=440;
		REG_SOUNDCHANNEL[channel].LEN=256;
		REG_SOUNDCHANNEL[channel].VOL=64;
		REG_SOUNDCHANNEL[channel].TRIGGER=1;
	}
	/* Write to the buffer, converting from signed to unsigned */
	buffer[channel][ptr[channel]]=c^0x80;
	ptr[channel]=(ptr[channel]+1)&(BUFFER_SIZE-1);
}

/* Interrupt function to signal the main task
   when an audio block has been played. */
static void audio_interrupt(void *userdata)
{
	SetSignal(SIGNAL_BIT_AUDIO);
}

static struct InterruptHandler handler =
{
	0,
	audio_interrupt,
	0,
	INTERRUPT_AUDIO
};

/* Constructor to initialise the audio hardware
   and set up the interrupt */

__constructor(200.main_init) void init()
{
	AddInterruptHandler(&handler);
	REG_SOUNDCHANNEL[0].MODE=SOUND_MODE_INT_F;
	REG_SOUNDCHANNEL[0].VOL=64;
	REG_SOUNDCHANNEL[1].VOL=64;
	REG_SOUNDCHANNEL[2].VOL=64;
	REG_SOUNDCHANNEL[3].VOL=64;
	EnableInterrupts();
}

/* Will never be called if the demo never exits, but
   for the sake of completeness... */
__destructor(200.main_init) void deinit()
{
	DisableInterrupts();
	RemoveInterruptHandler(&handler);
}

/* And finally our custom implementation of putchar */

int putchar(int c)
{
	putbyte(0,c)
	return(c);
}

