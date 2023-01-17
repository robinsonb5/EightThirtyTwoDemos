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
#include <string.h>
#include <memorypool.h>
#include "malloc.h"
#include "hexdump.h"
#include "socmemory.h"

struct mallocchecker
{
	struct mallocchecker *next,*prev;
	void *p;
};

struct mallocchecker *root=0;


struct mallocchecker *mallocchecker_new(struct mallocchecker *parent,void *p)
{
	int i;
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(!pool)
		return(0);
	struct mallocchecker *region=(struct mallocchecker *)pool->Alloc(pool,sizeof(struct mallocchecker),0,0);
	if(region)
	{
		if(parent)
		{
			region->next=parent->next;
			if(parent->next)
				parent->next->prev=region;
			region->prev=parent;
			parent->next=region;		
		}
		else
		{
			root=region;
			region->next=region->prev=0;
		}
		region->p=p;
	}
	return(region);
}

void mallocchecker_delete(struct mallocchecker *region)
{
//	printf("\nDeleting region\n\n");
	if(region->next)
		region->next->prev=region->prev;
	if(region->prev)
		region->prev->next=region->next;
	else
		root=region->next;
	free(region);
}

struct mallocchecker *mallocchecker_find(void *p)
{
	struct mallocchecker *m=root;
	while(m)
	{
		if(m->p==p)
			return(m);
		m=m->next;
	}
	return(0);
}


void mallocchecker_test()
{
	struct mallocchecker *m=root;
	while(m)
	{
		MemoryPool_CheckTags(m->p);
		m=m->next;
	}
}


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
	void *p;
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(!pool)
		return(0);
	p=pool->Alloc(pool,size,0,0);
	mallocchecker_new(root,p);
	return(p);
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
	struct mallocchecker *m=mallocchecker_find(ptr);
	mallocchecker_test();
	if(m)
		mallocchecker_delete(m);
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

void *realloc(void *ptr, size_t size)
{
	void *result=malloc(size);
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(!ptr)
		return(result);
	if(pool)
	{
		int oldsize=pool->GetAllocSize(pool,ptr);
		if(oldsize)
			memcpy(result,ptr,oldsize);
		else
		{
			printf("Error - can't fetch size of old block\n");
			free(result);
			result=0;
		}
		free(ptr);
	}
	return(result);
}

