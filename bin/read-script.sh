#!/bin/bash	
	
_read_script_main() {
	if [ ! -f "${1}" ] ; then
		echo 'need a script to read..'
		return
	fi

	local dir=audio-$(ts.sh)
	mkdir -p ${dir} || return ${?}

	local n=0
	#cat script.md |\

	grep -v '^$' ${1} |\
	while read line ; do
		echo ----------------------------------------------------------
		local filename=${dir}/$(printf "audio-%03d\n" ${n})-$(echo ${line} | text-to-filename.js | cut -f1-5 -d-).wav
		let n=${n}+1
		echo "generating ${line} to ${filename}"
		echo ${line} | piper-text-to-speech.js | tee f | base64 -d > ${filename}
	done

}

_read_script_main ${*}
