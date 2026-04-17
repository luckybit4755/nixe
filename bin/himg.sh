#!/bin/bash	

_himg_main() {
	local h=${HOME}/tmp/.himg.html
	fullpath ${*} | egrep -v '\.import$' | image_html.sh > ${h} || return ${?}
	firefox ${h}
}

fullpath () {
    local f;
    for f in $*; do
        ( ( cd ${f} 2> /dev/null && echo ${PWD} ) || ( cd $(dirname ${f} ) 2> /dev/null && echo ${PWD}/$( basename ${f} ) ) );
    done
}


_himg_main ${*}
