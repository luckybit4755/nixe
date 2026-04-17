#!/bin/bash	

_uname_main() {
	for file in ${*} ; do
		local ext=$( echo "${file}" | sed 's,.*\.\([^.]*\)$,\1,' )
		local uname=u-$( uuidgen ).${ext}
		mv -i "${file}" ${uname}
	done
}

_uname_main ${*}
