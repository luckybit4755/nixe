#!/bin/bash	

_spacey_main() {
	ls ${*} | grep ' ' | while read file ; do
		local space=$( echo ${file} | tr '[ ()]' '[_\-]' )
		if [ "${line}" != "${space}" ] ; then
			mv -i "${file}" ${space}
		fi
	done
}

_spacey_main ${*}
