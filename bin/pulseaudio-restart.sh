#!/bin/bash	

_pulseaudio_restart_main() {
	#killall pavucontrol
	sudo alsa force-reload
	systemctl --user restart pulseaudio && echo ww # && sleep 3 && pavucontrol &
}

_pulseaudio_restart_main ${*}
