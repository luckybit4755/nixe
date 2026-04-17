#!/bin/bash	
	
_run_vnc_main() {
	xrandr --listactivemonitors

	xrandr --listactivemonitors\
	|awk -- 'BEGIN { getline } { gsub(/\/[[:digit:]]+/,"",$3) ; print $3 }'\
	|grep 3840\
	|while read GEOMETRY ; do
		echo x11vnc -clip ${GEOMETRY} -rfbauth ~/.vnc/passwd -scale 2000x1200 -ncache 10
		x11vnc -clip ${GEOMETRY} -rfbauth ~/.vnc/passwd -scale 2000x1200 -ncache 10
		#x11vnc -clip ${GEOMETRY} -rfbauth ~/.vnc/passwd -scale .5 -ncache 10
		break
	done


	return
	killall Xtightvnc 2> /dev/null
	rm -f /tmp/.X1-lock /tmp/.X2-lock /tmp/.X3-lock /tmp/.X4-lock /tmp/.X5-lock /tmp/.X11-unix/X1 /tmp/.X11-unix/X2 /tmp/.X11-unix/X3 /tmp/.X11-unix/X4 /tmp/.X11-unix/X5

	vncserver -geometry 1200x900 && (sleep 1 ; tail -f ~/.vnc/*.log)
}

_run_vnc_main ${*}
