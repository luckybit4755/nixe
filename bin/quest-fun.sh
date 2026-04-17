#!/bin/bash	
	
_quest-fun_main() {

	# list installed packages
	adb shell pm list packages -f | awk -F "==" '/^package:\/data\/app\// && !/com.(meta|facebook|oculus)/ {p=$2; sub(/-.*/,"",p); print p}'
}

_quest-fun_main ${*}
