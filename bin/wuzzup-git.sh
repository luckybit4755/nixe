#!/bin/bash	

# seems like sometimes this is "main" and not "master", which is nice..
export MAIN=${MAIN-main}
	
export LINE="-----------------------------------------------------------------------------"

_wuzzup_git_main() {
	if [ 0 = ${#} ] ; then
		_wuzzup_git_status
		return ${?}
	fi

	local args=(${*})
	for ((i=0;i<${#};i++)) ; do
		local arg=${args[${i}]}
		case "${arg}" in
			-h|-help|--help)
				_wuzzup_git_usage
				return
				;;
			-clone-branch|-cloneb|-cb)
				let n=${i}+2
				if [ ${n} -ge ${#} ] ; then 
					_wuzzup_git_usage cb
					return
				fi
				let i=${i}+1 ; local repo=${args[${i}]}
				let i=${i}+1 ; local branch=${args[${i}]}
				_wuzzup_git_clone_branch ${repo} ${branch}
				;;
			-newtask|-new-task|-nt)
				let n=${i}+2
				#let n=${i}+3
				if [ ${n} -ge ${#} ] ; then 
					_wuzzup_git_usage nt
					return
				fi
				let i=${i}+1 ; local repo=${args[${i}]}
				#let i=${i}+1 ; local ticket=${args[${i}]}
				let i=${i}+1 ; local name=${args[${i}]}
				#_wuzzup_git_new_task ${repo} ${ticket} ${name}
				_wuzzup_git_new_task ${repo} ${name}
				;;
			-lmod) _wuzzup_git_modified 1 ;;
			-mod)  _wuzzup_git_modified 0 ;;
			-push-back|-push|-pb) _wuzzup_git_push_back ;;
			-remote) 
				let n=${i}+1
				if [ ${n} -ge ${#} ] ; then 
					_wuzzup_git_usage pb
					return
				fi
				let i=${i}+1 ; local name=${args[${i}]}
				_wuzzup_git_add_remote ${name} 
				;;
			*) _wuzzup_git_file_to_url ${arg}
		esac
	done
}

#############################################################################

_wuzzup_git_usage() {
	local suboptions=${*-cb nt pb remote}

	_wuzzup_git_preamble

	local suboptions
	for suboption in ${suboptions} ; do
		echo
		_wuzzup_git_usage_${suboption}
	done
}

_wuzzup_git_preamble() {
cat << EOM
usage: wuzzup-git.sh [file]
without args gives status of cwd

With filename or directories as arguments, it attempts to create a url

Fancy actions:
EOM
}

_wuzzup_git_usage_cb() {
cat << EOM
  -cb
  -cloneb
  -clone-branch <REPO> <BRANCH>   
  clone remote branch to local directory named after the branch
EOM
}

_wuzzup_git_usage_nt() {
cat << EOM
  -nt
  -newtask
  -new-task <REPO> <TICKET> <NAME> 
  clone repository, create a local branch from origin/${MAIN}, and a corresponding remote branch
  <TICKET> should be like the JIRA ID (XXX-1234)
  <NAME>   should be short like: super-cool-thing-u-love
EOM
}

_wuzzup_git_usage_pb() {
cat << EOM
  -pb
  -push
  -push-back
  push the local branch changes to the remote branch on the origin 
  the script prompts to verify before pushing
EOM
}

_wuzzup_git_usage_remote() {
cat << EOM
  -remote <NAME>
  looks at the git reference for your current origin and replace your name with the <NAME>
  ie: wuzzup-git.sh -remote funcollc ; the name it adds removes 'llc' from the end...
  the script prompts to verify before adding the remote
EOM
}

#############################################################################

_wuzzup_git_status() {
	echo ${LINE}

	_wuzzup_git_file_to_url . | sed 's,\.$,,'
	local name=$( basename ${PWD} | cut -f1 -d_ )
	local prefix=$( echo ${name} | cut -f1 -d- )

	git shortlog -sn \
	| awk '
		NR<=5{
			n=$1; sub(/^ *[0-9]+[ \t]*/,"");
			printf("%s %s(%d)", 1 == NR ? "authors:" : ",",  $0, n );
		} 
		END {print ""}
	'

	echo ${LINE}

	echo Branches:
	git branch -vv 
	echo ${LINE}

	echo Remotes:
	git remote -v | _wuzzup_git_columns
	echo ${LINE}

	git status | head -1
	echo ${LINE}
}

_wuzzup_git_file_to_url() {
	local arg=${1}
	local branch=$( git status | head -1 | sed 's,.* ,,' )
	local url=$( git config --get remote.origin.url | sed 's,:,/,;s,^.*@,https://,;s,\.git$,,' )
	echo ${url}/tree/${branch}/${arg} | sed "s,/tree/${MAIN}/,/blob/${MAIN}/,;s,///,://,"
}

_wuzzup_git_columns() {
	awk '
		BEGIN {
			LINE_COUNT = 0;
			FIELD_MAX = 0;
		}
		{ 
			if ( NF > FIELD_MAX ) {
				FIELD_MAX = NF;
			}

			for ( i = 1 ; i <= NF ; i++ ) {
				l = length( $i );
				if ( l > MAX[ i ] ) {
					MAX[ i ] = l;
				}
				LINES[ LINE_COUNT, i ] = $i;
			}
			LINE_COUNT++;
		}
		END {
			for ( i = 0 ; i < LINE_COUNT ; i++ ) {
				for ( j = 1 ; j <= FIELD_MAX ; j++ ) {
					format = "%-" 1 + MAX[ j ] "s ";
					printf( format, LINES[ i, j ] );
				}
				print "";
			}
		}
	'
}

_wuzzup_git_clone_branch() {
	local repo=${1}; shift
	local branch=${1}; shift
	local directory=$( echo ${branch} | sed 's,/,_,g' )
	echo git clone -b ${branch} --single-branch ${repo} ${directory}
	git clone -b ${branch} --single-branch ${repo} ${directory}
	#echo consider running: git push ${repo} ${branch}:${branch}
}

_wuzzup_git_new_task() {
	local repo=${1}; shift
	#local ticket=${1}; shift
	local name=${1}; shift

	local ws="${ticket}_${name}"
	ws="${name}"
	if [ -d ${ws} ] ; then
		echo ${ws} already exists
		return 1
	fi

	local branch="${ticket}/${name}"
	branch="${name}"

	echo cloning to ${ws}
	git clone ${repo} ${ws} || return 2
	cd ${ws} || return 3

	echo create the local branch
	git checkout -b ${branch} origin/${MAIN} || return 4

	echo create the remote branch
	git push origin ${MAIN}:${branch} || return 5

	local url=$( echo ${repo} | sed 's,:,/,;s,^git@,https://,;s,\.git$,,' )"/tree/${branch}"
	echo remote branch should be at ${url}

	echo ---
	echo you may want to add the ${MAIN} branch of your fork and pull to get up-to-date
	echo 'git remote add <nickname> <main-repo>'
	echo 'git pull <nickname> ${MAIN}'
}
				
_wuzzup_git_modified() {
	local lmod=${1};shift
	local file
	for file in $( git diff --name-only origin/${MAIN} ) ; do 
		if [ 1 = "${lmod}" ] ; then
			echo ${file}
		else
			_wuzzup_git_file_to_url ${file}
		fi 
	done
}

_wuzzup_git_push_back() {
	local branch=$( git status | head -1 | sed 's,.* ,,' )

	echo "remote origin set to:"
	git remote -v | grep origin
	echo 
	echo -n "do you want to: git push origin ${branch} [y/N]? "
	read r
	if [ "y" = "${r}" ] ; then
		echo --------------------------------------------
		echo git push origin ${branch}
		git push origin ${branch}
		echo --------------------------------------------
		echo "check $( _wuzzup_git_file_to_url . | sed 's,\.$,,' )"
	else
		echo "ok, maybe later then"
	fi
}
	
_wuzzup_git_add_remote() {
	local name=${1} ; shift
	local short=$( echo ${name} | sed 's,llc$,,' );

	if [ 0 != $( git remote -v | grep -wc "^${short}" ) ] ; then
		echo "that name (or one like it) is already in use..."
		return
	fi

	local repo=$( 
		git remote -v \
		| awk -v name=${name} '
			/^origin.*\(fetch\)$/ {
				repo = $2;
				sub( /:[^\/]*/, ":" name , repo );
				print repo;
			}
		'
	);
	local command="git remote add ${short} ${repo}"
	echo 
	echo -n "do you want to run: ${command} [y/N]? "
	read r
	if [ "y" = "${r}" ] ; then
		echo --------------------------------------------
		${command}
		git remote -v | grep ${short}
		echo --------------------------------------------
		echo ""
		echo "you can pull files with: git pull ${short} ${MAIN}"
		echo ""
	else
		echo "ok, maybe later then"
	fi
}

_wuzzup_git_main ${*}
