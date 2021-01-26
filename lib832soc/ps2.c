#include <stdio.h>

#include <hw/uart.h>
#include <hw/ps2.h>
#include <hw/timer.h>
#include <hw/interrupts.h>
#include <hw/keyboard.h>


struct hw_ringbuffer kbbuffer;
struct hw_ringbuffer mousebuffer;


void PS2Handler(void *userdata)
{
	int kbd;
	int mouse;
	
	kbd=HW_PS2(REG_PS2_KEYBOARD);
	mouse=HW_PS2(REG_PS2_MOUSE);

	if(kbd & (1<<BIT_PS2_RECV))
		hw_ringbuffer_fill(&kbbuffer,kbd&0xff);

	if(kbd & (1<<BIT_PS2_CTS))
	{
		if(kbbuffer.out_hw!=kbbuffer.out_cpu)
		{
			HW_PS2(REG_PS2_KEYBOARD)=kbbuffer.outbuf[kbbuffer.out_hw];
			kbbuffer.out_hw=(kbbuffer.out_hw+1) & (HW_RINGBUFFER_SIZE-1);
		}
	}

	if(mouse & (1<<BIT_PS2_RECV))
		hw_ringbuffer_fill(&mousebuffer,mouse&0xff);

	if(mouse & (1<<BIT_PS2_CTS))
	{
		if(mousebuffer.out_hw!=mousebuffer.out_cpu)
		{
			HW_PS2(REG_PS2_MOUSE)=mousebuffer.outbuf[mousebuffer.out_hw];
			mousebuffer.out_hw=(mousebuffer.out_hw+1) & (HW_RINGBUFFER_SIZE-1);
		}
	}
}


static struct InterruptHandler ps2_inthandler=
{
	0,
	PS2Handler,
	0
};

__constructor(101.ps2) void PS2Init()
{
	puts("In PS2 constructor\n");
	kbbuffer.action=PS2Handler;
	hw_ringbuffer_init(&kbbuffer);
	mousebuffer.action=PS2Handler;
	hw_ringbuffer_init(&mousebuffer);
	AddInterruptHandler(&ps2_inthandler);
	ClearKeyboard();
}

__destructor(101.ps2) void PS2End()
{
	RemoveInterruptHandler(&ps2_inthandler);
}

