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
		*(.text.*)
		*(.rodata)
		*(.rodata.*)
		*(.data)
		. = ALIGN(4);
		__ctors_start__ = . ;
		KEEP(*(SORT(.ctors)))
		KEEP(*(SORT(.ctors.*)))
		__ctors_end__ = . ;
		. = ALIGN(4);
		__dtors_start__ = . ;
		KEEP(*(SORT(.dtors)))
		KEEP(*(SORT(.dtors.*)))
		__dtors_end__ = . ;
	} >mem

	.bss : {
		__bss_start__ = . ;
		*(.bss)
		*(.bss.*)
	  	__bss_end__ = . ;
	} >mem
	.=ALIGN(4);
	STACKTOP = . + 0x2000;
	__end = . + 0x2000;

	/DISCARD/ : {
		*(.eh_frame)
		*(.gnu.build-id)
	} 
}

