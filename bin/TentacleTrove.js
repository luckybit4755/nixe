#!/usr/bin/env node 

const fs = require('fs').promises; // Use fs.promises for async/await
const readline = require('readline')
const { createHash } = require('crypto')
const axios = require('axios')
const { exec } = require('child_process');

module.exports = class TentacleTrove {
	// https://stackoverflow.com/questions/3115150/how-to-escape-regular-expression-special-characters-using-javascript
	static escapeRegex(text) {
  		return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
	}
/*
 const TentacleTrove = require('./TentacleTrove')
for (const f in await TentacleTrove.searchFiles('./bin/', ['fun'])) console.log(f)
*/

	static async searchFiles(
		dirPath, 
		searchStrings, 
		afterLine = 0, 
		filePattern = /\.(py|js|go|c|cpp|sh)$/,
		callback = TentacleTrove.findMatchesInFile // (filePath, searchStrings, afterLine) => TentacleTrove.findMatchesInFile(filePath, searchStrings, afterLine)
	) {
		return { async *[Symbol.iterator](){
			const directories = [dirPath]
			while (directories.length) {
				current = directories.shift()

				const files = await fs.readdir(current);
				for (const file of files) {
					const filePath = path.join(current, file);
					const stats = await fs.stat(filePath); // Get file stats asynchronously

					if (stats.isDirectory()) {
						directories.push(filePath)
						//const subdirResults = await TentacleTrove.searchFiles(filePath, searchStrings, afterLine); // Recursively search subdirectoriesI
						//results.push(...subdirResults); // Add subdirectory results
					} else if (stats.isFile() && filePattern.test(filePath)) {
						//const fileResults = await callback(filePath, searchStrings, afterLine);
						//results.push(...fileResults); // Add file-specific results
						yield(await callback(filePath, searchStrings, afterLine))
					}
				}
			}
		}} // symbol
	}

	static async findMatchesInFile(filePath, searchStrings, afterLine) {
		try {
			const data = await fs.readFile(filePath, 'utf8'); // Read file content asynchronously
			const lines = data.split('\n');
			return Fart.handleLines(lines, filePath, searchStrings, afterLine)

		} catch (err) {
			console.error('Error reading file:', filePath, err);
		}
	}

	static handleLines(lines, filePath, searchStrings, afterLine) {
		const results = [];
		let lineNumber = 1;
		let matched = null;
		let matchedOn = 0;
		let blanked = 0;

		for (const line of lines) {
			const trimmed = line.trim();
			const isBlank = (0 == trimmed.length);
			lineNumber++;

			if (matched) {
				if (lineNumber<= matchedOn + afterLine) {

					if (isBlank) {
						blanked++
					} else {
						blanked = 0
					}
					matched.push(line);/// + (isBlank ? `<<< BLANK: ${blanked} and ${matched.length}` : ''));

					if (blanked>=2) {
						matched = null;
					}
				} else {
					matched = null;
				}
				continue;
			}
			if (searchStrings.every(str => line.includes(str))) {
				matchedOn = lineNumber;
				blanked = 0;
				matched = [line];
				results.push({ file: filePath, lineNumber, text: trimmed, matched });
			}
		}

		return results;
	}

	static *quoting(line, debug = false) {
		const firstQuote = line.indexOf('"');
		if (-1 == firstQuote) return;

		if (debug) console.log(line);

		let started = -1;
		for (let i = firstQuote ; i < line.length ; i++ ) {
			const c = line[i];
			switch(c) {
				case '\\': i++; break;
				case '"':
					if (started >0) {
						const ended = i - 1;
						const s = line.substring(started, ended + 1);
						if (debug) console.log('from', started, 'to', ended,'->', s);
						yield s;
						started = -1;
					} else {
						started = i + 1;
					}
			}
		}
	}

	// don't remember...
	static chopo(o, max = 33) {
		switch(typeof(o)) {
			case 'string': return o.length < max ? o : (o.substring(0,max) + '[...]')
			case 'object':
				if (Array.isArray(o)) {
					const a = []
					for(const v of o) a.push(Rimmer.chopo(v, max))
					return a
				}
				const p = {}
				for(const [k,v] of Object.entries(o)) {
					p[k] = Rimmer.chopo(v, max)
			   	}
				return p
			default: return o
		}
	}


	static onWord(word) {
		const allLower = /^[a-z0-9]+$/.test(word);
		word = word.replace(/-/g, '_')
		if (-1 == word.indexOf('_') & !allLower) {
			Fart.onCamel(word);
		} else {
			Fart.onSnake(word);
		}
	}

	static onSnake(snake) {
		console.log(TentacleTrove.snakeToCamel(snake));
	}

	static onCamel(camel) {
		console.log(TentacleTrove.camelToSnake(camel));
	}

	static snakeToCamel(snake, firstCamel = false) {
		return snake
			.replace(/-/g, '_')
			.split('_')
			.map((s,i)=> TentacleTrove.camelUp(s,i, firstCamel))
			.join('');
	}
	
	static camelUp(word, index, firstCamel) {
		return (index||firstCamel) 
			? word.substring(0,1).toUpperCase() + word.substring(1).toLowerCase()
			: word
	}

	static camelToSnake(camel) {
		return camel.replace(/([A-Z])/g, '_$1').toLowerCase().replace(/^_/, '' )
	}

	static async fileExists(filename) {
		try {
			return await fs.stat(filename)
		} catch (e) {
			return false
		}
	}


	static async *readLines() {
		const rl = readline.createInterface({
			input: process.stdin,
			terminal: false
		});

		for await (const line of rl) {
			yield line;
		}

		rl.close();
	}

};
