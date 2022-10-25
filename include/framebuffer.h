#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H

char *Framebuffer_Allocate(int width, int height, int depth);
void Framebuffer_Free(char *framebuffer);
void Framebuffer_Set(char *framebuffer,int bits);

#endif

