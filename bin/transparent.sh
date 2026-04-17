#!/bin/bash	

_transparent_main() {
	local filename=${1} ; shift
	local color=${1-white} ; shift
	local percent=${1-2} ; shift
	
	if [ ! -f "${filename}" ] ; then
		echo "usage: transparent.sh <filename> [color:white] [percent:2]"
		exit
	fi
	
	convert ${filename} -fuzz ${percent}% -transparent "${color}" transparent-${filename}
}

_transparent_main ${*}
