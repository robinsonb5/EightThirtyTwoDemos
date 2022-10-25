#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>
#include <hw/blitter.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 
unsigned int *FrameBuffer;	// Frame Buffer pointer
unsigned int screenwidth=640;		// Initial screen width
unsigned int screenheight=480;		// Initial screen heigth

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

void makeRectBlitter(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color)
{
	int w=xE-xS;
	int t;
	while(t=REG_BLITTER[BLITTER_DEST].ROWS)	/* Wait for any previous operation to finish - FIXME use an interrupt */
		;
//	putchar('a');
	w&=~3; /* Make sure the width is a multiple of 4 */
	REG_BLITTER[BLITTER_SRC1].ADDRESS=FrameBuffer;
	REG_BLITTER[BLITTER_SRC1].SPAN=w;
	REG_BLITTER[BLITTER_SRC1].MODULO=4*(screenwidth-w);
//	REG_BLITTER[BLITTER_SRC1].DATA=color;

	REG_BLITTER[BLITTER_DEST].ADDRESS=(FrameBuffer+screenwidth*yS+xS);
	REG_BLITTER[BLITTER_DEST].SPAN=w;
	REG_BLITTER[BLITTER_DEST].MODULO=4*(screenwidth-w);
	REG_BLITTER[BLITTER_DEST].ACTIVE=2;
	REG_BLITTER[BLITTER_DEST].ROWS=yE-yS; /* Trigger blitter */
//	putchar('b');
}


void initDisplay(enum screenmode mode,int bits)
{
	int w,h;
	w=Screenmode_GetWidth(mode);
	h=Screenmode_GetHeight(mode);
	if(w && h)
	{
		screenwidth=w;
		screenheight=h;
		FrameBuffer=(unsigned int *)malloc_aligned((bits/8) * w*h,32);
		Screenmode_Set(mode);
		HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
		HW_VGA(PIXELFORMAT) = bits==32 ? PIXELFORMAT_RGB32 : PIXELFORMAT_RGB16;
	}
}


void timetest(char *description,void (*drawfunc)(unsigned int,unsigned int,unsigned int,unsigned int,unsigned int))
{
	int iterations;
	int i;
	int t;
	unsigned int c,x,y,w,h;
	srand(0x55aa55aa); /* Seed the random number generator so the sequence is repeatable */
	iterations=(640*480*200) / (screenwidth*screenheight);
	t=HW_TIMER(REG_MILLISECONDS);
	for(i=0;i<iterations;++i)
	{
		c=rand();
		x=rand()%screenwidth;
		y=rand()%screenheight;
		w=screenwidth-x;
		h=screenheight-y;
		w=rand()%w;
		h=rand()%h;
		if(w>4 && h>4)
			drawfunc(x,y,x+w,y+h,c);
	}
	t=HW_TIMER(REG_MILLISECONDS)-t;
	printf("%d iterations using %s draw functions in %d ms.\n",iterations,description,t);
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
	unsigned int c,x,y,w,h;
	int update=1;
	int mode=SCREENMODE_640x480_60;

	while(1)
	{	
		if(update)
		{
			update=0;
			initDisplay(mode,32);
			printf("\nTesting %d x %d\n",screenwidth,screenheight);
			timetest("C",makeRect);
//			FrameBuffer=(int *)(((int)FrameBuffer)|0x40000000); /* Evil hack - upper image of memory which doesn't clear cachelines on write */
//			timetest("C (cache bypass)",makeRect);
			timetest("Blitter",makeRectBlitter);

//			printf("Press 1 - %d to switch screenmodes.\n",SCREENMODE_MAX);
		}

#if 0
		makeRect(0,0,639,479,0x7f7f7f7f);
		makeRect(0,0,63,63,0x00ff0000);
		makeRect(64,64,127,127,0x30303030);
		makeRect(128,128,191,191,0xc0c0c0c0);
		makeRect(192,192,255,255,0x00000000);
		makeRect(256,256,319,319,0xffffffff);
		makeRectBlitter(320,240,640,480,0x7f7f7f7f);
		while(1)
			;
#endif

		c=rand();
		x=rand()%screenwidth;
		y=rand()%screenheight;
		w=screenwidth-x;
		h=screenheight-y;
		w=rand()%w;
		h=rand()%h;
		if(w>4 && h>4)
			makeRectBlitter(x,y,x+w,y+h,c);

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
				case '0':
					mode=c-'1';
					break;
				default:
					break;
			}
			FrameBuffer=(int *)(((int)FrameBuffer)&0x3fffffff); /* Evil hack - upper image of memory which doesn't clear cachelines on write */
			free((char *)FrameBuffer);
			update=1;
		}				
	}

    return 0;
}

