#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "eightpixelfont.h"

unsigned char *FrameBuffer=0;	// Frame Buffer pointer
int screenwidth=1280;		// Initial screen width
int screenheight=480;		// Initial screen heigth

#define REG_VGA_CLUTIDX 0x40
#define REG_VGA_CLUTDATA 0x44


struct terminal
{
	int cursx,cursy;
	int w,h;
	int depth;
};

struct terminal term;

void update_term(int screenwidth,int screenheight,int bits)
{
	term.cursx=0;
	term.cursy=0;
	term.w=screenwidth/8;
	term.h=screenheight/8;
	term.depth=bits;
}

void term_scroll()
{
	char *p=FrameBuffer+8*term.w;
	if(!FrameBuffer)
		return;
	memcpy(FrameBuffer,p,term.w*(term.h-1)*8);
	memset(FrameBuffer+term.w*(term.h-1)*8,0,8*term.w);
}

void term_newline()
{
	++term.cursy;
	term.cursx=0;
	if(term.cursy>=term.h)
	{
		term_scroll();
		term.cursy=term.h-1;
	}
}


int putchar(int c)
{
	char *p;
	char *f;
	if(FrameBuffer)
	{
		switch(c)
		{
			case 10:
				term_newline();
				break;
			case 13:
				term.cursx=0;
				break;
			default:
				p=FrameBuffer+8*term.cursy*term.w+term.cursx;
				f=eightpixelfont_getchar(c);
				if(f)
				{
					int i;
					for(i=0;i<8;++i)
					{
						*p=*f++;
						p+=term.w;
					}
				}
				if(++term.cursx>=term.w)
					term_newline();
				break;
		}
	}
	return(c);
}


void drawcharacter(int x,int y,char c)
{
	int sw=screenwidth/8;
	char *p=FrameBuffer+8*y*sw+x;
	char *f=eightpixelfont_getchar(c);
	if(f)
	{
		int i;
		for(i=0;i<8;++i)
		{
			*p=*f++;
			p+=sw;
		}
	}
}


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

#define ALIGNGUARD1 0x5432abcd
#define ALIGNGUARD2 0xa9875432
struct alignguard
{
	int guard1;
	void *mem;
	int guard2;
};

void *malloc_aligned(size_t size,int alignment,int high)
{
	char *result,*real;
	struct alignguard *tmp;
	--alignment;
	if(high)
		real=(char *)malloc_high(size+sizeof(struct alignguard)+alignment);
	else
		real=(char *)malloc(size+sizeof(struct alignguard)+alignment);
	printf("Real address is %x\n",(int)real);
	result=(char *)(((int)real+sizeof(struct alignguard)+alignment)&~alignment);
	tmp=(struct alignguard *)result;
	printf("Aligned to %x\n",(int)tmp);
	--tmp;
	printf("Wrote to %x\n",(int)tmp);
	tmp->guard1=ALIGNGUARD1;
	tmp->mem=real;
	tmp->guard2=ALIGNGUARD2;
	return(result);
}

void free_aligned(char *ptr)
{
	struct alignguard *tmp;
	tmp=(struct alignguard *)ptr;
	printf("Free pointer %x\n",(int)tmp);
	--tmp;
	if(tmp->guard1!=ALIGNGUARD1 || tmp->guard2!=ALIGNGUARD2)
	{
		printf("WARNING: memory corruption\n");
		return;
	}
	printf("Freeing real pointer %x fetched from %x\n",tmp->mem,(int)tmp);
	free((char *)tmp->mem);
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
		FrameBuffer=(char *)malloc_aligned((32 * w*h)/8,32,1);
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

void draw(bits)
{
	int i;
	update_term(screenwidth,screenheight,bits);
	for(i=0;i<screenheight;++i)
	{
		memset(FrameBuffer+(i*screenwidth*bits)/8,0x55,(screenwidth*bits)/8);
		++i;
		memset(FrameBuffer+(i*screenwidth*bits)/8,0xaa,(screenwidth*bits)/8);
	}
	for(i=0;i<screenheight;++i)
		plot(FrameBuffer,i,i,0xffffff,bits);
	for(i=0;i<screenheight;++i)
		plot(FrameBuffer,i+15,i,0x0,bits);
	puts("Hello, World! - ");
	puts("Some more text with a newline\n");
	puts("And some more text following the newline...\n");
}


int main(int argc, char **argv)
{
	int i;
	int bits=1;
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
			draw(bits);
			printf("\nCurrently using %d x %d in %d bits\n",screenwidth,screenheight,bits);
			printf("Press 1 - %d to switch screenmodes,\na - e to set bit depth (32, 16, 8, 4 or 1).\n",SCREENMODE_MAX);
		}
		c=getserial();
		if (c)
		{
			int oldbits=bits;
			refresh=0;
			switch(c)
			{
				case 't':
					puts("Lorem ipsum dolor sit amet.... \n");
					puts("Yes, just a bunch of random text to test\n");
					puts("newline handling and scrolling on full screen...\n\n");
					break;
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
			if(bits!=oldbits)
			{
				printf("%d bits per pixel\n",bits);
				setpalette(bits);
				draw(bits);
			}
			if(refresh)
				free_aligned(FrameBuffer);
		}				
	}
	
    return 0;
}

