#!/bin/bash	
	
_run_obs_main() {
	#flatpak run com.obsproject.Studio --config ~/.config/obs-studio
	obs
}

_run_obs_main ${*}
