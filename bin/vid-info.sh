#!/bin/bash	

_vid_info_main() {
	local file

	echo ------

	for file in ${*} ; do
		echo ${file}
		 ffprobe -v error -show_entries stream=width,height,bit_rate,duration,avg_frame_rate,-count_frames -of default=noprint_wrappers=1 ${file}
		ls -lh ${file}
		echo ------
	done

# ffprobe -show_format -v error -select_streams v:0 -of default=nw=1:nk=1 input.mp4
#ffprobe -show_format -v error -select_streams v:0 -of default=nw=1:nk=1 -show_entries stream=width,height,duration,avg_frame_rate,-count_frames -format compact ${file}
#ffprobe -show_format -v error -select_streams v:0 -of default=nw=1:nk=1 -format compact ${file}
#ffprobe -v error -show_entries stream=width,height,bit_rate,duration,avg_frame_rate,-count_frames -of default=noprint_wrappers=1 ${file}

}

_vid_info_main ${*}
