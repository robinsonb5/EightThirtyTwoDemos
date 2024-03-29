#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned short *FrameBuffer;	// Frame Buffer pointer
int screenwidth=1280;		// Initial screen width
int screenheight=480;		// Initial screen heigth

int palette[]=
{
	0x0,
	0xff0000,
	0x00ff00,
	0x0000ff,
	0xffff00,
	0x00ffff,
	0xff00ff,
	0xffffff,
	0x444444,
	0xbb4444,
	0x44bb44,
	0x4444bb,
	0xbbbb44,
	0x44bbbb,
	0xbb44bb,
	0xbbbbbb
};

#define REG_VGA_CLUTIDX 0x40
#define REG_VGA_CLUTDATA 0x44

void setpalette()
{
	int i,j;
	for(i=0;i<16;++i)
	{
		for(j=0;j<16;++j)
		{
			HW_VGA(REG_VGA_CLUTIDX)=i+16*j;
			HW_VGA(REG_VGA_CLUTDATA)=palette[i];
		}
	}
}


void drawRectangle(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color)
{
	unsigned int x,y,yoff;
	for (y = yS; y <= yE; y += 1)
	{
		yoff = y * screenwidth;
		for (x = xS; x <= xE; x += 1)
		{
			*(FrameBuffer + x + yoff) = color;
		}
	}
}


void *malloc_aligned(size_t size,int alignment)
{
	char *result,*real;
	int *tmp;
	--alignment;
	real=(char *)malloc(size+4+alignment);
	printf("Real address is %x\n",(int)real);
	result=(char *)(((int)real+4+alignment)&~alignment);
	tmp=(int *)result;
	printf("Aligned to %x\n",(int)tmp);
	--tmp;
	printf("Wrote to %x\n",(int)tmp);
	*tmp=(int)real;
	return(result);
}

void free_aligned(char *ptr)
{
	int *tmp;
	int real;
	tmp=(int *)ptr;
	printf("Free pointer %x\n",(int)tmp);
	--tmp;
	real=*tmp;
	printf("Freeing real pointer %x fetched from %x\n",real,(int)tmp);
	free((char *)real);
}

void initDisplay(enum screenmode mode,int bits)
{
	int w,h;
	w=Screenmode_GetWidth(mode);
	h=Screenmode_GetHeight(mode);
	if((!w) || (!h))
	{
		mode=SCREENMODE_640x480_60;
		w=640;
		h=480;
	}	
	if(w && h)
	{
		screenwidth=w;
		screenheight=h;
		FrameBuffer=(short *)malloc_aligned((bits/8) * w*h,32);
		Screenmode_Set(mode);
		HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
		HW_VGA(PIXELFORMAT) = bits==32 ? PIXELFORMAT_RGB32 : PIXELFORMAT_RGB16;
	}
}

#define SWAP(x) ((x<<8) | (x>>8))

char getserial()
{
	while(1)
	{
		int c=HW_UART(REG_UART);
		if(c&(1<<REG_UART_RXINT))
		{
			c&=0xff;
			return(c);
		}
	}
}

int main(int argc, char **argv)
{
	int i;
	int bits=16;
	int refresh=1;
	enum screenmode mode=SCREENMODE_640x480_60;
	setpalette();
	while(1)
	{
		int c;
		int sw;
		if(refresh)
		{
			initDisplay(mode,bits);
			sw=(screenwidth-32)/4;
			drawRectangle(0,0,screenwidth-1,screenheight-1,SWAP(0x39e7));
			for(i=0;i<240;++i)
			{
				int g=(i>>3) | ((i>>2)<<5) | ((i>>3) << 11); 
				drawRectangle(0,i*2,sw-1,i*2+1,SWAP(g));
				drawRectangle(sw,i*2,2*sw-1,i*2+1,SWAP((i>>3)<<11));
				drawRectangle(2*sw,i*2,3*sw-1,i*2+1,SWAP((i>>2)<<5));
				drawRectangle(3*sw,i*2,4*sw-1,i*2+1,SWAP(i>>3));
			}
			printf("\nCurrently using %d x %d in %d bits\n",screenwidth,screenheight,bits);
			printf("Press 1 - %d to switch screenmodes, a for 16 bit, b for 32-bit.\n",SCREENMODE_MAX);
		}
		c=getserial();
		if (c)
		{
			refresh=1;
			switch(c)
			{
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
				case '8':
				case '9':
				case '0':
					mode=c-'1';
					break;
				case 'a':
					bits=16;
					break;
				case 'b':
					bits=32;
					break;
				case 'c':
					HW_VGA(REG_VGA_PIXELCLOCK)=0x005;
					HW_VGA(PIXELFORMAT) = 0x1;
					refresh=0;
					break;
				case 'd':
					HW_VGA(REG_VGA_PIXELCLOCK)=0x105;
					HW_VGA(PIXELFORMAT) = 0x0;
					refresh=0;
					break;
				case 'e':
					HW_VGA(REG_VGA_PIXELCLOCK)=0x305;
					HW_VGA(PIXELFORMAT) = 0x2;
					refresh=0;
					break;
				case 'f':
					HW_VGA(REG_VGA_PIXELCLOCK)=0x705;
					HW_VGA(PIXELFORMAT) = 0x3;
					refresh=0;
					break;
				case 'g':
					HW_VGA(REG_VGA_PIXELCLOCK)=0x1f05;
					HW_VGA(PIXELFORMAT) = 0x4;
					refresh=0;
					break;
			}
			if(refresh)
				free_aligned(FrameBuffer);
		}				
	}
	
    return 0;
}

