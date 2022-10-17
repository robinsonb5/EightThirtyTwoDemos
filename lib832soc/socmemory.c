#include <sys/types.h>
#include <stdio.h>
#include <stddef.h>
#include <memorypool.h>
#include <socmemory.h>

static struct MemoryPool rootmemorypool;

struct MemoryPool *SoCMemory_GetPool()
{
	return(&rootmemorypool);
}

extern char _bss_end__; // Defined by the linker script
extern char STACKSIZE;
static char *stacksize=&STACKSIZE;

/* Identify RAM size by searching for aliases - up to a maximum of 64 megabytes */

#define ADDRCHECKWORD 0x55aa44bb
#define ADDRCHECKWORD2 0xf0e1d2c3


#define MAXMEMBIT 27

__constructor(100.socmeory) void _initMem()
{
	int ss=(int)stacksize;
	volatile int *freebase=(int*)&_bss_end__;
	char *rambase;
	char *ramtop;
	int i;
	int a1;
	int aliases=0;
	int banksize;
	unsigned int size=1<<(MAXMEMBIT-19);

	freebase+=(int)stacksize;

	printf("__bss_end__ is %x\n",(int)&_bss_end__);
	printf("STACKSIZE is %x\n",(int)stacksize);

	// Seed the RAM;
	a1=19;
	*freebase=ADDRCHECKWORD;
	for(i=18;i<MAXMEMBIT;++i)
	{
		freebase[a1]=ADDRCHECKWORD;
		a1<<=1;
	}	

	//	If we have a cache we need to flush it here.

	// Now check for aliases
	a1=1;
	*freebase=ADDRCHECKWORD2;
	for(i=1;i<MAXMEMBIT;++i)
	{
		if(freebase[a1]==ADDRCHECKWORD2)
			aliases|=a1;
		a1<<=1;
	}

	aliases<<=2;

	while(aliases)
	{
		aliases=(aliases<<1)&0xfffffff;	// Test currently supports up to 64m longwords = 256 megabytes.
		size>>=1;
	}
	printf("RAM size (assuming no address faults) is 0x%x megabytes\n",size);
	
	banksize=(size/4)<<20;;	
	rambase=(char*)freebase;
	rambase=(char *)(((int)rambase)&0xfff00000);	/* Round down to the nearest megabyte */

	MemoryPool_InitRootPool(&rootmemorypool);
	MemoryPool_SeedMemory(&rootmemorypool,rambase+3*banksize,banksize,SOCMEMORY_BANK3);
	MemoryPool_SeedMemory(&rootmemorypool,rambase+2*banksize,banksize,SOCMEMORY_BANK2);
	MemoryPool_SeedMemory(&rootmemorypool,rambase+banksize,banksize,SOCMEMORY_BANK1);
	MemoryPool_SeedMemory(&rootmemorypool,(char *)freebase,banksize-((char *)freebase-rambase),SOCMEMORY_BANK0);
}

