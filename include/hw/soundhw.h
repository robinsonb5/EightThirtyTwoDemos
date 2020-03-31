#ifndef SOUNDHW_H
#define SOUNDHW_H


struct SoundChannel
{
	char *DAT;	// 0-3
	unsigned int LEN;	// 4-7
	int TRIGGER; // 8-11
	int PERIOD;	// 12-15
	int VOL;	// 16-19
	long pad1; // 20-23
	long pad2; // 24-27
	long pad3; // 28-32
};	// 32 bytes long

#define REG_SOUNDCHANNEL ((volatile struct SoundChannel *)0xFFFFFD00)

#endif
