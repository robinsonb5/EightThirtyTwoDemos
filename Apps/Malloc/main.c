#define NULL 0
#include <sys/types.h>
#include <stdio.h>
//#include <stdlib.h>
#include "malloc.h"

#include "hw/uart.h"

int main(int argc, char **argv)
{
	int i,a;
	char *p,*p2,*p3,*p4;
//  initMem will be called automatically via a ctor.
//	_initMem();

	for(i=0;i<1;++i)
	{
		printf("Allocating memory\n");
		p=malloc(200000-10000*i);
		printf("p: %x\n",(int)p);
		if(p)
		{
			printf("Freeing memory\n");
			free(p);
		}
	}

#if 0
	malloc_dump();

	p=malloc(32768);
	malloc_dump();
	p2=malloc(80000);
	malloc_dump();
	p3=malloc(30000);
	malloc_dump();
	free(p);
	malloc_dump();
	free(p3);
	malloc_dump();
	free(p2);
	malloc_dump();
#endif

	puts("Allocating memory...\n");
	do {
		p=(char *)malloc(2048);
		if(p)
		{
			printf("Allocated 2k at %x\n - freeing..." ,p);
			free(p);
		}
		printf("\n");
		p=(char *)malloc(262144);
		if(p)
			printf("Allocated 256k at %x\n",p);
		printf("%d bytes free\n",availmem());
	} while(p);

	printf("Out of memory!\n");

	return(0);
}

