/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.

	This boot ROM ends up stored in the ZPU stack RAM
	which in the current incarnation of the project is
	memory-mapped to 0x04000000
	Halfword and byte writes to the stack RAM aren't
	currently supported in hardware, so if you use
    hardware storeh/storeb, and initialised global
    variables in the boot ROM should be declared as
    int, not short or char.
	Uninitialised globals will automatically end up
	in SDRAM thanks to the linker script, which in most
	cases solves the problem.
*/

#include "uart.h"
#include "cachecontrol.h"
#include "spi.h"
#include "minfat.h"
#include "checksum.h"
#include "printf.h"

void _boot();
void _break();

extern char prg_start;

char printbuf[32];

#define Breadcrumb(x) HW_UART(REG_UART)=x;


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
	((void (*)(void))(&prg_start))();
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
#ifdef DEBUG
//					unsigned char *p=&SREC_TEMP;
#else
//					unsigned char *p=(unsigned char *)SREC_ADDR;
#endif
					SREC_TEMP=DoDecode(SREC_TEMP,d0);
					--SREC_COUNTER;
					if(SREC_COUNTER<0)
					{
//						printf("%x: %x\n",SREC_ADDR,SREC_TEMP&0xff);
#ifndef DEBUG
						*(unsigned char *)SREC_ADDR=SREC_TEMP;
#endif
						++SREC_ADDR;
						if(SREC_ADDR>SREC_MAX_ADDR)
							SREC_MAX_ADDR=SREC_ADDR;
						SREC_COUNTER=1;
					}
				}
				else
				{
#ifdef DEBUG
//					unsigned char *p=&SREC_TEMP;
#else
//					unsigned char *p=(unsigned char *)SREC_ADDR;
#endif
					if(SREC_COUNTER==0)
					{
						SREC_TEMP<<=4;
#ifndef DEBUG
						*(unsigned char *)SREC_ADDR=SREC_TEMP;
#endif
//						*p<<=4;
					}
				}
			}
			else if(SREC_TYPE>=7)
			{
				int checksum=0;
				FLUSHCACHES;

				for(SREC_ADDR=(int)&prg_start;SREC_ADDR<SREC_MAX_ADDR;SREC_ADDR+=4)
					checksum+=*(int *)SREC_ADDR;
				printf("Checksum to %d: %d\n",SREC_MAX_ADDR,checksum);
				Breadcrumb('B');
//				printf("Booting to %x\n",SREC_ADDR);
#ifdef DEBUG
				exit(0);
#else
				((void (*)(void))(&prg_start))();
#endif
			}
			else
				Breadcrumb(48+SREC_TYPE);

		}
	}
}


void cvx(int val,char *buf)
{
	int i;
	int c;
	for(i=0;i<8;++i)
	{
		c=(val>>28)&0xf;
		val<<=4;
		if(c>9)
			c+='A'-10;
		else
			c+='0';
		*buf++=c;
	}
}


int main(int argc,char **argv)
{
	int i;

//	BootPrint("Initializing SD card\n");
	puts("Initializing SD card\n");
	if(spi_init())
	{
		puts("Hunting for partition\n");
		if(FindDrive())
		{
			int romsize;
			int *checksums;
			if(romsize=LoadFile(OSDNAME,&prg_start))
			{
				int error=0;
				char *sector=&prg_start;
				int offset=0;
				romsize+=3;
				romsize&=0xfffffffc;
				checksums=(int *)(sector+romsize);
				if(LoadFile("CHECKSUMBIN",(char*)checksums))
				{
					while(romsize>511)
					{
						int sum=checksum(sector+offset,512);
						int sum2=*checksums++;
						offset+=512;
						romsize-=512;
						if(sum!=sum2)
						{
							++error;
							cvx(offset,&printbuf[0]);
							printbuf[8]=' ';
							cvx(sum,&printbuf[9]);
							printbuf[17]=' ';
							cvx(sum2,&printbuf[18]);
							printbuf[26]=0;
							BootPrint(printbuf);
						}
					}
				}
				if(!error)
				{
					((void (*)(void))prg_start)();
//					_boot();
				}
			}
//			else
//				BootPrint("Can't load firmware\n");
		}
		else
		{
//			BootPrint("Unable to locate partition\n");
			puts("Unable to locate partition\n");
		}
	}
//	else
//		BootPrint("Failed to initialize SD card\n");

	puts("Booting from RS232.");
	SREC_MAX_ADDR=0;
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
				HandleByte(c);
				timeout=1000000;
			}
		}
	}

	return(0);
}

