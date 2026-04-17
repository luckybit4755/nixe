#!/bin/bash	

_flatten_directory_main() {
	if [ ${#} -lt 2 ] ; then
		echo "usage: flatten <input directory> [.. <input directory>] <output directory>"
		return 1
	fi

	local inputs=$( echo ${*} | rev | cut -f2- -d' '| rev )
	local output=$( echo ${*} | rev | cut -f1 -d' '| rev )
	mkdir -p fu

	find ${inputs} -type f | while read file ; do
		local out=${output}/$( echo ${file} | cut -f2- -d/ | sed 's,/,--,g' | sed 's,[^a-zA-Z0-9_.\-],_,g' )
		if [ -f ${out} ] ; then
			echo "already flattened ${file}"
			continue
		fi
		cp "${file}" ${out}
		echo "flattened ${file} to ${out}"
	done
}

_flatten_directory_main ${*}
