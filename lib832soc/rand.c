/* Simulation time:
--stop-time=5ms
*/

/*  Written in 2019 by David Blackman and Sebastiano Vigna (vigna@acm.org)

To the extent possible under law, the author has dedicated all copyright
and related and neighboring rights to this software to the public domain
worldwide. This software is distributed without any warranty.

See <http://creativecommons.org/publicdomain/zero/1.0/>. */

/* This is xoshiro128++ 1.0, one of our 32-bit all-purpose, rock-solid
   generators. It has excellent speed, a state size (128 bits) that is
   large enough for mild parallelism, and it passes all tests we are aware
   of.

   For generating just single-precision (i.e., 32-bit) floating-point
   numbers, xoshiro128+ is even faster.

   The state must be seeded so that it is not everywhere zero. */

/* Adapted slightly for lib832soc by AMR */

#include <stdio.h>
#include <sys/types.h>

static uint32_t s[4]={
	0x08320832,
	0x1a2b3c4d,
	0x56789abc,
	0xfedcba98
};

static inline uint32_t rotl(const uint32_t x, int k) {
	return (x << k) | (x >> (32 - k));
}


// uint32_t next(void) {
int rand() {
	uint32_t result = rotl(s[0] + s[3], 7) + s[0];

	uint32_t t = s[1] << 9;

	s[2] ^= s[0];
	s[3] ^= s[1];
	s[1] ^= s[2];
	s[0] ^= s[3];

	s[2] ^= t;

	s[3] = rotl(s[3], 11);

	return (int)result;
}

void srand(int seed)
{
	s[0] = (uint32_t)seed;
}

