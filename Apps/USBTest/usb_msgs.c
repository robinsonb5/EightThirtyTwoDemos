/* Outgoing messages. The first byte is the length of the message */

const char usb_msg_sof[]={3,0xa5,0x00,0x10};

const char usb_msg_in00[]={
	3,
	0x69,             // PID=IN
	0x00,             // ADDR:ENDP=0:0
	0x10              // + CRC5
};

const char usb_msg_setup00[] = {
	3,
	0x2d,             // PID
	0x00,             // ADDR:ENDP=0:0
	0x10              // CRC5
};

const char usb_msg_setup01[] = {
	3,
    0x2d,             // PID
    0x00,             // ADDR:ENDP=1:0
    0xe8              // CRC5
};

const char usb_msg_ack[] = {
	1,
	0xd2
};

const char usb_msg_get_device[] = { // get device descriptor of (0,0)
	11,
	0xc3,             // PID=DATA0
	0x80,             // bmRequestType=80
	0x06,             // bRequest=6 (Get_Descriptor)
	0x00,             // Desc Index=0
	0x01,             // Desc Type=1 (device)
	0x00,             // Language ID=0
	0x00,             //
	0x10,             // wLength=16
	0x00,
	0xe1,             // CRC16
	0x94
};

const char usb_msg_get_config[] = {
	11,
	0xc3,
	0x80,
	0x06,
	0x00,
	0x02,
	0x00,
	0x00,
	0x12,
	0x00,
	0xa4,
	0xf4,
};

enum usb_event_type {
	NONE,
	WAITCONNECT,
	WAITDISCONNECT,
	PORTRESET,
	RELEASERESET,
	SEND,
	RECV,
	RECVACK,
	CALL,
	BRANCH,
	RELEASE
};
	
struct usb_event {
	enum usb_event_type type;
	union {
		const char *msg;
		void (*fptr)(struct usb_port *port);
		struct usb_event *chain;
	} action;
	int delay;
};

void usb_recv_get_device(struct usb_port *port) {
	if(port) {
		while(!(HW_USB(REG_USB_STATUS)&STATUS_RX_EMPTY)) {
			int t=HW_USB(REG_USB_DATA);
			printf("%x ",t);
		}
		printf("\n");
	}
}

struct usb_event usb_event_init_port[] = 
{
	{WAITCONNECT,{.msg = 0},200},
	{PORTRESET,{.msg = 0},200},
	{RELEASERESET,{.msg = 0},1},
//	{SEND,{.msg = usb_msg_sof},0},
	{SEND,{.msg = usb_msg_setup00},0},
	{SEND,{.msg = usb_msg_get_device},0},
	{RECV,{.chain = usb_event_init_port},0},
	{RECVACK,{.chain = usb_event_init_port},0},
	{SEND,{.msg = usb_msg_in00},0},
	{RECV,{.chain = usb_event_init_port},0},
	{CALL,{.fptr = usb_recv_get_device},0},
	{NONE,{.msg = 0},0}
};

struct usb_event usb_event_idle[] = {
	{RELEASE,{.msg = 0},0},
	{WAITDISCONNECT,{.msg = 0},200},
	{BRANCH,{.chain=usb_event_init_port},20}
};
