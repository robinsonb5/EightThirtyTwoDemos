
#include <hw/uart.h>
#include <stdio.h>

#define RAM_MAXBIT 29

/* FIXME - use a smaller LFSR - this one will fail for RAMs smaller than 8 meg. */
#define CYCLE_LFSR {lfsr<<=1; if(lfsr&0x400000) lfsr|=1; if(lfsr&0x200000) lfsr^=1;}

/* Force a read-read of cache contents.  Takes the size of the cache (in bytes) as a parameter.
   Works using a brute-force read of four times as much data as will fit in the cache, ensuring
   that everything has to be flushed out. */
void refreshcache(volatile int *base,int size)
{
	int t;
	int i;

	for(i=0;i<size;++i)
		t=*base++;
}


/* Sanity check.  First stage check, writes and reads a bit pattern, and ensures that the same
   bit pattern is read back, before and after a cache refresh. */

static const int sanitycheck_bitpatterns[]={0x00000000,0x55555555,0xaaaaaaaa,0xffffffff};

int sanitycheck(volatile int *base,int cachesize)
{
	int result=1;
	int i;
	for(i=0;i<(sizeof(sanitycheck_bitpatterns)/sizeof(int));++i)
	{
		*base=sanitycheck_bitpatterns[i];
		if (*base!=sanitycheck_bitpatterns[i])
		{
			printf("Sanity check failed (before cache refresh) on 0x%x (got 0x%x)\n",sanitycheck_bitpatterns[i],*base);
			result=0;
		}
		refreshcache(base,cachesize);
		if (*base!=sanitycheck_bitpatterns[i])
		{
			printf("Sanity check failed (after cache refresh) on 0x%x (got 0x%x)\n",sanitycheck_bitpatterns[i],*base);
			result=0;
		}
	}
	return(result);
}


int bytecheck(volatile int *base,int cachesize)
{
	int result=1;
	volatile unsigned char *b2=(volatile unsigned char *)base;
	volatile unsigned short *b3=(volatile unsigned short *)base;
	int t;

	t=base[0];
	t=base[1];
	t=base[2];
	t=base[3];

	base[0]=0x55555555;
	base[3]=0xaaaaaaaa;

	b2[0]=0xcc;
	b2[15]=0x33;

	if(base[0]!=0x555555cc)
	{
		printf("Byte check failed (before cache refresh) at 0 (got 0x%x)\n",base[0]);
		result=0;
	}

	if(base[3]!=0x33aaaaaa)
	{
		printf("Byte check failed (before cache refresh) at 3 (got 0x%x)\n",base[3]);
		result=0;
	}

	// Try again now the values are in cache.
	b2[1]=0x12;
	b3[7]=0xfedc;

	if(base[0]!=0x555512cc)
	{
		printf("Byte check 2 failed (before cache refresh) at 0 (got 0x%x)\n",base[0]);
		result=0;
	}

	if(base[3]!=0xdcfeaaaa)
	{
		printf("Byte check 2 failed (before cache refresh) at 3 (got 0x%x)\n",base[3]);
		result=0;
	}

	refreshcache(base,cachesize);

	if(base[0]!=0x5555cc12)
	{
		printf("Byte check failed (after cache refresh) at 0 (got 0x%x)\n",base[0]);
		result=0;
	}

	if(base[3]!=0xdcfeaaaa)
	{
		printf("Byte check failed (after cache refresh) at 3 (got 0x%x)\n",base[3]);
		result=0;
	}

	b2[2]=0x0f;
	b2[13]=0xf0;
	// Check byte reads from various alignments
	if(b2[0]!=0xcc)
	{
		printf("Byte read check failed at 0 (got 0x%x)\n",b2[0]);
		result=0;
	}
	if(b2[1]!=0x12)
	{
		printf("Byte read check failed at 1 (got 0x%x)\n",b2[1]);
		result=0;
	}
	if(b2[2]!=0x0f)
	{
		printf("Byte read check failed at 2 (got 0x%x)\n",b2[2]);
		result=0;
	}
	if(b2[3]!=0x55)
	{
		printf("Byte read check failed at 3 (got 0x%x)\n",b2[3]);
		result=0;
	}
	if(b2[12]!=0xaa)
	{
		printf("Byte read check failed at 12 (got 0x%x)\n",b2[12]);
		result=0;
	}
	if(b2[13]!=0xf0)
	{
		printf("Byte read check failed at 13 (got 0x%x)\n",b2[13]);
		result=0;
	}
	if(b2[14]!=0xfe)
	{
		printf("Byte read check failed at 14 (got 0x%x)\n",b2[14]);
		result=0;
	}
	if(b2[15]!=0xdc)
	{
		printf("Byte read check failed at 15 (got 0x%x)\n",b2[15]);
		result=0;
	}

	if(b3[0]!=0xcc12)
	{
		printf("Word read check failed at 0 (got 0x%x)\n",b3[0]);
		result=0;
	}
	if(b3[7]!=0xfedc)
	{
		printf("Word read check failed at 7 (got 0x%x)\n",b3[7]);
		result=0;
	}

	return(result);
}


int aligncheck(volatile int *base,unsigned int cachesize)
{
	int result=1;
	int t;
	volatile unsigned char *b=(volatile unsigned char *)base;
	base[0]=0x00112233;
	base[1]=0x44556677;
	base[2]=0x8899aabb;
	base[3]=0xccddeeff;
	base[4]=0x5555aaaa;

	t=*(volatile int *)(b+2);
	if(t!=0x22334455)
	{
		printf("Align check failed (before cache refresh) at 2 (got 0x%x)\n",t);
		result=0;
	}
	t=*(volatile int *)(b+6);
	if(t!=0x66778899)
	{
		printf("Align check failed (before cache refresh) at 6 (got 0x%x)\n",t);
		result=0;
	}
	t=*(volatile int *)(b+10);
	if(t!=0xaabbccdd)
	{
		printf("Align check failed (before cache refresh) at 10 (got 0x%x)\n",t);
		result=0;
	}
	t=*(volatile int *)(b+14);
	if(t!=0xeeff5555)
	{
		printf("Align check failed (before cache refresh) at 14 (got 0x%x)\n",t);
		result=0;
	}

	refreshcache(base,cachesize);

	t=*(volatile int *)(b+2);
	if(t!=0x22334455)
	{
		printf("Align check failed (after cache refresh) at 2 (got 0x%x)\n",t);
		result=0;
	}
	t=*(volatile int *)(b+6);
	if(t!=0x66778899)
	{
		printf("Align check failed (after cache refresh) at 6 (got 0x%x)\n",t);
		result=0;
	}
	t=*(volatile int *)(b+10);
	if(t!=0xaabbccdd)
	{
		printf("Align check failed (after cache refresh) at 10 (got 0x%x)\n",t);
		result=0;
	}
	t=*(volatile int *)(b+14);
	if(t!=0xeeff5555)
	{
		printf("Align check failed (after cache refresh) at 14 (got 0x%x)\n",t);
		result=0;
	}
	return(result);
}


#define LFSRSEED 12467

int lfsrcheck(volatile int *base,unsigned int size)
{
	int result=1;
	int cycles=127;
	int goodreads=0;
	/* Shift left 20 bits to convert to megabytes, then 2 bits right since we're dealing with longwords */
	unsigned int mask=(size<<18)-1;
	unsigned int lfsr=LFSRSEED;
	printf("Checking memory");
	while(--cycles)
	{
		int i;
		unsigned int lfsrtemp;
		unsigned int addrmask=0;
		putchar('.');
		lfsrtemp=lfsr;
		for(i=0;i<262144;++i)
		{
			unsigned int w=lfsr&0xfffff;
			unsigned int j=lfsr&0xfffff;
			base[j^addrmask]=w;

			CYCLE_LFSR;
		}
		lfsr=lfsrtemp;
		for(i=0;i<262144;++i)
		{
			unsigned int w=lfsr&0xfffff;
			unsigned int j=lfsr&0xfffff;
			unsigned int jr;
			jr=base[j^addrmask];
			if(jr!=w)
			{
				result=0;
				printf("0x%x good reads, ",goodreads);
				printf("Error at 0x%x, expected 0x%x, got 0x%x\n",j^addrmask, w,jr);
				goodreads=0;
			}
			else
				++goodreads;
			CYCLE_LFSR;
		}
		CYCLE_LFSR;
		addrmask|=lfsr;
		addrmask&=mask;
	}
	putchar('\n');
	return(result);
}


int linearcheck(volatile int *base,unsigned int size)
{
	int result=1;
	int cycles=127;
	int goodreads=0;
	/* Shift left 20 bits to convert to megabytes, then 2 bits right since we're dealing with longwords */
	unsigned int limit=(size<<18);
	unsigned int lfsr=LFSRSEED;
	unsigned int lfsrtemp;
	unsigned int addrmask=0;
	int i;
	printf("Linear memory check - limit %x\n",limit);
	printf("Writing...\n");
	lfsrtemp=lfsr;
	for(i=0;i<limit;++i)
	{
		unsigned int w=lfsr;
		base[i]=w;
		CYCLE_LFSR;
	}
	lfsr=lfsrtemp;
	printf("Reading...\n");
	for(i=0;i<limit;++i)
	{
		unsigned int w=lfsr;
		unsigned int jr;
		jr=base[i];
		if(jr!=w)
		{
			result=0;
			printf("0x%x good reads, ",goodreads);
			printf("Error at 0x%x, expected 0x%x, got 0x%x\n",i, w,jr);
			goodreads=0;
		}
		else
			++goodreads;
		CYCLE_LFSR;
	}
	putchar('\n');
	return(result);
}


/* Check for bad address bits and aliases. */

#define ADDRCHECKWORD 0x55aa44bb
#define ADDRCHECKWORD2 0xf0e1d2c3

unsigned int addresscheck(volatile int *base,int cachesize)
{
	int result=1;
	int i,j,k;
	int a1,a2;
	int aliases=0;
	unsigned int size=(1<<RAM_MAXBIT-20);
	// Seed the RAM;
	a1=1;
	*base=ADDRCHECKWORD;
	for(j=0;j<RAM_MAXBIT-2;++j)
	{
		a2=1;
		for(i=0;i<RAM_MAXBIT-2;++i)
		{
			base[a1|a2]=ADDRCHECKWORD;
			a2<<=1;
		}
		a1<<=1;
	}	
	refreshcache(base,cachesize);

	/* Now check for aliases */
	a1=1;
	*base=ADDRCHECKWORD2;
	for(j=0;j<RAM_MAXBIT-2;++j)
	{
		if(base[a1]==ADDRCHECKWORD2)
		{
			/* An alias isn't necessarily a failure. */
			aliases|=a1;
		}
		else if(base[a1]!=ADDRCHECKWORD)
		{
			result=0;
			printf("Bad data found at 0x%x (0x%x)\n",a1<<2, base[a1]);
		}
		a1<<=1;
	}
	aliases<<=2;
	if(aliases)
	{
		int aliasmask=1<<(RAM_MAXBIT-1);
		int aliasmask2=(1<<(RAM_MAXBIT))-1;

		while(aliases)
		{
			if((aliases&aliasmask)==0)	/* If the alias bits aren't contiguously the high bits, then it indicates a bad address. */
				result=0;
			aliases=(aliases<<1)&aliasmask2;
			size>>=1;
		}
		if(!result)
		{
			printf("Aliases found at 0x%x\n",aliases);
			size=1;
		}
	}
	
	return(size);
}


int simplecheck(volatile int *base, int cachesize)
{
	int result=1;
	base[0]=0x11223344;
	base[1]=0x55667788;
	base[2]=0x99aabbcc;
	base[3]=0xddeeff00;
	if(base[0]!=0x11223344)
	{
		printf("Simple check failed at 0 (got %x, expected 0x11223344))\n",base[0]);
		result=0;
	}
	if(base[1]!=0x55667788)
	{
		printf("Simple check failed at 1 (got %x, expected 0x55667788))\n",base[1]);
		result=0;
	}
	if(base[2]!=0x99aabbcc)
	{
		printf("Simple check failed at 2 (got %x, expected 0x99aabbcc))\n",base[2]);
		result=0;
	}
	if(base[3]!=0xddeeff00)
	{
		printf("Simple check failed at 3 (got %x, expected 0xddeeff00))\n",base[3]);
		result=0;
	}
	return(1);
}

#define CACHESIZE 4096

char waitkey()
{
	int t;
	do {
		t=HW_UART(REG_UART);
	} while (!(t&(1<<REG_UART_RXINT)));
	return(t&255);
}

#define test(x,y,z) printf("%s...",x); t=y(base,z); printf(" %s\n",t ? "passed" : "failed"); result&=t;

int MemCheck(int b)
{
	volatile int *base=(volatile int *)b;
	int result=1;
	int t;
	int size;

	printf("Address check... ");
	size=addresscheck(base,CACHESIZE);
	printf("%d megabytes found\n",size);

	test("Sanity check",sanitycheck,CACHESIZE);
	test("Simple check",simplecheck,CACHESIZE);
	test("Byte check",bytecheck,CACHESIZE);
	test("Alignment check",aligncheck,CACHESIZE);
	test("Linear check",linearcheck,size);
	test("LFSR check",lfsrcheck,size);

	if(result)
		printf("All checks passed\n");
	return(result);
}

int MemSize(int b)
{
	volatile int *base=(volatile int *)b;
	return(addresscheck(base,CACHESIZE));
}

