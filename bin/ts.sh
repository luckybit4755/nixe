#!/bin/bash	

_ts_main() {
	date +"${*}%Y-%m-%d_%H-%M-%S" ; return

	local d="/usr/share/dict/words"
	local c=$( egrep -c '^[a-z]+$' ${d})

	local n
	let n=${RANDOM}%${c}
	local word=$( egrep '^[a-z]+$' ${d} | head -${n} | tail -1 )
	date +"${*}%Y-%m-%d+%H-%M-%S+${word}"
}

_ts_main ${*}
