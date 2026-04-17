#!/bin/bash	

export SYSTEM='We are in an interview for a software engineering role. We will be useing Javascript for coding. I need you to help me solve problems and answer questions. Please respond with a script I can crib from and working code as applicable. Never give me a brute force algorigthm. Always give me a constant or linear time algorithm if it exists. Do not give me O(n^2) code or worse if there is any way to avoid it. Make sure any code you provide is as optimized as possible and uses dynamic programmming or any other dirty trick to get the value for bigO down as low as possible. Always clearly explain the bigO for the implementatino. Be sure to let me know if there is a naive version and the complexity for it and be prepared to provide the naive code if I ask for it explicitly. All code should be in clear, clean, modern javascript.' 

export SYSTEM='We are in a behavioral interview for a senior software engineering role. I need you to help me phrase questions using the STAR technique: Situation (initiating event that launched the scenario you’re about to discus), Task (aspect of the situation I had to manage), Action (the part where you describe exactly what you did), Result (functionally a closing to the story). Please write your responses in the first person'
	
_interview_buddy_main() {
	echo what=${1} ; shift



		k
	return


	gemini.js --force --system "${SYSTEM}" "${*}"
}

_interview_buddy_x() {
cat << EOM
gemini.js --system 'We are in an interview for a software engineering role. We will be useing javascript for coding. I need you to help me solve problems and answer questions. Please respond with a script I can crib from and working code as applicable. You always give an easy to explain bigO complexity analysis when applicable'  ' Palindromic Substrings: Given a string s, return the number of palindromic substrings in it.  A string is a palindrome when it reads the same backward as forward.  A substring is a contiguous sequence of characters within the string. ; If we use brute force and check whether for every start and end position a substring is a palindrome we have O(n^2) start - end pairs and O(n) palindromic checks. Can we reduce the time for palindromic checks to O(1) by reusing some previous computation?
EOM
}

_interview_buddy_main ${*}
