#include <stdio.h>
#include <hw/uart.h>
#include <hw/timer.h>
#include <hw/uart_buffered.h>
#include <hw/interrupts.h>

#include "uip.h"
#include "uip_arp.h"
//#include "network-device.h"
//#include "httpd.h"
#include "timer.h"

#include "slipdev.h"

#define network_device_read slipdev_poll
#define network_device_send slipdev_send
#define network_device_init slipdev_init

/*---------------------------------------------------------------------------*/
int
main(void)
{
  int i;
  uip_ipaddr_t ipaddr;
  struct timer periodic_timer;

  EnableInterrupts();

  puts("Starting\n");
  
  timer_set(&periodic_timer, CLOCK_SECOND / 2);
  
  puts("Network device init\n");

  network_device_init();
  puts("UIP Init\n");
  uip_init();

  puts("Set host addr\n");
  uip_ipaddr(ipaddr, 192,168,240,2);
  uip_sethostaddr(ipaddr);

  puts("Hello World init\n");
  hello_world_init();
  
  while(1) {
    uip_len = network_device_read();
    if(uip_len > 0) {
		HW_UART(REG_UART)='.';
      uip_input();
      /* If the above function invocation resulted in data that
	 should be sent out on the network, the global variable
	 uip_len is set to a value > 0. */
      if(uip_len > 0) {
	network_device_send();
      }
    } else if(timer_expired(&periodic_timer)) {
      timer_reset(&periodic_timer);
      for(i = 0; i < UIP_CONNS; i++) {
	uip_periodic(i);
	/* If the above function invocation resulted in data that
	   should be sent out on the network, the global variable
	   uip_len is set to a value > 0. */
	if(uip_len > 0) {
//		uip_split_output();
		HW_UART(REG_UART)='+';
	  network_device_send();
	}
      }

#if UIP_UDP
      for(i = 0; i < UIP_UDP_CONNS; i++) {
	uip_udp_periodic(i);
	/* If the above function invocation resulted in data that
	   should be sent out on the network, the global variable
	   uip_len is set to a value > 0. */
	if(uip_len > 0) {
	  network_device_send();
	}
      }
#endif /* UIP_UDP */

    }
  }
  return 0;
}

void uip_log(char *c)
{
	puts(c);
}

void slipdev_char_put(u8_t c)
{
	UARTWrite(c);
}

u8_t slipdev_char_poll(u8_t *c)
{
	int r=UARTBytesReady();
	if(r)
	{
		*c=UARTRead();
		return(1);
	}
	return(0);
}

int clock_time()
{
	return(HW_TIMER(REG_MILLISECONDS));
}

/*---------------------------------------------------------------------------*/
