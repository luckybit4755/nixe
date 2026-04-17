#!/bin/bash	
	
_apk_adb_install_main() {
	local apk=${1} ; shift
	if [ ! -f "${apk}" ] ; then
		echo "usage: apk-adb-install.sh <file.apk>"
		return
	fi

	adb connect 192.168.0.129:5555 || _apk_adb_install_info
	adb install -r -d ${apk} || _apk_adb_install_info
}

_apk_adb_install_info() {
cat << EOM

adb shell ip route
adb tcpip 5555
adb connect 192.168.0.129:5555

#adb shell pm list packages -f -i

EOM
}

_apk_adb_install_main ${*}
