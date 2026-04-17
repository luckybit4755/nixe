#!/usr/bin/env node 

const fs = require('node:fs').promises
const axios = require('axios')

const minimist = require("minimist")

class DescribeImage {
	async main() {
		const args = minimist(
			process.argv.slice(2), 
			{ 
				default: {
					prompt: 'Describe the image' ,
					url: 'http://aid:11434/api/generate',
				}, 
				alias: {
					prompt:'p',
					url: 'u',
				} 
			}
		)
		if (!args._.length) {
			const u = `usage: describe-image.js [--url ${args.u}][--prompt "${args.p}"] <image> [images]`
			return console.log(u)
		}
			                    
		const headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' }

		for (const filename of args._) {
			const image = (await fs.readFile(filename)).toString('base64')
			const request = JSON.stringify({
				"prompt": args.prompt, 
				"model": "llava", 
				"stream": false, 
				"images": [ image ]
			})

			const response = await axios.post(args.url, request, {headers})
			if (200 != response.status) {
				console.error('oh, snap!', filename, response)
				continue;
			}
			console.log(response.data.response)
		}
	}
};

new DescribeImage().main()
