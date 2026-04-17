#!/usr/bin/env node 

class PiInUrFace {
	async main() {
		const mx = 99999; // arbitrary
		const primes = this.sieveOfEratosthenes(mx);

		const constants = 'E LN10 LN2 LOG10E LOG2E PI SQRT1_2 SQRT2 TAU'.split(' ');
		Math.TAU = 2. * Math.PI; // :-/

		for (const constant of constants) {
			const value = Math[constant];
			const error = (n,d) => Math.abs(value - (n/d));
			const best = {constant, value, n:0,d:0,e:mx};

			for (const n of primes) for (const d of primes) {
				const e = error(n,d);
				if (e<best.e) {
					best.n = n;
					best.d = d;
					best.e = e;
					//console.log(best);
				}
			}
			console.log(`const float ${constant.padEnd(7)} = ${best.n}. / ${best.d}.; // ${best.e}`);
		}
	}

	sieveOfEratosthenes(n) {
		const isPrime = new Array(n + 1).fill(true);
		isPrime[0] = isPrime[1] = false;

		for (let i = 2; i * i <= n; i++) {
			if (isPrime[i]) for (let j = i * i; j <= n; j += i) isPrime[j] = false;
		}

		return isPrime.map((p,n)=>p?n:null).filter(n=>n);
	}
};

new PiInUrFace().main()
