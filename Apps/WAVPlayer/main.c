#include <stdio.h>
#include <unistd.h>

#include <signals.h>

#include "hw/vga.h"
#include "audiocontext.h"
#include "wav.h"

void ErrorMessage(const char *msg)
{
	printf("Error: %s\n",msg);
}


int main(int argc,char **argv)
{
    struct AudioContext *ac=0;
	struct Wav *wav=0;
	HW_VGA(FRAMEBUFFERPTR)=0x01000000; /* Move the framebuffer out of bank zero */
	if(!chdir("WAVs"))
	{
		printf("Chdir succeeded\n");
		wav=wav_open("Prints.wav");
//		wav=wav_open("mdfourier-dac-44100.wav");
		if(wav)
		{
			printf("Found WAV file\n");
			
			if(ac=Audio_Create())
			{
				ac->SetFillFunction(ac,wav_read,wav);
				ac->Enable(ac);
				
				EnableInterrupts();
				do {
					WaitSignal(1);
				} while(ac->Handle(ac));
				ac->Disable(ac);

				ac->Dispose(ac);			
			}
			
			wav_close(wav);
		}
	}
	else
		printf("Chdir failed\n",);

	return(0);
}

