#!/usr/bin/env node

const fs = require('node:fs').promises
const readline = require('node:readline').promises
const axios = require('axios')

const minimist = require("minimist")

const SITUATION = 'We are in an interview for a software engineering role.'
const REFRESH = `${SITUATION} I have a lot of experience with Java and I need you to help refresh my memory by providing appropriate facts or examples. I have experience with:`

const LIST_JAVA = 'Spring, SpringMVC, JPA, RabbitMQ, JMS, JDBC, JNI, jUnit, JAXB, and Lucene.'

const LISTS = {
LANG   : 'Java, Node.js, Python, GoLang, C++, PHP',
JAVA   : 'Spring, SpringMVC, JPA, RabbitMQ, JMS, JDBC, JNI, jUnit, JAXB, Maven, Lucene, FreeMarker, Swing',
CLOUD  : 'Docker, Vagrant, VirtualBox, RabbitMQ, ActiveMQ, Kafka, Terraform, EC2, Hadoop, OpenTSDB, Cassandra',
ETC    : 'Linux, Ubuntu, Debian, Bash, awk, make, jenkins, Confluence, git, maven, MediaWiki, Nginx, HTML, CSS, GraphViz, JavaScript, NoVNC, ExaBGP',
DB     : 'MySQL, PostgreSQL, Oracle, DB2, Sybase, SQL Server, Lucene, JackRabbit (JCR), Hadoop, OpenTSDB, LDAP, Cassandra',
CON    : 'Glassfish, Tomcat, Rhapsody, Jetty',
}

const TECH = (() => { const s = new Set(); for (const v of Object.values(LISTS)) for(const t of v.split(',').map(s=>s.trim())) s.add(t); return Array.from(s).join(', '); })();

const SYSTEMS = {
	'resume' : "You are an expert in technical writing specializing in resumes. I'm a experienced developer with over 25 years in the industry writing backends in Java, C, C++, PHP and Python and a lot more. I will provide sections from my resume and you will give me alternative improved versions of the section. You do not provide additional content or a completed resume.",
	'code'   : "${SITUATION} We will be using javascript for coding. I need you to help me solve problems and answer questions. Please respond with a script I can crib from and working code as applicable. You always give an easy to explain bigO complexity analysis when applicable. If there is a naive approach, describe it briefly but focus on the most optimized solution",
	'java'   : `${REFRESH}: ${LISTS.JAVA}`,
	'cloud'  : `${REFRESH}: ${LISTS.CLOUD}`,
	'all'    : `${REFRESH}: ${TECH}`,
	'buddy'  : "You are an expert in code analysis and generation. I ask you questions about code and issues and you help to pin point the problem, create, implement and test solutions. You are passionate about best practices and creating exemplary software. Your examples are in Javascript.",
	'html'   : 'You are an expert at reading code and project descriptions and generating compelling descriptions and explanations. You do not comment about it being code and your write the descriptions as though you are the author. You descriptions will go on the internet for potential users to read so do not write them with me as the intended audience.',
	'summary': 'You are note keeping assistant! I give you a bulletted list of notes and you write a brief 1-2 sentence summary I can present in my daily standup.'

};

class AskOllama {
	ASK = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
	constructor() {
		AskOllama.SYSTEMS = SYSTEMS; // ???

		this.mini = {
			default: {
				prompt: AskOllama.ASK,
				url: 'http://aid:11434/api/generate',
				model: 'llama3',
				//model: 'phi4',
				system: 'code',
			},
			alias: {
				prompt:'p',
				url: 'u',
				system: 's',
				model: 'm',
			}
		}
	}

	async main() {
		const args = minimist( process.argv.slice(2), this.mini)

		const headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' };
		const prompt = AskOllama.ASK === args.prompt ? await this.readLines() : await this.getPrompt(args.prompt);
		const system = args.system in AskOllama.SYSTEMS ? AskOllama.SYSTEMS[args.system] : await this.getPrompt(args.system);

		const stream = false
		const model = args.model

		const request = JSON.stringify({prompt, system, model, stream})
		//console.error('----------------------------------------------------------------------------------------');
		//console.error(request);
		//console.error('----------------------------------------------------------------------------------------');

		const response = await axios.post(args.url, request, {headers})
		if (200 == response.status) {
			console.log(response.data.response)
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
		return lines
	}

	async getPrompt(prompt) {
		try { 
			await fs.stat(prompt);
			prompt = (await fs.readFile(prompt)).toString()
			//console.error(`read prompt from file: ${prompt}`);
		} catch(e){}
		return prompt;
	}
};

new AskOllama().main()
