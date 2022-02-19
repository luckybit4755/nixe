#!/bin/bash	

_old_sdd_main() {
	sudo mount /dev/sda1 /media/vgvm/ubu20
}

_old_sdd_main ${*}
