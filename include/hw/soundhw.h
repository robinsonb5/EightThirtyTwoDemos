#ifndef SOUNDHW_H
#define SOUNDHW_H


struct SoundChannel
{
	char *DAT;	// 0-3
	unsigned int LEN;	// 4-7
	int TRIGGER; // 8-11
	int PERIOD;	// 12-15
	int VOL;	// 16-19
	long PAN; // 20-23
	long FORMAT; // 24-27
	long MODE; // 28-32
};	// 32 bytes long

#define REG_SOUNDCHANNEL ((volatile struct SoundChannel *)0xFFFFFD00)

#define SOUND_FORMAT_MONO_S8 0
#define SOUND_FORMAT_MONO_S16 1

/* Panning not yet supported */
#define SOUND_PAN_NONE 0
#define SOUND_PAN_LEFT 1
#define SOUND_PAN_RIGHT 2
#define SOUND_PAN_CENTRE 3

#define SOUND_MODE_INT_B 0
#define SOUND_MODE_INT_F (1<<SOUND_MODE_INT_B)

#endif
