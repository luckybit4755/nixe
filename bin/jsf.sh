#!/bin/bash	

_jsf_main() {
	sed 's,    ,\t,g;s,\t,\\t,g;s,$,\\n,' | tr -d '\n'
	echo
}

_jsf_main ${*}
