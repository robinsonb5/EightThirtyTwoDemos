#!/bin/bash

cat $1 | while read a; do
	b=${a,,}
	if [ "${b: -4}" = ".rom" ]; then
		echo "\"[file normalize \"$2/${a%.rom}_word.vhd\"]\"\\"
	fi
	if [ "${b: -4}" = ".vhd" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -4}" = ".ucf" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -2}" = ".v" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -3}" = ".vh" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -3}" = ".sv" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -4}" = ".svh" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -4}" = ".xci" ]; then
		echo "\"[file normalize \"$2/${a}\"]\"\\"
	fi
	if [ "${b: -4}" = ".qip" ]; then
		bash ../../../Scripts/expandtemplate_vivado.sh $2/${a%.qip}.files $2/$(dirname $a)
	fi
done

