#include <stdio.h>

#include "checksum.h"

unsigned char sector_buffer[512];

int main(int argc,char **argv)
{
	if(argc==3)
	{
		int l;
		FILE *f=fopen(argv[1],"rb");
		FILE *f2=fopen(argv[2],"wb");
		if(f && f2)
		{
			while(l=fread(sector_buffer,1,512,f))
			{
				if(l)
				{
					unsigned int cs=checksum(sector_buffer,l);
					unsigned char out[4];
					out[0]=(cs>>24)&255;
					out[1]=(cs>>16)&255;
					out[2]=(cs>>8)&255;
					out[3]=cs&255;
					printf("%08x\n",cs);
					fwrite(out,4,1,f2);
				}
			}
		}
		fclose(f2);
		fclose(f);
	}
	else
		printf("Usage: mkchecksum infile outfile\n");
	return(0);
}
