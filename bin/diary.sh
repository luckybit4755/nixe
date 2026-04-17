#!/bin/bash	

export DOW=(Mon Tues Wednes Thurs Fri)
export DICT="${HOME}/.vim/moar-complete.txt"
	
_diary_main() {
	local dir=${1} ; shift
	local action=${1-journal} ; shift
	local time=${1-tbd} ; shift
	local whom=${1-team} ; shift
	time=$(echo ${time} | tr ':' '-')

	mkdir -p ${dir} || return ${?}

	_diary_usage ${dir}|| return 0
	_diary_vim_dict ${dir}

	local days=($(last-monday.js))
	local first=${days[0]}
	local last=${days[4]}
	local og=${dir}
	dir=${dir}/week-${first}_to_${last}

	_diary_setup ${first} ${last} ${dir} || return ${?}

	case ${action} in
		#meet*) _diary_meeting ${dir} ${time} ${whom} ;;
		week|summary|sum) _diary_summary ${dir} ${time} ;;
		retro) find $(ls -d ${og}/* | sort -n | tail -2) -name 'summary*' | xargs cat ;; 
		*) _diary_journal ${dir} ${action} ;;
	esac
}

_diary_usage() {
	local dir=${1} ; shift
	local f=$(echo ${dir} | cut -c1)
	if [ "" = "${dir}" ] || [ "-" = "${f}" ] ; then
		echo "usage: diary.sh <directory>"
		return 1
	fi
}

_diary_setup() {
	local first=${1} ; shift
	local last=${1} ; shift
	local dir=${1} ; shift
	local days=($(last-monday.js)) # can't pass arrays

	export VIM=$(echo ${VISUAL} ${EDITOR} | cut -f1 -d' ')
	if [ "" = "${VIM}" ] ; then
		export VIM="vim"
	fi

	echo "This week is from ${first} to ${last}: ${dir}"
	#mkdir -p ${dir}/meetings || return 1
	mkdir -p ${dir} || return 1

	_diary_currently ${dir}

	local week=${dir}/week-${first}_to_${last}.md
	# "week" sauce:if [ ! -f ${week} ] ; then
	# "week" sauce:	echo "- Creating ${week}"
	# "week" sauce:	_diary_create_week ${first} ${last} > ${week}
	# "week" sauce:fi

	local i=0
	local day
	for day in ${days[@]} ; do
		local dow=${DOW[${i}]}day
		let i=${i}+1
		local wod=$(echo ${dow} | tr '[A-Z]' '[a-z]' )

		local file=${dir}/diary-${day}-${wod}.md
		if [ -f ${file} ] ; then
			continue
		fi
		echo "- Creating ${file}"

		_diary_create ${dow} ${day} ${first} ${last} >  ${file}
	done
}

_diary_currently() {
	local dir=${1} ; shift
	#cd ${dir}
	if [ -h current ] ; then
		local target=$(file current | sed 's,.* ,,')
		if [ "${target}" == "${dir}" ] ; then
			cd -
			return 
		fi
		rm current
	fi
	if [ ! -h current ] ; then
		ln -s ${dir} current
	fi
	#cd -
}

_diary_vim_dict() {
	local dir=${1} ; shift

	find ${dir} -type f \
	| egrep '\.(md|sql|txt)$' \
	| egrep -vw '(nope|snit|crap|cruft|bak|backup)' \
	| xargs egrep -iho '[a-z]*[a-z0-9_]+' \
	| awk '{if(length($0)>2)print}' \
	| sort -u  \
	> ${DICT}
}

_diary_edit() {
	local file=${1} ; shift
	echo "Editing ${file}"
	echo ${VIM} ${file}
	${VIM} ${file}
}

_diary_journal() {
	local dir=${1} ; shift
	local action=${1} ; shift

	if [ "" = "${action}" ] || [ "journal" = "${action}" ] ; then
		local today=$(date +"${dir}/diary-%Y-%m-%d-%A.md" | tr '[A-Z]' '[a-z]')
		_diary_edit ${today}
		return ${?}
	fi

	local maybe
	for maybe in "${dir}/diary-*${action}*.md" "${dir}/${action}*.md" ; do
		if [ -f ${maybe} ] ; then
			_diary_edit ${maybe}
			return ${?}
		fi
	done

	echo "Not sure what to do with ${action}"
	return 1
}

_diary_meeting() {
	local dir=${1} ; shift
	local time=${1} ; shift
	local whom=${1} ; shift
	local meeting=$(date +"${dir}/meetings/meetings-%Y-%m-%d-%A-${time}" | tr '[A-Z]' '[a-z]')"-${whom}.md"
	_diary_edit ${meeting}
}

_diary_summary() {
	local dir=${1} ; shift
	local time=${1} ; shift
	local week=${dir}/summary-$(basename ${dir}).md

	if [ -f ${week} ] ; then
		echo -n "Overwrite ${week} [y/N]? "
		read r
		if [ "y" != "${r}" ] ; then
			echo "Good call..."
			return
		fi
		echo "It's clobberin' time!"
	fi

	_diary_summary_generate ${dir} | tee ${week}

	echo "Wrote summary to ${week}"
}

_diary_summary_generate() {
	local dir=${1} ; shift
	local week=$(basename ${dir}| cut -f2- -d- | tr _ ' ')
		
	echo "# Weekly summary for ${week}"

	ls ${dir}/*.md \
	| grep -v summary \
	| sort \
	| xargs awk '/^# Summary/ {ON=1} /^# Standup / {ON=0} ON{print}' \
	| egrep -v '(Tomorrow.s Yesterday:|------|^$)' \
	| sed 's,^# Summ.*,\n#&,' 
}

_diary_log_set_title() {
    echo -e "\033]0;" ${*} "\007";
}

_diary_create() {
	local dow=${1} ; shift
	local day=${1} ; shift
	local first=${1} ; shift
	local last=${1} ; shift
	local desc="${day} : ${dow}"
cat << DIARY
-----------------------------------------------------------------------
# Standup : ${desc}
-----------------------------------------------------------------------

Yesterday:
- c/p here

Today:
- get 
- some

-----------------------------------------------------------------------
# Notes : ${desc}
-----------------------------------------------------------------------

WW!

-----------------------------------------------------------------------
# Summary : ${desc}
-----------------------------------------------------------------------

Tomorrow's Yesterday:
-
-

-----------------------------------------------------------------------
DIARY

# Work Log : ${desc}
## Standup : ${desc}
## Progress : ${desc}
## Discussion : ${desc}

}

_tmi_diary_create() {
	local dow=${1} ; shift
	local day=${1} ; shift
	local first=${1} ; shift
	local last=${1} ; shift
	local desc="${day} : ${dow}"
cat << DIARY
# Work Log : ${desc}

## Goals : ${desc}

1. enjoy
2. your
3. life

## Standup : ${desc}

## Progress : ${desc}

## Notes : ${desc}

DIARY
}

_diary_create_week() {
	local first=${1} ; shift
	local last=${1} ; shift
cat << DIARY
# Work Log: for the week of ${first} to ${last}

## Goals: week ${first} to ${last}

1. enjoy
2. your
3. life

## Summary: week ${first} to ${last}

1. each 
2. week
3. passes
DIARY
}


_diary_main ${*}
