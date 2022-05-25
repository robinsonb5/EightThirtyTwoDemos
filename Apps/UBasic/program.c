#include "ubasic.h"
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

#include "hw/uart.h"

#define MAX_PROGRAM_LENGTH    32768
#define xprint(x) printf("%s",x);

int readline(char *buf,int len)
{
	int cr=0;
	int i=0;
	while(!cr)
	{
		int c=HW_UART(REG_UART);
		if(c&(1<<REG_UART_RXINT))
		{
			c&=0xff;
			if(c==13) // Enter
				cr=1;
			else if(c==8) // Backspace
				--i;
			else if (c!=10)
				buf[i++]=c;
			if(i<0)
				i=0;
			if(i>=len-1)
				i=len-2;		
		}
	}
	buf[i]=0;
	return (i);
}

int main(int argc,char **argv)
{
    char *program = (char *)malloc(MAX_PROGRAM_LENGTH);
    char *p = program;
    size_t program_length = 0;
    if (!program) {
        xprint("Out of memory\n");
        exit(1);
    }

    for (;;) {
        char s[256];
        size_t len = readline(s, sizeof(s));

        xprint("OK\n");

        if (program_length + len >= MAX_PROGRAM_LENGTH - 2) {
            xprint("Not enough memory");
        } else {
            if (len == 3 && s[0] == 'r' && s[1] == 'u' && s[2] == 'n') {
                *p = '\0';

                ubasic_init(program);
                
                do {
                    ubasic_run();
                } while(!ubasic_finished());

                p = program;
                program_length = 0;
            } else if (len > 0) {
                // append the line
                char *s2 = s;
                for (s2 = s; *s2; ++s2) {
                    *p = *s2;
                    p++; program_length++; 
                }
                *p = '\n';
                p++; program_length++;
            }
        }
    }

    free(program);
    exit(0);
}
