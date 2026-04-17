#!/bin/bash	
# https://trac.ffmpeg.org/wiki/Slideshow

#

#In your ffmpeg command, you are creating a video by piping a series of PNG images as input. By default, ffmpeg does not loop the input images, so the resulting video won't loop either. To make the video loop, you need to add the "-stream_loop" option to ffmpeg. Here's the modified command:
#
#bash
#
#cat *.png | ffmpeg -f image2pipe -framerate ${framerate} -i - -stream_loop -1 -c:v libx264 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" noice.mp4
#
#Explanation:
#
#	-stream_loop -1: This option tells ffmpeg to loop the input indefinitely. The value "-1" means it will loop forever. If you want a specific number of loops, you can replace "-1" with the desired number of loops.
#
#	-c:v libx264 -pix_fmt yuv420p: These options specify the video codec (libx264) and pixel format (yuv420p) for the output video. This is a common setup for H.264-encoded videos with good compatibility.
#
#	-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2": This option is an optional video filter that ensures the video dimensions are even numbers. Some video codecs require even dimensions. If your input images have even dimensions, you can skip this option.
#
#With these modifications, your resulting video "noice.mp4" should loop indefinitely, playing the sequence of PNG images in a loop. Remember to replace $

_png2_mp4_main() {
	local framerate=${FRAMERATE-24}
	local mp4=movie-$(date +"%Y.%m.%d-%H.%M.%S").mp4
	
		
#mp4=movie-$(date +"%Y.%m.%d-%H.%M.%S").gif

	local xtra='-stream_loop -1 -c:v libx264 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"'
	xtra='-stream_loop -1 -pix_fmt yuv420p'
	xtra="-loop 0"

#	       -stream_loop number (input)
#           Set number of times input stream shall be looped. Loop 0 means no loop, loop -1 means infinite loop.
	xtra="-stream_loop -1"
	xtra="" 


	cat ${*} | ffmpeg ${xtra} -f image2pipe -framerate ${framerate} -i - ${mp4} || return ${?}
	#cat ${*} | ffmpeg -f image2pipe -framerate ${framerate} -i - ${mp4} || return ${?}
	ls -lh ${PWD}/${mp4}
}

_png2_mp4_main ${*}
