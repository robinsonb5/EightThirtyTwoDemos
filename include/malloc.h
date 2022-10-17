#ifndef MALLOC_H
#define MALLOC_H

/*
 * malloc.h
 *
 * Internals for the memory allocator
 */

// #include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

void *malloc(size_t);
void *malloc_high(size_t);
void *malloc_aligned(size_t size,int alignment);
void *calloc(int nmemb,size_t size);
void free(void *m);
int availmem();

void malloc_dump(int count);

#ifdef __cplusplus
}
#endif

#endif
