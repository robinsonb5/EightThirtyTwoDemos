#include <stdio.h>
#include <stdlib.h>

#include <signals.h>

#include "audiocontext.h"

#include "hw/soundhw.h"

void Audio_Dispose(struct AudioContext *ac);
int Audio_Handle(struct AudioContext *ac);
void Audio_Enable(struct AudioContext *ac);
void Audio_Disable(struct AudioContext *ac);
void Audio_SetFillFunction(struct AudioContext *ac,int (*fillfunc)(void *,char *,int),void *userdata);

extern void *Audio_ServerStub;
void *InputBase;

void Audio_Enable(struct AudioContext *ac)
{
  if(ac->Active==0)
  {
    int i;
    int *buf=(int *)ac->leftbuffer[0];
    int *buf2=(int *)ac->rightbuffer[0];
    int *buf3=(int *)ac->leftbuffer[1];
    int *buf4=(int *)ac->rightbuffer[1];

	AddInterruptHandler(&ac->inthandler);

	REG_SOUNDCHANNEL[0].DAT=(char *)buf;
	REG_SOUNDCHANNEL[0].LEN=AUDIOBUFFERSIZE/4;	
	REG_SOUNDCHANNEL[0].PERIOD=80;	
	REG_SOUNDCHANNEL[0].VOL=0x40;
	REG_SOUNDCHANNEL[0].FORMAT=SOUND_FORMAT_MONO_S16;
	REG_SOUNDCHANNEL[0].TRIGGER=1;
	REG_SOUNDCHANNEL[0].MODE=SOUND_MODE_INT_F; /* Enable interrupt */	
	REG_SOUNDCHANNEL[1].DAT=(char *)buf2;
	REG_SOUNDCHANNEL[1].LEN=AUDIOBUFFERSIZE/4;	
	REG_SOUNDCHANNEL[1].PERIOD=80;	
	REG_SOUNDCHANNEL[1].VOL=0x40;
	REG_SOUNDCHANNEL[1].FORMAT=SOUND_FORMAT_MONO_S16;
	REG_SOUNDCHANNEL[1].TRIGGER=1;
	REG_SOUNDCHANNEL[1].MODE=0; /* Only need interrupts from one channel */	
    ac->Active=1;
  }
}


void Audio_Disable(struct AudioContext *ac)
{
  if(ac->Active)
  {
    ac->Active=0;
	RemoveInterruptHandler(&ac->inthandler);
	REG_SOUNDCHANNEL[0].LEN=0;	
	REG_SOUNDCHANNEL[1].LEN=0;	
  }
}


static void ac_inthandler(void *ud)
{
	struct AudioContext *ac=(struct AudioContext *)ud;
	if(ac && ac->Active)
	{
		int buf=ac->ActiveBuffer^1;
		REG_SOUNDCHANNEL[0].LEN=AUDIOBUFFERSIZE/4;	
		REG_SOUNDCHANNEL[0].LEN=AUDIOBUFFERSIZE/4;	
		REG_SOUNDCHANNEL[0].DAT=(char *)ac->leftbuffer[buf];
		REG_SOUNDCHANNEL[1].DAT=(char *)ac->rightbuffer[buf];
		ac->ActiveBuffer=buf;
		SetSignal(0);
	}
}


void Audio_Clear(struct AudioContext *ac)
{
	int *buf=(int *)ac->leftbuffer[0];
	int *buf2=(int *)ac->rightbuffer[0];
	int *buf3=(int *)ac->leftbuffer[1];
	int *buf4=(int *)ac->rightbuffer[1];
	int i;
	for(i=0;i<AUDIOBUFFERSIZE/2;i+=4)
	{
		*buf++=0;
		*buf2++=0;
		*buf3++=0;
		*buf4++=0;
	}
}


struct AudioContext *Audio_Create()
{
	struct AudioContext *ac;
	if(!(ac=malloc(sizeof(struct AudioContext))))
		return(NULL);
	memset(ac,0,sizeof(struct AudioContext));
	ac->Dispose=Audio_Dispose;
	ac->Handle=Audio_Handle;
	ac->Enable=Audio_Enable;
	ac->Disable=Audio_Disable;
	ac->SetFillFunction=Audio_SetFillFunction;
	ac->inthandler.next=0;
	ac->inthandler.bit=INTERRUPT_AUDIO;
	ac->inthandler.userdata=ac;
	ac->inthandler.handler=ac_inthandler;

	ac->Active=0;
	ac->ActiveBuffer=0;

	ac->filebuffer=malloc(AUDIOBUFFERSIZE);
	ac->leftbuffer[0]=malloc(AUDIOBUFFERSIZE/2);
	ac->leftbuffer[1]=malloc(AUDIOBUFFERSIZE/2);
	ac->rightbuffer[0]=malloc(AUDIOBUFFERSIZE/2);
	ac->rightbuffer[1]=malloc(AUDIOBUFFERSIZE/2);

	Audio_Clear(ac);

	return(ac);
}


void Audio_Dispose(struct AudioContext *ac)
{
  if(ac)
  {
  	if(ac->filebuffer)
  		free(ac->filebuffer);
  	if(ac->leftbuffer[1])
  		free(ac->leftbuffer[1]);
  	if(ac->leftbuffer[0])
  		free(ac->leftbuffer[0]);
  	if(ac->rightbuffer[1])
  		free(ac->rightbuffer[1]);
  	if(ac->rightbuffer[0])
  		free(ac->rightbuffer[0]);
    if(ac->Active)
      ac->Disable(ac);

    free(ac);
  }
}


int Audio_Handle(struct AudioContext *ac)
{
	int bytesread=0;
	if(ac)
	{
		short *buf=(short *)ac->filebuffer;
		short *left,*right;
		int i;
		if(ac->FillFunction)
			bytesread=ac->FillFunction(ac->FillUserData,(char *)buf,AUDIOBUFFERSIZE);
		if(bytesread<AUDIOBUFFERSIZE)
		{
			for(i=bytesread;i<AUDIOBUFFERSIZE;++i)
			{
				buf[i]=0;
			}
		}
		left=(short *)ac->leftbuffer[ac->ActiveBuffer];	
		right=(short *)ac->rightbuffer[ac->ActiveBuffer];
		for(i=0;i<AUDIOBUFFERSIZE/4;++i)
		{
			*left++=*buf++;
			*right++=*buf++;
		}	
	}
	return(bytesread>0);
}

void Audio_SetFillFunction(struct AudioContext *ac,int (*fillfunc)(void *,char *,int),void *userdata)
{
    if(ac)
    {
        ac->FillFunction=fillfunc;
        ac->FillUserData=userdata;
    }
}

