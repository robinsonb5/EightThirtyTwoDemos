#ifndef MEMORYPOOL_H
#define MEMORYPOOL_H

/*
	Routines to handle memory pools, with the ability to track memory of different types
	and with special alignment needs.
	Pools can be freed in a single call, or chunks can be freed individually.
*/

struct MemoryPool_AllocFragment;
struct MemoryPool_AllocRecord;

struct MemoryPool
{
	void (*Delete)(struct MemoryPool *pool);

	/* Allocate without alignment restrictions */
	void *(*Alloc)(struct MemoryPool *pool,int size, int flags,int flagmask);

	/* Allocate a chunk aligned to a boundary. */
	void *(*AllocAligned)(struct MemoryPool *pool,int size,int alignment,int flags,int flagmask);

	/* Allocate a chunk that fits within a "page" of specified alignment */
	void *(*AllocMasked)(struct MemoryPool *pool,int size,int alignment,int flags,int flagmask);

	/* Return a chunk of memory to the pool */
	void (*Free)(struct MemoryPool *pool,void *p);

	/* Free all chunks allocated with the above functions. */
	void (*FreeAll)(struct MemoryPool *pool);

	/* private */
	void *(*Provision)(struct MemoryPool *pool,int size,int flags,int flagmask);
	void *(*Release)(struct MemoryPool *pool, void *p);
	struct MemoryPool_AllocFragment *fragmentlist;
	struct MemoryPool_AllocRecord *recordlist;
	struct MemoryPool *parent;
};

struct MemoryPool *NewMemoryPool(struct MemoryPool *parent);

void MemoryPool_DumpFragments(struct MemoryPool *pool);

void MemoryPool_InitRootPool(struct MemoryPool *pool);
void MemoryPool_SeedMemory(struct MemoryPool *pool, void *p,int size,int flags);

#endif

