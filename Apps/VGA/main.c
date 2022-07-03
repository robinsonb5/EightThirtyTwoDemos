#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned short *FrameBuffer;	// Frame Buffer pointer
int screenwidth=640;		// Initial screen width
int screenheigth=480;		// Initial screen heigth

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

void initDisplay(void)
{
	FrameBuffer=(short *)malloc(sizeof(short)*640*480);
	HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
	HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB16;
}

#define SWAP(x) ((x<<8) | (x>>8))

int main(int argc, char **argv)
{
	int i;
	initDisplay();
	drawRectangle(0,0,639,479,SWAP(0x39e7));
	for(i=0;i<240;++i)
	{
		int g=(i>>3) | ((i>>2)<<5) | ((i>>3) << 11); 
		drawRectangle(0,i*2,149,i*2+1,SWAP(g));
		drawRectangle(150,i*2,299,i*2+1,SWAP((i>>3)<<11));
		drawRectangle(300,i*2,449,i*2+1,SWAP((i>>2)<<5));
		drawRectangle(450,i*2,599,i*2+1,SWAP(i>>3));
	}
	while(1)
		;
    return 1;
}

