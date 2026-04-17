#!/bin/bash	

_temperature_main() {
	local csv="/home/vgvm/src/nursery/wetter8/wetter8.csv"

	date --date=@$(tail -1 ${csv} | sed 's/.*,//')

	tail -8 ${csv} \
	| cut -f1,4 -d, \
	| sed 's/^1,/front /;s/^2,/garage /;s/^3,/basement /;s/^4,/freezer /;s/^5,/pool /;s/^6,/deck /;s/^7,/stairs /;s/^8,/under /;' \
	| sort -n -k+2,2 \
	| column -t 
}

_temperature_main ${*}
