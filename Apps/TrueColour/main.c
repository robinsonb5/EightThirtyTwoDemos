#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 
unsigned int *FrameBuffer;	// Frame Buffer pointer
int screenwidth=640;		// Initial screen width
int screenheigth=480;		// Initial screen heigth


// makeRect(xS,yS,xE,yE,color) - Draw a rectangle
void makeRect(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color)
{
	unsigned int x,y,yoff;
	for (y = yS; y <= yE; y += 1)
	{
		yoff = y * screenwidth;
		for (x = xS; x <= xE; x += 1)
		{
			int t=*(FrameBuffer + x + yoff);
			t=((t>>1)&0x7f7f7f7f)+((color>>1)&0x7f7f7f7f);
			*(FrameBuffer + x + yoff) = t;
		}
	}
}


void initDisplay(void)
{
	FrameBuffer=(short *)malloc(sizeof(int)*640*480);
	HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
	HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB32;
	memset(FrameBuffer,0,sizeof(int)*640*480);
}


int main(int argc, char **argv)
{
    int i;

	initDisplay();

	while(1)
	{
		unsigned int c=rand()&0x00fffffff;
		unsigned int x=rand()%640u;
		unsigned int y=rand()%480u;
		unsigned int w=640-x;
		unsigned int h=480-y;
		w=rand()%w;
		h=rand()%h;
		makeRect(x,y,x+w,y+h,c);
	}

    return 0;
}

