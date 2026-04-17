#!/bin/bash	

_unreal_main() {
	cd /mnt/old-sec/vgvm/apps/unreal/Engine/Binaries/Linux || return ${?}
	./UnrealEditor &
}

_unreal_main ${*}
