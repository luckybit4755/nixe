#!/bin/bash	

# white or yellow
export COLOR=${COLOR-white}
	
_lul_letters_main() {
	_lul_letters_input ${*} | _lul_letters_filter
}

_lul_letters_input() {
	if [ 0 = ${#} ] ; then
		cat 
	else
		echo ${*}
	fi
}

_lul_letters_filter() {
	tr '[A-Z]' '[a-z]' | sed "s,[a-z],:alphabet-${COLOR}-&:,g;s, ,     ,g;s,!,:grey-exclamation:,g;s,?,:grey_question:,"
}

_lul_letters_main ${*}
