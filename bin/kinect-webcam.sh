#!/bin/bash	
# https://github.com/xxorde/librekinect

_kinect_webcam_main() {
	echo options gspca_kinect depth_mode=1 | sudo tee /etc/modprobe.d/kinect-depth.conf
	sudo rmmod gspca_kinect
	sudo modprobe gspca_kinect depth_mode=1 || return 1

	mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 30
}

_kinect_webcam_main ${*}
