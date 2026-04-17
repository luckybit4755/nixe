#!/usr/bin/env node 

const fs = require('node:fs').promises
const readline = require('readline')
const axios = require('axios')
const minimist = require("minimist")

class A111Image {
	ASK = 'Put your prompt here, please!'

	async main() {
		const now = new Date()
		const ts = 'FullYear Month Date Minutes Seconds Milliseconds'
			.split(' ')
			.map((w,i)=>now[`get${w}`]() + (1==i?i:0)).join('-')
		const file = `/tmp/a1111-image-${ts}.png`

		const options = { 
			default: {
				prompt: A111Image.ASK,
				negative: 'blurry, watermark, out of focuse, cropped, missing limbs, extra limbs, ugly, waifu, hentai',
				steps: 33,
				width:960,
				height: 540,
				url: 'http://aid:7860/sdapi/v1/txt2img',
				file
			}, 
			alias: {},
		}

		for(const [k,v] of Object.entries(options.default)) {
			options.alias[k] = k.charAt(0);
		}

		const args = minimist(process.argv.slice(2), options)
		if (false) {
			const u = `usage: a111-image.js [--url ${args.u}][--prompt "${args.p}"] <image> [images]`
			return console.error(u)
		}
			                    
		const headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' }

		const prompt = A111Image.ASK === args.prompt ? await this.readLines() : await this.getPrompt(args.prompt);
		console.error('=======================================================')
		console.error(prompt)
		console.error('=======================================================')

		const request = JSON.stringify({
			prompt,
			negative: args.negative, 
			steps: args.steps,
			width: args.width,
			height: args.height,
		});

		const response = await axios.post(args.url, request, {headers})
		if (200 != response.status) {
			console.error('oh, snap!', args.filename, response)
			exit(33);
		}

		console.error('wait for it...');
		const image = Buffer.from(response.data.images[0], 'base64')
		await fs.writeFile(args.file, image);
		console.log(args.file)
	}

	async readLines(joiner = '\n') {
		return new Promise((resolve,reject)=> {
		const lines = []
		readline.createInterface({input:process.stdin, terminal:false})
		.on('line', line => lines.push(line))
		.on('close', () => resolve(lines.join(joiner)))
		})
		return lines
	}

    async getPrompt(prompt) {
        try {
            await fs.stat(prompt);
            prompt = (await fs.readFile(prompt)).toString()
        } catch(e){}
        return prompt;
    }
};

new A111Image().main()
