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

/*
 * This structure should be a power of two.  This becomes the
 * alignment unit.
 */
struct free_arena_header;

struct arena_header {
	int type;
	size_t size;
	struct free_arena_header *next, *prev;
};

#ifdef DEBUG_MALLOC
#define ARENA_TYPE_USED 0x64e69c70
#define ARENA_TYPE_FREE 0x012d610a
#define ARENA_TYPE_HEAD 0x971676b5
#define ARENA_TYPE_DEAD 0xeeeeeeee
#else
#define ARENA_TYPE_USED 0
#define ARENA_TYPE_FREE 1
#define ARENA_TYPE_HEAD 2
#endif

#define MALLOC_CHUNK_MASK 511

#define ARENA_SIZE_MASK (~(sizeof(struct arena_header)-1))

/*
 * This structure should be no more than twice the size of the
 * previous structure.
 */
struct free_arena_header {
	struct arena_header a;
	struct free_arena_header *next_free, *prev_free;
};

// extern char heap_low, heap_top;	// Take the addresses of these.

void malloc_add(void *p,size_t size);

void *malloc(size_t);
void *calloc(int nmemb,size_t size);
void free(void *m);
int availmem();

void malloc_dump();

#ifdef __cplusplus
}
#endif

#endif
