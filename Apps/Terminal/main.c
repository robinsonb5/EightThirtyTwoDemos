#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>
#include <framebuffer.h>

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

char *initdisplay(enum Screenmode mode,int bits)
{
	char *result;
	int w,h;
	Screenmode_Set(mode);
	w=Screenmode_GetWidth(SCREENMODE_CURRENT);
	h=Screenmode_GetHeight(SCREENMODE_CURRENT);
	result=Framebuffer_Allocate(w,h,bits);
	Framebuffer_Set(result,bits);
	screenwidth=w;
	screenheight=h;
	return(result);	
}


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
	FrameBuffer=initdisplay(mode,bits);
	draw(bits);
	while(1)
	{
		int c;
		int sw;
		c=getserial();
		if (c)
		{
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
					printf("Switching to mode %d\n",mode);
					refresh=1;
					break;
				case 'a':
				case 'b':
				case 'c':
				case 'd':
				case 'e':
					refresh=1;
					bits=32>>(c-'a');
					if(c=='e')
						bits>>=1;
					break;
			}
			if(refresh)
			{
				char *old=FrameBuffer;
				FrameBuffer=0; /* Inhibit text output during framebuffer swap */
				Framebuffer_Free(old);
				FrameBuffer=initdisplay(mode,bits);
				setpalette(bits);
				draw(bits);
				printf("%d bits per pixel\n",bits);
			}
		}				
	}
	
    return 0;
}

