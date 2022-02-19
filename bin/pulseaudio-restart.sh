#!/bin/bash	

_pulseaudio_restart_main() {
	killall pavucontrol
	systemctl --user restart pulseaudio && sleep 3 && pavucontrol &
}

_pulseaudio_restart_main ${*}
