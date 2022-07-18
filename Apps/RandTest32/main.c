#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>

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


#define ITERATIONS 500

void timetest(char *description,void (*drawfunc)(unsigned int,unsigned int,unsigned int,unsigned int,unsigned int))
{
	int i;
	int t;
	unsigned int c,x,y,w,h;
	srand(0x55aa55aa); /* Seed the random number generator so the sequence is repeatable */
	t=HW_TIMER(REG_MILLISECONDS);
	for(i=0;i<ITERATIONS;++i)
	{
		c=rand();
		x=rand()%screenwidth;
		y=rand()%screenheight;
		w=screenwidth-x;
		h=screenheight-y;
		w=rand()%w;
		h=rand()%h;
		if(w>0 && h>0)
			drawfunc(x,y,x+w,y+h,c);
	}
	t=HW_TIMER(REG_MILLISECONDS)-t;
	printf("%d iterations using %s draw functions in %d ms.\n",ITERATIONS,description,t);
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
				
			timetest("C",makeRect);
			timetest("assembly",&makeRectFast);
			timetest("unrolled assembly",&makeRectFastUnrolled);

			printf("\nCurrently using %d x %d\n",screenwidth,screenheight);
			printf("Press 1 - 7 to switch screenmodes.\n");
		}

		c=rand();
		x=rand()%screenwidth;
		y=rand()%screenheight;
		w=screenwidth-x;
		h=screenheight-y;
		w=rand()%w;
		h=rand()%h;
		if(w>0 && h>0)
			makeRectFastUnrolled(x,y,x+w,y+h,c);	

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
			free_aligned((char *)FrameBuffer);
			update=1;
		}				
	}

    return 0;
}

