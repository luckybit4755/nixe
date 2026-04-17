#!/bin/bash	
	
_ubu_configure_java_main() {
	echo "you have to configure these dumb things independently..."
	sudo update-alternatives --config java
	sudo update-alternatives --config javac

	export JAVA_HOME=$(file /etc/alternatives/java | sed 's,.* ,,;s,/bin/java$,,')
	echo "export JAVA_HOME=${JAVA_HOME}"

}

_ubu_configure_java_main ${*}
