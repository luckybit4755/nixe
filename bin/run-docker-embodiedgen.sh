#!/bin/bash	
	
_run_docker_embodiedgen_main() {
	local API_KEY=$(cat ${HOME}/.huggingface/token)

	 docker run -it -p 7860:7860 \
		 --platform=linux/amd64 \
		 --gpus all \
	  	 -e ENDPOINT="YOUR_VALUE_HERE" \
	  	 -e API_KEY="${API_KEY}" \
	 	 -e API_VERSION="YOUR_VALUE_HERE" \
	 	 -e MODEL_NAME="YOUR_VALUE_HERE" \
		 registry.hf.space/horizonrobotics-embodiedgen-image-to-3d:latest \
		 python app.py

}

_run_docker_embodiedgen_main ${*}
