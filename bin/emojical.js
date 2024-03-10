#!/usr/bin/env node 

/*
(づ￣ ³￣)づ
ԅ(‾⌣‾ԅ)
(๑'ᵕ'๑)⸝*
(๑ ืົཽ₍₍ළ₎₎ ืົཽ)
(◠ᵕ◠✿)
(૭ ｡•̀ ᵕ •́｡ )૭
(ノ・∀・)ノ
ʕ•ᴥ•ʔ
(ᵔᴥᵔ)
V•ᴥ•V
(っ◕‿◕)っ
ʕ·ᴥ·ʔ
╰•‿•╯
(^_^)
(∩^o^)⊃━☆ﾟ.*
(o˘◡˘o)
(づ｡◕‿‿◕｡)づ
(≧∀≦)
(◕‿◕✿)
(^‿^)
(´･ω･\`)
(づ￣ ³￣)づ
(◕‿◕✿)
✿◡‿◡
(◕દ◕)
(●'◡'●)シ ︎
૮₍ ´• ˕ • ₎ა
( ˘ ³˘)♥︎
(• ◡•)
(❍ᴥ❍ʋ)
(｡◕‿‿◕｡)
(o˘◡˘o)
(∩^o^)⊃━☆ﾟ.*
ˁ(⦿ᨎ⦿)ˀ                          jjj
(ᵒ̴̶̷᷄﹏ᵒ̴̶̷᷅)b 
(╥﹏╥)
(｡•́︿•̀｡)
(˚ ˃̣̣̥⌓˂̣̣̥ )
o(╥﹏╥)o
(˚ ˃̣̣̥⌓˂̣̣̥  )づ♡ 
ᕙ(⇀‸↼‶)ᕗ
٩(ˊᗜˋ*)و ♡ 
( ᴗ͈ˬᴗ͈)ഒj
ᕙ( ᗒᗣᗕ )ᕗ                 
( ｡ •̀ ᴖ •́ ｡ )
⁽⁽(੭ꐦ •̀Д•́ )੭*⁾⁾
꒰ᐢ. .ᐢ꒱


( ɔ '́ '̯̀ )ɔ   
૮₍ ˃ ⤙ ˂ ₎ა

(•_•) ( •_•)>⌐■-■ (⌐■_■)                  
৻(  •̀ ᗜ •́  ৻)    


*/

class Emojical {
	static BITS = {
		  "eyes":   [ 
		
			"•̀•́", "ᗒᗕ", "≧≦", "'", "^", "˘", "•", "‾", "●", "◕", "◠", "◡", "❍", "⦿", "･", "·", "◕", "o", "ᵔ", " ืົཽ"
		  	, "ᵒ̴̶̷᷄ᵒ̴̶̷᷅", "╥", "•́•̀", "˃̣̣̥˂̣̣̥", "╥", "˃̣̣̥˂̣̣̥", "⇀↼", "ˊˋ", "ᴗ͈", "˂̣̣", "'`"
			, ["⌐■","_", "■"] // right only
			, ["■","_", "■¬"] // left only
			// ÿ, Ö, Ü, ¢, £, ¥, ₧, ƒ. á, í, ó, ú, ñ, Ñ, ª, º, ¿, ⌐, ¬, ½, ¼, ¡, «, ». ·, ·, ·, │, ┤, ╡, ╢, ╖, ╕, ╣, ║, ╗, ╝, ╜, ╛, ┐. └, ┴, ┬, ├, ─, ┼ ...

		]
		, "mouths": [ "_", "˕", "‿", "‿‿", "∀", "⌣", "◠", "◡", "‿", "³", "o", "ᵕ", "ᴥ", "ω", "દ", "₍₍ළ₎₎", "ᨎ" , "ᴖ", "﹏", "︿", "⌓", "↼", "ᗜ", "ᗣ", "ᴖ", "Д", "⤙" ]
		, "sides":  [ "()", "ʕʔ", "꒰꒱" ]
		, "ears":   [ "VV", "╰╯", "૮ა", "ˁˀ", "<>" ]
		, "larms":  [ "ԅԅ", "ᕙᕗ", "٩و" ]
		, "rarms":  [ "∩⊃", "૭૭", "っっ", "づづ", "ノノ", "ɔɔ" ]
		, "cheeks": [ "*", "●", "✿", "｡", "๑", "o"]

	}

	constructor() {
		this.generic = Emojical.BITS.sides[0]
		for (let i = 0 ; i < 5 ; i++) Emojical.BITS.sides.push(this.generic)
		this.earChance = .2
		this.larmChance = .1
		this.rarmChance = .1
		this.cheekChance = .2
	}
	
	main(args) {
		for (let i = 0 ; i < 12 ; i++ ) {
			console.log(new Array(10).fill(0).map(_=>this.randomFace()).join("   "))
		}
	}

	randomFace() {
		const face = []
		const sides = this.pick(Emojical.BITS.sides)
		const eyes = this.pick(Emojical.BITS.eyes)
		const mouth = 3 == eyes.length ? eyes[1] : this.pick(Emojical.BITS.mouths)
		const ears = (Math.random() < this.earChance && this.generic === sides) ? this.pick(Emojical.BITS.ears) : null
		const larms = (!ears && Math.random() < this.larmChance) ? this.pick(Emojical.BITS.larms) : null
		const rarms = (!ears && !larms && Math.random() < this.rarmChance) ? this.pick(Emojical.BITS.rarms) : null
		const cheek = 3 != eyes.length && Math.random() < this.cheekChance ? this.pick(Emojical.BITS.cheeks) : null
		const lcheek = cheek && Math.random() < .5 ? cheek : null
		const rcheek = cheek && Math.random() < .5 ? cheek : null

		for (const a of [ears, larms, sides, rarms, lcheek, eyes]) {
			this.first(face, a)
		}
		face.push(mouth)
		for(const a of [ eyes, larms, rcheek, sides, ears, rarms]) {
			this.last(face, a)
		}
		return face.join('');
	}

	pick(a) {
		return a[Math.floor(Math.random() * a.length)]
	}

	first(f, a) {
		if (a) f.push(a[0])
		return f
	}

	last(f, a) {
		if (a) f.push(a[a.length - 1])
		return f
	}
};

new Emojical().main(process.argv.slice(2));
