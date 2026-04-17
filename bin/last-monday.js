#!/usr/bin/env node 

const SECSIE = 60 * 60 * 1000 * 24;

class LastMonday {
	async main() {
		const start = new Date().getTime();
		for (let ts = start ; ts > start - 7 * SECSIE ; ts -= SECSIE) {
			const date = new Date(ts)
			const day = date.getDay()
			if (1 == day) {
				return this.datesOfTheWeek(ts);
				const s = 'getFullYear getMonth getDate'
					.split(' ')
					.map((m,i)=>(date[m]() + ((1==i)?1:0)).toString().padStart(2,'0'))
					.join('-')
				console.log(s);
				break;
			}
		}
	}

	datesOfTheWeek(start) {
		for (let ts = start, i = 0 ; i < 5 ; i++, ts += SECSIE) {
			console.log(this.dateToString(new Date(ts)))
		}
	}

	dateToString(date) {
		return 'getFullYear getMonth getDate'
			.split(' ')
			.map((m,i)=>(date[m]() + ((1==i)?1:0)).toString().padStart(2,'0'))
			.join('-')
	}
};

new LastMonday().main()
