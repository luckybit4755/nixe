#!/bin/bash	

_yed_main() {
	java -jar /home/vgvm/funk/yed-3.20.1/yed.jar ${*} &
}

_yed_main ${*}
