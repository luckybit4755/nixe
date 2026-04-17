#!/usr/bin/env node

const fs = require('node:fs').promises;
const readline = require('node:readline').promises;
const axios = require('axios');
const minimist = require("minimist");

class PiperTextToSpeech {
	ASK = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
	constructor() {
		this.mini = {
			default: {
				prompt: PiperTextToSpeech.ASK,
				url: 'http://p40:5000/',
				voice: 'en_US-amy-medium',
			},
			alias: {
				prompt:'p',
				url: 'u',
				voice: 'v',
			}
		}
	}

	async main() {
		const args = minimist( process.argv.slice(2), this.mini)

		const headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' };
		const text = PiperTextToSpeech.ASK === args.prompt ? await this.readLines() : args.prompt;
		const voice = args.voice;

		console.error('voice is ', voice)
		console.error('text is ', text)

		const request = JSON.stringify({text, voice})

		const response = await axios.post(args.url, request, {headers})

		if (200 == response.status) {
			console.log(response.data.audio);
		} else {
			console.error('oh, snap!', response)
		}
	}

	async readLines(joiner = '\n') {
		return new Promise((resolve,reject)=> {
			const lines = []
			readline.createInterface({input:process.stdin, terminal:false})
				.on('line', line => lines.push(line))
				.on('close', () => resolve(lines.join(joiner)))
		})
	}
};

new PiperTextToSpeech().main()
