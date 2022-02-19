#!/bin/bash	

_mount_phone_main() {
	cd 
	jmtpfs tmp/mtp
}

_mount_phone_main ${*}
