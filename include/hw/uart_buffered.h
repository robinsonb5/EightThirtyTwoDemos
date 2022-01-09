#ifndef UART_BUFFERED_H
#define UART_BUFFERED_H

#include <hw/hw_ringbuffer.h>

extern struct hw_ringbuffer uartbuffer;

#define UARTRead(x) hw_ringbuffer_read(&uartbuffer)
#define UARTBytesReady(x) hw_ringbuffer_count(&uartbuffer)
#define UARTWrite(x) hw_ringbuffer_write(&uartbuffer,x);

#endif

