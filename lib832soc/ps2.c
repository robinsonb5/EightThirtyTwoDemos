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
	{
		if(kbbuffer.flags & PS2_FLAG_WAITACK)
		{
			switch(kbd&0xff)
			{
				case PS2_BAT:
					kbbuffer.flags|=PS2_FLAG_BAT;
					kbbuffer.flags&=~PS2_FLAG_WAITACK;
					break;
				case PS2_ACK:
					kbbuffer.flags|=PS2_FLAG_ACK;
					kbbuffer.flags&=~PS2_FLAG_WAITACK;
					break;
				case PS2_ERROR:
					kbbuffer.flags|=PS2_FLAG_ERROR;
					kbbuffer.flags&=~PS2_FLAG_WAITACK;
					break;
				case PS2_RESEND:
					kbbuffer.flags|=PS2_FLAG_RESEND;
					kbbuffer.flags&=~PS2_FLAG_WAITACK;
					break;
			}		
		}
		hw_ringbuffer_fill(&kbbuffer,kbd&0xff);
	}

	if(!(kbbuffer.flags & PS2_FLAG_WAITACK) && (kbd & (1<<BIT_PS2_CTS)))
	{
		if(kbbuffer.out_hw!=kbbuffer.out_cpu)
		{
			int t=kbbuffer.outbuf[kbbuffer.out_hw];
			HW_PS2(REG_PS2_KEYBOARD)=t;
			if(t&PS2_FLAG_WAITACK)
				kbbuffer.flags|=PS2_FLAG_WAITACK;
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
	0,
	INTERRUPT_PS2
};


int PS2Keyboard_TestFlags(int flags)
{
	int result=kbbuffer.flags&flags;
	int enabled=DisableInterrupts();
	kbbuffer.flags&=~result;
	if(enabled)
		EnableInterrupts();
	return(result);
}


int PS2Mouse_TestFlags(int flags)
{
	int result=mousebuffer.flags&flags;
	int enabled=DisableInterrupts();
	mousebuffer.flags&=~result;
	if(enabled)
		EnableInterrupts();
	return(result);
}


//void PS2KeyboardWrite(int x)
void PS2KeyboardWrite(char *msg,int len)
{
	int x;
	while(len)
	{
		x=*msg++;
		hw_ringbuffer_write(&kbbuffer,len ? x : x | PS2_FLAG_WAITACK); /* Mark the last byte as requiring an acknowledgement */
		--len;
	}
}

void PS2KeyboardWriteChar(char x)
{
	hw_ringbuffer_write(&kbbuffer, x | PS2_FLAG_WAITACK); /* Mark the last byte as requiring an acknowledgement */
}


void PS2MouseWriteChar(int x)
{
	hw_ringbuffer_write(&mousebuffer,x);
}


__constructor(101.ps2) void PS2Init()
{
	puts("In PS2 constructor\n");
	hw_ringbuffer_init(&kbbuffer);
	kbbuffer.action=PS2Handler;
	hw_ringbuffer_init(&mousebuffer);
	mousebuffer.action=PS2Handler;
	AddInterruptHandler(&ps2_inthandler);
}

__destructor(101.ps2) void PS2End()
{
	RemoveInterruptHandler(&ps2_inthandler);
}

