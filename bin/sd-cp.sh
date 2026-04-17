#!/bin/bash	

_sd_cp_main() {
	#http://127.0.0.1:7860/file=/mnt/old-sec/vgvm/models/stable-diffusion-webui-redux/outputs/img2img-images/2023-07-31/00052-1033809436.png?1690849471.471678
	for u in ${*} ; do
		f=$( echo ${u} | sed 's,.*file=,,;s,?.*,,' )
		#echo ${u} to ${f}
		b=$(basename ${f})
		cp -i ${f} sd-${b} || continue
		ls -l sd-${b}
	done

}

_sd_cp_main ${*}
