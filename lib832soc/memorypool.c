#include <stdio.h>

#include "memorypool.h"

void MemoryPool_DumpFragments(struct MemoryPool *pool);

struct MemoryPool_AllocFragment
{
	struct MemoryPool_AllocFragment *next;
	int size;
	int flags;
};

struct MemoryPool_AllocRecord
{
	struct MemoryPool_AllocRecord *next;
	int size;
};


#define GUARDWORD1 0x5aa5
#define GUARDWORD2 0xc22c

struct AllocTag
{
	unsigned short guard;
	int size;
	int flags;
	unsigned short guard2;
};


static void addfreerecord(struct MemoryPool *pool,struct MemoryPool_AllocRecord *record, int size)
{
	if(pool && record)
	{
		record->next=pool->recordlist;
		record->size=size;
		pool->recordlist=record;
	}
}


static void removefreerecord(struct MemoryPool *pool,struct MemoryPool_AllocRecord *p)
{
	struct MemoryPool_AllocRecord *record=pool->recordlist;
	if(pool->recordlist==p)
		pool->recordlist=pool->recordlist->next;
	else
	{
		while(record)
		{
			if(record->next==p)
			{
				record->next=record->next->next;
				record=0;
			}
			else
				record=record->next;
		}
	}
}


static void addfragment(struct MemoryPool *pool,void *p, int s,int flags)
{
	struct MemoryPool_AllocFragment *fragment;
	/* Don't bother with chunks less than four times the size of the header. */
	if(s>4*sizeof(struct MemoryPool_AllocFragment))
	{
		fragment=(struct MemoryPool_AllocFragment *)p;
		fragment->next=pool->fragmentlist;
		fragment->size=s;
		fragment->flags=flags;
		pool->fragmentlist=fragment;
	}
}


static void removefragment(struct MemoryPool *pool,struct MemoryPool_AllocFragment *p)
{
	struct MemoryPool_AllocFragment *Fragment=pool->fragmentlist;
	if(pool->fragmentlist==p)
		pool->fragmentlist=pool->fragmentlist->next;
	else
	{
		while(Fragment)
		{
			if(Fragment->next==p)
			{
				Fragment->next=Fragment->next->next;
				Fragment=0;
			}
			else
				Fragment=Fragment->next;
		}
	}
}


static void mergefragments(struct MemoryPool *pool)
{
	struct MemoryPool_AllocFragment *fragment1,*fragment2;

	fragment1=pool->fragmentlist;
	while(fragment1)
	{
		fragment2=fragment1->next;

		while(fragment2)
		{
			char *r1,*r2;
			r1=(char *)fragment1;
			r2=(char *)fragment2;
			if((r2-r1)==fragment1->size && fragment1->flags==fragment2->flags)
			{
				removefragment(pool,fragment2);
				fragment1->size+=fragment2->size;
				fragment2=fragment2->next;
			}
			else if((r1-r2)==fragment2->size && fragment1->flags==fragment2->flags)
			{
				removefragment(pool,fragment1);
				fragment2->size+=fragment1->size;
				fragment1=0;
				break;
			}
			else
				fragment2=fragment2->next;
		}
		if(fragment1)
			fragment1=fragment1->next;
		else
			fragment1=pool->fragmentlist; // Start over since Fragments were merged
	}
//	MemoryPool_DumpFragments(pool);
}


void MemoryPool_DumpFragments(struct MemoryPool *pool)
{
	struct MemoryPool_AllocFragment *Fragment=pool->fragmentlist;
	while(Fragment)
	{
		if((long)Fragment>1)
			printf("Fragment at %lx of size %x, flags %d\n",(long)Fragment,Fragment->size,Fragment->flags);
		else
		{
			printf("Bad Fragment at %lx\n",(long)Fragment);
			return;
		}
		Fragment=Fragment->next;
	}
}


static void *checkalign(int size, void *v,int chunksize,int alignment)
{
	char *p=(char *)v;
	long boundary;
	long mask;

	mask=alignment-1;
	mask=~mask;

	if(size>chunksize)
		return(0);      /* Definitely not big enough */

	boundary=((long)p+(alignment-1)) & mask;  /* Round up to the next boundary */
	if(((boundary-(long)p)+size)>chunksize)
		return(0);	/* Not enough space after the boundary */

	return((void *)boundary);
}


/* Horribly hacky function to return the flags from a newly-provisioned memory block.
   Only applicable to chunks allocated from a parent pool, not to the root pool. */
static int provision_getflags(void *p)
{
	char *p2=(char *)p;
	struct AllocTag *at;
	p2-=sizeof(struct MemoryPool_AllocRecord);
	p2-=sizeof(struct AllocTag);
	at=(struct AllocTag *)p2;
	return(at->flags);
}



static void *checkmask(int size,void *v,int chunksize,int alignment)
{
	char *p=(char *)v;
	long m1,m2;
	long boundary;
	long mask;

	mask=alignment-1;
	mask=~mask;

	printf("Using mask %lx\n",mask);

	if(size>chunksize)
		return(0);      /* Definitely not big enough */
	m1=(long)p & mask;
	m2=(long)(p+size-1) & mask;

	/* If we take a chunk from the start, will it cross a boundary? */
	if(m1 == m2)
	{
		/* No?  Good to go; */
		return(p);
	}

	m1=(long)(p+chunksize-size) & mask;
	m2=(long)(p+chunksize-1) & mask;

	/* If we take a chunk from the end, will it cross a boundary? */
	if(m1 == m2)
	{
		/* No?  Good to go; */
		return(p+chunksize-size);
	}

	/* Both simple cases would cross a boundary, so work from a boundary instead. */
	boundary=(long)p+(alignment-1);
	boundary&=mask;  /* Yes, I know, yuk. */

	/* Is the chunk still large enough? */
	if(((long)p+chunksize-boundary)>=size)
		return((void *)boundary);

	return(0);
}


static void AddAllocTag(void *p,int size,int flags)
{
	struct AllocTag *at;
	if(p)
	{
		at=(struct AllocTag *)p;
		at->guard=GUARDWORD1;
		at->size=size;
		at->flags=flags;
		at->guard2=GUARDWORD2;
		printf("Setting alloctag flags at %x to %x\n",(int)at,flags);
	}
}


static void *AllocAligned(struct MemoryPool *pool,int size,int alignment,int flags,int flagmask)
{
	char *result=0;
	char *p=0;
	int chunksize=alignment+size;	/* The minimum size guaranteed to be able to accommodate size bytes on a boundary */
	int fragflags=flags;
	struct MemoryPool_AllocFragment *fragment=pool->fragmentlist;

	while(fragment)
	{
		if(((fragment->flags^flags)&flagmask)==0)
		{
			if((result=(char *)checkalign(size,
				((char *)fragment)+sizeof(struct AllocTag),
				fragment->size-sizeof(struct AllocTag),alignment))) /* Do we have a match? */
			{
				/* If the current Fragment is big enough to accommodate the allocation,
				   remove it from the list. */
				fragflags=fragment->flags;
				removefragment(pool,fragment);
				p=(char *)fragment;
				chunksize=fragment->size;
				fragment=0;
			}
		}
		if(fragment)
			fragment=fragment->next;
	}

	if(!result)
	{
		struct AllocTag *at;
		int allocsize=chunksize+2*sizeof(struct AllocTag)+sizeof(struct MemoryPool_AllocRecord);
		if(pool && (p=pool->Provision(pool,allocsize,flags,flagmask)))
		{
			fragflags=provision_getflags(p);
			printf("Fragment flags %d\n",fragflags);
			result=checkalign(size,((char *)p)+sizeof(struct AllocTag),allocsize,alignment);
		}
	}

	if(result)
	{
		size+=sizeof(struct AllocTag);
		// Prepend the result with a tag;
		result-=sizeof(struct AllocTag);
		AddAllocTag(result,size,fragflags);

		if(result==p)
			addfragment(pool,p+size,chunksize-size,fragflags);
		else if((result+size)==(p+size*2))  // FIXME - p+chunksize maybe?
			addfragment(pool,p,chunksize-size,fragflags);
		else
		{
			addfragment(pool,p,result-p,fragflags);
			addfragment(pool,result+size,(p+chunksize)-(result+size),fragflags);
		}

		result+=sizeof(struct AllocTag);
	}
	return(result);
}


static void *AllocMasked(struct MemoryPool *pool,int size,int alignment,int flags,int flagmask)
{
	char *result=0;
	char *p=0;
	int fragflags=flags;
	int chunksize=size*2;	/* The minimum size guaranteed to be able to accommodate size bytes within a page */

	struct MemoryPool_AllocFragment *fragment=pool->fragmentlist;

	while(fragment)
	{
		printf("%x, %x, %x\n",fragment->flags,flags,(fragment->flags^flags)&flagmask);
		if(((fragment->flags^flags)&flagmask)==0)
		{
			if((result=(char *)checkmask(size,
				((char *)fragment)+sizeof(struct AllocTag),
				fragment->size-sizeof(struct AllocTag),alignment))) /* Do we have a match? */
			{
				/* If the current Fragment is big enough to accommodate the allocation,
				   remove it from the list. */
				fragflags=fragment->flags;
				removefragment(pool,fragment);
				p=(char *)fragment;
				chunksize=fragment->size;
				fragment=0;
			}
		}
		if(fragment)
			fragment=fragment->next;
	}


	if(!result)
	{
		int allocsize=chunksize+2*sizeof(struct AllocTag)+sizeof(struct MemoryPool_AllocRecord);
		if(pool && (p=pool->Provision(pool,allocsize,flags,flagmask)))
		{
			fragflags=provision_getflags(p);
			result=checkmask(size,p+sizeof(struct AllocTag),chunksize-sizeof(struct AllocTag),alignment);
		}
	}
	if(result)
	{
		size+=sizeof(struct AllocTag);
		// Prepend the result with a tag;
		result-=sizeof(struct AllocTag);
		AddAllocTag(result,size,fragflags);

		if(result==p)
			addfragment(pool,p+size,chunksize-size,fragflags);
		else if((result+size)==(p+size*2))  // FIXME - p+chunksize maybe?
			addfragment(pool,p,chunksize-size,fragflags);
		else
		{
			addfragment(pool,p,result-p,fragflags);
			addfragment(pool,result+size,(p+chunksize)-(result+size),fragflags);
		}

		result+=sizeof(struct AllocTag);
	}
	return(result);
}


static void *AllocUnmasked(struct MemoryPool *pool,int size, int flags, int flagmask)
{
	struct MemoryPool_AllocFragment *fragment=pool->fragmentlist;
	int fragflags=flags;
	char *p=0;
	size+=sizeof(struct AllocTag);
	while(!p && fragment)
	{
		if((fragment->size>=size) && ((fragment->flags^flags)&flagmask)==0)   /* Do we have a match? */
		{
			printf("Found fragment at %lx with size %x and flags %d\n",(long)fragment,fragment->size,fragment->flags);
			removefragment(pool,fragment);
			addfragment(pool,(char *)fragment+size,fragment->size-size,fragment->flags);     /* Record leftovers */
			fragflags=fragment->flags;
			p=(char *)fragment;
		}
		else
			fragment=fragment->next;
	}
	/* No Fragments found?  Allocate a fresh chunk. */
	if(!p && pool && (p=pool->Provision(pool,size,flags,flagmask)))
	{
		fragflags=provision_getflags(p);
		p+=sizeof(struct MemoryPool_AllocRecord);
	}
	if(p)
	{
		// Prepend the result with a tag;
		AddAllocTag(p,size,fragflags);
		p+=sizeof(struct AllocTag);
	}
//	printf("Memory allocated at %x (size %x)\n",(long)p,size-sizeof(struct AllocTag));
	return(p);
}


static void Free(struct MemoryPool *pool,void *p)
{
	struct AllocTag *at=(struct AllocTag *)(((char *)p)-sizeof(struct AllocTag));
	if(!p)
		return;
	if(at->guard==GUARDWORD1 && at->guard2==GUARDWORD2)
	{
		at->guard=at->guard2=-1;
		addfragment(pool,(void *)at,at->size,at->flags); // Fragment->flags);
	}
	else
		printf("Error - chunk at %lx has guardwords %x and %x\n",(long)p,at->guard,at->guard2);

	mergefragments(pool);
}


static void FreeAllMasked(struct MemoryPool *pool)
{
	struct MemoryPool_AllocRecord *record=pool->recordlist;

	while(record)
	{
		struct MemoryPool_AllocRecord *nextrecord=record->next;
		removefreerecord(pool,record);
		if(pool->parent)
			pool->parent->Free(pool->parent,record);
		record=nextrecord;
	}
	pool->recordlist=0;
	pool->fragmentlist=0;
}


static void *Provision(struct MemoryPool *pool,int size,int flags,int flagmask)
{
	char *p=0;
	if(pool && pool->parent)
	{
		p=pool->parent->Alloc(pool->parent,size,flags,flagmask);
		if(p)
		{
			addfreerecord(pool,(struct MemoryPool_AllocRecord *)p,size);
			p+=sizeof(struct MemoryPool_AllocRecord);
		}
	}

	return(p);
}


/* Release a chunk back to the parent pool. */

static void *Release(struct MemoryPool *pool,void *p)
{
	printf("FIXME - release not yet implemented\n");
}


static void deletepool(struct MemoryPool *pool)
{
	FreeAllMasked(pool);
	if(pool->parent)
		pool->parent->Free(pool->parent,pool);
}


static void initpool(struct MemoryPool *pool,struct MemoryPool *parent)
{
	pool->parent=parent;
	pool->Delete=deletepool;
	pool->AllocMasked=AllocMasked;
	pool->AllocAligned=AllocAligned;
	pool->Alloc=AllocUnmasked;
	pool->Free=Free;
	pool->FreeAll=FreeAllMasked;
	pool->Provision=Provision;
	pool->Release=Release;
	pool->recordlist=0;
	pool->fragmentlist=0;
}

/* Straightforward single-linked list of allocation and Fragment records. */

struct MemoryPool *NewMemoryPool(struct MemoryPool *parent)
{
	struct MemoryPool *pool=0;
	if(parent)
		pool=parent->Alloc(parent,sizeof(struct MemoryPool),0,0);
	if(pool)
		initpool(pool,parent);
	return(pool);
}


static void deleterootpool(struct MemoryPool *pool)
{
	FreeAllMasked(pool);
	printf("Error: attempt to delete root memory pool!\n");
}

static void *provisionrootpool(struct MemoryPool *pool,int size,int flags, int flagmask)
{
	printf("Error: Out of memory!\n");
	return(0);
}

void MemoryPool_InitRootPool(struct MemoryPool *pool)
{
	if(pool)
	{
		initpool(pool,0);
		pool->Delete=deleterootpool;
		pool->Provision=provisionrootpool;
	}
}

void MemoryPool_SeedMemory(struct MemoryPool *pool,void *p,int size,int flags)
{
	if(pool)
	{
		char *c=(char *)p;
		printf("Memory pool - adding %x bytes at %x, flags %d\n",size,(int)p,flags);
		addfreerecord(pool,p,size);
		c+=sizeof(struct MemoryPool_AllocRecord);
		size-=sizeof(struct MemoryPool_AllocRecord);
		addfragment(pool,c,size,flags);
	}
}

#if 0
#include <stdlib.h>

int main(int argc,char **argv)
{
	struct MemoryPool rmp;
	void *m[5];
	void *t,*t2;
	int i;
	int size=64*1024*1024;
	t=malloc(size);
	t2=malloc(size);
	MemoryPool_InitRootPool(&rmp);
	printf("Seeding memory at %lx, flags %d\n",(long)t,0);
	MemoryPool_SeedMemory(&rmp,t,size,0);
	printf("Seeding memory at %lx, flags %d\n",(long)t2,1);
	MemoryPool_SeedMemory(&rmp,t2,size,1);

	m[0]=rmp.Alloc(&rmp,65536,0,0);
	m[1]=rmp.AllocAligned(&rmp,65536,4096,0,1);
	m[2]=rmp.AllocMasked(&rmp,4096,16384,0,0);
	m[3]=rmp.AllocAligned(&rmp,65536,4096,1,1);
	m[4]=rmp.AllocMasked(&rmp,4096,16384,1,1);

	for(i=0;i<5;++i)
	{
		printf("Allocated memory at %lx\n",(long)m[i]);
		if(m[i])
			rmp.Free(&rmp,m[i]);
	}

	rmp.FreeAll(&rmp);
	free(t);
	free(t2);

	return(0);
}
#endif

