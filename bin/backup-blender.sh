#!/bin/bash	

export ME=$(which ${0})
export ME_BASE=$(basename ${0} | sed 's,\.sh$,,')

export SOURCES="txt data/blender data/project/godot src/lbl src/me src/lbl src/nursery etc data/phone"
export TARGET="${HOME}/cloud/backups"

export RSYNC="rsync -a \
	--no-links \
	--exclude cruft/ \
	--exclude snit/ \
	--exclude node_modules/
"

_backup_blender_main() {
	if [ ! -d ${TARGET} ] ; then
		_backup_blender_fatal "no backup directory ${TARGET}"
	fi

	cd ${HOME}

	local src
	for src in ${SOURCES} ; do
		src=${HOME}/${src}
		if [ ! -d ${src} ] ; then
			_backup_blender_warn "cannot find ${src}, skipping"
			continue
		fi
		local base=$(basename ${src})

		target=${TARGET}/${base}
		mkdir -p ${target}
		if [ 0 != ${?} ] ; then
			_backup_blender_error "could not create ${target}"
			continue
		fi

		_backup_blender_info "sync to ${target}"

		cd ${src} 
		if [ 0 != ${?} ] ; then
			_backup_blender_error "could not change to ${src}"
			continue
		fi

		${RSYNC} . ${target}	
		if [ 0 != ${?} ] ; then
			_backup_blender_error "rsync errors for ${src}"
			continue
		fi
	done

	#rsync -av --exclude='*/trash/' --exclude='*/junk/' /source/directory/ /destination/directory/

#	cd ~/data/blender ; rsync -av $(ls | egrep -v '(snit|crust)') ~/cloud/blender
}

_backup_blender_no_snit_rysnc() {
	find . -type d -maxdepth 2| egrep '/(snit|cruft|node_modules)$'
	find . -type d -maxdepth 2 \
	| egrep "${JUNK}" \
	| sed 's,^,--exclude,'
}

_backup_blender_info()  {  _backup_blender_out INFO ${*}; }
_backup_blender_warn()  { _backup_blender_out WARN ${*}; }
_backup_blender_error() { _backup_blender_out ERROR ${*}; }
_backup_blender_fatal() { _backup_blender_out FATAL ${*}; exit 1 ; }
_backup_blender_out() { date +"%Y-%m-%d_%H-%M-%S ${ME_BASE} ${*}"; }

_backup_blender_main ${*}
