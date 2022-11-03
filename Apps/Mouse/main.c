#include <stdio.h>
#include <stdlib.h>

#include <hw/interrupts.h>
#include <hw/ps2.h>
#include <hw/keyboard.h>
#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/vga.h>
#include <hw/screenmode.h>
#include <framebuffer.h>

#include <hw/mousedriver.h>

void PS2Handler(void *userdata);

char ledmsg[2]={0xed,0x00};


struct mousepointer
{
	int x,y;
};

void mousepointer_clamp(struct mousepointer *p)
{
	int w=Screenmode_GetWidth(SCREENMODE_CURRENT);
	int h=Screenmode_GetHeight(SCREENMODE_CURRENT);
	if(!p)
		return;
	if(p->x>=w)
		p->x=w-1;
	if(p->y>=h)
		p->y=h-1;
	if(p->x<0)
		p->x=0;
	if(p->y<0)
		p->y=0;
}

void mousepointer_update(struct mousepointer *p,struct mousedriver *driver)
{
	if(!p)
		return;
	mousedriver_ps2_handle(driver);
	if(mousedriver_get_event(driver))
	{
		p->x+=mousedriver_get_dx(driver);
		p->y+=mousedriver_get_dy(driver);
		mousepointer_clamp(p);
		HW_VGA(REG_VGA_SP0XPOS)=p->x;
		HW_VGA(REG_VGA_SP0YPOS)=p->y;
	}
}

char pollserial()
{
	int c=HW_UART(REG_UART);
	if(c&(1<<REG_UART_RXINT))
	{
		c&=0xff;
		return(c);
	}
	return(0);
}


unsigned int *alignsprite(unsigned int *src,int words)
{
	unsigned int *result=(unsigned int *)malloc_aligned(sizeof(unsigned int)*words,4);
	int i;
	if(result)
	{
		for(i=0;i<words;++i)
		{
			result[i]=src[i];
		}
	}
	return(result);
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
	return(result);	
}


extern unsigned int Screenmode_PointerSprite[];

int main(int argc, char **argv)
{	
	struct mousedriver driver;
	struct mousepointer pointer;
	int mode=0,bits=16;
//	unsigned int *sprite=alignsprite(Screenmode_PointerSprite,32);
	unsigned int *sprite=Screenmode_PointerSprite;
	char *framebuffer=initdisplay(SCREENMODE_640x480_60,bits);

	HW_VGA(REG_VGA_SP0PTR)=(int)sprite;
	HW_VGA(REG_VGA_SP0WIDTH)=16;
	HW_VGA(REG_VGA_SP0WORDS)=32;
	HW_VGA(REG_VGA_SP0XPOS)=1;
	HW_VGA(REG_VGA_SP0YPOS)=1;

	puts("Enabling interrupts...\n");
	EnableInterrupts();

	// Turn off LEDs
	PS2KeyboardWriteChar(0xed);
	PS2KeyboardWriteChar(0x00);

	mousedriver_ps2_init(&driver);

	while(1)
	{
		int k,c;
		k=HandlePS2RawCodes();
		if(k)
			putchar(k);
		
		mousepointer_update(&pointer,&driver);

		c=pollserial();
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
					printf("Switching to mode %d\n",mode);
					if(framebuffer)
						Framebuffer_Free(framebuffer);
					printf("Freed old buffer\n");
					framebuffer=initdisplay(mode,bits);
					break;
				case 'a':
				case 'b':
				case 'c':
				case 'd':
				case 'e':
					bits=32>>(c-'a');
					if(c=='e')
						bits>>=1;
					Framebuffer_Set(framebuffer,bits);
					break;
			}
		}				

	}
	return(0);
}


