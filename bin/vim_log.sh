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

random_emoji() {
    #"(\__/)"
    emojis=(
        "(ᵔᴥᵔ)"
        "V•ᴥ•V"
        "(っ◕‿◕)っ"
        "ʕ·ᴥ·ʔ"
		"╰•‿•╯"
		"(^_^)"
		"(∩^o^)⊃━☆ﾟ.*"
		"(o˘◡˘o)"
		"(づ｡◕‿‿◕｡)づ"
		"(≧∀≦)"
		"(◕‿◕✿)"
		"(^‿^)"
		"(´･ω･\`)"
		"(づ￣ ³￣)づ"
		"(◕‿◕✿)"
		"✿◡‿◡"
		"(◕દ◕)"
		"(●'◡'●)シ ︎"
		"૮₍ ´• ˕ • ₎ა"
		"( ˘ ³˘)♥︎"
		"(• ◡•)" 
		"(❍ᴥ❍ʋ)"
		"(｡◕‿‿◕｡)"
		"(o˘◡˘o)"
		"(∩^o^)⊃━☆ﾟ.*"
		"ˁ(⦿ᨎ⦿)ˀ"
		" Ƹ̵̡Ӝ̵̨̄Ʒ"
    )

    # Get the number of emojis in the array
    num_emojis=${#emojis[@]}

    # Generate a random index between 0 and num_emojis-1
    random_index=$((RANDOM % num_emojis))

    # Return the randomly selected emoji
    echo "${emojis[random_index]}"
}


# no main to maintain the ${*} as much as possible...
export KEY=$( uuidgen 2>/dev/null || echo r${RANDOM}-${RANDOM}-${RANDOM}-${RANDOM} )
export FULL=$( _vim_log_fullpath ${*} )
export VIM_TMI=${VIM_TMI-$(random_emoji)}

args=""
for arg in ${*} ; do
	if [ -f ${arg} ] ; then
		arg="${arg}"
	else
		if [[ ${arg} = *: ]] ; then
			file=$( echo ${arg} | cut -d: -f1)
			line=$( echo ${arg} | cut -d: -f2)
			arg="${file} +${line}"
		fi
	fi
	args="${args} ${arg}"
done

_vim_log_entry start
vim ${args}
_vim_log_entry stop
_vim_log_set_title $(random_emoji)
