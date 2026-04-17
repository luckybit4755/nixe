#!/bin/bash	

_bach_main() {
	mkdir -p bach_up
	local filename=${1} ; shift
	local key=$( echo ${*} | tr ' ' '-' );

	cp -i ${filename} bach_up/${filename}++${key}
}

_bach_main ${*}
