#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int buffer[24];
int buffer2[24];

// Assembly language function to spam the memory interface as fast as possible and test the write buffer.
void testfunc(char *buf);

int main(int argc, char **argv)
{
    int i;
    int err=0;
    srand(HW_TIMER(REG_MILLISECONDS));
    testfunc(buffer);
	memcpy(buffer2,buffer,sizeof(buffer));
    for(i=0;i<16;++i)
    {
    	if(buffer[i]!=0x00000055)
    	{
			++err;
			printf("Mismatch at %d: %x\n",i,buffer[i]);
    	}
    }
    for(i=16;i<4;++i)
    {
    	if(buffer[i]!=0xaaaaaaaa)
    	{
			++err;
			printf("Mismatch at %d: %x\n",i,buffer[i]);
    	}
    }
    printf("Completed with %d errors\n",err);

    return 0;
}

