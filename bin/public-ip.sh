#!/bin/bash	

_public_ip_main() {
	local history="${HOME}/.public_ip.log"
	touch ${history}

	local last=$( tail -1 ${history} | cut -f2 -d' ' )
	local current=$( _public_ip_lookup )

	if [ "${last}" = "${current}" ] ; then
		date +"%Y_%m_%d+%H_%M_%S still ${current}"
	else
		date +"%Y_%m_%d+%H_%M_%S ${current}" | tee -a ${history}
		echo -e "From: ${USER}@localhost\nSubject: ip change\n\nIp is now ${current}" \
		| sendmail luckybit@duck.com
		#| sendmail luckybit4755@gmail.com
	fi
}

_public_ip_lookup() {
	nslookup myip.opendns.com. resolver1.opendns.com \
	| awk '/^Address:/{A=$NF}END{print A}'
}

_public_ip_main ${*} 2>&1 >> ${HOME}/.public_ip.out
