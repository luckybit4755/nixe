#!/bin/bash	

_nvidia_rmmoder_main() {
	sudo rmmod nvidia_drm
	sudo rmmod nvidia
	sudo rmmod nvidia_uvm
	sudo rmmod nvidia_modeset
	sudo rmmod nvidia_uvm
	sudo rmmod nvidia
	sudo rmmod nvidia_modeset
}

_nvidia_rmmoder_main ${*}
