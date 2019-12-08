#define UARTBASE 0xffffffc0

#define HW_UART(x) *(volatile unsigned int *)(UARTBASE+x)

#define REG_UART 0

#define UART_B_TXREADY 8
#define UART_F_TXREADY 0x100
#define UART_B_RXREADY 9
#define UART_F_RXREADY 0x200

