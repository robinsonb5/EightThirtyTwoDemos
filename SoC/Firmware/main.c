/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.
*/

#include <printf.h>
#include <hw/uart.h>
#include <hw/spi.h>
#include <minfat.h>
#include <hw/cachecontrol.h>
#include "dualthread.h"

// #define Breadcrumb(x) HW_UART(REG_UART)=x;

#define Breadcrumb(x) 

#define BOOT_ADDR 0x10000000

// RS232 boot code - falls back to this if SD boot fails.

int SREC_COLUMN;
int SREC_ADDR;
int SREC_ADDRSIZE;
int SREC_BYTECOUNT;
int SREC_TYPE;
int SREC_COUNTER;
int SREC_TEMP;
int SREC_MAX_ADDR;

void _boot()
{
	void (*f)();
	f=(void(*f)())BOOT_ADDR;
	thread_wake();
	f();
	while(1)
		;
}

int DoDecode(int a0,int d0)
{
	d0&=0xdf;	// To upper case, if necessary - numbers are now 16-25
	d0-=55;		// Map 'A' onto decimal 10.
	if(d0<0)	// If negative, then digit was a number.
		d0+=39; // map '0' onto 0.
	a0<<=4;
	a0|=d0;
	return(a0);
}

void HandleByte(char d0)
{
	++SREC_COLUMN;

	if(d0=='S')
	{
		SREC_COLUMN=0;
		SREC_ADDR=0;
		SREC_BYTECOUNT=0;
		SREC_TYPE=0;
		Breadcrumb('S');
	}
	else
	{
		if(SREC_COLUMN==1)
		{
			int t;
			Breadcrumb('t');
			t=SREC_TYPE=DoDecode(SREC_TYPE,d0);	// Called once, should result in type being in the lowest nybble bye of SREC_TYPE

			if(t>3)
				t=10-t;	// Just to be awkward, S7 has 32-bit addr, S8 has 24 and S9 has 16!

			SREC_ADDRSIZE=(t+1)<<1;

//			printf("SREC_TYPE: %d, SREC_ADDRSIZE: %d\n",SREC_TYPE,SREC_ADDRSIZE);
			Breadcrumb(t+48);
		}
		else if((SREC_TYPE<=9)&&(SREC_TYPE>0))
		{
			Breadcrumb(SREC_TYPE+48);
			if(SREC_COLUMN<=3)	// Columns 2 and 3 contain byte count.
			{
				SREC_BYTECOUNT=DoDecode(SREC_BYTECOUNT,d0);
//				printf("Bytecount: %x\n",SREC_BYTECOUNT);
			}
			else if(SREC_COLUMN<=(SREC_ADDRSIZE+3)) // Columns 4 to ... contain the address.
			{
				SREC_ADDR=DoDecode(SREC_ADDR,d0); // Called 2, 3 or 4 times, depending on the number of address bits.
				SREC_COUNTER=1;
//				printf("SREC_ADDR: %x\n",SREC_ADDR);
			}
			else if(SREC_TYPE>0 && SREC_TYPE<=3) // Only types 1, 2 and 3 have data
			{
				if(SREC_COLUMN<=((SREC_BYTECOUNT<<1)+1))	// Two characters for each output byte
				{
					SREC_TEMP=DoDecode(SREC_TEMP,d0);
					--SREC_COUNTER;
					if(SREC_COUNTER<0)
					{
						*(unsigned char *)SREC_ADDR=SREC_TEMP;
						++SREC_ADDR;
						if(SREC_ADDR>SREC_MAX_ADDR)
							SREC_MAX_ADDR=SREC_ADDR;
						SREC_COUNTER=1;
					}
				}
				else
				{
					if(SREC_COUNTER==0)
					{
						SREC_TEMP<<=4;
						*(unsigned char *)SREC_ADDR=SREC_TEMP;
					}
				}
			}
			else if(SREC_TYPE>=7)
			{
				int checksum=0;
				FLUSHCACHES;

				printf("Checksumming from %d to %d... ",BOOT_ADDR,SREC_MAX_ADDR);
				for(SREC_ADDR=BOOT_ADDR;SREC_ADDR<SREC_MAX_ADDR;SREC_ADDR+=4)
					checksum+=*(int *)SREC_ADDR;
				printf("%d\n",checksum);
				printf("Checksumming again from %d to %d... ",BOOT_ADDR,SREC_MAX_ADDR);
				checksum=0;
				for(SREC_ADDR=BOOT_ADDR;SREC_ADDR<SREC_MAX_ADDR;SREC_ADDR+=4)
					checksum+=*(int *)SREC_ADDR;
				printf("%d\n",checksum);
				Breadcrumb('B');
#ifdef DEBUG
				exit(0);
#else
				_boot();
#endif
			}
			else
				Breadcrumb(48+SREC_TYPE);

		}
	}
}

char bytepayload[]=
{
	0x11,0x22,0x33,0x44,
	0xff,0xee,0xdd,0xcc,
	0x55,0x66,0x77,0x88,
	0xbb,0xaa,0x99,0x88
};

int payload[]={
	0x11112222,
	0x33334444,
	0x55556666,
	0x77778888,
	0x9999aaaa,
	0xbbbbcccc,
	0xddddeeee,
	0xffff0000
};

void test1()
{
	int i;
	int *p=(int *)BOOT_ADDR;
	*p++=0x5;
	*p++=0x5;
	*p++=0x5;
	*p++=0x5;
	*p++=0x5;
	*p++=0x5;
	*p++=0x5;
	*p++=0x5;
	p=(int *)BOOT_ADDR;
	for(i=0;i<8;++i)
	{
		printf("%d: %x\n",i,*p++);
	}
}

void test2()
{
	int i;
	int *p;
	char *p2=(char *)BOOT_ADDR;
	*p2++=0xa;
	*p2++=0xa;
	*p2++=0xa;
	*p2++=0xa;
	*p2++=0xa;
	*p2++=0xa;
	*p2++=0xa;
	*p2++=0xa;
	p=(int *)BOOT_ADDR;
	for(i=0;i<2;++i)
	{
		printf("%d: %x\n",i,*p++);
	}
}

void test()
{
	int i;
	int *o=payload;
	char *o2=bytepayload;
	int *p=(int *)BOOT_ADDR;
	char *p2=(char *)BOOT_ADDR;
	for(i=0;i<8;++i)
	{
		*p++=*o++;
	}		
	p=(int *)BOOT_ADDR;
	for(i=0;i<8;++i)
	{
		printf("%d: %x\n",i,*p++);
	}
	for(i=0;i<16;++i)
	{
		*p2++=*o2++;
	}		
	p2=(char *)BOOT_ADDR;
	for(i=0;i<16;++i)
	{
		printf("%d: %x\n",i,*p2++);
	}
}

// Identify RAM size by searching for aliases - up to a maximum of 64 megabytes

#define ADDRCHECKWORD 0x55aa44bb
#define ADDRCHECKWORD2 0xf0e1d2c3

void _initMem()
{
	volatile int *base=(int*)BOOT_ADDR;
	char *ramtop;
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
	printf("RAM size (assuming no address faults) is 0x%x megabytes\n",size);
}

int main(int argc,char **argv)
{
	int *mem=(int *)0x10000000;
	int *memb=(char *)0x10000000;
	int havesd;
	int i;

	puts("Initializing SD card\n");
	havesd=(sd_get_size()>0) && FilesystemPresent();

	puts("RS232 boot - press ESC to boot from SD.");
	SREC_MAX_ADDR=0;
	test1();
	test2();
	while(1)
	{
		int c;
		int timeout=1000000;
		putchar('.');
		while(timeout--)
		{
			int r=HW_UART(REG_UART);
			if(r&(1<<REG_UART_RXINT))
			{
				c=r&255;
				if(c==27)
				{
					if(havesd && LoadFileAbs("BOOT832 BIN",BOOT_ADDR))
					{
						puts("Booting...\n");
						_boot();
					}
					else
						puts("SD boot failed\n");
				}
				HandleByte(c);
				timeout=1000000;
			}
		}
	}

	return(0);
}

void thread2boot(int addr);

int thread2main(int argc,char **argv)
{
	thread_sleep();
	putchar('2');
	thread2boot(BOOT_ADDR);
	return(0);
}

