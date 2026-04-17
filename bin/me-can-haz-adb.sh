#!/bin/bash	
	
_me_can_haz_adb_main() {

	adb shell ip route || return ${?}
	adb tcpip 5555 || return ${?}
	adb connect 192.168.0.129:5555 || return ${?}
	adb shell ls /storage/emulated/0/Documents || return ${?}
	echo k

}

_me_can_haz_adb_main ${*}
