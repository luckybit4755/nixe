#!/bin/bash	
	
_questo_main() {
	local to=${1-192.168.0.129:5555}
	local ip=${to/:*/}
	local port=${to/*:/}
	
	printf "%33s\nLet's_try_to_hook_you_up,_home_slice\n%33s\n" "" "" \
	| sed 's, ,--,g;s,_, ,'

	_questo_runo adb shell ip route || return ${?}
	_questo_runo adb tcpip ${port}  || return ${?}
	_questo_runo adb connect ${to}  || return ${?}
	#echo adb shell pm list packages -f -i || echo boo
}

_questo_runo() {
	local command="${*}"

	${command} && return 0
	local boo=${?}
	echo "FAIL PATROL: ${command}"
	return ${?}

	
}

_questo_main ${*}
