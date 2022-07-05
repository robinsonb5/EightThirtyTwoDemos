#!/bin/bash

cat $1 | while read a; do
	b=${a,,}
	if [ "${b: -4}" = ".rom" ]; then
		echo -n "$2/${a%.rom}_word.vhd "
	fi
	if [ "${b: -4}" = ".vhd" ]; then
		echo -n "$2/${a} "
	fi
	if [ "${b: -2}" = ".v" ]; then
		echo -n "$2/${a} "
	fi
	if [ "${b: -3}" = ".vh" ]; then
		echo -n "$2/${a} "
	fi
	if [ "${b: -3}" = ".sv" ]; then
		echo -n "$2/${a} "
	fi
	if [ "${b: -4}" = ".svh" ]; then
		echo -n "$2/${a} "
	fi
	if [ "${b: -4}" = ".qip" ]; then
		bash ../../../Scripts/expandtemplate_dep.sh $2/${a%.qip}.files $2/$(dirname $a)
	fi
done

