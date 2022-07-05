#ifndef AUDIOCONTEXT_H
#define AUDIOCONTEXT_H

#include <hw/soundhw.h>
#include <hw/interrupts.h>

#define AUDIOACTIVE 1
#define AUDIOINTACTIVE 2

#define AUDIOBUFFERSIZE 131072

struct AudioContext
{
  void (*Dispose)(struct AudioContext *ac);
  int (*Handle)(struct AudioContext *ac);
  void (*Enable)(struct AudioContext *ac);
  void (*Disable)(struct AudioContext *ac);
  void (*SetFillFunction)(struct AudioContext *ac,int (*fillfunc)(void *,char *,int),void *userdata);
  void *Server;
  int  (*FillFunction)(void *ud,char *buf,int len);
  void *FillUserData;
  int Active;
  int ActiveBuffer;
  struct InterruptHandler inthandler;
  void *filebuffer;
  void *leftbuffer[2];
  void *rightbuffer[2];
};

struct AudioContext *Audio_Create();

#endif

