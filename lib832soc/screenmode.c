#include <hw/vga.h>

#include <hw/screenmode.h>

#include <stdio.h>

struct screenmode_timings {
	short hsize;
	short hsstart;
	short hsstop;
	short htotal;
	short vsize;
	short vsstart;
	short vsstop;
	short vtotal;
	int pixelclock;
};

static struct screenmode_timings timings[SCREENMODE_MAX]=
{
	{ 640, 656, 752, 800, 480, 500, 502, 525, VGA_HSYNC_NEG|VGA_VSYNC_NEG|5},
	{ 768, 792, 872, 976, 576, 577, 580, 597, VGA_HSYNC_NEG|VGA_VSYNC_POS|3},
	{ 800, 824, 896,1024, 600, 601, 603, 625, VGA_HSYNC_POS|VGA_VSYNC_POS|3},
	{ 800, 856, 976,1040, 600, 637, 643, 666, VGA_HSYNC_POS|VGA_VSYNC_POS|2},
	{1024,1048,1184,1328, 768, 771, 777, 806, VGA_HSYNC_NEG|VGA_VSYNC_NEG|1},
	{1280,1312,1504,1600, 480, 500, 502, 525, VGA_HSYNC_NEG|VGA_VSYNC_NEG|2},
	{1280,1390,1430,1650, 720, 725, 730, 750, VGA_HSYNC_POS|VGA_VSYNC_POS|1},
	{1920,2008,2052,2200,1080,1084,1089,1125, VGA_HSYNC_POS|VGA_VSYNC_POS|1},
	{1920,2448,2492,2640,1080,1084,1089,1125, VGA_HSYNC_POS|VGA_VSYNC_POS|1}
};

int Screenmode_GetWidth(enum screenmode mode)
{
	if(mode>=0 && mode<SCREENMODE_MAX)
		return(timings[mode].hsize);
	return(0);
}

int Screenmode_GetHeight(enum screenmode mode)
{
	if(mode>=0 && mode<SCREENMODE_MAX)
		return(timings[mode].vsize);
	return(0);
}

int Screenmode_Set(enum screenmode mode)
{
	if(mode>=0 && mode<SCREENMODE_MAX)
	{
		HW_VGA(REG_VGA_HTOTAL)=timings[mode].htotal;
		HW_VGA(REG_VGA_HSIZE)=timings[mode].hsize;
		HW_VGA(REG_VGA_HSSTART)=timings[mode].hsstart;
		HW_VGA(REG_VGA_HSSTOP)=timings[mode].hsstop;
		HW_VGA(REG_VGA_VTOTAL)=timings[mode].vtotal;
		HW_VGA(REG_VGA_VSIZE)=timings[mode].vsize;
		HW_VGA(REG_VGA_VSSTART)=timings[mode].vsstart;
		HW_VGA(REG_VGA_VSSTOP)=timings[mode].vsstop;
		HW_VGA(REG_VGA_PIXELCLOCK)=timings[mode].pixelclock;
		return(1);
	}
	else
		return(0);
}

