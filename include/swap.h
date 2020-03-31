#ifndef SWAP_H
#define SWAP_H

#ifdef __cplusplus
extern "C" {
#endif

unsigned int ConvBBBB_LE(unsigned int i);
unsigned int ConvBB_LE(unsigned int i);
unsigned int ConvWW_LE(unsigned int i);

unsigned int ConvBBBB_BE(unsigned int i);
unsigned int ConvBB_BE(unsigned int i);
unsigned int ConvWW_BE(unsigned int i);

#ifdef __cplusplus
}
#endif

#endif

