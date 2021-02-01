#include <stdio.h>

#define HW_MUTEX(x) *((volatile unsigned int *)(0xfffffff0+x))
#define REG_MUTEX 0
#define REG_CPUID 4

int main(int argc,char **argv)
{
	int m;
	while(m=HW_MUTEX(REG_MUTEX))
		;
	printf("Hello from thread %d\n",1+2*HW_MUTEX(REG_CPUID));
	HW_MUTEX(REG_MUTEX)=0;
	return(0);
}


int thread2main(int argc,char **argv)
{
	int m;
	while(m=HW_MUTEX(REG_MUTEX))
		;
	printf("Hello from thread %d\n",2+2*HW_MUTEX(REG_CPUID));
	HW_MUTEX(REG_MUTEX)=0;
	return(0);
}

