#!/bin/bash	

_m2_salad_main() {
	local in="m2_soup.txt"
	local out="m2_salad.txt"
	local cp="m2_cp.txt"

	m2_soup.sh

	if [ "${in}" -nt "${out}" ] ; then
		echo ${out} is older than ${in}... rebuilding ${out}
		grep class$ ${in} \
		| cut -f1 -d. \
		| tr '[$/]' . \
		| xargs javap -classpath $( cat ${cp} )  \
		> ${out}
	else 
		echo ${out} is newer than ${in}... remove ${out} to rebuild it
	fi

}

_m2_salad_main ${*}
