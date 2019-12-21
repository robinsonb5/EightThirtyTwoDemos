#define NULL 0
#include <sys/types.h>
//#include <stdlib.h>
#include "malloc.h"

#include "uart.h"
#include "small_printf.h"

int main(int argc, char **argv)
{
	char *p,*p2,*p3,*p4;
	_initMem();
	malloc_dump();
	p=malloc(32768);
	p2=malloc(80000);
	p3=malloc(30000);
	free(p);
	free(p3);
	free(p2);

	puts("Allocating memory...\n");
	do
	{
		p=(char *)malloc(2048);
		if(p)
		{
			printf("Allocated 2k at %d\n - freeing..." ,p);
			free(p);
		}
		p=(char *)malloc(262144);
		if(p)
			printf("Allocated 256k at %d\n",p);
	} while(p);
	printf("Out of memory!\n");

	printf("Header sizes: %d, %d\n",sizeof(struct arena_header),sizeof(struct free_arena_header));
	return(0);
}

