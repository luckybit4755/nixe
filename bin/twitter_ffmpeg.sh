#!/bin/bash	

_twitter_ffmpeg_main() {
	local video=${1} ; shift
	if [ "" = "${video}" ] || [ "-h" = "${video}" ] ; then 
		echo 'usage: twitter_ffmpeg.sh <video>'
		return 1
	fi
	if [ ! -f ${video} ] ; then
		echo "file not found: ${video}"
		return 2
	fi

	local out="video-$( date +'%Y.%m.%d.%H.%M.%S' ).mp4"

	local out=$(basename ${video} | sed 's,\.[^.]*$,-twitted.mp4,')
	if [ "${out}" = "${video}" ] ; then
		echo "what kind of name is ${video}?"
		return 3
	fi
	if [ -f ${out} ] ; then
		echo "file already exists, you turnip."
		rm -i ${out} || return 4
	fi

	ffmpeg -i ${video} -r 30 -c:v libx264 -b:v 1M -vf scale=640:-1 ${out} || return ${?}

	ls -l ${video} ${out}
}

_twitter_ffmpeg_main ${*}
