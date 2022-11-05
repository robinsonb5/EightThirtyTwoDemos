#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/interrupts.h>
#include <hw/vga.h>
#include <hw/screenmode.h>
#include <hw/blitter.h>
#include <signals.h>
#include <socmemory.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

 
unsigned int *FrameBuffer;	// Frame Buffer pointer
unsigned int screenwidth=640;		// Initial screen width
unsigned int screenheight=480;		// Initial screen heigth


struct InterruptHandler inthandler;

static void blitter_handler(void *ud)
{
	int t=REG_BLITTER[BLITTER_CTRL].ROWS;
	SetSignal(0);
}


/* Waits for the blitter to become available, using signals. */
void WaitBlitter()
{
	int t;
	while(t=REG_BLITTER[BLITTER_CTRL].ROWS)
		WaitSignal(1<<0);
}


/* Returns 1 if the blitter is available */
int PollBlitter()
{
	int t=REG_BLITTER[BLITTER_CTRL].ROWS;
	if(t)
		return(0);
	else
		return(1);
}


void makeRectFast(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color);
void makeRectFastUnrolled(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color);

// makeRect(xS,yS,xE,yE,color) - Draw a rectangle

void makeRect(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color)
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


void memset_blit(char *buf,int span,int rows,int fill)
{
	int t;
	WaitBlitter();

	REG_BLITTER[BLITTER_DEST].ADDRESS=buf;
	REG_BLITTER[BLITTER_DEST].SPAN=span;
	REG_BLITTER[BLITTER_DEST].MODULO=0;

	REG_BLITTER[BLITTER_CTRL].FUNCTION=BLITTER_FUNC_A;
	REG_BLITTER[BLITTER_CTRL].ACTIVE=BLITTER_ACTIVE_NONE; /* Constant value */

	REG_BLITTER[BLITTER_SRC1].DATA=fill;

	REG_BLITTER[BLITTER_CTRL].ROWS=rows; /* Trigger blitter */
}


void makeRectBlitter(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color)
{
	int w=xE-xS;
	int t;
	WaitBlitter();

	/* Channel 1 - DMA from memory */

	REG_BLITTER[BLITTER_CTRL].ACTIVE=BLITTER_ACTIVE_SRC1;

	REG_BLITTER[BLITTER_SRC1].ADDRESS=(FrameBuffer+screenwidth*yS+xS);
	REG_BLITTER[BLITTER_SRC1].SPAN=w;
	REG_BLITTER[BLITTER_SRC1].MODULO=4*(screenwidth-w);

	/* Channel 2 - DMA disabled, so a constant value */

	REG_BLITTER[BLITTER_SRC2].DATA=0x01020300;

	/* Output parameters */

	REG_BLITTER[BLITTER_DEST].ADDRESS=(FrameBuffer+screenwidth*yS+xS);
	REG_BLITTER[BLITTER_DEST].SPAN=w; /* Width, specified in 32-bit words */
	REG_BLITTER[BLITTER_DEST].MODULO=4*(screenwidth-w); /* Line modulo, specified in bytes, but must be a multiple of 4! */

	REG_BLITTER[BLITTER_CTRL].FUNCTION=BLITTER_FUNC_A_PLUS_B;

	REG_BLITTER[BLITTER_CTRL].ROWS=yE-yS; /* Trigger blitter */
}


void initDisplay(enum screenmode mode,int bits)
{
	int w,h;
	w=Screenmode_GetWidth(mode);
	h=Screenmode_GetHeight(mode);
	if(w && h)
	{
		struct MemoryPool *pool=SoCMemory_GetPool();
		screenwidth=w;
		screenheight=h;
		FrameBuffer=(unsigned int *)pool->AllocAligned(pool,(bits/8) * w*h,32,0,SOCMEMORY_BANK0); /* Any bank but zero */
		Screenmode_Set(mode);
		HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
		HW_VGA(PIXELFORMAT) = bits==32 ? PIXELFORMAT_RGB32 : PIXELFORMAT_RGB16;
	}
	memset_blit((char *)FrameBuffer,w,h,0x000000); /* Clear the screen using the blitter */
}


char getserial()
{
	int c=HW_UART(REG_UART);
	if(c&(1<<REG_UART_RXINT))
	{
		c&=0xff;
		return(c);
	}
	return(0);
}


int main(int argc, char **argv)
{
    int i;
	int t;
	int colour;
	unsigned int c,x,y,w,h;
	int update=0;
	int mode=SCREENMODE_800x600_72;
	struct MemoryPool *pool=SoCMemory_GetPool();

	inthandler.next=0;
	inthandler.handler=blitter_handler;
	inthandler.bit=INTERRUPT_BLITTER;
	AddInterruptHandler(&inthandler);
	EnableInterrupts();

	initDisplay(mode,32);
	makeRectBlitter(271,40,320,280,0xaa551fe2);

	printf("Press 1 - 9 to change screenmode\n");

	colour=0;
	while(1)
	{	
		int i;

		x=rand()%screenwidth;
		y=rand()%screenheight;
		w=rand()%screenwidth;
		h=rand()%screenheight;
		if(w<x)
		{
			i=x; x=w; w=i;
		}
		if(h<y)
		{
			i=y; y=h; h=i;		
		}
		w-=x;
		h-=y;

		if(w>8 && h>8)
			makeRectBlitter(x,y,x+w,y+h,colour);

		update=0;

		c=getserial();
		if (c)
		{
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
					mode=c-'0';
					update=1;
					break;
				default:
					break;
			}
			if(update)
			{
				update=0;
				FrameBuffer=(int *)(((int)FrameBuffer)&0x3fffffff); /* Evil hack - upper image of memory which doesn't clear cachelines on write */
				pool->Free(pool,(char *)FrameBuffer);
				initDisplay(mode,32);
			}

		}				
	}

    return 0;
}

