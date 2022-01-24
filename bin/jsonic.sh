#!/bin/bash	

_jsonic_main() {
	python -m json.tool
}

_jsonic_main ${*}
