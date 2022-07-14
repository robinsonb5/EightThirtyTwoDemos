#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned short *FrameBuffer;	// Frame Buffer pointer
int screenwidth=1280;		// Initial screen width
int screenheight=480;		// Initial screen heigth

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

enum screenmode {SCREENMODE_640x480,SCREENMODE_1280x480,SCREENMODE_800x600,test};

void SetScreenmode(enum screenmode mode)
{
	switch(mode) {
		case SCREENMODE_640x480:
			HW_VGA(REG_VGA_HTOTAL)=800;
			HW_VGA(REG_VGA_HSIZE)=640;
			HW_VGA(REG_VGA_HSSTART)=656;
			HW_VGA(REG_VGA_HSSTOP)=752;
			HW_VGA(REG_VGA_VTOTAL)=525;
			HW_VGA(REG_VGA_VSIZE)=480;
			HW_VGA(REG_VGA_VSSTART)=500;
			HW_VGA(REG_VGA_VSSTOP)=502;
			HW_VGA(REG_VGA_PIXELCLOCK)=3;	
			break;
		case SCREENMODE_1280x480:
			HW_VGA(REG_VGA_HTOTAL)=1600;
			HW_VGA(REG_VGA_HSIZE)=1280;
			HW_VGA(REG_VGA_HSSTART)=1312;
			HW_VGA(REG_VGA_HSSTOP)=1504;
			HW_VGA(REG_VGA_VTOTAL)=525;
			HW_VGA(REG_VGA_VSIZE)=480;
			HW_VGA(REG_VGA_VSSTART)=500;
			HW_VGA(REG_VGA_VSSTOP)=502;
			HW_VGA(REG_VGA_PIXELCLOCK)=1;	
			break;
		case SCREENMODE_800x600:
			HW_VGA(REG_VGA_HTOTAL)=1040;
			HW_VGA(REG_VGA_HSIZE)=800;
			HW_VGA(REG_VGA_HSSTART)=856;
			HW_VGA(REG_VGA_HSSTOP)=976;
			HW_VGA(REG_VGA_VTOTAL)=666;
			HW_VGA(REG_VGA_VSIZE)=600;
			HW_VGA(REG_VGA_VSSTART)=637;
			HW_VGA(REG_VGA_VSSTOP)=643;
			HW_VGA(REG_VGA_PIXELCLOCK)=1;
			break;
		default:
			printf("Unknown screenmode %d\n",mode);
			break;
	}
}

void initDisplay(enum screenmode mode)
{
	int w,h;
	switch(mode) {
		case SCREENMODE_640x480:
			w=640;
			h=480;
			break;
		case SCREENMODE_1280x480:
			w=1280;
			h=480;
			break;
		case SCREENMODE_800x600:
			w=800;
			h=600;
			break;
	}
	screenwidth=w;
	screenheight=h;
	FrameBuffer=(short *)malloc(sizeof(short)*w*h);
	SetScreenmode(mode);
	HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
	HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB16;
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
	enum screenmode mode=SCREENMODE_640x480;
	while(1)
	{
		int c;
		initDisplay(mode);
		drawRectangle(0,0,screenwidth-1,screenheight-1,SWAP(0x39e7));
		for(i=0;i<240;++i)
		{
			int g=(i>>3) | ((i>>2)<<5) | ((i>>3) << 11); 
			drawRectangle(0,i*2,149,i*2+1,SWAP(g));
			drawRectangle(150,i*2,299,i*2+1,SWAP((i>>3)<<11));
			drawRectangle(300,i*2,449,i*2+1,SWAP((i>>2)<<5));
			drawRectangle(450,i*2,599,i*2+1,SWAP(i>>3));
		}
		printf("Press 1, 2 or 3 to switch screenmodes.\n");
		c=getserial();
		if (c)
		{
			switch(c) {
				case '1':
					mode=SCREENMODE_640x480;
					break;

				case '2':
					mode=SCREENMODE_800x600;
					break;			
				
				case '3':
					mode=SCREENMODE_1280x480;
					break;			
			
			}		
			free(FrameBuffer);
		}				
	}
	
    return 0;
}

