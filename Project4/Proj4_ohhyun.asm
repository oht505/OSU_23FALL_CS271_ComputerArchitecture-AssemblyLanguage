TITLE Program Template     (template.asm)

; Author: HyunTaek, Oh
; Last Modified: Nov. 19, 2023
; OSU email address: ohhyun@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:        4         Due Date: Nov. 19, 2023
; Description: Display title, name and instruction. Get a number from user [1-4000] inclusive 
;				and use it as a counter of the number of prime numbers
;              Display these prime numbers with empty space (at least 3 digits), and then
;			   check the number of data in  a line whether it is equal to 10 or not.
;			   if it is equal to 10, move to next line. Plus, count the number of row when 
;			   the line moves to next one to print "Press any key to continue ...".
;			   After that, Display closing comment and name
;			   

INCLUDE Irvine32.inc


lowerLimit	= 1
upperLimit	= 4000
maxColCount	= 10
maxRowCount	= 20
Check2digit	= 10			
Check3digit	= 100
Check4digit	= 1000
Check5digit	= 10000

.data
Intro			BYTE	"Prime Numbers Programmed by HyunTaek, Oh",0
Instruction		BYTE	"Enter the number of prime numbers you would like to see.",10,13,
						"I'll accept orders for up to 4000 primes.",10,13,
						" ", 10,13,
						" ** EC1: Align the output columns (the first digit of each number on a row should match with the row above).", 10,13,
						" ** EC2: Extend the range of primes to display up to 4000 primes. shown 20 rows of primes per page.",0
msgGetNumber	BYTE	"Enter the number of primes to display [1 ... 4000]: ",0
InvalidNum		BYTE	"No primes for you! Number out of range. Try again.",0
userInputN		DWORD	?
validFlag		DWORD	?
emptySpace7		BYTE	"       ",0
emptySpace6		BYTE	"      ",0
emptySpace5		BYTE	"     ",0
emptySpace4		BYTE	"    ",0
emptySpace3		BYTE	"   ",0
primeFlag		DWORD	?
currNum			DWORD	?
columnCounter	DWORD	?
rowCounter		DWORD	?
msgContinue		BYTE	"Press any key to continue ...",0
Goodbye			BYTE	"Results certified by HyunTaek, Oh. Goodbye. ",0

.code
; -------------------------------------------------------------------------------
;	Name: Main
;
;	The main procedure consists of 4 calls: Introduction, getUserData, showPrimes,
;	and farewell. It starts from Introduction to farewell in a row.
;
;---------------------------------------------------------------------------------

main PROC

	CALL	Introduction
	CALL	getUserData
	CALL	showPrimes
	CALL	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -------------------------------------------------------------------------------
;	Name: Introduction
;
;	Introduction procedure shows Title and Name first, and then display
;   instruction and Extra Credit comments.
;
;---------------------------------------------------------------------------------

Introduction PROC
; Introduction - Title
	MOV		EDX, OFFSET Intro				; Title and Name			
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf

; Introduction - Instruction 
	MOV		EDX, OFFSET Instruction			; Instruction & ECs
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf

_end:
	RET
Introduction ENDP

; -------------------------------------------------------------------------------
;	Name: getUserData
;
;	Get a number from user, which is used for counting the number of prime numbers
;   a number would be stored into 'userInputN' variable, and then the number will
;	be checked by validate procedure that the number is in a range(1 ~ 4000)
;
;---------------------------------------------------------------------------------
getUserData PROC

_getNumber:
; Get number 'n' from users
	MOV		EDX, OFFSET msgGetNumber		; message for getting a number from user
	CALL	WriteString

	CALL	ReadInt
	MOV		userInputN, EAX					; Store the number into 'userinputN' variable 

	CALL	validate						; To check the number valid, call validate
	CMP		validFlag, 0					; If validFlag==0, which means it is not in valid range
	JE		_getNumber						; Try to get a new number for range

	CALL	Crlf

_end:
	RET

getUserData ENDP

; -------------------------------------------------------------------------------
;	Name: validate
;
;	Check the user input value valid  [1 <= user input <= 4000]
;	
;	Receives: userInputN is how many prime numbers need.
;
;	Returns: validFlag is used for checking user input.
;			 if valifFlag is equal to 1, the number is valid and move next step.
;			 if not, clear the validFlag to get re-enter the number of primes
;
;	** EC2: Extend the range of prime numbers from 200 to 4000. 
;---------------------------------------------------------------------------------
validate PROC
; Check the number valid if it is in a range
	CMP		userInputN, lowerLimit				; Check N < 1
	JL		_msgError
	CMP		userInputN, upperLimit				; Check N > 4000
	JG		_msgError

	MOV		validFlag, 1						; If valid, flag = 1
	JMP		_end								

_msgError:
; Display error message if it is out of range
	MOV		EDX, OFFSET InvalidNum
	CALL	WriteString
	CALL	Crlf
	
	MOV		validFlag, 0						; If not valid, flag = 0

_end:
	RET

validate ENDP

; -------------------------------------------------------------------------------
;	Name: showPrimes
;
;	Get the return boolean value from the "isPrime" procedure, and if the number is 
;	a prime number, display that number with empty space (from 3~7, depending on digits)
;	Then, check the number of column values. If the number is equal to 10, move the cursor
;	from the end of line to next line. Moreover, if the number of rows is equal to 20, 
;	print a continue message for separating.
;
;	Preconditions: if primeFlag is equal to 1, the number is prime, so print it
;				   if not, skip the process of printing.
;	
;	Receives:	Get the return boolean value from isPrime procedure
;
;	** EC1: Align the output columns
;	** EC2: show 20 rows of prime numbers and print "Press any key to continue"
;---------------------------------------------------------------------------------
showPrimes PROC
; Display results of prime numbers
	MOV		ECX, userInputN				; Use ECX for Loop Count
	MOV		primeFlag, 0				; initialize primeflag
	MOV		currNum, 1				
	MOV		columnCounter, 0			; for counting the number of data in a line
	MOV		rowCounter, 1				; for counting the number of rows 

_loopForPrime:
	INC		currNum						; Start from 2.
	CALL	isPrime						; to check the value of currNum is Prime number.
	CMP		primeFlag, 1				; if it is a prime number, prepare for printing
	JE		_printPrime

	JMP		_loopForPrime				; if not, skip the process of printing

_printPrime:
	INC		columnCounter				
	MOV		EAX, currNum
	CALL	WriteDec

; **EC1: By using empty spaces, Align the output columns
	CMP		EAX, Check2digit			; if the number is less than 10, print 7 empty digit spaces
	JL		_emptySpace7
	CMP		EAX, Check3digit			; if the number is less than 100, print 6 empty digit spaces
	JL		_emptySpace6
	CMP		EAX, Check4digit			; if the number is less than 1000, print 5 empty digit spaces
	JL		_emptySpace5
	CMP		EAX, Check5digit			;i f the number is less than 10000, print 4 empty digit spaces
	JL		_emptySpace4

	JMP		_emptySpace3				; if the number is more than 10000, print 3 empty digit spaces

_countContent:
	MOV		EAX, columnCounter
	CMP		EAX, maxColCount			; if data count is equal to 10, move to next line
	JGE		_jumpLine

_returnForLoop:
	LOOP	_loopForPrime				; If the prime number to print left, Loop again.
	JMP		_end

_emptySpace7:
	MOV		EDX, OFFSET emptySpace7		; Print 7 digit empty spaces
	CALL	WriteString
	JMP		_countContent

_emptySpace6:
	MOV		EDX, OFFSET emptySpace6		; Print 6 digit empty spaces
	CALL	WriteString
	JMP		_countContent

_emptySpace5:
	MOV		EDX, OFFSET emptySpace5		; Print 5 digit empty spaces
	CALL	WriteString
	JMP		_countContent

_emptySpace4:
	MOV		EDX, OFFSET emptySpace4		; Print 4 digit empty spaces
	CALL	WriteString
	JMP		_countContent

_emptySpace3:
	MOV		EDX, OFFSET emptySpace3		; Print 3 digit empty spaces
	CALL	WriteString
	JMP		_countContent	

_jumpLine:
	CALL	Crlf
	MOV		columnCounter, 0			
	INC		rowCounter					; count the number of row
	CMP		rowCounter, maxRowCount		; if rows are equal to 20, print continue
	JG		_printContinue
	JMP		_countContent

_printContinue:
	MOV		EDX, OFFSET msgContinue
	CALL	WriteString
	CALL	Crlf
	MOV		rowCounter, 1				; initialize row counter to 1 if over 20
	JMP		_countContent

_end:
	CALL	Crlf
	RET
showPrimes ENDP

; -------------------------------------------------------------------------------
;	Name: isPrime
;
;	Find out prime numbers. Register EBX serves as a divisor increasing from 2 to currNum. 
;	(currNum is a prime number if it is eligible for having only two factors: 1, 
;    currNum itself)
;
;	Receives: "currNum" is for checking current number.
;				currNum is global variable, so in each iteration, the value increases
;				out of this procedure
;
;	Returns: "primeFlag" is to check that the current value is prime number.
;			  if the value is a prime number, set prime flag to 1 
;			  if not, clear prime flag to 0 
;---------------------------------------------------------------------------------
isPrime PROC
; Check a Prime number
	MOV		EBX, 1				; EBX will be a divisor

_checkPrime:
	INC		EBX
	MOV		EAX, currNum		

; If the number divided by itself
	CMP		EAX, EBX			
	JE		_validPrime

; For dividing, initialize EDX to 0
	MOV		EDX, 0
	DIV		EBX

; If remainder is 0, it is not prime number
	CMP		EDX, 0				; If EDX == 0 (remainder == 0), the number has other factors except 1 or itself.
	JE		_invalidPrime		
	JMP		_checkPrime			; Go up and divide again until reaching the same value of currNum 

_validPrime:
; if prime number, set flag to 1
	MOV		primeFlag, 1
	JMP		_end

_invalidPrime:
; if not prime number, clear flag to 0
	MOV		primeFlag, 0

_end:
	RET

isPrime ENDP

; -------------------------------------------------------------------------------
;	Name: farewell
;
;	Display a closing comment and name.
;
;---------------------------------------------------------------------------------
farewell PROC
; Closing comment - goodbye
	CALL	Crlf
	MOV		EDX, OFFSET Goodbye
	CALL	WriteString
	CALL	Crlf

_end:
	RET
farewell ENDP

END main
