#!/bin/bash

##############################################################################

######                              ##
 ##  ##                             ##    Bang is a collection of functions
 ##  ##   ###    ### ##     ######  ##    for bash which provide sly utility.
 ##  ##   # ##    ### ##   ##  ##   ##
 #####      ##    ##  ##   ##  ##   ##    It reflects my own experiences with
 ##  ##   ####    ##  ##    ####    ##    what is useful in a UNIX shell 
 ##  ##  ## ##    ##  ##    #       ##    developer world.  
 ##  ##  ## ##    ##  ##    #####    
######    #####  #### ###  ##   ##  ##    Val
                           ##   ##        
                            #####		  LastUpdate: 2004.11.05

##############################################################################
#
# See http://elvis.dlogic.org/viewcvs/cgi/viewcvs.cgi/shell_party/bin/
# 
# $Header: /usr/local/cvsroot/shell_party/bin/Bang.sh,v 1.14 2006/02/03 16:28:36 val Exp $
#
##############################################################################

##############################################################################

          ###     ###     #                  
           ##      ##     #                   the add function will catalog
 ###    #####   #####    #    ######  ###     current working directory on 
 # ##  ##  ##  ##  ##    #   ##  ##  ## ##    a per user/host basis
   ##  ##  ##  ##  ##    #   ##  ##  ## ##
 ####  ##  ##  ##  ##   #     ####   ## ##    the go function with no arguments
## ##  ##  ##  ##  ##   #     #      ## ##    will cd to the last directory added
## ##  ##  ##  ##  ##   #     #####  ## ##    for the current user on the current
 #####  ######  ######  #    ##   ##  ###     host.  if an argument is provided
                       #     ##   ##          the last substring match is cd'd to
                       #      #####       

##############################################################################

export _b_add_file=~/.b_add_file
export _b_add_hosthname=localhost

set_title() {
	echo -e "\033]0;" ${*} "\007"; 
}

add() {
	echo ${USER}@${_b_add_hosthname}:${PWD} >> ${_b_add_file}
}

go() {
	local to
	local here=${USER}@${_b_add_hosthname}
	if [ "" = "${1}" ] ; then
		to=`grep ${here} ${_b_add_file} | tail -1`
	else
		local expr
		to=""
		for expr in /${1}$ /${1}/trunk$ ${1} ; do
			to=$( grep ${here} ${_b_add_file} | grep ${expr} | tail -1 )
			if [ "" != "${to}" ] ; then
				break
			fi
		done
	fi
	if [ "" != "${to}" ] ; then
		to=`echo ${to} | cut -f2- -d:`
		cd ${to}
	fi
	set_title $( basename ${PWD} )
}

_go_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	if [ "" = "${cur}" ] ; then cur=. ; fi
	local guess=$( 
		grep "${USER}@${_b_add_hosthname}:" ${_b_add_file} | 
		sed 's,/trunk$,,' |
		sed 's,.*/,,' | 
		grep "^${cur}"| 
		cut -f2- -d:  |
		xargs
	)
	COMPREPLY=( ${guess} )
}   

complete -F _go_complete -o filenames go 2>/dev/null

##############################################################################

_ssh_complete_hosts_filter() {
	sed 's,#.*,,' | egrep -v ':|127.0.0|255.255' | expand | sed 's,^[^ ]* ,,' | tr ' ' '\n' | grep -i '[a-z]' 
}

_ssh_complete_hosts() {
	cat /etc/hosts | _ssh_complete_hosts_filter
}

_ssh_complete_history() {
	history | grep '^  *[0-9][0-9]*  ssh' |  sed 's,.*  ssh ,,;s,-[^ ]* *,,;s, .*,,'
}

_ssh_complete_v_file() {
	cut -f2 -d' ' ${HOME}/.v_ssh_file  | sort -u | egrep -v '(^[\[-])'
}

_ssh_complete_choices() {
	( _ssh_complete_v_file ; _ssh_complete_hosts ; _ssh_complete_history ) | sort -u
}

_ssh_complete () { 
	local hst=$( echo ${COMP_WORDS[COMP_CWORD]} )
	if [ "" = "${hst}" ]; then hst="." ; fi
	COMPREPLY=( $( _ssh_complete_choices | grep ^${hst} )    )
}

complete -F _ssh_complete -o filenames ssh 2>/dev/null

##############################################################################

 ####
##  ##
##        is a smarter version of cd, it will try to cd to its first argument
##        in the following way:  just cd there (if it is a directory), cd to
##        the dirname (if it is a file), convert dots to slashes (if it is a 
##  ##    java qualified classname)
 ####

##############################################################################

c() {
	cd ${1} 2>/dev/null || cd $( ls -d *${1}* | head -1 ) || cd $( dirname ${1} ) || cd $( echo ${1} | tr . / ) 2>/dev/null
}

##############################################################################

  ###
 ##  
#####      is my do "the right thing" function.  It works by identifying
 ##        the most recently modified file in ${PWD} and passing it on to
 ##        a type specific function based on the results of the file command.
 ##                                                                           
 ##        It is named for the famously generic function example commonly
 ##        found in math, frequently in the form of:  g = f( x )
#### 

##############################################################################

_f_postscript() { 
	ghostview ${*} &
}

_f_directory() {
	cd ${*}
}

_f_gzip() {
	gunzip ${*}
}

_f_pdf() {
	gv ${*} &
}

_f_zip() {
	unzip ${*}
}

_f_image() {
	xv ${*} &
}

_f_jpeg() {
	_f_image ${*}
}

_f_gif() {
	_f_image ${*}
}

_f_png() {
	_f_image ${*}
}

_f_ascii() {
	vim ${*}
}

_f_url() {
	wget ${*}
}

_f_host() {
	ssh ${*}
}

_f_what() {
	if [ -e ${*} ] ; then
		file ${*} | awk '{print $2}' | tr '[A-Z]' '[a-z]' | tr -d '[[:punct:]]' 
	else
		if [ "http://" = "$( echo ${*} | cut -c1-7 )" ] ; then
			echo url
			return
		fi

		( ping -c 1 ${1} 2>&1 ) > /dev/null
		if [ 0 = ${?} ] ; then
			echo host
			return
		fi
	fi
}

_f_() { 
	local match
	local ftof=""
	for match in $( find . -name "${1}" | egrep -vw 'svn|CVS' | xargs ls -tr ) ; do
		if [ "" != "${ftof}" ] && [ 1 = $( echo ${match} | egrep -cw 'target' ) ] ; then
			continue
		fi
		ftof=${match}
	done
	local what=$( _f_what ${ftof} )
	if [ "" = "${what}" ] ; then
		uhm... ${ftof}
	else
		echo ${ftof}
		_f_${what} ${ftof} 
		if [ 127 = ${?} ] ; then
			$( echo ${VISUAL} ${EDITOR} vim | awk '{ print $1; }' ) ${ftof}
			echo "no f command for type '_f_${what}', using vim..."
		fi
	fi
}

f() {
	local ftof=${1}
	if [ "" = "${ftof}" ] ; then 
		ftof="$( ls -tr | tail -1 )"
	fi
	local what=$( _f_what ${ftof} )
	if [ "" != "${what}" ] ; then
		echo ${ftof}
	fi
	_f_${what} ${ftof} 
}

_f_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	if [ "" = "${cur}" ] ; then
		COMPREPLY=( $( ls -tr |tail -1 ) )
	else
		COMPREPLY=( $( find . -type f -name "${cur}*" | egrep -vw 'target|svn|CVS' | xargs ls -tr | sed 's,.*/,,' ) )
	fi
}   

complete -F _f_complete -o filenames f 2>/dev/null

##############################################################################

### ##    ###  ###  ##  ##  ### ######  ######     takes a c++ filename and
 ### ##  ## ##  ##  ##  #  ## #  ##  ##  ##  ##    generates a "self compiling"
 ##  ##  ## ##  ## # ## #  ##    ##  ##  ##  ##    c++ application.  it also 
 ##  ##  #####  ## # ## #  ##    ##  ##  ##  ##    throws you into an editor.
 ##  ##  ##     ## # ## #  ##    ##  ##  ##  ##
 ##  ##  ##      ##   ##   ##    ##  ##  ##  ##
#### ###  ####   ##   ##    ###  #####   ##### 
                                 ##      ##    
                                ####    ####   

##############################################################################

_newcpp_gen_hdef() {
	echo ${*} | tr '[a-z]' '[A-Z]' | cut -f1 -d. | sed 's,$,_BY_NEWCPP,'
}

_newcpp_genFileHeader() {
	local cmpl=${1}
	local file=${2}
	local name=${3}

cat << EOM | cut -f2-
	/*2>/dev/null 2>/dev/null 2>/dev/null 2>/dev/null 2>/dev/null

	#############################################################
	# 
	# ${file} is an example of a "self compiling program".  The 
	# bits you are looking at here are written in shell.  It can
	# be used by following these simple steps:
	#
	#	% chmod 755 ${file}
	#	% ./${file} args
	#
	# A temporary binary will be generated and removed when the
	# the application finishes. This can be used to fill a ~/bin
	# with this sort of file instead of other types of scripts.
	# 
	# The key advantage of a shell script is typically it's cross
	# platform nature, it can be run wherever the interpreter is
	# installed. Just think of the interpreter as being ${cmpl}
	#
	# This way, you can have your utility applications written in
	# ${cmpl} and run them in the same way under Linux, Solaris,
	# MacOs, BeOs, Windoze, etc.
	#
	# This new script is more conducive to use as a header file ala
	# http://elvis.dlogic.org/~val/c++/Glaxer/dox/html/classGlaxerCoronaLoader.html
	#
	#############################################################

	this=\$( which \${0} )
	from=\$( dirname \${this} )
	here=\${PWD}
	cd \${from}
	from=\${PWD}
	cd \${here}

	tmpsrc=/tmp/.${file}.\${USER}.\${RANDOM}.\${SECONDS}.cpp
	tmpdst=/tmp/.${file}.\${USER}.\${RANDOM}.\${SECONDS}

	cp \${this} \${tmpsrc}

	INCZ="" # put your -I stuff here..
	LIBZ="" # put your -L stuff here..

	${cmpl} \${INCZ} -I\${from} \${tmpsrc} -o \${tmpdst} -D${name}Standalone \${LIBZ} && \\
	\${tmpdst} \${*}

	rm -rf \${tmpsrc} \${tmpdst} 

	#############################################################
	#
	# The exit keeps the rest of the file from being interpreted
	# by the shell
	#
	#############################################################
	exit

	*/
EOM
}

_newcpp_genFile() {
	local file=${1}
	local name=${2}

	local hdef=$( _newcpp_gen_hdef ${name} )

	_newcpp_genFileHeader c++ ${*}

cat << EOM | cut -f2-
	
	#ifndef ${hdef}
	#define ${hdef}

	#include <vector>       // for vector
	#include <string>       // for string
	#include <iostream>     // for cin

	/**
	 *
	 * The ${name} class is the best class ever!
	 * All the other classes are *so* jealous!
	 * They wish they had been generated by Bang.sh!
	 * 
	 * http://elvis.dlogic.org/~val/Bang.sh
	 *
	 * The C++ style is meant to minimize the distance
	 * between application and library code.
	 *
	 */
	class ${name} {

		public:

			/**
			 *
			 * *****                 
			 *   *                   
			 *   *   *   * ***    ** 
			 *   *   *   * *  *  *  *
			 *   *    * *  *  *  ****
			 *   *    * *  *  *  *   
			 *   *     *   *  *  *   
			 *   *     *   ***    ***
			 *         *   *         
			 *        *    *         
			 * 
			 */
			
			/**	
			 *
	 		 * For passing around args
			 *
	 		 */
			typedef std::vector< std::string > StringVector;


			/**
			 *
 			 * *                                      
 			 * *             *                        
 			 * *  * *    ** ***  ***   * *    **   ** 
 			 * *  ** *  *    *      *  ** *  *    *  *
 			 * *  *  *   *   *    ***  *  *  *    ****
 			 * *  *  *    *  *   *  *  *  *  *    *   
 			 * *  *  *    *  *   *  *  *  *  *    *   
 			 * *  *  *  **    *   **** *  *   **   ***
 			 * 
 			 */

			// put your instance level methods somewhere around here

			/**
			 *
			 *  ***                *     
			 * *     *         *         
			 * *    ***  ***  ***  *   **
			 *  *    *      *  *   *  *  
			 *   *   *    ***  *   *  *  
			 *    *  *   *  *  *   *  *  
			 *    *  *   *  *  *   *  *  
			 * ***    *   ****  *  *   **
			 *
			 */

			/**
			 *
			 * Typically prints a little usage message
			 *
			 * @return 1
			 *
			 */
			static int usage();
			
			/**
			 *
			 * This C++ method picks up from where C left off.
			 *
			 * @param args  the arguments to the "application"
			 *
			 * @return 0 on success, 1 on fail
			 *
			 */
			static int main( StringVector args );

			/**
			 *
			 * This parallels the traditional C function of the same
			 * name...
			 *
			 * @param argc  the number of strings in the array
			 * @param argv  array of character pointers with arguments
			 *
			 * @return 0 on success, 1 on fail
			 *
			 */
			static int main( int argc, char *argv[] );

		private:

	};

	/**
	 *
	 * *                 *
	 * *                 *
	 * *  * ** **  ***   *
	 * *  ** ** *  *  *  *
	 * *  *  *  *  *  *  *
	 * *  *  *  *  *  *  *
	 * *  *  *  *  *  *  *
	 * *  *  *  *  ***   *
	 *			   *      
	 *			   *      
	 *
	 */

	inline
	int
	${name}::usage() {
		std::cout << "usage: ${name} [options]" << std::endl;
		return 1;
	}

	inline 
	int 
	${name}::main( int argc, char *argv[] ) {
		StringVector args;
		for ( int i = 0 ; i < argc ; i++ ) args.push_back( argv[ i ] );
		return main( args );
	}

	inline
	int 
	${name}::main( StringVector args ) {
		return usage();
	}
			
	#ifdef ${name}Standalone
	int 
	main( int argc, char *argv[] ) { 
		return ${name}::main( argc, argv ); 
	}
	#endif

	#endif
EOM

}

newcpp() {
	local file=${1}

	if [ ! -f ${file} ] ; then
		local name=`echo $1 | sed 's,\.c.*$,,;s,\.h.*$,,'`
		_newcpp_genFile ${file} ${name} >> ${file}
		chmod 755 $1
	fi

	$( echo ${VISUAL} ${EDITOR} vim | awk '{ print $1; }' ) ${file}
}

##############################################################################

                           ##                       
                                                    
### ##    ###  ###  ##  #####   ###  #### ###  ### 		takes a java filename and
 ### ##  ## ##  ##  ##  #  ##   # ##  ##   #   # ##     generates a "self compiling"
 ##  ##  ## ##  ## # ## #  ##     ##  ##   #     ##     java application.  it also 
 ##  ##  #####  ## # ## #  ##   ####   ## #    ####     throws you into an editor.
 ##  ##  ##     ## # ## #  ##  ## ##   ## #   ## ## 
 ##  ##  ##      ##   ##   ##  ## ##    ##    ## ## 
#### ###  ####   ##   ##   ##   #####   ##     #####
                         # ##                       
                         ###                        

##############################################################################

_newjava_genFile() {
	local file=${1}
	local name=${2}

	local pckg=$( echo ${file} | sed 's,^.*java/,,' | tr / . )
	if [ "" != "${pckg}" ] ; then
		local package="package $( echo ${pckg} | sed 's,\.[^.]*\.java$,,' );"
	else 
cat << EOM | cut -f2-
	/*2>/dev/null 2>/dev/null 2>/dev/null 2>/dev/null 2>/dev/null
	
	#############################################################
	#
	# ${file} is an example of a "self compiling program".  The 
	# bits you are looking at here are written in shell.  It can
	# be used by following these simple steps:
	#
	#	% chmod 755 ${file}
	#	% ./${file} args
	#	
	#############################################################
	
	javac ${file} && java ${name} \${*}
	  
	#############################################################
	#
	# The exit keeps the rest of the file from being interpreted
	# by the shell
	#
	#############################################################
	exit

	 */
EOM
	fi

cat << EOM | cut -f2-
	${package}
	
	import java.io.*;
	import java.util.*;

	/**
	 *
	 * <P>
	 * </P>
	 * 
	 * @author Val
	 *
	 */
	public class ${name} {

		/** 
		 * 
		 * main
		 * 
		 * @param args
		 * 
		 */
		public static final void main( String args[] ) {
			System.out.println( "${name} is here for you!" );
		}
		
	};
EOM

}

newjava() {
	local file=${1}

	if [ ! -f ${file} ] ; then
		local name=$( basename $1 | sed 's,\.java$,,' )
		mkdir -p $( dirname ${file} ) 2>&1 > /dev/null
		_newjava_genFile ${file} ${name} >> ${file}
		chmod 755 $1
	fi

	$( echo ${VISUAL} ${EDITOR} vim | awk '{ print $1; }' ) ${file}
}

_newhaxe_genFile() {
	local file=${1} ; shift
	local name=${1} ; shift
cat << EOM | cut -f2- 
	// 2>/dev/null; haxe -main ${name} -neko ${name}.hx && echo "rock" | neko ${name} ; exit
	class ${name} {
		static function main() {
			( new ${name}() ).file${name}( neko.io.File.stdin() );
		}

		public function new() {
		}

		public function file${name}( file : neko.io.FileInput ) : Void {
			try {
				while ( !file.eof() ) {
					neko.io.File.stdout().write( this.line${name}( file.readLine() ) + "\n" );
				}
			} catch ( e : Dynamic ) {
			}
		}

		public function line${name}( line : String ) : String {
			return line;
		}
	}
EOM
}

newhaxe() {
	local file=${1}

	if [ ! -f ${file} ] ; then
		local name=$( basename $1 | sed 's,\.hx$,,' )
		mkdir -p $( dirname ${file} ) 2>&1 > /dev/null
		_newhaxe_genFile ${file} ${name} >> ${file}
		chmod 755 $1
	fi

	$( echo ${VISUAL} ${EDITOR} vim | awk '{ print $1; }' ) ${file}

}


##############################################################################

                  ##### ###                                 
                 ##   #  ##                                     watches a files
### ##    ###   ##       ## ##    ###  ### ##    ######  ###    passed in and
 ### ##  ## ##  ##       ### ##   # ##  ### ##  ##  ##  ## ##   returns once
 ##  ##  ## ##  ##       ##  ##     ##  ##  ##  ##  ##  ## ##   one of them is
 ##  ##  ## ##  ##       ##  ##   ####  ##  ##   ####   #####   modified.
 ##  ##  ## ##  ##       ##  ##  ## ##  ##  ##   #      ##   
 ##  ##  ## ##   ##   #  ##  ##  ## ##  ##  ##   #####  ##      useful for 
#### ###  ###     ####  #### ###  ######### ### ##   ##  ####   roll-your-own
                                                ##   ##         "ide" games or
                                                 #####          job control

##############################################################################

noChange() {
	local newest=${1}

	# find newest of the bunch
	local file
	for file in ${*} ; do
		if [ ${file} -nt ${newest} ] ; then newest=${file} ; fi
	done

	# create the reference file
	local ref_file=/tmp/.${USER}.whileUnmodified.ref
	touch -r ${newest} ${ref_file}

	# loop until a file is modified
	while [ -f ${ref_file} ] ; do
		
		for file in ${*} ; do

			if [ ${file} -nt ${ref_file} ] ; then 
				rm ${ref_file}	
				break
			fi
		done
		usleep 100000

	done
}

##############################################################################

      ###    sl will call out to ls for multiple files or if the 
       ##    first argument is a directory.  if the first argument
 ####  ##    is an file, it will run less on it.  it was created 
##  #  ##    from thru the realization that I was executing ls with
###    ##    tab completion to hunt for files an then editing the 
 ###   ##    command line to run less.  this function combines both
  ###  ##    activities is a single package...
#  ##  ## 
####  ####

##############################################################################

sl() {
	LS_ARGS="-F --color=tty -h"
	LS_ARGS="-F -h"
	LESS_ARGS="-i --tabs=4"

	if [ "$#" -lt 1 ] || [ "$#" -gt 1 ] || [ -d ${1} ] ; then
		ls $LS_ARGS ${*}
	else
		if [ -f ${1} ] ; then
			less $LESS_ARGS ${1}
		else
			man ${1}
        fi
	fi
}

##############################################################################

  ###        ### ###                     ###      	will print the canonical
 ##           ##  ##                 ##   ##     	name of a file or directory
######## ###  ##  ## ######    ###  ####  ## ##  	
 ##   ##  ##  ##  ##  ##  ##   # ##  ##   ### ## 
 ##   ##  ##  ##  ##  ##  ##     ##  ##   ##  ## 
 ##   ##  ##  ##  ##  ##  ##   ####  ##   ##  ## 
 ##   ##  ##  ##  ##  ##  ##  ## ##  ##   ##  ## 
 ##   ##  ##  ##  ##  ##  ##  ## ##  ##   ##  ## 
####   ############## #####    #####  ####### ###
                      ##                         
                     ####                        

##############################################################################

fullpath() {
	local f
	for f in $* ; do	
		( \
			( cd ${f} 2>/dev/null && echo ${PWD} ) \
		||  \
			( cd $(dirname ${f} ) 2>/dev/null && echo ${PWD}/$( basename ${f} ) ) \
		)
	done
}

##############################################################################

###  ##  ## ####   ### ###### 	prints a list of files or directories in a 
 ##  ##  # ##  #  ## #  ##  ##	form which can be pasted into the scp command
 ## # ## # ###    ##    ##  ##
 ## # ## #  ###   ##    ##  ##
 ## # ## #   ###  ##    ##  ##
  ##   ##  #  ##  ##    ##  ##
  ##   ##  ####    ###  ##### 
                        ##    
                       ####   

##############################################################################

wscp() {
	local host=${USER}@$( echo ${HOSTNAME} | cut -f1 -d. )

	if [ 0 = ${#} ] ; then
		echo ${host}:${PWD}
	else
		local f
		for f in $* ; do
			echo ${host}:$( fullpath ${f} )
		done
	fi 
}

##############################################################################

   ###                          	generate stubbed out doxygen/javadoc
    ##                          	comments from a method signature
 #####   ###   ###  ###### ###  
##  ##  ## #  ## ##  ##  ##  ## 
##  ##  ##    ## ##  ##  ##  ## 
##  ##  ##    ## ##  ##  ##  ## 
##  ##  ##    ## ##  ##  ##  ## 
##  ##  ##    ## ##  ##  ##  ## 
 ######  ###   ###  #### ### ###

##############################################################################

dcom() {
	local method=${*}
	if [ 0 = $# ] ; then read method ; fi
	
	local indent='\t\t * '
	local indent='\t * '
		
	local ornaments="public|static|final|const|virtual|enum|private|function"
	local head=$( echo ${method} | sed 's,(.*,,' )
	local bare=$( echo ${head} | tr ' ' '\n' | egrep -v "${ornaments}" | xargs )
	local name=$( echo ${bare} | awk '{ print $NF }' )
	local rtype=$( echo ${bare} | awk '{ print $1 }' | grep -v void )
	local arguments=$( echo ${method} | sed 's,[^(]*(,,;s,)[^)]*,,;s,^ *,,;' )

	echo -e "${indent}" | sed 's, ,/*,'
	echo -e "${indent}"

	if [ "${name}" = "${rtype}" ] ; then
		echo -e "${indent}Constructor"
	else
		echo -e "${indent}${name}"
	fi

	if [ "" != "${arguments}" ] ; then
		echo ${arguments}   | \
		tr ',' '\n'		 	| \
		sed 's,=.*,,'	   	| \
		tr -d '[[:punct:]]' | \
		awk -v i="${indent}" '
			BEGIN { 
				print( i ); 
			} { 
				printf( i ); 
				printf( "@param %s\n", $NF ); 
			}
		'
	fi
	
	if [ "${name}" != "${rtype}" ] && [ "" != "${rtype}" ] ; then
		echo -e "${indent}\n${indent}@return a ${rtype}"
	fi
	
	echo -e "${indent}"
	echo -e "${indent}" | sed 's,\* ,*/,'

}

viewcvs() {
	cat CVS/Root | sed 's,.*/,,'
	local arg
	for arg in ${*} ; do
		echo "http://viewcvs.taalee.com/index.cgi/$( cat CVS/Repository )/${arg}?cvsroot=$(cat CVS/Root | sed 's,.*/,,')&rev=HEAD&content-type=text/vnd.viewcvs-markup"
	done
}

link() {
	echo "<img src='' style='float:right' id='x' />"
	echo "<UL>"
	sed 's,.*,<li><a href="&" id="&">&</a></li>,;s,>\([^<]*jpg\)<,><img src=\"\1\" width="64" height="64" onMouseOver="document.getElementById( @x@ ).src=@\1@"><,' | tr '@' "'"
	echo "</UL>"
}

ff() {
	local dir="${1}" 
	local pat="${2}" 
	if [ "" = "${pat}" ] ; then
		pat=${dir}
		dir=src
	fi
	if [ "" = "${pat}" ] ; then
		echo usage: ff directory pattern
	else
		find ${dir} -iname "*${pat}*" | xargs ls -tr
	fi
}

##############################################################################
##############################################################################

web() {
	fullpath ${*} |\
	sed 's,.*,<li><a href="&">&</a></li>,' > ~/public_html/tmp/web.html
}

string_to_integer() {
	echo ${*} | od -t u1 | sed 's,[^ ]*,,;s, ,,g;' | tr -d '\n'
	echo
}

tt() {
	tidy -i -q -w 0 -xml ${*} 2>/dev/null
}

mvn_moo() {
	mvn ${*} 2>&1 | tee e 
	local status=${PIPESTATUS[0]}
	grep -w BUILD e | sed "s,^,$( basename ${PWD} ): ," | notify.sh
	return ${status}
}

moo() {
	clear ; mvn_moo ${*}
}

random_word() {
	local n
	let n=${RANDOM}%${#}
	_random_word_=( ${*} )
	echo ${_random_word_[${n}]}
}

random_phrase() {
	local adj="big red fat sad funny silly rash demonic childish rosy"
	local noun="panda kitten turtle donkey turkey lion squirrel rat"
	local verb="kicked licked sniffed moved attacked fondled bothered liked mocked"
	local adv="quickly soundly smoothly noisily messily suddenly openly"
	echo -n "The"
	echo -n " "$( random_word ${adj} )
	echo -n " "$( random_word ${noun} )
	echo -n " "$( random_word ${adv} )
	echo -n " "$( random_word ${verb} )
	echo -n " a"
	echo -n " "$( random_word ${adj} )
	echo -n " "$( random_word ${noun} )
	echo "."
}

# in the old days, john taylor and I used to send stuff around like this 
# when we didn't want to scp hop stuff thru ...
# usage:  uuu myfile
uuu() {
	cp ${1} .uuu && gzip .uuu && uuencode .uuu.gz .uuu.gz && rm .uuu.gz
}

# cut and paste from uuencode, then
# usage: nnn > myfile
nnn() {
	uudecode && gunzip .uuu.gz && cat .uuu && rm .uuu
}

#
y() { 
	local y=~/.y

	local command=$( grep "${*}" ${y} | tail -1 )
	if [ "" != "${command}" ] ; then
		${command}
	else 
		echo ${*} >> ${y}
	fi
}

_y_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	if [ "" = "${cur}" ] ; then cur=. ; fi
	local i=0;
	local line
	# must be a better way...
	for line in $( grep "${cur}" ~/.y | sed 's,[[:space:]],☃,g' ) ; do 
		COMPREPLY[${i}]=$( echo ${line} | sed 's,☃, ,g' )
		let i=${i}+1
	done
}   
complete -F _y_complete -o filenames y 2>/dev/null

##############################################################################
#
# to support invocation of functions from the cli (without sourcing)
#
##############################################################################

${*}

#
# $Log: Bang.sh,v $
# Revision 1.14  2006/02/03 16:28:36  val
# fix name
#
# Revision 1.13  2006/02/03 15:52:48  val
# make newjava smarter about package name
#
# Revision 1.12  2005/11/23 13:25:23  val
# add custom tab completion for the 'go' function
#
# Revision 1.11  2005/03/20 03:17:11  val
# function is a common method ornament...
#
# Revision 1.10  2005/02/02 13:04:14  val
# generate usage method in newcpp
#
# Revision 1.9  2005/02/02 12:54:42  val
# revamp newcpp
#
# Revision 1.8  2005/01/27 02:41:44  val
# fixed fullpath
#
# Revision 1.7  2005/01/27 02:40:04  val
# yada-yada
#
# Revision 1.5  2004/11/30 00:18:13  val
# added dcom function
#
# Revision 1.4  2004/11/18 11:55:25  val
# added newjava function
#
# Revision 1.3  2004/11/05 13:45:44  val
# removed function decoration
#
# Revision 1.2  2004/11/05 13:40:41  val
# more comments
#
#
