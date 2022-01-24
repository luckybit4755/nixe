#!/bin/bash	
# https://askubuntu.com/questions/648603/how-to-create-an-animated-gif-from-mp4-video-via-command-line

_mp4_to_gif_main() {
	for mp4 in ${*} ; do
		local gif=$( echo ${mp4} | sed 's,\.[a-z0-9][a-z0-9]*$,.gif,' )
		ffmpeg -i ${mp4} -r 15 ${gif} || break
		ls ${PWD}/${gif}
  done
  #-vf scale=512:-1 \
  #-ss 00:00:03 -to 00:00:06 \
}

_mp4_to_gif_main ${*}
