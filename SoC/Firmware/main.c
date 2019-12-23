/*	Firmware for loading files from SD card.
	Part of the ZPUTest project by Alastair M. Robinson.
	SPI and FAT code borrowed from the Minimig project.
*/


#include "stdarg.h"

#include "uart.h"
#include "spi.h"
#include "minfat.h"
#include "cachecontrol.h"
#include "tiny_printf.h"

#define Breadcrumb(x) HW_UART(REG_UART)=x;

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


/* Load files named in a manifest file */

static unsigned char Manifest[2048];


void _break()
{
	while(1)
		;
}


int main(int argc,char **argv)
{
	int i;

	puts("Initializing SD card\n");
	if(spi_init())
	{
		puts("Hunting for partition\n");
		FindDrive();
		if(LoadFile("MANIFESTMST",Manifest))
		{
			unsigned char *buffer=Manifest;
			int ptr;
			puts("Parsing manifest\n");
			while(1)
			{
				unsigned char c=0;
				ptr=0;
				// Parse address
				while((c=*buffer++)!=' ')
				{
					HW_UART(REG_UART)=c;
					if(c=='#') // Comment line?
						break;
					if(c=='G')
						_boot();

					if(c=='\n')
						_break(); // Halt CPU

					if(c=='L')
						buffer=Manifest;

					c=(c&~32)-('0'-32); // Convert to upper case
					if(c>='9')
						c-='A'-'0';
					ptr<<=4;
					ptr|=c;
				}
				// Parse filename
				if(c!='#')
				{
					int i;
					while((c=*buffer++)==' ')
						;
					--buffer;
					// c-1 is now the filename pointer

//					printf("Loading file %s to %d\n",fn,(long)ptr);
//					buffer[11]=0;
					LoadFile(buffer,(unsigned char *)ptr);
//					HW_VGA(FRAMEBUFFERPTR)=ptr;
				}

				// Hunt for newline character
				while((c=*buffer++)!='\n')
					;
			}
		}
		else
		{
			puts("Loading manifest failed\n");
		}
	}

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

