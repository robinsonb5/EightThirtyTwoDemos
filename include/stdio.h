#ifndef STDIO_H
#define STDIO_H

#include <hw/uart.h>
#include "printf.h"
#include "minfat.h"

typedef fileTYPE FILE;
#define stdin 0
#define stdout 1
#define stderr 2
#define EOF (-1)

int fgetc(FILE *f);

#endif

