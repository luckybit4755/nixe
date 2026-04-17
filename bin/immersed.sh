#!/bin/bash


# /etc/X11/XvMCConfig : add libvdpau_nvidia.so
# idk...

	
_immersed_main() {
	while true ; do
		echo ----------------------------------------------------------------------------
		date +"%Y.%m.%d.%H.%M.%S"
		~/funk/Immersed-x86_64.AppImage
		if [ -f /tmp/fi ] ; then
			echo bye
			break
		fi
		sleep 3
	done
}

_immersed_main ${*}
