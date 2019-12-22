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
	return(0);

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

