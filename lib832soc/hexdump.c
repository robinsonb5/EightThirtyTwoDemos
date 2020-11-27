
#include <hw/uart.h>

static char string[18];

void hexdump(unsigned char *p,unsigned int l)
{
	int i=0;
	unsigned char *p2=(unsigned int *)p;
	char *sp;
	string[16]=0;
	sp=string;
	while(l--)
	{
		int t,t2;
		t=*p2++;
		t2=t>>4;
		t2+='0'; if(t2>'9') t2+='@'-'9';
		putchar(t2);
		t2=t&0xf;
		t2+='0'; if(t2>'9') t2+='@'-'9';
		putchar(t2);

		if(t<32 || (t>127 && t<160))
			*sp++='.';
		else
			*sp++=t;
		++i;
		if((i&3)==0)
			putchar(' ');
		if((i&15)==0)
		{
			puts(string);
			putchar('\n');
			sp=string;
		}
	}
	if(i&15)
	{
		*sp++=0;
		puts(string);
		putchar('\n');
	}
}


