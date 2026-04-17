#!/bin/bash	
	
_firey_main() {
	local ip=${1} ; shift

	local isIp=$(echo ${ip} | egrep -c '^([0-9]+\.){3}[0-9]+$')
	echo hi ${#} and also ${1}

	echo the ip is ${ip} and the want ${*} access
	if [ 1 != ${isIp} ] || [ 0 = ${#} ] ; then
		_firey_usage
	fi

	for port in ${*} ; do
		ufw allow from ${ip} to any port ${port} || exit ${?}
	done

	ufw reload && ufw enable && ufw status && echo nice...
}

_firey_usage() {
	echo "usage: firey.sh <ip> <port> [port]"
	exit 1
} 

_firey_main ${*}
