#!/usr/bin/env node 

import report from "puppeteer-report";
import puppeteer from "puppeteer";

class HtmlToPdf {

	async main() {
		if (4 !== process.argv.length) {
			return usage()
		}

		const html = `file://${process.argv[2]}`
		const path =  process.argv[3]

		if (html.endsWith('.html') && path.endsWith('.pdf')) {
			console.log(`>> INPUT  ${html}`)
			console.log(`>> OUTPUT ${path}`)
		} else {
			return usage()
		}

		const browser = await puppeteer.launch({
			args: ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage"],
		});

		try {
			const page = await browser.newPage();
			await page.goto(html)
			const m = '20mm'
			const margin = { bottom: m, left: m, right: m, top: m, }
			const format = 'letter' // a4?
			await report.pdfPage(page, { path, format, margin });
		} finally {
			await browser.close();
		}
	}
	
	usage() {
		console.error("usage: html-to-pdf.js <file.html> <file.pdf>")
		process.exit(1)
	}
};

new HtmlToPdf().main()
