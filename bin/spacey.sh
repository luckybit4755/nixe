#!/bin/bash	

_spacey_main() {
	ls ${*} | while read file ; do
		local space=$( echo ${file} | sed 's,[^a-zA-Z0-9_.\-],_,g' )
		if [ "${file}" != "${space}" ] ; then
			mv -i "${file}" ${space}
		fi
	done
}

_spacey_main ${*}
