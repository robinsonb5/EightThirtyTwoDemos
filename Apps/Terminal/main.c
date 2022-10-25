#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>
#include <hw/blitter.h>
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
	int fgpen;
	int bgpen;
	int mode;
};

struct terminal term;

void update_term(int screenwidth,int screenheight,int bits)
{
	term.cursx=0;
	term.cursy=0;
	term.w=screenwidth/8;
	term.h=screenheight/8;
	term.depth=bits;
	term.fgpen=0xffffffff;
	term.bgpen=0;
}

void term_scroll_cpu()
{
	char *p=FrameBuffer+(8*term.w*term.depth);
	if(!FrameBuffer)
		return;
	memcpy(FrameBuffer,p,(term.depth*term.w*(term.h-1)*8));
	memset(FrameBuffer+(term.depth*term.w*(term.h-1)*8),0,(term.depth*8*term.w));
}

void term_scroll_blitter()
{
	char *p=FrameBuffer+(8*term.w*term.depth);
	int t;
	if(!FrameBuffer)
		return;
	while(t=REG_BLITTER[BLITTER_DEST].ROWS)	/* Wait for any previous operation to finish - FIXME use an interrupt */
		;
//	putchar('a');
	REG_BLITTER[BLITTER_SRC1].ADDRESS=p;
	REG_BLITTER[BLITTER_SRC1].SPAN=(term.w*term.depth)/4;
	REG_BLITTER[BLITTER_SRC1].MODULO=0;
//	REG_BLITTER[BLITTER_SRC1].DATA=color;

	REG_BLITTER[BLITTER_DEST].ADDRESS=FrameBuffer;
	REG_BLITTER[BLITTER_DEST].SPAN=(term.w*term.depth/4);
	REG_BLITTER[BLITTER_DEST].MODULO=0;
	REG_BLITTER[BLITTER_DEST].ACTIVE=2;
	REG_BLITTER[BLITTER_DEST].ROWS=(term.h-1)*8; /* Trigger blitter */
//	putchar('b');

	while(t=REG_BLITTER[BLITTER_DEST].ROWS)	/* Wait for any previous operation to finish - FIXME use an interrupt */
		;
	p=FrameBuffer+(term.h-8)*term.w*term.depth;
	REG_BLITTER[BLITTER_SRC1].ADDRESS=p;
	REG_BLITTER[BLITTER_SRC1].SPAN=(term.w*term.depth)/4;
	REG_BLITTER[BLITTER_SRC1].MODULO=0;

	REG_BLITTER[BLITTER_SRC1].DATA=0;
//	REG_BLITTER[BLITTER_DEST].ADDRESS=FrameBuffer;
//	REG_BLITTER[BLITTER_DEST].SPAN=(term.w*term.depth/4);
//	REG_BLITTER[BLITTER_DEST].MODULO=0;
	REG_BLITTER[BLITTER_DEST].ACTIVE=0;
	REG_BLITTER[BLITTER_DEST].ROWS=8; /* Trigger blitter */
}

void term_scroll()
{
	if(term.mode)
		term_scroll_blitter();
	else
		term_scroll_cpu();
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
				p=FrameBuffer+(term.depth*(8*term.cursy*term.w+term.cursx));
				f=eightpixelfont_getchar(c);
				if(f)
				{
					int i,j,t,t2;
					for(i=0;i<8;++i)
					{
						char *p2=p;
						switch(term.depth)
						{
							case 1:
								t2=*f++;
								if(term.fgpen&1)
								{
									if(term.bgpen&1)
										*p2++=0xff;
									else
										*p2++=t2;
								}
								else if(term.bgpen&1)
									*p2++=~t2;
								else
									*p2++=0;
								break;
							case 4:
								t=*f++;
								for(j=0;j<4;++j)
								{
									t2=0;
									if(t&0x80)
										t2|=term.fgpen<<4;
									else
										t2|=term.bgpen<<4;
									if(t&0x40)
										t2|=term.fgpen&0xf;
									else
										t2|=term.bgpen&0xf;
									t<<=2;
									*p2++=t2;
								}
								break;
							
							case 8:
								t=*f++;
								for(j=0;j<8;++j)
								{
									if(t&0x80)
										t2=term.fgpen;
									else
										t2=term.bgpen;
									t<<=1;
									*p2++=t2;
								}
								break;

							case 16:
								t=*f++;
								for(j=0;j<8;++j)
								{
									if(t&0x80)
										t2=term.fgpen;
									else
										t2=term.bgpen;
									t<<=1;
									*(short *)p2=t2;
									p2+=2;
								}
								break;

							case 32:
								t=*f++;
								for(j=0;j<8;++j)
								{
									if(t&0x80)
										t2=term.fgpen;
									else
										t2=term.bgpen;
									t<<=1;
									*(int *)p2=t2;
									p2+=4;
								}
								break;
							
							default:
								break;
						}
						p+=term.depth*term.w;
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

/* Dawnbringer's 16 colour palette */
int palette[]=
{
	0x140C1C,
	0x442434,
	0x30346D,
	0x4E4A4F,
	0x854C30,
	0x346524,
	0xD04648,
	0x757161,
	0x597DCE,
	0xD27D2C,
	0x8595A1,
	0x6DAA2C,
	0xD2AA99,
	0x6DC2CA,
	0xDAD45E,
	0xDEEED6
}

void setpalette(int bits)
{
	int i,j;
	int r,g,b;
	switch(bits)
	{
		case 4:
			for(i=0;i<16;++i)
			{
				HW_VGA(REG_VGA_CLUTIDX)=i;
				HW_VGA(REG_VGA_CLUTDATA)=palette[i];
			}
			break;		
		case 8:
			r=g=b=0;
			for(i=0;i<256;++i)
			{
				HW_VGA(REG_VGA_CLUTIDX)=i;
				HW_VGA(REG_VGA_CLUTDATA)=(r<<16)|(g<<8)|b;
				r+=7;
				r&=255;
				g+=31;
				g&=255;
				b+=41;
				b&=255;
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
	int t,t2;
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
	int i,t,t2;
	update_term(screenwidth,screenheight,bits);
	t=HW_TIMER(REG_MILLISECONDS);
	term.mode^=1;
	term_scroll();
	t=HW_TIMER(REG_MILLISECONDS)-t;
	t2=HW_TIMER(REG_MILLISECONDS);
	term.mode^=1;
	term_scroll();	
	t2=HW_TIMER(REG_MILLISECONDS)-t2;
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
	printf("Scroll method: %s, time %d ms.\n",term.mode ? "cpu" : "blitter",t);
	printf("Scroll method: %s, time %d ms.\n",term.mode ? "blitter" : "cpu",t2);
	puts("Press 1-9 to choose screenmode, a-e to choose bit depth...\n");
	puts("Press t to print some text, press p to cycle colours...\n");
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
	term.mode=0;
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
				case 's':
					term.mode^=1;
					printf("Scroll mode: %s\n",term.mode ? "Blitter" : "CPU");
					break;
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
				case 'p':
					term.fgpen+=13073;
					term.bgpen+=367;
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

