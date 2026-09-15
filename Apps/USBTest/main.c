// FIXME - it seems likely that we're taking too much time preparing the get_descriptor message
// and will have to cue up both the token and actual message before sending. This means we'll 
// need to widen the FIFO so we have enough bits to encoding an SEZ in the stream.
// Also worth checking the clocking.

#include <sys/types.h>
#include <stddef.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

#include <hw/timer.h>

#define breadcrumb(x) putchar(x)
//#define breadcrumb(x)

#define USBBASE 0xFFFFFA00

#define REG_USB_STATUS 0
#define REG_USB_DATA 4
#define REG_USB_COMMAND 8

#define HW_USB(x) *(volatile unsigned long *)(USBBASE+x)

#define STATUS_DM0 1
#define STATUS_DM1 2
#define STATUS_DP0 4
#define STATUS_DP1 8
#define STATUS_RX_EMPTY 0x10
#define STATUS_TX_FULL 0x20
#define STATUS_SENDING 0x40
#define STATUS_RECV 0x80

#define STATUS_RESET 0x8000

#define COMMAND_SEND 1

struct usb_port;
struct usb_func;

#include "usb_msgs.c"
#define RINGBUFFER_LEN 128
struct ringbuffer {
	char buffer[RINGBUFFER_LEN];
	unsigned int inptr;
	unsigned int outptr;
};

struct ringbuffer buffer= {
	{0},0,0
};
#define ringbuffer_write(x) {buffer.buffer[buffer.inptr++]=x; buffer.inptr&=(RINGBUFFER_LEN-1);}
#define ringbuffer_read() (buffer.buffer[(buffer.outptr++)&(RINGBUFFER_LEN-1)])
#define ringbuffer_isempty() ((buffer.inptr & (RINGBUFFER_LEN-1))==(buffer.outptr & (RINGBUFFER_LEN-1)))

enum port_state { DISCONNECTED=0, RESET, CONNECTED, ENUMERATED };

struct usb_port {
	int portidx;
	enum port_state state;
	int fullspeed;
	int wait;
	int timestamp;
	int len;
	int lock;	// When this is set the port may not be switched.
	struct usb_func *chain;
};

struct usb_func {
	void (*fptr)(struct usb_port *port);
	union {
		const char *msg;
		int len;
	} u;
	int delay;
};

struct usb_func funcs[];

#define USB_PORTS 2

struct usb_port usb_ports[USB_PORTS];

#define setport(port) (HW_USB(REG_USB_STATUS)=(port))
#define isempty (HW_USB(REG_USB_STATUS)&STATUS_RX_EMPTY)

static void usb_detect(struct usb_port *port);

static int usb_crc16(const unsigned char *payload, int len)
{
	unsigned int res = 0xffff;
	unsigned int b;
	int i;
	while(len--) {
		unsigned int input=*payload++;
		int bits=8;
		while(bits--) {
			b = (input ^ res) & 1;
			input >>= 1;
			if (b) {
				res = (res >> 1) ^  0xa001; // 8005, but bit-reversed
			} else {
				res = (res >> 1);
			}
			res = res & 0xffff;
		}
	}
	return res ^ 0xffff;
}


static void waittxempty() {
	int time=1000000;
	while(time && (HW_USB(REG_USB_STATUS)&STATUS_SENDING)) {
		--time;
	}
}

static void usb_send(struct usb_port *port,const char *msg) {
	int len;
	int crc=0;
	if(port && msg) {
		len=*msg++;
//		if(len>3) {
//			crc=usb_crc16(msg+1,len-3);
//			printf("crc: %x (%x %x)\n",crc,msg[len-2],msg[len-1]);
//		}
		setport(port->portidx);
		port->lock=1;
		HW_USB(REG_USB_DATA)=0x80; // Sync
		while(len--)
			HW_USB(REG_USB_DATA)=*msg++;
		HW_USB(REG_USB_COMMAND)=COMMAND_SEND;
	}
}

static void usb_sof(struct usb_port *port) {
	waittxempty();
	if(port) {
		if(port->fullspeed)
			usb_send(port,usb_msg_sof);
		else
			HW_USB(REG_USB_COMMAND)=COMMAND_SEND; // Send with FIFO empty just sends SEZ for keepalive		
	}
}

static void usb_send_msg(struct usb_port *port) {
	waittxempty();
	if(port) {
		if(port->chain->u.msg)
			usb_send(port,port->chain->u.msg);
		++port->chain;
	}
}

static void usb_dump_buffer(struct usb_port *port) {
	while(!ringbuffer_isempty())
		printf("%02x ",ringbuffer_read());
	printf("\n");
//	breadcrumb('d');
	if(port)
		++port->chain;
}

static void usb_idle(struct usb_port *port) {
	int st=HW_USB(REG_USB_STATUS);
	if(port) {
		port->lock=0;
		if(!(st & (0x5 << port->portidx))) {
			printf("Device disconnected\n");
			port->chain=funcs;
		}
	}
}

enum recvstate {INIT,SOF,IN,SENT,RECEIVE,ACK,NAK,DONE};
static void usb_recv(struct usb_port *port) {
	static int timeout=10000;
	static enum recvstate state=INIT;

	if(port && port->chain) {
		if(timeout) {
			--timeout;
			switch(state) {
				case INIT:
					if(!(HW_USB(REG_USB_STATUS)&STATUS_SENDING)) {
						port->len = port->chain->u.len;
						state = SOF;
					}
					break;
				case SOF:
					timeout = 10000;
					usb_sof(port);
					state = IN;
				case IN:
					timeout = 10000;
					if(!(HW_USB(REG_USB_STATUS)&STATUS_SENDING)) {
						usb_send(port,usb_msg_in00);
						state = SENT;
						port->wait=0;
					}
					break;
				case SENT:
					if(!(HW_USB(REG_USB_STATUS)&STATUS_SENDING)) {
//						HW_USB(REG_USB_DATA)=0x80; // Sync
//						HW_USB(REG_USB_DATA)=0xd2; // Queue up an ACK
						state = RECEIVE;
					}
				case RECEIVE:
					if(HW_USB(REG_USB_STATUS)&STATUS_RECV) {
						int count=0;
						int sendack=1;
						int receivednak=0;
						HW_USB(REG_USB_DATA)=0x80; // Sync
						HW_USB(REG_USB_DATA)=0xd2; // Queue up an ACK
						HW_USB(REG_USB_COMMAND)=COMMAND_SEND; /* Send ACK */				
						while(!(HW_USB(REG_USB_STATUS)&STATUS_RX_EMPTY)) {
							int t=HW_USB(REG_USB_DATA);
							if(count > 0)
								ringbuffer_write(t);
							if(count==1 && t==0x5a) /* NAK received */
								receivednak=1;
							++count;
						}
						if (receivednak)
							state = NAK;
						else
							state = DONE;
						if(count>3) {
							port->len-=count-3;
							if(port->len>0)
								state = IN;
						}
					}
					break;
				case ACK:
					usb_send(port,usb_msg_ack);
					if(port->len>0)
						state = SOF;
					else
						state = DONE;
					break;
				case NAK:
					printf("NAK received - retrying\n");
					--port->chain;
					break;
				case DONE:
					timeout=10000;
					state=INIT;
					port->lock=0;
					++port->chain;
					break;
			}
		} else {
			printf("Timeout\n");
			timeout=10000;
			state=INIT;
			port->lock=0;
			port->chain=funcs;
		}
	}		
}

static void usb_get_response(struct usb_port *port) {
	static int timeout=10000;
	if(port) {
		waittxempty();
		if(!(HW_USB(REG_USB_STATUS)&STATUS_RECV) && timeout) {
			--timeout;
			return;
		}
		if(timeout) {
//			printf("Got reply\n");
			while(!(HW_USB(REG_USB_STATUS)&STATUS_RX_EMPTY)) {
				int t=HW_USB(REG_USB_DATA);
				ringbuffer_write(t);
//				printf("%x ",t);
			}
//			printf("\n");
			timeout=10000;
			++port->chain;
		} else {
			printf("Timeout\n");
			timeout=10000;
			port->lock=0;
			port->chain=funcs;
		}
	}
}

static void usb_release_reset(struct usb_port *port) {
	if(port) {
		port->lock=0;
		port->state=CONNECTED;
		++port->chain;
		HW_USB(REG_USB_STATUS)=port->portidx;
	}
}

static void usb_reset(struct usb_port *port) {
	if(port) {
		port->lock=1;
		port->state=RESET;
		++port->chain;
		HW_USB(REG_USB_STATUS)=STATUS_RESET|(port->portidx);
	}
}

static void usb_detect(struct usb_port *port) {
	int st=HW_USB(REG_USB_STATUS);
	if(port) {
		if(st & (0x5 << port->portidx)) {
			port->fullspeed = st & (0x1<<port->portidx) ? 0 : 1;
			printf("New %s device attached to port %d\n",port->fullspeed ? "full speed" : "low speed",port->portidx);
			++port->chain;
		}
	}
}

static void usb_checkpoint(struct usb_port *port) {
	if(port)
		printf("\nCheckpoint %c for port %d\n",(char)port->chain->u.len,port->portidx);
	if(port)
		++port->chain;
}

struct usb_func funcs[]={
	{usb_detect,{.msg=0},200},
	{usb_reset,{.msg=0},20},
	{usb_release_reset,{.msg=0},40},
	{usb_send_msg,{.msg=usb_msg_setup00},0},
	{usb_send_msg,{.msg=usb_msg_get_device},0},
	{usb_get_response,{.len=2},0},
	{usb_recv,{.len=16},0},
	{usb_dump_buffer,{.msg=0},10},

	{usb_send_msg,{.msg=usb_msg_setup00},0},
	{usb_send_msg,{.msg=usb_msg_get_config},0},
	{usb_get_response,{.len=2},0},
	{usb_recv,{.len=18},0},
	{usb_dump_buffer,{.msg=0},0},

	{usb_idle,{.msg=0},10},
	{0,0}
};


void usb_service() {
	int result;
	static int portno=0;
	struct usb_port *port=&usb_ports[portno];
	
	// No point continuing while a transmission is in progress.
	if(HW_USB(REG_USB_STATUS)&STATUS_SENDING)
		return;

	if(!port->wait) {
		struct usb_func *f=port->chain;		
		if(f && f->fptr)
			f->fptr(port);
		else
			port->chain=funcs;
		
		if(f && f->delay) {
			port->timestamp=GetTimer(1);
			port->wait=f->delay;
		} else
			port->wait=0;
		
	} else if (CheckTimer(port->timestamp)) {
		// Send keepalive
		if(port->state > RESET)
			usb_sof(port);
		--port->wait;
		port->timestamp=GetTimer(1);
	}

	// Since we're sharing so much infrastructure between ports
	// We can't switch ports until a transaction is complete.
	if(!port->lock) {
		portno=portno+1;
		if(portno==USB_PORTS)
			portno=0;
	}
	return;	
}

static void usb_initports() {
	int i;
	for(i=0;i<USB_PORTS;++i) {
		usb_ports[i].portidx=i;
		usb_ports[i].state=DISCONNECTED;
		usb_ports[i].lock=0;
		usb_ports[i].chain=funcs;
	}
}


int main(int argc,char **argv) {
	int i;
	usb_initports();
	printf("Watching USB ports for new devices.\n");
	while(1) {
		usb_service();
	}

	return(0);
}

