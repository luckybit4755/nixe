set -o vi
export EDITOR=vim
alias l='ls -lathr'
alias md='mkdir -p'
alias rd='rmdir'
sl() { if [ $# -lt 1 ] || [ $# -gt 1 ] || [ -d ${1} ]; then ls -F -h ${*} ; else less -Si -r ${*} ; fi }
