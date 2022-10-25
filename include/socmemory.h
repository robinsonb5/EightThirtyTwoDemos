#ifndef SOCMEMORY_H
#define SOCMEMORY_H

#include <memorypool.h>

#define SOCMEMORY_BANK0 1
#define SOCMEMORY_BANK1 2
#define SOCMEMORY_BANK2 4
#define SOCMEMORY_BANK3 8

struct MemoryPool *SoCMemory_GetPool();

#endif

