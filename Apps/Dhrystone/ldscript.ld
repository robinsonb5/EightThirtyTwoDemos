MEMORY
{
   mem : ORIGIN = 0x10000000, LENGTH = 0x000fdfff
}

SECTIONS
{
	. = 0x0;
	_start = .;

	.text.startup :
	{
		KEEP(*(.text.startup)) /* Seed section, allows use of --gc-sections */
	} >mem

	.code : {
	  *(.text)
	  *(.rodata)
	  *(.rodata.*)
	  *(.data)
	} >mem

	.bss : {
		__bss_start__ = . ;
	  *(.bss)
	  *(.bss.*)
	  	__bss_end__ = . ;
	} >mem
	.=ALIGN(4);
	STACKTOP = . + 0x2000;

	/DISCARD/ : {
	  *(.eh_frame)
	  *(.gnu.build-id)
	} 
}

