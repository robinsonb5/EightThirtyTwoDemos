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

#define I2CBASE 0xFFFFF900

#define REG_I2C_STATUS 0
#define REG_I2C_DATA 4

#define I2C_PORT_EDID 1
#define I2C_PORT_SMBUS 2

#define HW_I2C(x) *(volatile unsigned long *)(I2CBASE+x)

#define STATUS_READY 1
#define STATUS_BUSY 2
#define STATUS_ERR 4

#define STATUS_RESET 0x8000
#define STATUS_GO 0x100


#define BATTERY_ADDRESS 0x0B

#define BATTERY_VOLTAGE 0x09
#define BATTERY_CURRENT 0x0A
#define BATTERY_CAPACITY 0x0D
#define BATTERY_DISCHARGE_TIME 0x12
#define BATTERY_CHARGE_TIME 0x13

int getstatus() {
	int status=HW_I2C(REG_I2C_STATUS);
	return(status);
}

void reset() {
	HW_I2C(REG_I2C_STATUS)=STATUS_RESET| I2C_PORT_SMBUS;	
}

void waitbusy() {
	while(getstatus() & STATUS_BUSY)
		;
}

int waitdataready() {
	int result=getstatus();
	while((result&STATUS_BUSY) || ((result & (STATUS_READY | STATUS_ERR))==0))
		result=getstatus();
	return(result);
}

int smbus_read_word(int address, int reg) {
	int result=0;
	waitbusy();
	HW_I2C(REG_I2C_STATUS)=STATUS_RESET|I2C_PORT_SMBUS;
	// FIXME check here that the bus is clear

	HW_I2C(REG_I2C_DATA) = 1; // Sending 1 byte after the device address
	HW_I2C(REG_I2C_DATA) = (address << 1); // Write transaction
	HW_I2C(REG_I2C_DATA) = reg;
	HW_I2C(REG_I2C_DATA) = 2; // Collecting 2 bytes from the device
	HW_I2C(REG_I2C_DATA) = (address << 1) | 1; // Read transaction
	HW_I2C(REG_I2C_STATUS)=I2C_PORT_SMBUS | STATUS_GO;
	if(waitdataready()&STATUS_ERR)
		printf("Error detected\n");
	while(getstatus() & STATUS_READY) {
		int w=HW_I2C(REG_I2C_DATA);
		result = (result >> 8) | ((w&0xff) << 8);
	}
	return result;
}

int main(int argc,char **argv) {
	int t;
	
	reset();
	
	printf("Drain FIFO\n");
	while(getstatus() & STATUS_READY)
		printf("%x ",HW_I2C(REG_I2C_DATA));	

	t=smbus_read_word(BATTERY_ADDRESS,BATTERY_CAPACITY);
	printf("Remaining capacity: %d%%\n",t);
	
	t=smbus_read_word(BATTERY_ADDRESS,BATTERY_CHARGE_TIME);
	if(t==0xffff)
		printf("Not charging\n");
	else
		printf("Time to charged: %d minutes\n",t);

	t=smbus_read_word(BATTERY_ADDRESS,BATTERY_DISCHARGE_TIME);	
	if(t!=0xffff)
		printf("Run-time left: %d minutes\n",t);
	return(0);
}

