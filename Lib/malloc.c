/*
 * malloc.c
 *
 * Very simple linked-list based malloc()/free().
 *
 * Simplified even further by Alastair M. Robinson for TG68 project.
 *
 */

#include <sys/types.h>
//#include "stdio.h"
#include "malloc.h"
#include "small_printf.h"

// Re-implement sbrk, since the libgloss version doesn't know about our memory map.
char *_sbrk(int nbytes)
{
	// Since we add the entire memory in _premain() we can skip this.
	printf("Custom sbrk asking for %d bytes\n",nbytes);
	return(0);
}


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

static inline void mark_block_dead(struct free_arena_header *ah)
{
#ifdef DEBUG_MALLOC
	ah->a.type = ARENA_TYPE_DEAD;
#endif
}

static inline void remove_from_main_chain(struct free_arena_header *ah)
{
	struct free_arena_header *ap, *an;

	mark_block_dead(ah);

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

	pah = ah->a.prev;
	nah = ah->a.next;
	if (pah->a.type == ARENA_TYPE_FREE &&
	    (char *)pah + pah->a.size == (char *)ah) {
		/* Coalesce into the previous block */
		pah->a.size += ah->a.size;
		pah->a.next = nah;
		nah->a.prev = pah;
		mark_block_dead(ah);

		ah = pah;
		pah = ah->a.prev;
	} else {
		/* Need to add this block to the free chain */
		ah->a.type = ARENA_TYPE_FREE;

		ah->next_free = __malloc_head.next_free;
		ah->prev_free = &__malloc_head;
		__malloc_head.next_free = ah;
		ah->next_free->prev_free = ah;
	}

	/* In either of the previous cases, we might be able to merge
	   with the subsequent block... */
	if (nah->a.type == ARENA_TYPE_FREE &&
	    (char *)ah + ah->a.size == (char *)nah) {
		ah->a.size += nah->a.size;

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

#if 0 // AMR - using a fixed arena.

	fp = (struct free_arena_header *)
	    mmap(NULL, fsize, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (fp == (struct free_arena_header *)MAP_FAILED) {
		return NULL;	/* Failed to get a block */
	}
#endif

	fp = (struct free_arena_header *)_sbrk(fsize);
	if(fp==0)
		return(NULL);

	/* Insert the block into the management chains.  We need to set
	   up the size and the main block list pointer, the rest of
	   the work is logically identical to free(). */
	fp->a.type = ARENA_TYPE_FREE;
	fp->a.size = fsize;

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

	/* Now we can allocate from this block */
	return __malloc_from_block(fp, size);

	return NULL;
}

void free(void *ptr)
{
	struct free_arena_header *ah;

	printf("Freeing memory at %x\n",ptr);

	if (!ptr)
		return;

	ah = (struct free_arena_header *)
	    ((struct arena_header *)ptr - 1);
	printf("Arena header at %x, %x, %d, %x, %x\n", ah,ah->a.type,ah->a.size,ah->a.next,ah->a.prev);
	/* Merge into adjacent free blocks */
	ah = __free_block(ah);
}


// Initialise memory for malloc.


// Identify RAM size by searching for aliases - up to a maximum of 64 megabytes

#define ADDRCHECKWORD 0x55aa44bb
#define ADDRCHECKWORD2 0xf0e1d2c3

static unsigned int addresscheck(volatile int *base,int cachesize)
{
	int i,j,k;
	int a1,a2;
	int aliases=0;
	unsigned int size=64;
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
	printf("SDRAM size (assuming no address faults) is 0x%d megabytes\n",size);
	
	return((unsigned int)base+(size*(1<<20)));
}

extern char _end; // Defined by the linker script

// FIXME - implement .ctors
//__attribute__((constructor(101)))  // Highest Priority
void _initMem(void)
{
	char *ramtop;
	ramtop=(char *)addresscheck((volatile int *)&_end,0);
	ramtop=(char*)((int)ramtop & 0xffff0000);
	malloc_add(&_end,ramtop-&_end);	// Add the entire RAM to the free memory pool
}

void malloc_dump()
{
	struct free_arena_header *h=&__malloc_head;
	struct arena_header *a=&h->a;
	int c=5;
	printf("All chunks\n");
	do
	{
		printf("Arena header at %x, type %x, size %x\n",a,a->type,a->size);
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
		h=h->next_free;
		a=&h->a;
		--c;
	} while(c && a && a->type!=ARENA_TYPE_HEAD);
}

