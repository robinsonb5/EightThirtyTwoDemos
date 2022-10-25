#include <stddef.h>
#include <stdio.h>

#include <hw/vga.h>

#include <framebuffer.h>
#include <socmemory.h>

char *Framebuffer_Allocate(int width, int height, int depth)
{
	struct MemoryPool *pool=SoCMemory_GetPool();
	size_t bytesperrow=(width*depth+7)/7;
	size_t size=height*bytesperrow;
	char *result=0;
	if(pool)
		result=pool->AllocAligned(pool,size,32,0,SOCMEMORY_BANK0); /* 32 bytes alignment from any bank other than zero */
	return(result);
}

void Framebuffer_Free(char *framebuffer)
{
	struct MemoryPool *pool=SoCMemory_GetPool();
	if(pool)
		pool->Free(pool,framebuffer);
}

void Framebuffer_Set(char *framebuffer,int bits)
{
	HW_VGA(FRAMEBUFFERPTR) = (int)framebuffer;
	switch(bits)
	{
		case 32:
			HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB32;
			break;
		case 16:
			HW_VGA(PIXELFORMAT) = PIXELFORMAT_RGB16;
			break;
		case 8:
			HW_VGA(PIXELFORMAT) = PIXELFORMAT_CLUT8BIT;
			break;
		case 4:
			HW_VGA(PIXELFORMAT) = PIXELFORMAT_CLUT4BIT;
			break;
		case 1:
			HW_VGA(PIXELFORMAT) = PIXELFORMAT_MONO;
			break;
		default:
			printf("Error: Bad bit depth\n");
			break;
	}
}

