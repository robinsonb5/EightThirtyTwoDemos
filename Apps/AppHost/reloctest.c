#include <stdio.h>

char message[]="Hello, world\n";
struct reloctest
{
	char *msg;
	struct reloctest *self;
};

struct reloctest rtest=
{
	message,
	&rtest
};


int main(int argv,char**argv)
{
	printf("Message: %s\n",message);
	printf("Struct is at: %x\n",(int)&rtest);
	printf("Message read from struct is: %s\n",rtest.msg);
	printf("Struct.self is: %x\n",(int)rtest.self);
	return(0);
}

