#include "uart.h"
#include "soundhw.h"

#include <stdio.h>

#define NULL 0
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>

#include "replay.h"

fileTYPE *file;

static struct stat statbuf;


char *LoadFile(const char *filename)
{
	char *result=0;
	int fd=open(filename,0,O_RDONLY);
	printf("open() returned %d\n",fd);
	if((fd>0)&&!fstat(fd,&statbuf))
	{
		int n=statbuf.st_size; // 64-bit
		printf("File size is %d\n",n);
		result=(char *)malloc(n);
		if(result)
		{
			if(read(fd,result,n)<0)
			{
				printf("Read failed\n");
				free(result);
				result=0;
			}
		}
	}
	return(result);
}


int main(int argc, char **argv)
{
	char *ptr;
	if((ptr=LoadFile("DEEPHOUSMOD")))
//	if((ptr=LoadFile("SCARPTCHMOD")))
//	if((ptr=LoadFile("JOYRIDE MOD")))
//	if((ptr=LoadFile("ENIGMA     ")))
//	if((ptr=LoadFile("GUITAR~1   ")))
	{
		printf("File successfully loaded to %x\n",ptr);
		ptBuddyPlay(ptr,0);
//		REG_SOUNDCHANNEL[0].VOL=63;
//		REG_SOUNDCHANNEL[0].PERIOD=200;
//		REG_SOUNDCHANNEL[0].DAT=ptr;
//		REG_SOUNDCHANNEL[0].LEN=statbuf.st_size/2;
//		REG_SOUNDCHANNEL[0].TRIGGER=0;
	}
	else
		printf("Loading failedn\n");
	return(0);
}

