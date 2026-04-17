#!/bin/bash	
##############################################################################
#
# https://towardsdatascience.com/installing-multiple-cuda-cudnn-versions-in-ubuntu-fcb6aa5194e2
# https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-ubuntu-22-04
# https://docs.nvidia.com/deploy/xid-errors/index.html#topic_3_2
# https://forum.manjaro.org/t/nvidia-drivers-boot-into-black-screen-after-upgrade-on-desktop-system-with-intel-igpu/112146/49 <-- idk...
# 
# other useful commands:
# % sudo ubuntu-drivers autoinstall
# % nvtop
#
# log mess
# % egrep 'NVRM|nvidia' /var/log/syslog
# % sudo dmesg | grep nvidia 
# % ( cat /var/log/syslog ; sudo dmesg ) | grep nvidia
#
# punt: sudo apt-get purge *nvidia* && sudo apt update && sudo apt -y upgrade && sudo ubuntu-drivers autoinstall && sudo apt install -y nvidia-cuda-toolkit && sudo reboot 
#
# lunt: sudo apt-get purge *nvidia* && sudo apt -y update && sudo apt -y upgrade && sudo apt -y install nvidia-driver-510 nvidia-utils-510 && sudo apt install -y nvidia-cuda-toolkit && sudo reboot
#
# meinherz:diffusers[17:15:26]: sudo apt install -y nvidia-cuda-toolkit

#
# sudo ubuntu-drivers autoinstall && sudo apt install -y nvidia-cuda-toolkit && nvidia-smi
#


# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu
#
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
# sudo apt-get install cuda-11.8
# sudo dpkg -i cuda-keyring_1.0-1_all.deb
# sudo apt-get install cuda-11.8
#
#
#

#### The following packages were automatically installed and are no longer required:
####   libgdk-pixbuf-xlib-2.0-0 libgdk-pixbuf2.0-0 libnvidia-cfg1-515 libnvidia-common-515 libnvidia-egl-wayland1 libnvidia-extra-515
####   libnvidia-fbc1-515 libnvidia-fbc1-515:i386 libnvidia-gl-515 libnvidia-gl-515:i386 libxnvctrl0 nvidia-kernel-source-515
####   nvidia-prime nvidia-settings screen-resolution-extra xserver-xorg-video-nvidia-515
#### Use 'sudo apt autoremove' to remove them.
#### The following additional packages will be installed:
####   libcuinj64-11.5 libnvidia-compute-495 libnvidia-compute-510 libnvidia-ml-dev nvidia-cuda-dev nvidia-cuda-gdb
####   nvidia-cuda-toolkit-doc nvidia-profiler nvidia-visual-profiler
#### Recommended packages:
####   libnvcuvid1 nsight-compute nsight-systems
#### The following packages will be REMOVED:
####   libnvidia-compute-515 libnvidia-compute-515:i386 libnvidia-decode-515 libnvidia-decode-515:i386 libnvidia-encode-515
####   libnvidia-encode-515:i386 nvidia-compute-utils-515 nvidia-driver-515 nvidia-utils-515
#### The following NEW packages will be installed:
####   libcuinj64-11.5 libnvidia-compute-495 libnvidia-compute-510 libnvidia-ml-dev nvidia-cuda-dev nvidia-cuda-gdb
####   nvidia-cuda-toolkit nvidia-cuda-toolkit-doc nvidia-profiler nvidia-visual-profiler
#### 0 upgraded, 10 newly installed, 9 to remove and 47 not upgraded.
#
#
# internet rando:I upgraded both nvidia-kernel-common and nvidia-kernel-source to 515:
# sudo apt-get install nvidia-kernel-common-515
# sudo apt-get install nvidia-kernel-source-515
# sudo apt-get -y install cuda 
# worked for me afterwards. Hope this works for someone as well.
#
##############################################################################

_nvidia_info_main() {
	# this is a lot of spew
	echo sudo lshw -C display
	sudo lshw -C display | awk '
		$1 == "*-display" { ON = 1; next }
		$1 ~ /\*-[a-z]*/ { ON = 0; next }
		{if(0)print}
		ON && /(product|vendor|configuration|resources|info)/ { print }
	'
	echo ----------------------------------------------------------
	echo dmesg about nvidia
	sudo dmesg |g -i nvidia
	echo ----------------------------------------------------------

	echo nvidia devices: $( ls -lthr /dev/nvidia* 2>/dev/null | xargs )

	echo kernel modules loaded
	echo lsmod \| grep -i nv
	lsmod | grep -i nv
	echo ---

	# this is not very useful
	#echo sudo ubuntu-drivers devices
	#sudo ubuntu-drivers devices
	#echo ---

	echo nvidia-detector 
	nvidia-detector  -h
	echo ---

	echo update kernel modules
	sudo nvidia-modprobe -u
	echo ---

	echo kernel modules
	dkms status
	echo ---

	echo ----------------------------------------------------------

	echo drivers:
	grep . /proc/driver/nvidia/version /sys/module/nvidia/version | sed 's,:,:\t,'
	echo ---

	echo nvidia-compute deb version
	dpkg -l |g nvidia-compute
	echo ----------------------------------------------------------

	echo all you need to know:
	echo nvidia-smi
	nvidia-smi

	echo ----------------------------------------------------------
	echo try python:
	echo -e 'import pycuda.driver as cuda\ncuda.init()\nprint("there are", cuda.Device.count(), "cuda devices found")' | python

}

_nvidia_info_main ${*}
