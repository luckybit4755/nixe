#!/bin/bash	

_m2_soup_main() {
	local in="m2_cp.txt"
	local out="m2_soup.txt"

	m2_cp.sh

	if [ "${in}" -nt "${out}" ] ; then
		echo ${out} is older than ${in}... rebuilding ${out}
		cat m2_cp.txt | tr ':' '\n'  | grep jar | while read j ; do 
			jar tf ${j}  2>/dev/null
		done > m2_soup.txt
	else
		echo ${out} is newer than ${in}... remove ${out} to rebuild it
	fi
}

_m2_soup_main ${*}
