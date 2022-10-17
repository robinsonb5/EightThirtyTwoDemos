/*
 * malloc.c
 *
 * Very simple linked-list based malloc()/free().
 *
 * Reworked to use the new memory pool system.
 *
 */

#include <sys/types.h>
#include <stdio.h>
#include <stddef.h>
#include <memorypool.h>
#include "malloc.h"
#include "hexdump.h"
#include "socmemory.h"


/* Return memory from a bank other than 0 */
void *malloc_high(size_t size)
{
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(!pool)
		return(0);
	return(pool->Alloc(pool,size,0,SOCMEMORY_BANK0));
}

/* Return memory from any bank */
void *malloc(size_t size)
{
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(!pool)
		return(0);
	return(pool->Alloc(pool,size,0,0));
}

/* Return memory from any bank with specific alignment */
void *malloc_aligned(size_t size,int alignment)
{
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(!pool)
		return(0);
	return(pool->AllocAligned(pool,size,alignment,0,0));
}

void free(void *ptr)
{
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(pool)
		pool->Free(pool,ptr);
}

int availmem()
{
	/* FIXME - calculate how much memory is availble */
	return(0);
}

void *calloc(int nmemb,size_t size)
{
	char *result=(char *)malloc(nmemb*size);
	if(result)
	{
		char *ptr=0;
		size*=nmemb;
		while(size--)
		{
			*ptr++=0;
		}
	}
	return(result);
}

