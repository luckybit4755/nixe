#!/bin/bash	
	
_phone_sync_main() {
	mount_phone.sh || return ${?}
	rsync -av /home/vgvm/tmp/mtp/SD\ card/DCIM/Camera /home/vgvm/data/phone
}

_phone_sync_main ${*}
