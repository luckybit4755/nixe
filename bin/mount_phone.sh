#!/bin/bash	

_mount_phone_main() {
	killall kiod5
	cd 
	jmtpfs tmp/mtp && ls -lathr tmp/mtp || echo derp
}

_mount_phone_main ${*}
