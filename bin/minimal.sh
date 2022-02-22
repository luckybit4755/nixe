# curl https://luckybit4755.github.io/nixe/bin/minimal.sh > /tmp/minimal.sh ; source /tmp/minimal.sh
set -o vi
export EDITOR=vim
alias l='ls -Flathr'
alias md='mkdir -p'
alias rd='rmdir'
alias nosnit='rm -rf snit'
sl() { [ $# -lt 1 ] || [ $# -gt 1 ] || [ -d ${1} ] && ls -Fthr ${*} || less -Si -r ${*} ; }
