#!/bin/bash	
	
_ninja_main() {
	local system=${1-java}
	echo "system is: ${system}"

	_ninja_prompt
	while read question ; do
		_ninja_top_line
		echo "question is: ${question}"
		ask-ollama.js -s ${system} -p "${question}";
		_ninja_bottom_line
	done
}

_ninja_prompt() {
	echo -n "Yes? "
}

_ninja_top_line() {
cat << NINJA
,_._._._._._._._._|__________________________________________________________,
|_|_|_|_|_|_|_|_|_|_________________________________________________________/
                  |
NINJA
}

_ninja_bottom_line() {
	local a='▬▬ι═══════ﺤ'
	local b='-═══════ι▬▬'
	echo "   ${a}    ${b}    ${a}    ${b}    ${a}    ${b}    ${a}"
}

_ninja_main ${*}
