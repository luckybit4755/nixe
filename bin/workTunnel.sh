#!/bin/sh  

SSH_PORT=5279
SSH_PORT=22

usage() {
       echo ""
       echo "usage:  workTunnel remote_host:remote_port ssh_server[:local_port]"
       echo ""
       exit
}

main() {

		if [ 2 = ${#} ] ; then 
		
		   local remote_host=$( echo ${1} | cut -f1 -d: )
		   local remote_port=$( echo ${1} | cut -f2 -d: )
		   shift

		   local remote_srvr=$( echo ${1} | cut -f1 -d: )
		   local  local_port=$( echo ${1} | cut -f2 -d: )
		   shift
		fi

       if [    "-h" = "${remote_host}" ] ; then usage ; fi
       if [ "-help" = "${remote_host}" ] ; then usage ; fi

       if [      "" = "${remote_host}" ] ; then usage ; fi
       if [      "" = "${remote_port}" ] ; then usage ; fi
       if [      "" = "${remote_srvr}" ] ; then usage ; fi
       if [      "" = "${local_port}" ] ; then usage ; fi

       if [ "${remote_srvr}" = "${local_port}"  ] ; then
               local_port="${remote_port}"
       fi

       local ssh_fwd="${local_port}:${remote_host}:${remote_port}"
       local ssh_srv="${USER}@${remote_srvr}"
       local ssh_cmd="ssh -F/dev/null -N -p ${SSH_PORT} -L ${ssh_fwd} ${ssh_srv} -g -T"
       ssh_cmd="ssh -F/dev/null -N -p ${SSH_PORT} -L ${ssh_fwd} ${ssh_srv} -g -T"

       local xtitle="${remote_host}:${remote_port} on ${local_port}"
#       echo xterm -T '"'${xtitle}'"' -geometry 40x4 -e '"'${ssh_cmd} ${*}'"'
#       xterm -T "${xtitle}" -geometry 40x4 -e "${ssh_cmd} ${*}" &
#xterm -T "${xtitle}" -geometry 40x4 -e "${ssh_cmd} ${*}" &
#xterm -T "${xtitle}" -geometry 40x4 -e "
	   echo ${ssh_cmd} ${*}
	   ${ssh_cmd} ${*}
}

main ${*}
