#!/bin/bash	
	
_kde_bg_main() {
	local file=$(_fullpath ${1})

	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    var allDesktops = desktops();
    print (allDesktops);
    for (i=0;i<allDesktops.length;i++) {{
        d = allDesktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
        d.writeConfig("Image", "file://'${file}'")
    }}
'
}

_fullpath () {
    cd $( dirname ${1} ) 2> /dev/null \
    && echo ${PWD}/$( basename ${1} )
}


_kde_bg_main ${*}
