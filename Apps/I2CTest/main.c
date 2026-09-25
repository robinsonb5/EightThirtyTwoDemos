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

#define I2C_PORT_EDID 2

#define HW_I2C(x) *(volatile unsigned long *)(I2CBASE+x)

#define STATUS_READY 1
#define STATUS_BUSY 2
#define STATUS_ERR 4

#define STATUS_RESET 0x8000

int getstatus() {
	int status=HW_I2C(REG_I2C_STATUS);
	return(status);
}

void reset() {
	HW_I2C(REG_I2C_STATUS)=STATUS_RESET| I2C_PORT_EDID;	
}

void waitbusy() {
	printf("Waiting for busy flag to be released...");
	printf("%x\n",getstatus());
	while(HW_I2C(REG_I2C_STATUS) & STATUS_BUSY)
		;
	printf("%x\n",getstatus());
	printf("done\n");
}

char edid[128];

void parse_dtd(const char *e) {
	int t;
	int i;
	t=(e[1]<<8) | e[0];
	if(!t) { // Monitor descriptor
		int isascii=0;
		t=e[3];
		switch(t) {
			case 0xff :
				printf("Serial number: ");
				isascii=1;
				break;
			case 0xfe :
				printf("Unspecified text: ");
				isascii=1;			
				break;
			case 0xfd : 
				printf("Monitor range limits\n");
				/*
				4 	Offsets for display range limits
Bits 7–4	00 = reserved
Bits 3–2	Horizontal rate offsets:

00 = none;
10 = +255 kHz for max. rate;
11 = +255 kHz for max. and min. rates.
Bits 1–0	Vertical rate offsets:

00 = none;
10 = +255 Hz for max. rate;
11 = +255 Hz for max. and min. rates.
5	Minimum	vertical field rate (1–255 Hz; 256–510 Hz, if offset).
6	Maximum
7	Minimum	horizontal line rate (1–255 kHz; 256–510 kHz, if offset).
8	Maximum
9	Maximum pixel clock rate, rounded up to 10 MHz multiple (10–2550 MHz).
10	Extended timing information type:

00 = Default GTF (when basic display parameters byte 24, bit 0 is set).
01 = No timing information.
02 = Secondary GTF supported, parameters as follows.
04 = CVT (when basic display parameters byte 24, bit 0 is set), parameters as follows.
11–17	Video timing parameters (if byte 10 is 00 or 01, padded with 0A 20 20 20 20 20 20)
*/
				break;
			case 0xfc :
				printf("Monitor name: ");
				isascii=1;			
				break;
			case 0xfb:
				printf("Additional white point data\n");
				break;
			case 0xfa:
				printf("Additional timing identifiers\n");
				break;
			case 0xf9:
				printf("Display colour management\n");
				break;
			case 0xf8:
				printf("CVT 3-byte Timing Codes\n");
				break;
			case 0xf7:
				printf("Additional standard timing 3\n");
				break;
			default:
				break;
		}
		if(isascii) {
			for(i=5;i<18;++i)
				putchar(e[i]);
			putchar('\n');
		}
/*	
    FD: Monitor range limits. 6- or 13-byte (with additional timing) binary descriptor.
    FB: Additional white point data. 2× 5-byte descriptors, padded with 0A 20 20.
    FA: Additional standard timing identifiers. 6× 2-byte descriptors, padded with 0A.
    F9: Display Color Management (DCM).
    F8: CVT 3-Byte Timing Codes.
    F7: Additional standard timing 3.	
*/
	} else { // Detailed timing descriptor
		printf("Preferred display mode: \n");
		printf("\tPixel clock: %d\n",t*10);
		
		t=e[2] | ((e[4]&0xf0)<<4);
		printf("\tH active pixels: %d\n",t);
		
		t=e[3] | ((e[4]&0xf)<<8);
		printf("\tH blank pixels: %d\n",t);
		
		t=e[5] | ((e[7]&0xf0)<<4);
		printf("\tV active lines: %d\n",t);
		
		t=e[5] | ((e[7]&0xf)<<8);
		printf("\tV blank lines: %d\n",t);

		printf("\tH front porch: %d\n",e[8]|((e[11]&0xc0)<<2));
		printf("\tH sync width: %d\n",e[9]|((e[11]&0x30)<<4));
		
		printf("\tV front porch: %d\n",(e[10] >> 4)|((e[11]&0xc)<<2));
		printf("\tV sync width: %d\n",(e[10]&0xf)|((e[11]&3)<<4));
	
	}
/* 
12	Horizontal image size, mm, 8 lsbits (0–255 mm, 161 in)
13	Vertical image size, mm, 8 lsbits (0–255 mm, 161 in)
14	Bits 7–4	Horizontal image size, mm, 4 msbits (0–15)
Bits 3–0	Vertical image size, mm, 4 msbits (0–15)
15	Horizontal border pixels (one side; total is twice this) (0–255)
16	Vertical border lines (one side; total is twice this) (0–255)
17	Features bitmap
Bit 7	Signal Interface Type:

0 = non-interlaced;
1 = interlaced.
Bits 6–5	Stereo mode (combine bits 6–5 with bit 0):

00 x = none, bit 0 is "don't care";
01 0 = field sequential, right during stereo sync;
10 0 = field sequential, left during stereo sync;
01 1 = 2-way interleaved, right image on even lines;
10 1 = 2-way interleaved, left image on even lines;
11 0 = 4-way interleaved;
11 1 = side-by-side interleaved.
Bit 4 = 0	Analog sync.
If set, the following bit definitions apply:
Bit 3	Sync type:

0 = analog composite;
1 = bipolar analog composite.
Bit 2	Serration:

0 = without serrations;
1 = with serrations (H-sync during V-sync).
Bit 1	Sync on red and blue lines additionally to green

0 = sync on green signal only;
1 = sync on all three (RGB) video signals.
Bits 4–3 = 10	Digital sync., composite (on HSync).
If set, the following bit definitions apply:
Bit 2	Serration

0 = without serration;
1 = with serration (H-sync during V-sync).
Bit 1	Horizontal sync polarity:

0 = negative;
1 = positive.
Bits 4–3 = 11	Digital sync., separate
If set, the following bit definitions apply:
Bit 2	Vertical sync polarity:

0 = negative;
1 = positive.
Bit 1	Horizontal sync polarity:

0 = negative;
1 = positive.
Bit 0	Stereo mode (combines with bits 6–5)
*/

}

void parse_sti(const char *e) {
	int t;
	t=e[0];
	if(e[0]==1 && e[1]==1)
		return;
	if(t) printf("Mode:\n\tX resolution: %d\n",(t+31)*8);
	t=e[1];
	switch((t>>6)&3) {
		case 0 : printf("\tAspect ration: 16:10\n"); break;
		case 1 : printf("\tAspect ration: 4:3\n"); break;
		case 2 : printf("\tAspect ration: 5:4\n"); break;
		case 3 : printf("\tAspect ration: 16:9\n"); break;
	}
	printf("\tVertical frequency: %d\n",(t&0x3f)+60);
}

void parse_edid(const char *e) {
	int i;
	int t;
	t=(e[8] << 8) | e[9];
	printf("Manufacturer code: ");
	for(i=0;i<3;++i) {
		int c=65+((t>>10)&31);
		putchar(c);
		t<<=5;
	}
	putchar('\n');
	
	t=(e[11]<<8) | e[10];
	printf("Product code: %x\n",t);
	
	t=e[12] | (e[13]<<8) | (e[14]<<16) | (e[15]<<24);
	printf("Serial number: %d\n",t);
	
	int week=e[16];
	int year=e[17];
	
	printf("Week: %d, year of %s: %d\n",week,week==0xff ? "model" : "manufacture", year + 1990 );
	
	printf("EDID verson: %d.%d\n",edid[18],edid[19]);

	t=edid[20];
	
	if(t&0x80) {
		printf("Digital input - ");
		switch(t&4) {
			case 1 : printf("DVI - "); break;
			case 2 : printf("HDMIa - "); break;
			case 3 : printf("HDMIb - "); break;
			case 4 : printf("MDDI - "); break;
			case 5 : printf("DisplayPort - "); break;
			default : printf("Undefined port - "); break;
		}
		int d=(t>>4) & 0x7;
		if(d && d<7)
			printf("Bit depth: %d\n",4+2*d);
		else 
			printf("Bit depth undefined\n");
	}

	printf("Width: %dcm, Height: %dcm\n",edid[21], edid[22]);
	
	t=edid[23]+100;
	printf("Gamma: %d.%d\n",t/100,t%100);
	
	t=edid[24];
	printf("DPMS - standby: %s, suspend: %s, active-off: %s\n",t&0x80 ? "yes" : "no", t&0x40 ? "yes" : "no", t&0x20 ? "yes" : "no");
	switch((t>>3) & 3) {
		case 0: printf("RGB 4:4:4\n"); break;
		case 1: printf("RGB 4:4:4 + YCrCb 4:4:4\n"); break;
		case 2: printf("RGB 4:4:4 + YCrCb 4:2:2\n"); break;
		case 3: printf("RGB 4:4:4 + YCrCb 4:4:4 + YCrCb 4:2:2\n"); break;
	}

	if(t&4)
		printf("Standard sRGB\n");
	if(t&2)
		printf("Preferred timing mode in first descriptor block\n");
	if(t&1)
		printf("Continuous timings with GFT or CVT supported\n");
	
	// FIXME print chromaticity coordinates here
	
	printf("Established modes supported:\n");
	// Established mode bitmap:
	t=edid[35];
	if (t&0x80) printf("\t720x480 @ 70Hz (VGA)\n");
	if (t&0x40) printf("\t720×400 @ 88 Hz (XGA)\n");
	if (t&0x20) printf("\t640×480 @ 60 Hz (VGA)\n");
	if (t&0x10) printf("\t640×480 @ 67 Hz (Apple Macintosh II)\n");
	if (t&0x08) printf("\t640×480 @ 72 Hz\n");
	if (t&0x04) printf("\t640×480 @ 75 Hz\n");
	if (t&0x02) printf("\t800×600 @ 56 Hz\n");
	if (t&0x01) printf("\t800×600 @ 60 Hz\n");

	t=edid[36];
	if (t&0x01) printf("\t800×600 @ 72 Hz\n");
	if (t&0x01) printf("\t800×600 @ 75 Hz\n");
	if (t&0x01) printf("\t832×624 @ 75 Hz (Apple Macintosh II)\n");
	if (t&0x01) printf("\t1024×768 @ 87 Hz, interlaced (1024×768i)\n");
	if (t&0x01) printf("\t1024×768 @ 60 Hz\n");
	if (t&0x01) printf("\t1024×768 @ 70 Hz\n");
	if (t&0x01) printf("\t1024×768 @ 75 Hz\n");
	if (t&0x01) printf("\t1280×1024 @ 75 Hz\n");
	
	t=edid[37];
	if (t&0x80) printf("\t1152x870 @ 75 Hz (Apple Macintosh II)\n");
	if (t&0x7f) printf("\t+ manufacturer-specific modes\n");

	for(i=0;i<8;++i) {
		parse_sti(&edid[38+2*i]);
	}
	for(i=0;i<4;++i) {
		parse_dtd(&edid[54+18*i]);
	}

}



int main(int argc,char **argv) {
	int i;
	
	reset();

	waitbusy();
	printf("Sending start address\n");
	HW_I2C(REG_I2C_DATA)=0x1;  // Send 1 byte after the address byte
	HW_I2C(REG_I2C_DATA)=0xa0; // 0x50, 0 for write
	HW_I2C(REG_I2C_DATA)=0;    // Start address

	waitbusy();
	printf("Receiving data\n");
	HW_I2C(REG_I2C_DATA)=0x80; // Receive 128 bytes of EDID data
	HW_I2C(REG_I2C_DATA)=0xa1; // 0x50,1 for read
	waitbusy();

	int t;
	t=HW_I2C(REG_I2C_DATA);
	t=HW_I2C(REG_I2C_DATA);
	t=HW_I2C(REG_I2C_DATA);
	i=0;
	while(getstatus() & STATUS_READY) {
		edid[i]=HW_I2C(REG_I2C_DATA);
		printf("%02x  ",edid[i]);
		if((i&15)== 15)
			printf("\n");
		++i;
	}
	
	parse_edid(edid);

	return(0);
}

