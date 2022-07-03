#ifndef VGA_H
#define VGA_H

/* Hardware registers for the ZPU MiniSOC VGA demo project.
   Based on the similar TG68MiniSOC project, but with
   changes to suit the ZPU's archicture */

#define VGABASE 0xFFFFFE00

#define FRAMEBUFFERPTR 0x0
#define PIXELFORMAT 0x4

#define SP0PTR 0x10
#define SP0XPOS 0x14
#define SP0YPOS 0x18


#define PIXELFORMAT_RGB16 0
#define PIXELFORMAT_RGB32 1

#define HW_VGA(x) *(volatile unsigned long *)(VGABASE+x)

#define VGA_INT_VBLANK 1 /* Not currently implemented */

#endif

