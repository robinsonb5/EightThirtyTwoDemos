#include <hw/uart.h>
#include <hw/uart_buffered.h>
#include <hw/interrupts.h>

struct hw_ringbuffer uartbuffer;

void UARTHandler(void *userdata)
{
	int uart=HW_UART(REG_UART2);

	if(uart & (1<<REG_UART_RXINT))
		hw_ringbuffer_fill(&uartbuffer,uart&0xff);
	if(uart & (1<<REG_UART_TXREADY))
	{
		if(uartbuffer.out_hw!=uartbuffer.out_cpu)
		{
			HW_UART(REG_UART2)=uartbuffer.outbuf[uartbuffer.out_hw];
			uartbuffer.out_hw=(uartbuffer.out_hw+1) & (HW_RINGBUFFER_SIZE-1);
		}
	}
}


static struct InterruptHandler uart_inthandler=
{
	0,
	UARTHandler,
	0,
	INTERRUPT_SERIAL
};

/* Constructor dependencies: interrupts */
__constructor(101.uartbuffered) void UARTInit()
{
	puts("In buffered UART constructor\n");
	uartbuffer.action=UARTHandler;
	hw_ringbuffer_init(&uartbuffer);
	AddInterruptHandler(&uart_inthandler);
}

__destructor(101.uartbuffered) void UARTEnd()
{
	RemoveInterruptHandler(&uart_inthandler);
}

