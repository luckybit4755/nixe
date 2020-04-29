#!/bin/bash	

export VIM_LOG=${HOME}/.vim_log.txt

_vim_log_set_title() {
	echo -e "\033]0;" ${*} "\007"; 
}

_vim_log_timestamp() {
	date +"%Y.%m.%d.%H.%M.%S"
}

# no main to maintain the ${*} as much as possible...
key=$( uuidgen )
echo -e "${key}\t${HOSTNAME}\t$( _vim_log_timestamp )\tstart\t"${*} >> ${VIM_LOG}
_vim_log_set_title vim $( basename ${*} 2>/dev/null )
vim ${*}
echo -e "${key}\t${HOSTNAME}\t$( _vim_log_timestamp )\tstop\t"${*}  >> ${VIM_LOG}
_vim_log_set_title $( basename ${PWD} 2>/dev/null )
