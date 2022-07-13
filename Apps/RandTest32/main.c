#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 
unsigned int *FrameBuffer;	// Frame Buffer pointer
int screenwidth=640;		// Initial screen width
int screenheigth=480;		// Initial screen heigth

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


void initDisplay(void)
{
	FrameBuffer=(int *)malloc(sizeof(int)*640*480);
	HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
	HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB32;
	memset(FrameBuffer,0,sizeof(int)*640*480);
}


#define ITERATIONS 1000

int main(int argc, char **argv)
{
    int i;
	int t;
	unsigned int c,x,y,w,h;

	initDisplay();

	srand(0x55aa55aa); /* Seed the random number generator so the sequence is repeatable */
	t=HW_TIMER(REG_MILLISECONDS);
	for(i=0;i<ITERATIONS;++i)
	{
		c=rand();
		x=rand()%640u;
		y=rand()%480u;
		w=640-x;
		h=480-y;
		w=rand()%w;
		h=rand()%h;
		if(w>0 && h>0)
			makeRect(x,y,x+w,y+h,c);
	}
	t=HW_TIMER(REG_MILLISECONDS)-t;
	printf("%d iterations using C draw functions in %d ms.\n",ITERATIONS,t);

	srand(0x55aa55aa); /* Seed the random number generator so the sequence is repeatable */
	t=HW_TIMER(REG_MILLISECONDS);
	for(i=0;i<ITERATIONS;++i)
	{
		c=rand();
		x=rand()%640u;
		y=rand()%480u;
		w=640-x;
		h=480-y;
		w=rand()%w;
		h=rand()%h;
		if(w>0 && h>0)
			makeRectFast(x,y,x+w,y+h,c);
	}
	t=HW_TIMER(REG_MILLISECONDS)-t;
	printf("%d iterations using assembly draw functions in %d ms.\n",ITERATIONS,t);

	srand(0x55aa55aa); /* Seed the random number generator so the sequence is repeatable */
	t=HW_TIMER(REG_MILLISECONDS);
	for(i=0;i<ITERATIONS;++i)
	{
		c=rand();
		x=rand()%640u;
		y=rand()%480u;
		w=640-x;
		h=480-y;
		w=rand()%w;
		h=rand()%h;
		if(w>0 && h>0)
			makeRectFastUnrolled(x,y,x+w,y+h,c);
	}
	t=HW_TIMER(REG_MILLISECONDS)-t;
	printf("%d iterations using unrolled assembly draw functions in %d ms.\n",ITERATIONS,t);

	/* After timing is finished just keep running */
	while(1)
	{
		c=rand();
		x=rand()%640u;
		y=rand()%480u;
		w=640-x;
		h=480-y;
		w=rand()%w;
		h=rand()%h;
		if(w>0 && h>0)
			makeRectFastUnrolled(x,y,x+w,y+h,c);	
	}

    return 0;
}

