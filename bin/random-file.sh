#!/bin/bash	
	
_random_file_main() {
	local directory=${1-.} 

	ls ${directory}/* \
	| awk -v seed=$(date +%s) 'BEGIN{srand(seed)} {print rand() " " $1}' \
	| sort -n \
	| head -1 \
	| sed 's,.* ,,'
}

_random_file_main ${*}
