//	appstart.S
//	Copyright 2021 by Alastair M. Robinson

//	This file is part of Lib832.

//	Lib832 is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser General Public License as
//	published by the Free Software Foundation, either version 3 of
//	the License, or (at your option) any later version.

//	Lib832 is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser General Public License for more details.

//	You should have received a copy of the GNU Lesser General Public License
//	along with lib832.  If not, see <https://www.gnu.org/licenses/>.


// Startup code for lib832 loadable apps.

	.section .text.startup

_start:
	.int	0x38333242	// ID
	.ref	__reloctable__
	.ref	__bss_end__
	.ref	STACKSIZE
	.ref	_premain
	.int	0

	.global _premain
_premain:
	stdec r6
	.lipcrel _main
	add	r7
	ldinc r6
	mr	r7

