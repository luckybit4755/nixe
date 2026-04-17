#!/bin/bash	

_kde_desktop_restart_main() {
	kquitapp5 plasmashell && kstart5 --window 0 plasmashell
		
	# kstart5 plasmashell
	# sudo systemctl restart display-manager.service
}

_kde_desktop_restart_main ${*}
