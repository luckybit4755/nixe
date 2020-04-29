set -o vi

alias l='ls -lathr'
alias md='mkdir -p'

status() { sudo systemctl status ${*} | cat ; }
stop() { sudo systemctl stop ${*} | cat ; }
start() { sudo systemctl start ${*} | cat ; } 
restart() { sudo systemctl restart ${*} | cat ; }
sl() { if [ $# -lt 1 ] || [ $# -gt 1 ] || [ -d ${1} ]; then ls -F -h ${*} ; else less -Si -r ${*} ; fi }
