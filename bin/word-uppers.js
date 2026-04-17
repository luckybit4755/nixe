#!/usr/bin/env node 

class word_uppers {
	main(args) {
		require('readline')
			.createInterface({input:process.stdin, terminal:false})
			.on('line', line => this.onLine(line))
		;
	}

	onLine(line) {
		const cz = []
		let b4 = -1
		for(const c of line.split('')) {
			if ((-1 == b4 || /\s/.test(b4)) && /[a-z]/.test(c)) {
				cz.push(c.toUpperCase())
			} else {
				cz.push(c)
			}
			b4 = c
		}
		console.log(cz.join(''))
	}
};

new word_uppers().main(process.argv.slice(2));
