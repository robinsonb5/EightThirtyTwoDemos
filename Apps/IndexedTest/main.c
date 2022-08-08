#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned char *FrameBuffer;	// Frame Buffer pointer
int screenwidth=1280;		// Initial screen width
int screenheight=480;		// Initial screen heigth

#define REG_VGA_CLUTIDX 0x40
#define REG_VGA_CLUTDATA 0x44

void setpalette(int bits)
{
	int i,j;
	switch(bits)
	{
		case 4:
			for(i=0;i<16;++i)
			{
				HW_VGA(REG_VGA_CLUTIDX)=i;
				HW_VGA(REG_VGA_CLUTDATA)=i*0x1111111;
			}
			break;		
		case 8:
			for(i=0;i<256;++i)
			{
				HW_VGA(REG_VGA_CLUTIDX)=i;
				HW_VGA(REG_VGA_CLUTDATA)=i*0x010101;
			}
			break;
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

void plot(unsigned char *framebuffer,int x,int y,unsigned int c,int bits)
{
	int bytesperrow;
	unsigned short *hcptr;
	unsigned int *tcptr;
	switch(bits)
	{
		case 1:
			bytesperrow=screenwidth>>3;
			framebuffer+=y*bytesperrow;
			framebuffer[x>>3]&=~(1<<(7-(x&7)));			
			if(c)
				framebuffer[x>>3]|=1<<(7-(x&7));
			break;
		case 4:
			bytesperrow=screenwidth>>1;
			framebuffer+=y*bytesperrow;
			framebuffer[x>>1]&=(x&1) ? 0xf0 : 0x0f;
			framebuffer[x>>1]|=(x&1) ? (c&0xf) : ((c&0xf)<<4);
			break;
		case 8:
			bytesperrow=screenwidth;
			framebuffer+=y*bytesperrow;
			framebuffer[x]=c;
			break;
		case 16:
			bytesperrow=screenwidth*2;
			hcptr=(unsigned short *)(framebuffer+y*bytesperrow);
			hcptr[x]=c;		
			break;
		case 32:
			bytesperrow=screenwidth*4;
			tcptr=(unsigned int *)(framebuffer+y*bytesperrow);
			tcptr[x]=c;		
			break;	
	}
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
		FrameBuffer=(short *)malloc_aligned((bits * w*h)/8,32);
		Screenmode_Set(mode);
		HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
		switch(bits)
		{
			case 32:
				HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB32;
				break;
			case 16:
				HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB16;
				break;
			case 8:
				HW_VGA(PIXELFORMAT) = PIXELFORMAT_CLUT8BIT;
				break;
			case 4:
				HW_VGA(PIXELFORMAT) = PIXELFORMAT_CLUT4BIT;
				break;
			case 1:
				HW_VGA(PIXELFORMAT) = PIXELFORMAT_MONO;
				break;
		}
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
	int bits=32;
	int refresh=1;
	enum screenmode mode=SCREENMODE_640x480_60;
	setpalette(8);
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
				drawRectangle(0,i*2,sw-1,i*2+1,i);
				drawRectangle(sw,i*2,2*sw-1,i*2+1,255-i);
				drawRectangle(2*sw,i*2,3*sw-1,i*2+1,i/2);
				drawRectangle(3*sw,i*2,4*sw-1,i*2+1,255-i/2);
			}
			printf("\nCurrently using %d x %d in %d bits\n",screenwidth,screenheight,bits);
			printf("Press 1 - %d to switch screenmodes,\na - e to set bit depth (32, 16, 8, 4 or 1).\n",SCREENMODE_MAX);
		}
		c=getserial();
		if (c)
		{
			refresh=0;
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
					refresh=1;
					break;
				case 'a':
					HW_VGA(PIXELFORMAT) = 0x1;
					bits=32;
					break;
				case 'b':
					HW_VGA(PIXELFORMAT) = 0x0;
					bits=16;
					break;
				case 'c':
					HW_VGA(PIXELFORMAT) = 0x4;
					bits=8;
					break;
				case 'd':
					HW_VGA(PIXELFORMAT) = 0x3;
					bits=4;
					break;
				case 'e':
					HW_VGA(PIXELFORMAT) = 0x2;
					bits=1;
					break;
			}
			printf("%d bits per pixel\n",bits);
			setpalette(bits);
			memset(FrameBuffer,0x55,(screenwidth*screenheight*bits)/8);
			for(i=0;i<screenheight;++i)
				plot(FrameBuffer,i,i,0xffffff,bits);
			for(i=0;i<screenheight;++i)
				plot(FrameBuffer,i+16,i,0x0,bits);
			if(refresh)
				free_aligned(FrameBuffer);
		}				
	}
	
    return 0;
}

