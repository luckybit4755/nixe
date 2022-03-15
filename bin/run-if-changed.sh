#!/bin/bash	

_run_if_changed_main() {
	local file
	local command

	case ${#} in
		0) _run_if_changed_usage ; return 33 ;;
		1) file=${1} ; command=${file} ;;
		*) file=${1} ; shift ; command=${*} ;;
	esac

	local stamp=33 #$( _run_if_changed_stamp ${file} )

	echo "watching ${file} at ${stamp}, run: ${command}"

	while true ; do 
		local nu=$( _run_if_changed_stamp ${file} )
		if [ "${nu}" = "${stamp}" ] ; then
			echo that is boring >/dev/null
		else 
			stamp=${nu}

			clear
			echo "updated ${file} to ${stamp}, run: ${command}"
			time ${command} 2>&1 | tee /tmp/rif-${USER}.txt
			echo "ran"
		fi
		sleep 1
	done
	
}

_run_if_changed_usage() {
	echo "usage:run-if-changed.sh <file-to-watch> [command-to-run-if-not-the-same-file]"
}

_run_if_changed_stamp() {
	date -r ${1}
}

_run_if_changed_main ${*}
