#!/bin/bash	

_twitter_ffmpeg_main() {
	if [ $# != 1 ] ; then
		echo 'usage: twitter_ffmpeg.sh <video>'
		return 1
	fi

	local out="video-$( date +'%Y.%m.%d.%H.%M.%S' ).mp4"
	ffmpeg -i ${1} -r 30 -c:v libx264 -b:v 1M -vf scale=640:-1 ${out}
	ls ${PWD}/${out}
}

_twitter_ffmpeg_main ${*}
