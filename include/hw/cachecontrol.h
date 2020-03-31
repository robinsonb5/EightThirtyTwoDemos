#ifndef CACHECONTROL_H
#define CACHECONTROL_H

#define CACHEBASE 0xffffffb4
#define HW_CACHE(x) *(volatile unsigned int *)(CACHEBASE+x)

// Cache control register
// Write a '1' to the low bit to flush caches

#define REG_CACHE_CTRL 0x0
#define FLUSHCACHES (HW_CACHE(0)=1)

#endif

