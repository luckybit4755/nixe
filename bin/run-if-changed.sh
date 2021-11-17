#!/bin/bash	

_run_if_changed_main() {
	local file
	local command

	case ${#} in
		1) echo wtf? ; file=${1} ; command=${file} ; echo fuck ;;
		2) file=${1} ; shift ; command=${*} ;;
		*) _run_if_changed_usage ; return 33
	esac

	local stamp=33 #$( _run_if_changed_stamp ${file} )

	echo "watching ${file} to see if ${stamp} changes..."

	while true ; do 
		local nu=$( _run_if_changed_stamp ${file} )
		if [ "${nu}" = "${stamp}" ] ; then
			echo that is boring >/dev/null
		else 
			stamp=${nu}
			clear;
			echo what a thrill "${command}: ${nu}"
			${command} 2>&1 | tee /tmp/rif-${USER}.txt
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
