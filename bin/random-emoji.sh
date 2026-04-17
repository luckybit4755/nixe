#!/bin/bash	

_random_emoji_main() {
	_random_emoji
}

_random_emoji() {
    local emojis=(
		"(づ￣ ³￣)づ"
		"ԅ(‾⌣‾ԅ)"
		"(๑'ᵕ'๑)⸝*"
		"(๑ ืົཽ₍₍ළ₎₎ ืົཽ)"
		"(◠ᵕ◠✿)"
		"(૭ ｡•̀ ᵕ •́｡ )૭"
		"(ノ・∀・)ノ"
		"ʕ•ᴥ•ʔ"
        "(ᵔᴥᵔ)"
        "V•ᴥ•V"
        "(っ◕‿◕)っ"
        "ʕ·ᴥ·ʔ"
		"╰•‿•╯"
		"(^_^)"
		"(∩^o^)⊃━☆ﾟ.*"
		"(o˘◡˘o)"
		"(づ｡◕‿‿◕｡)づ"
		"(≧∀≦)"
		"(◕‿◕✿)"
		"(^‿^)"
		"(´･ω･\`)"
		"(づ￣ ³￣)づ"
		"(◕‿◕✿)"
		"✿◡‿◡"
		"(◕દ◕)"
		"(●'◡'●)シ ︎"
		"૮₍ ´• ˕ • ₎ა"
		"( ˘ ³˘)♥︎"
		"(• ◡•)" 
		"(❍ᴥ❍ʋ)"
		"(｡◕‿‿◕｡)"
		"(o˘◡˘o)"
		"(∩^o^)⊃━☆ﾟ.*"
		"ˁ(⦿ᨎ⦿)ˀ"
		" Ƹ̵̡Ӝ̵̨̄Ʒ"
    )

    local num_emojis=${#emojis[@]}              # Get the number of emojis in the array
    local random_index=$((RANDOM % num_emojis)) # Generate a random index between 0 and num_emojis-1
    echo "${emojis[random_index]}"              # Return the randomly selected emoji
}

_random_emoji_main ${*}
