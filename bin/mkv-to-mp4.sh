#!/bin/bash	
	
_mkv-to-mp4_main() {
	echo iou... ffmpeg -stream_loop 10 -i rh-sneak-0001-0037.mkv -c:v libx264 -crf 23 -preset veryfast -c:a aac -b:a 128k -shortest rh-sneak-0001-0037.mp4
}

_mkv-to-mp4_main ${*}
