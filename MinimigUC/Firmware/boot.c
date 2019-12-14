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

#include "spi.h"
#include "minfat.h"
#include "checksum.h"
#include "small_printf.h"

void _boot();
void _break();

extern char prg_start;

char printbuf[32];

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
//					((void (*)(void))prg_start)();
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
	while(1)
		;
	return(0);
}

