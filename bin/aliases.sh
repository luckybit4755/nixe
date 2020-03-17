alias avg='awk '\''BEGIN {min=max="ww"} {n++;s+=$1;if("ww"==max||$1>max)max=$1;if("ww"==min||$1<min)min=$1;} END {printf( "min:%f,max:%f,sum:%f,count:%d,average:%f\n",min,max,s,n,s/n);;}'\'''
alias r='reset ; echo c ; clear'
alias gud='(svn status ; git status ) > .gud ; vim .gud ; rm -f .gud'
alias jetty='clear ; mvn -P jetty clean jetty:run 2>&1 | tee jetty.log'
alias ee="vim \$( egrep '\.java:\[[0-9]*,[0-9]*\]' e | sed 's,^\[ERROR\],,;s,\[,+,g' | head -1 | cut -f1 -d, | tr : ' ')"
alias ffix='vim $( grep ${PWD} e | grep java: | head -1 | cut -f1 -d, | sed "s,:\[, +," )'
alias fj='nocvs | egrep -vw "tests?"'
alias ft='nocvs | egrep -w "tests?"'
alias l='ls -thrill'
alias la='ls -latr'
alias md='mkdir -p'
alias nocvs='(find src -type f || find . -type f ) 2>/dev/null | egrep -v '\''(\.svn|CVS|\.swp|\.git)'\'' | sed '\''s,//*,/,g'\'' | xargs ls -tr | cat'
alias nosnit='rm -rf snit'
alias rd='rmdir'
alias st='tree -I CVS -f'
alias sup='cvs diff 2>/dev/null |grep RC | sed "s,.*$(basename ${PWD})/,,;s/,v$//"'
alias timestamp='date +"%Y.%m.%d.%H.%M.%S"'
alias vim="vim_log.sh"
alias work='ssh work'
alias xencode='sed '\''s/</\&lt;/g;s/>/\&gt;/g;s/"/\&quot;/g'\'''
alias cum='pwd > ~/.cumrc'
alias here='cd $( cat ~/.cumrc )'
alias trim="sed 's,^ *,,;s, *$,,'"
alias imageInfo='sips -g pixelHeight -g pixelWidth'

# this is terrible...
if [ "Darwin" = "$( uname )" ] ; then
	alias ls='ls -G'
else
	alias ls='ls --color=tty'
fi
