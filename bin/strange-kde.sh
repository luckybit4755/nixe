#!/bin/bash	

export DICT=${HOME}/txt/words.txt

export PHRASE="You are an expert at creating evocative phrases. I will give you a word and you generate a single phrase inspired by it. Keep your output brief: less than a sentence long. Do not add commentary describing your output."

export SCENE="You are an expert at writing stable diffusion prompts to generate images in the style of vintage, golden age of comics books! I provide you with some key words and you describe images in the spirit of 'Weird Tales' or other sorts of supernatural inspired comic books including adventurers, detectives, mystics, travelers or other enigmatic chacters. Be sure to emphasize that this should be comic book art! You only ever generate a single image prompt and you do not describe the prompt itself or provide commentary on your output."

export SCENE="You are an expert at writing stable diffusion prompts to generate images in the style of Office Space, Kafka-esque corporate nonsense. You illustrate ideas like 'Meanwhile, as I track down who needs to be do what, I'm being told if I need help to track down who needs to do what and get them to do what needs to be done they can help me with that. Then they ask me to to it. Which makes sense from a perspective I am unable to perceive'. I provide you with some key words and you describe images in the spirit of 'Office Space' or workplace absurdity inspired imagery including cubicles, business attire, office bimbo's and himbo's, nice-guy asshole managers and other irksome and sympathetic chacters. Be sure to emphasize that this should be realisic photography style! You only ever generate a single image prompt and you do not describe the prompt itself or provide commentary on your output."

export NEGATIVE='nsfw, porn, bad art, extra limbs, missing limbs, weird anatomy, boring'
	
_strange_kde_main() {

	while true ; do 
		echo "-------------------------------------------------------------------"
		_strange_kde_once
		sleep 121
	done
}

_strange_kde_once() {

	local word=$(cat ${DICT} | awk -v S=${RANDOM} 'BEGIN{srand(S)} {print rand() * 10000 " " $1}' | sort -rn | head -1 | sed 's,.* ,,')
	local phrase=$(ask-ollama.js -s "${PHRASE}" -p ${word})
	local scene=$(echo ${phrase} | ask-ollama.js -s "${SCENE}" )

cat << BIZARRO
word is ${word}
phrase is ${phrase}
scene is ${scene}
BIZARRO

    local filename=$(echo "${scene}. ${SCENE}" | a111-image.js -n "${NEGATIVE}")
	kde-bg.sh ${filename}
}

_strange_kde_main ${*}
