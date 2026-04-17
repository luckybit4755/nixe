#!/bin/bash	

_kenshi_main() {
	cd ${HOME}/.steam/debian-installation/steamapps/common/Kenshi
	export WINEPATH="${HOME}/.steam/debian-installation/steamapps/compatdata/233860/pfx/drive_c/windows/system32"
	wine ./kenshi_x64.exe ${*}
}

_kenshi_main ${*}
