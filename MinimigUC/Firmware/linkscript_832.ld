MEMORY
{
   mem : ORIGIN = 0x0, LENGTH = 0x0010000
}
SECTIONS
{
	. = 0x0;
	_start = .;
	.startup : {
	  KEEP(*(.text.startup))
	} >mem

	.code : {
	  *(.text.*)
	  *(.rodata)
	  *(.rodata.*)
	  *(.data)
	} >mem
	_romend=.;
	.bss : {
		__bss_start__ = . ;
	  *(.bss)
	  	__bss_end__ = . ;
	} >mem
	/DISCARD/ : {
	  *(.eh_frame)
	  *(.gnu.build-id)
	  *(.note.gnu.build-id)
	} 
	_prg_start = 0x2000;
}

