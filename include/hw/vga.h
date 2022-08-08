#ifndef VGA_H
#define VGA_H

/* Hardware registers for the ZPU MiniSOC VGA demo project.
   Based on the similar TG68MiniSOC project, but with
   changes to suit the ZPU's archicture */

#define VGABASE 0xFFFFFE00

#define FRAMEBUFFERPTR 0x0
#define PIXELFORMAT 0x4

#define REG_VGA_PIXELCLOCK 0x08

#define REG_VGA_HTOTAL 0x10
#define REG_VGA_HSIZE 0x14
#define REG_VGA_HSSTART 0x18
#define REG_VGA_HSSTOP 0x1c

#define REG_VGA_VTOTAL 0x20
#define REG_VGA_VSIZE 0x24
#define REG_VGA_VSSTART 0x28
#define REG_VGA_VSSTOP 0x2c

#define REG_VGA_SP0PTR 0x80
#define REG_VGA_SP0XPOS 0x84
#define REG_VGA_SP0YPOS 0x88
#define REG_VGA_SP0WORDS 0x8c
#define REG_VGA_SP0WIDTH 0x90

#define VGA_HSYNC_POS (1<<30)
#define VGA_HSYNC_NEG 0
#define VGA_VSYNC_POS (1<<31)
#define VGA_VSYNC_NEG 0

#define PIXELFORMAT_RGB16 0
#define PIXELFORMAT_RGB32 1
#define PIXELFORMAT_MONO 2
#define PIXELFORMAT_CLUT4BIT 3
#define PIXELFORMAT_CLUT8BIT 4

#define HW_VGA(x) *(volatile unsigned long *)(VGABASE+x)

#define VGA_INT_VBLANK 1 /* Not currently implemented */

#endif

