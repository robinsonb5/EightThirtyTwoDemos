#ifndef _STACKTOP
int __attribute__((section(".bss.stack"))) _STACKBASE[_STACKSIZE/4];
#endif

extern int __bss_start;
extern int __bss_end;
extern int __ctors_start__;
extern int __ctors_end__;
extern int __dtors_start__;
extern int __dtors_end__;

extern int main(int argc, char **argv);

void __attribute__ ((weak)) exit (int status)  
{
	while(1)
		;	// Spin for eternity
}


void __attribute__ ((weak)) _premain()  
{
	int t;
	int *ctors;

// Clear BSS data

	int *bss=&__bss_start;
	while(bss<&__bss_end)
		*bss++=0;

//  Run global constructors...
	ctors=&__ctors_end__;  // Reverse order for priorities
	while(ctors>&__ctors_start__)
	{
		void (*fp)();
		fp=(void (*)())(*--ctors);
		fp();
	}

	t=main(0, 0);
//  Run global destructors...  normal order, destruct in opposite order to construction
	ctors=&__dtors_start__;
	while(ctors<&__dtors_end__)
	{
		void (*fp)();
		fp=(void (*)())(*ctors++);
		fp();
	}
	exit(t);
}


