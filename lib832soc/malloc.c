/*
 * malloc.c
 *
 * Very simple linked-list based malloc()/free().
 *
 * Simplified even further by Alastair M. Robinson for TG68 project.
 *
 */

#include <sys/types.h>
#include <stdio.h>
#include <stddef.h>
#include "malloc.h"
#include "hexdump.h"


/* Both the arena list and the free memory list are double linked
   list with head node.  This the head node. Note that the arena list
   is sorted in order of address. */
static struct free_arena_header __malloc_head = {
	{
		ARENA_TYPE_HEAD,
		0,
		&__malloc_head,
		&__malloc_head,
	},
	&__malloc_head,
	&__malloc_head
};

static inline void remove_from_main_chain(struct free_arena_header *ah)
{
	struct free_arena_header *ap, *an;
	ap = ah->a.prev;
	an = ah->a.next;
	ap->a.next = an;
	an->a.prev = ap;
}

static inline void remove_from_free_chain(struct free_arena_header *ah)
{
	struct free_arena_header *ap, *an;
	ap = ah->prev_free;
	an = ah->next_free;
	ap->next_free = an;
	an->prev_free = ap;
}

static inline void remove_from_chains(struct free_arena_header *ah)
{
	remove_from_free_chain(ah);
	remove_from_main_chain(ah);
}

void *__malloc_from_block(struct free_arena_header *fp, size_t size)
{
	size_t fsize;
	struct free_arena_header *nfp, *na, *fpn, *fpp;

	fsize = fp->a.size;
	/* We need the 2* to account for the larger requirements of a
	   free block */
	if (fsize >= (size + 2 * sizeof(struct arena_header))) {
		/* Bigger block than required -- split block */
		nfp = (struct free_arena_header *)((char *)fp + size);
		na = fp->a.next;

		nfp->a.type = ARENA_TYPE_FREE;
		nfp->a.size = fsize - size;
		fp->a.type = ARENA_TYPE_USED;
		fp->a.size = size;


		/* Insert into all-block chain */
		nfp->a.prev = fp;
		nfp->a.next = na;
		na->a.prev = nfp;
		fp->a.next = nfp;

		/* Replace current block on free chain */
		nfp->next_free = fpn = fp->next_free;
		nfp->prev_free = fpp = fp->prev_free;
		fpn->prev_free = nfp;
		fpp->next_free = nfp;
	} else {
		fp->a.type = ARENA_TYPE_USED; /* Allocate the whole block */
		remove_from_free_chain(fp);
	}

	return (void *)(&fp->a + 1);
}

static struct free_arena_header *__free_block(struct free_arena_header *ah)
{
	struct free_arena_header *pah, *nah;

	printf("Free block: %x\n",(int)ah);

	pah = ah->a.prev;
	nah = ah->a.next;

#if 0
	hexdump(ah,sizeof(struct free_arena_header));
	printf("Prev: %x\n",(int)pah);
	hexdump(pah,sizeof(struct free_arena_header));
	printf("Next: %x\n",(int)nah);
	hexdump(nah,sizeof(struct free_arena_header));

	printf("end of prev: %x\n",(int)((char *)pah + pah->a.size));
#endif

	if (pah->a.type == ARENA_TYPE_FREE &&
	    (char *)pah + pah->a.size == (char *)ah) {
		/* Coalesce into the previous block */
		printf("Coalescing...\n");
		pah->a.size += ah->a.size;
		pah->a.next = nah;
		nah->a.prev = pah;

		ah = pah;
		pah = ah->a.prev;
	} else {
		/* Need to add this block to the free chain */
		ah->a.type = ARENA_TYPE_FREE;

//		hexdump(&__malloc_head,sizeof(struct free_arena_header));
//		printf("Add to free chain: %x\n",(int)ah);

		ah->next_free = __malloc_head.next_free;
		ah->prev_free = &__malloc_head;
		__malloc_head.next_free = ah;
		ah->next_free->prev_free = ah;
//		hexdump(&__malloc_head,sizeof(struct free_arena_header));
//		hexdump(ah,sizeof(struct free_arena_header));
//		hexdump(ah->next_free,sizeof(struct free_arena_header));
	}

	/* In either of the previous cases, we might be able to merge
	   with the subsequent block... */
	if (nah->a.type == ARENA_TYPE_FREE &&
	    (char *)ah + ah->a.size == (char *)nah) {
		ah->a.size += nah->a.size;
		printf("Merging with subsequent block: %x\n",(int)nah);

		/* Remove the old block from the chains */
		remove_from_chains(nah);
	}

	/* Return the block that contains the called block */
	return ah;
}


void malloc_add(void *p,size_t size)
{
	struct free_arena_header *fp;
	struct free_arena_header *pah;
	fp=(struct free_arena_header *)p;
	fp->a.type = ARENA_TYPE_FREE;
	fp->a.size = size & ~MALLOC_CHUNK_MASK; // Round down size to fit chunk mask


	printf("Adding %x bytes at %x to the memory pool\n",size,p);

	printf("Malloc head: %x\n",(int)&__malloc_head);

	/* We need to insert this into the main block list in the proper
	   place -- this list is required to be sorted.  Since we most likely
	   get memory assignments in ascending order, search backwards for
	   the proper place. */
	for (pah = __malloc_head.a.prev; pah->a.type != ARENA_TYPE_HEAD;
	     pah = pah->a.prev) {
		if (pah < fp)
			break;
	}

	/* Now pah points to the node that should be the predecessor of
	   the new node */
	fp->a.next = pah->a.next;
	fp->a.prev = pah;
	pah->a.next = fp;
	fp->a.next->a.prev = fp;

	/* Insert into the free chain and coalesce with adjacent blocks */
	fp = __free_block(fp);
}


void *malloc(size_t size)
{
	struct free_arena_header *fp;
	struct free_arena_header *pah;
	size_t fsize;

	printf("Custom malloc asking for 0x%x bytes\n",size);

	if (size == 0)
		return NULL;

	/* Add the obligatory arena header, and round up */
	size = (size + 2 * sizeof(struct arena_header) - 1) & ARENA_SIZE_MASK;
	for (fp = __malloc_head.next_free; fp->a.type != ARENA_TYPE_HEAD;
	     fp = fp->next_free) {

		if (fp->a.size >= size) {
			/* Found fit -- allocate out of this block */
			return __malloc_from_block(fp, size);
		}
	}

	/* Nothing found... need to request a block from the kernel */

	fsize = (size + MALLOC_CHUNK_MASK) & ~MALLOC_CHUNK_MASK;

	return NULL;
}

void free(void *ptr)
{
	struct free_arena_header *ah;

	if (!ptr)
		return;

	ah = (struct free_arena_header *)
	    ((struct arena_header *)ptr - 1);
	/* Merge into adjacent free blocks */
	ah = __free_block(ah);
}


// Initialise memory for malloc.


void malloc_dump()
{
	struct free_arena_header *h=&__malloc_head;
	struct arena_header *a=&h->a;
	int c=5;
	printf("All chunks\n");
	do
	{
		printf("Arena header at %x, type %x, size %x\n",a,a->type,a->size);
//		hexdump(a,sizeof(struct free_arena_header));
		h=a->next;
		a=&h->a;
		--c;
	} while(c && a && a->type!=ARENA_TYPE_HEAD);

	printf("Free chunks\n");
	a=&__malloc_head.a;
	c=5;
	do
	{
		printf("Arena header at %x, type %x, size %x\n",a,a->type,a->size);
//		hexdump(a,sizeof(struct arena_header));
		h=h->next_free;
		a=&h->a;
		--c;
	} while(c && a && a->type!=ARENA_TYPE_HEAD);
}

int availmem()
{
	int result=0;
	struct free_arena_header *h=__malloc_head.next_free;
	while(h && h->a.type==ARENA_TYPE_FREE)
	{
		result+=h->a.size;
//		hexdump(h,sizeof(struct free_arena_header));
//		printf("Free: %d\n",result);
		h=h->next_free;
	}
	return(result);
}


extern char _bss_end__; // Defined by the linker script
extern char STACKSIZE
static char *stacksize=&STACKSIZE;

// Identify RAM size by searching for aliases - up to a maximum of 64 megabytes

#define ADDRCHECKWORD 0x55aa44bb
#define ADDRCHECKWORD2 0xf0e1d2c3

__constructor(100.malloc) void _initMem()
{
	int ss=(int)*stacksize;
	volatile int *base=(int*)&_bss_end__;
	char *ramtop;
	int i,j,k;
	int a1,a2;
	int aliases=0;
	unsigned int size=64;

	base+=(int)*stacksize;

	printf("__bss_end__ is %x\n",(int)&_bss_end__);
	printf("STACKSIZE is %x\n",(int)*stacksize);

	// Seed the RAM;
	a1=19;
	*base=ADDRCHECKWORD;
	for(j=18;j<25;++j)
	{
		base[a1]=ADDRCHECKWORD;
		a1<<=1;
	}	

	//	If we have a cache we need to flush it here.

	// Now check for aliases
	a1=1;
	*base=ADDRCHECKWORD2;
	for(j=1;j<25;++j)
	{
		if(base[a1]==ADDRCHECKWORD2)
			aliases|=a1;
		a1<<=1;
	}

	aliases<<=2;

	while(aliases)
	{
		aliases=(aliases<<1)&0x3ffffff;	// Test currently supports up to 16m longwords = 64 megabytes.
		size>>=1;
	}
	printf("RAM size (assuming no address faults) is 0x%x megabytes\n",size);
	
	ramtop=(char*)base+(size*(1<<20));
	ramtop=(char*)((int)ramtop & 0xffff0000);
	malloc_add(base,ramtop-base);	// Add the entire RAM to the free memory pool
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

