#include <stdio.h>
#define NULL 0
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <hw/vga.h>
#include <hw/timer.h>
#include "hw/screenmode.h"
#include <minfat.h>

#include "jpeglib.h"

#include "socmemory.h"

fileTYPE *file;

static struct stat statbuf;


struct JPEGContext
{
	struct jpeg_decompress_struct cinfo;
	struct jpeg_error_mgr jerr;
	int fd;
	JSAMPROW rowptr[1];
};

void jpeg_unixio_src (j_decompress_ptr cinfo, int infile);

int timestamp;

char *getenv(const char *name)
{
	return(0);
}

int sscanf(const char *str,const char *fmt,...)
{
	return(0);
}


int *InitDisplay(enum screenmode mode,int bits)
{
	int *result=0;
	int w,h;
	struct MemoryPool *pool=SoCMemory_GetPool();
	w=Screenmode_GetWidth(mode);
	h=Screenmode_GetHeight(mode);
	if(w && h)
	{
		result=(int *)pool->AllocAligned(pool,(bits/8) * w*h,32,0,SOCMEMORY_BANK0); /* Any bank but zero */
		Screenmode_Set(mode);
		HW_VGA(FRAMEBUFFERPTR) = (int)result;
		HW_VGA(PIXELFORMAT) = bits==32 ? PIXELFORMAT_RGB32 : PIXELFORMAT_RGB16;
	}
	return(result);
}


int main(int argc, char **argv)
{
	printf("JPEG Demo\n");
	file=malloc(sizeof(fileTYPE));
	struct JPEGContext *jc=malloc(sizeof(struct JPEGContext));

	timestamp=HW_TIMER(REG_MILLISECONDS);

	printf("calling jpeg_std_error\n");
	jc->cinfo.err = jpeg_std_error(&jc->jerr);
	printf("creating decompress object\n");
	jpeg_create_decompress(&jc->cinfo);
	printf("created decompress\n");
	jc->fd=open("BIRD    JPG",0,O_RDONLY);
	printf("open() returned %d\n",jc->fd);

	if((jc->fd>0)&&!fstat(jc->fd,&statbuf))
	{
		int *imagebuf;
		printf("File size: %d\n",statbuf.st_size);
		jpeg_unixio_src(&jc->cinfo,jc->fd);
		printf("Added unixio source\n");
		
		if((imagebuf=InitDisplay(SCREENMODE_640x480_60,32)))
		{
			int row;
			JOCTET *rowbuffer;
			int *imagep;
			imagep=(int *)imagebuf;
			jpeg_read_header(&jc->cinfo, TRUE);
			jpeg_start_decompress(&jc->cinfo);
			printf("Started decompress\n");
			printf("dimensions %d x %d\n",jc->cinfo.output_width,jc->cinfo.output_height);
			printf("components: %d\n",jc->cinfo.output_components);
			rowbuffer=malloc(jc->cinfo.output_width*jc->cinfo.output_components);	// Read data is 24 bits.

			for(row=0;row<jc->cinfo.output_height;++row)
			{
				JOCTET *t=rowbuffer;
				jc->rowptr[0]=rowbuffer;
				int x,w;
				int scanlines=jpeg_read_scanlines(&jc->cinfo,&jc->rowptr,1);
				for(x=0;x<jc->cinfo.output_width;++x)
				{
					int r=*t++;
					int g=*t++;
					int b=*t++;
					w=b<<16 | g <<8 | r;
					*imagep++=w;
				}
			}
		}
	}
	timestamp=HW_TIMER(REG_MILLISECONDS)-timestamp;

	printf("%d milliseconds elapsed\n",timestamp);

	return(0);
}
