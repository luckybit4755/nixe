#!/bin/bash	

_m2_cp_cleaner() {
	sed 's,<[^>]*>,,g;s,.*\[,,;s/\].*//g;s/, */@/g' | tr '@' '\n'
}

_m2_cp_main() {
	local in="pom.xml"
	local out="m2_cp.txt"
		
	local no_test="-Dmaven.test.skip=true"
	if [ "-test" == "${1}" ] ; then
		no_test=""
	fi

	if [ "${in}" -nt "${out}" ] ; then
		echo ${out} is older than ${in}... rebuilding ${out}
		local tmp="/tmp/m2_cp.tmp.${USER}.${$}.${RANDOM}.tmp"
		mvn -X test ${no_test} 2>&1 > ${tmp}
		grep -w classpathElements ${tmp} | _m2_cp_cleaner | sort -u | xargs | tr ' ' ':' > ${out}
		rm -f ${tmp}
	else
		echo ${out} is newer than ${in}... remove ${out} to rebuild it
	fi

}

_m2_cp_main ${*}
