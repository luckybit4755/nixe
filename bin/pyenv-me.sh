#!/bin/bash	
	
_pyenv_me_main() {
	if [ -d "$HOME/.pyenv" ]; then
		export PYENV_ROOT="$HOME/.pyenv"
		export PATH="$PYENV_ROOT/bin:$PATH"

		export PYENV_ROOT="$HOME/.pyenv"
		command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"
#
#eval "$(pyenv init --path)"
#
##eval "$(pyenv init -)"
##eval "$(pyenv init - --no-rehash bash)"
#
#eval "$(pyenv virtualenv-init -)"
	fi
}

_pyenv_me_main ${*}
