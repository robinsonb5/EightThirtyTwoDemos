
#include <stdio.h>

#define NULL 0
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <minfat.h>
#include <fileutils.h>

#include <hw/spi.h>
#include <hw/uart.h>
#include <hw/soundhw.h>

#include "ptreplay.h"


char getserial()
{
	int c=HW_UART(REG_UART);
	if(c&(1<<REG_UART_RXINT))
	{
		c&=0xff;
		return(c);
	}
	return(0);
}


int main(int argc, char **argv)
{
	char *ptr;
	char *fn;
	struct wildcard_pattern pattern;
	pattern.casesensitive=0;
	pattern.pattern="*mod";
	while(1)
	{
		ChangeDirectoryByCluster(0);
		fn=FileSelector(&pattern);
		if(fn)
		{
			if((ptr=LoadFile(fn)))
			{
				printf("File successfully loaded to %x\n",(int)ptr);
				ptBuddyPlay(ptr,0);
				printf("Playing - press Esc to stop\n");
				while(getserial()!=27)
					;
				ptBuddyClose();
				free(ptr);
			}
			else
				printf("Loading failedn\n");
		}
	}
	return(0);
}


