#!/bin/bash	
#############################################################################
#
# https://linoxide.com/linux-how-to/how-to-install-nvidia-driver-on-ubuntu/
#
# apt -y install hwinfo
#
#
#
# version will vary: sudo apt install nvidia-utils-455 
# $ sudo nvidia-settings
#
#############################################################################

export VIDEO_VENDOR="nvidia"

_ubuntu_info_main() {
	local info
	for info in video ; do
		_ubuntu_info_line		
		echo ${info} | tr '[a-z]' '[A-Z]' | sed 's,.,& ,g'
		_ubuntu_info_line		
		_ubuntu_info_${info}
	done
	_ubuntu_info_line		
}

_ubuntu_info_video() {
	hwinfo  --gfxcard --short
	prime-select query 
	lshw -c display | grep -i ${VIDEO_VENDOR}
	lspci -nnk | grep -iA3 vga
	lspci | grep -i --color 'vga\|3d\|2d'

	inxi -Gx

	nvidia-smi
}

_ubuntu_info_line() {
	echo -----------------------------------------------------------------------------
}

_ubuntu_info_main ${*}
