#ifndef SCREENMODE_H
#define SCREENMODE_H

#include <hw/vga.h>

#include <hw/screenmode.h>

enum screenmode {
	SCREENMODE_640x480_60,
	SCREENMODE_768x576_60,
	SCREENMODE_800x600_56,
	SCREENMODE_800x600_72,
	SCREENMODE_1024x768_70,
	SCREENMODE_1280x480_60,
	SCREENMODE_1280x720_60,
	SCREENMODE_1920x1080_30,
	SCREENMODE_1920x1080_24,
	SCREENMODE_MAX};

int Screenmode_GetWidth(enum screenmode mode);
int Screenmode_GetHeight(enum screenmode mode);

/* returns 1 on successful completion, 0 on error. */
int Screenmode_Set(enum screenmode mode);

#endif

