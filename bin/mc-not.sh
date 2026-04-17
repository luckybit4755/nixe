#!/bin/bash	

_mc_not_main() {
	if [ "-l" = "${1}" ] ; then
		_mc_not_listen
	else
		_mc_not_send ${*}
	fi
}
		
_mc_not_listen() {
	echo "listening for ${HOSTNAME}"
	socat - UDP4-RECVFROM:12345,ip-add-membership=239.255.0.1:0.0.0.0,fork \
	| while read r ; do
		echo "go: ${r}"
		notify-send "${r}"
	done
 	#| grep -w "${HOSTNAME}" \
}
	
_mc_not_send() {
	if [ 0 = ${#} ] ; then
		socat - UDP-DATAGRAM:239.255.0.1:12345,broadcast
	else 
		echo "${*}" | socat - UDP-DATAGRAM:239.255.0.1:12345,broadcast
	fi
}

_mc_not_main ${*}
