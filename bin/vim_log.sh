#!/bin/bash	

export VIM_LOG=${HOME}/.vim_log.txt

_vim_log_set_title() {
	echo -e "\033]0;" ${*} "\007"; 
}

_vim_log_title() {
	_vim_log_set_title vim $( basename ${*} 2>/dev/null )
}

_vim_log_timestamp() {
	date +"%Y.%m.%d.%H.%M.%S"
}

_vim_log_fullpath() {
    for f in $*; do
        ( ( cd ${f} 2> /dev/null && echo ${PWD} ) || ( cd $(dirname ${f} ) 2> /dev/null && echo ${PWD}/$( basename ${f} ) ) )
    done
}

_vim_log_entry() {
	local action=${1} 
	echo -e "${KEY}\t${HOSTNAME}\t$( _vim_log_timestamp )\tstart\t"${FULL} >> ${VIM_LOG}
	if [ "start" = "${action}" ] ; then
		_vim_log_title ${FULL}
	else
		_vim_log_title ${PWD}
	fi
}


# no main to maintain the ${*} as much as possible...
export KEY=$( uuidgen 2>/dev/null || echo r${RANDOM}-${RANDOM}-${RANDOM}-${RANDOM} )
export FULL=$( _vim_log_fullpath ${*} )

_vim_log_entry start
vim ${*}
_vim_log_entry stop


#echo -e "${key}\t${HOSTNAME}\t$( _vim_log_timestamp )\tstart\t"${*} >> ${VIM_LOG}
#_vim_log_set_title vim $( basename ${*} 2>/dev/null )
#
#vim ${*}
#
#echo -e "${key}\t${HOSTNAME}\t$( _vim_log_timestamp )\tstop\t"${*}  >> ${VIM_LOG}
#_vim_log_set_title $( basename ${PWD} 2>/dev/null )
