#!/bin/bash	


# from https://unix.stackexchange.com/questions/12578/list-packages-on-an-apt-based-system-by-installation-date
_installed_debs_main() {
	for x in $(ls -1t /var/log/dpkg.log*); do zcat -f $x |tac |grep -e " install " -e " upgrade "; done |awk -F ":a" '{print $1 " :a" $2}' |column -t|less -Si
}

_installed_debs_main ${*}
