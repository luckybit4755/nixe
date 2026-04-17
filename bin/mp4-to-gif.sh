#!/bin/bash	
# https://askubuntu.com/questions/648603/how-to-create-an-animated-gif-from-mp4-video-via-command-line

# ffmpeg -i rh-sneak-0001-0037.mkv -vf "fps=10,scale=320:-1:flags=lanczos,palettegen" palette.png
# ffmpeg -i rh-sneak-0001-0037.mkv -i palette.png -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" -loop 0 rh-sneak-0001-0037.gif

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
