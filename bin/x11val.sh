#!/bin/bash	

# troubleshoot this shit:
# journalctl -b -e | grep Xorg ;echo ww ;  cat ~/.xsession-errors

_x11val_main() {
	xrandr --dpi 96
	startx -- -dpi
	#startx 
	
	#-dpi 96
}

_x11val_main ${*}
