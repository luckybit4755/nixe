#!/bin/bash	
# source me!

export BAD_ANACONDA=${HOME}/funk/fuck-anaconda3
export ANACONDA=${HOME}/funk/anaconda3

_grossly_enable_conda_main() {
	if [ -h ${ANACONDA} ] ; then
		echo disabling it again...
		rm ${ANACONDA}
		return
	else
		ln -s ${BAD_ANACONDA} ${ANACONDA}
	fi



#export PATH="${ANACONDA/bin}:${PATH}"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('${ANACONDA}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${ANACONDA}/etc/profile.d/conda.sh" ]; then
        . "${ANACONDA}/etc/profile.d/conda.sh"
    else
        export PATH="${ANACONDA}/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
}

_grossly_enable_conda_main ${*}
