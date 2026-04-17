alias hawt='pwd > ~/.hawt ; rm -f ~/hot ; ln -s ${PWD} ~/hot'

hawt_oder_nawt() {
	if [ ! -f ~/.hawt ] ; then
		echo 'need to run "hawt" first in some directory'
		return 1
	fi

	local hawtness=$(cat ~/.hawt)
	if [ ! -d ${hawtness} ] ; then
		echo "Cannot find the directory ${hawtness}, maybe you are a loser?"
		return 2
	fi
}

hawtness() {
	hawt_oder_nawt || return ${?}
	local hawtness=$(cat ~/.hawt)
	cd ${hawtness}
}

gawt() {
	hawt_oder_nawt || return ${?}
	local hawtness=$(cat ~/.hawt)

	if [ ${#} = 0 ] ; then
		echo "Gee, what to copy? What to copy? No seriously... what do you want to copy to ${hawtness}?"
		return 3
	fi

	echo "${hawtness} gets all the  ${*}"
	cp -i ${*} ${hawtness}
}

