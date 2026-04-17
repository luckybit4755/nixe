#!/bin/bash	



_p1p2_main() {
	local p1="${1}" ; shift
	local p2="${1}" ; shift

	echo "showing last '${p1}' for '${p2}' in ${*}" >/dev/stderr

	awk -v P1="${p1}" -v P2="${p2}" ' 
		BEGIN {
			M = "ERROR"
		}
		$0 ~ P1 {
			M = $0;
			next;
		}
		$0 ~ P2 {
			printf( "%s -> %s\n", $0, M );
			M = "ERROR"
		}
	' ${*}
}

p1="${1}" ; shift
p2="${1}" ; shift
_p1p2_main "${p1}" "${p2}" ${*}
