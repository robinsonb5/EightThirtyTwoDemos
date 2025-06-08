#!/bin/bash

cat $1 | while read a; do
	b=${a,,}
	if [ "${b: -4}" = ".rom" ]; then
		echo "add_file \"[file normalize \"$2/${a%.rom}_word.vhd\"]\""
	fi
	if [ "${b: -4}" = ".vhd" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -4}" = ".ucf" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -2}" = ".v" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -3}" = ".vh" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -3}" = ".sv" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -4}" = ".svh" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -4}" = ".xci" ]; then
		echo "add_file \"[file normalize \"$2/${a}\"]\""
	fi
	if [ "${b: -4}" = ".qip" ]; then
		bash ../../../Scripts/expandtemplate_gowin.sh $2/${a%.qip}.files $2/$(dirname $a)
	fi
done

