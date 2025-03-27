TITLE String Primitives & Marcros     (Proj6_ohhyun.asm)

; Author: HyunTaek Oh
; Last Modified: Dec. 10, 2023
; OSU email address: ohhyun@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:        6         Due Date: Dec. 10, 2023
; Description:		1. Get 10 intergers from user 
;					2. Store the numeric values of them into memory
;					3. Print the contents of array
;					4. Display sum
;					5. Display truncated average

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGenerateString
;
; Get string value from user. Then, store it into inputBuffer(array)
;
; Receives:
; buffer		= address of message(prompt)
; inputBuffer	= address of an array 
; maxInputCount = Max size of buffer
; inputLength	= Length of user input
;
; returns: inputBuffer = generated string address
; ---------------------------------------------------------------------------------

mGetString	MACRO	buffer, inputBuffer, maxInputCount, inputLength

	PUSH	EDX
	PUSH	ECX
	PUSH	EAX

	mDisplayString	buffer

	MOV		EDX, inputBuffer		; location to store data
	MOV		ECX, maxInputCount		; max buffer size
	CALL	ReadString
	MOV		inputLength, EAX
	
	POP		EAX
	POP		ECX
	POP		EDX
ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Display string array
;
; Receives:
; buffer		= address of message(prompt)
;
; ---------------------------------------------------------------------------------

mDisplayString	MACRO	buffer

	PUSH	EDX					; Save the previous value of EDX register

	MOV		EDX, buffer
	CALL	WriteString

	POP		EDX					; Restore the previous value of EDX register

ENDM


; Constant 
LO				=	-2147483648
HI				=	2147483647
ASCII_0			=	48
ASCII_9			=	57
ASCII_pos		=	43
ASCII_neg		=	45
ASCII_enter		=	0
ASCII_space		=	32
maxBuffer		=	11
maxNumLength	=	10


.data
Intro1			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",13,10,
						"Written by: HyunTaek Oh",0
Intro2			BYTE	"Please provide 10 signed decimal integers.",13,10,
						"Each number needs to be small enough to fit inside a 32 bit register. After you have",13,10,
						"finished inputting the raw numbers I will display a list of the integers, their sum, and",13,10,
						"their average value.",0
inputArray		BYTE	maxNumLength DUP(?)
numsArray		SDWORD	maxNumLength DUP(?)
userNum			SDWORD	?
userInputLen	DWORD	?
signCheck		DWORD	?
outString		BYTE	1 DUP(?)
sum				SDWORD	?
avg				SDWORD	?
msgGetNum		BYTE	"Please enter a signed number: ",0
msgTryAgain		BYTE	"Please try again: ",0
msgError		BYTE	"ERROR: You did not enter a signed number or your number was too big.",0
msgResultNum	BYTE	"You entered the following numbers: ",0
msgSum			BYTE	"The sum of these numbers is: ",0
msgTruncAvg		BYTE	"The truncated average is: ",0
goodbye			BYTE	"Thanks for playing!",0


.code
main PROC

	mDisplayString	OFFSET Intro1				; Title & Name
	CALL	Crlf
	CALL	Crlf

	mDisplayString	OFFSET Intro2				; Program introduction
	CALL	Crlf
	CALL	Crlf

	MOV		ECX, maxNumLength					; loop count for 10 integers 
	MOV		EBX, 0								; For managing address

_loopforGetNum:									; Get user input 10 times
	PUSH	EBX
	PUSH	OFFSET signCheck
	PUSH	OFFSET userInputLen	
	PUSH	OFFSET numsArray		
	PUSH	OFFSET msgError					
	PUSH	OFFSET inputArray
	PUSH	OFFSET msgGetNum	
	CALL	ReadVal								

	ADD		EBX, 4								; To increase the address of an array that has numeric values
	LOOP	_loopforGetNum						; Loops until getting 10 integers

_DisplayNumbers:
	CALL	Crlf
	mDisplayString	OFFSET  msgResultNum		
	CALL	Crlf

	PUSH	OFFSET	outString
	PUSH	OFFSET	numsArray
	CALL	DisplayNumbers						; Display whole values in numeric array
	
	CALL	Crlf
	CALL	Crlf

_Calculate_Display_Sum:
	PUSH	OFFSET sum
	PUSH	OFFSET numsArray
	CALL	CalculateSum						; Calculate sum of numeric values

	mDisplayString	OFFSET	msgSum
	PUSH	OFFSET outString
	PUSH	sum
	CALL	WriteVal							; Print sum
	CALL	Crlf

_Calculate_Display_Avg:
	PUSH	OFFSET avg
	PUSH	sum
	CALL	CalculateAverage					; Calculate average of whole values in numveric array

	mDisplayString	OFFSET msgTruncAvg			
	PUSH	OFFSET outString
	PUSH	avg
	CALL	WriteVal							; Print truncated average

	CALL	Crlf
	CALL	Crlf

_sayGoodbye:
	mDisplayString	OFFSET goodbye				; Thanks

	Invoke ExitProcess,0	
main ENDP

; -------------------------------------------------------------------------------------------
; Name: ReadVal
;
; Invoke mGetstring and get integer values from user. Then Convert the value into
;	numeric one. Store this one value in a memory.
;
; Receives:
;	[EBP+8]		=	Message to get number from user
;	[EBP+12]	=	Address of input array
;	[EBP+16]	=	Message to show error
;	[EBP+20]	=	Address of an array to store numeric values
;	[EBP+24]	=	Length of user input
;	[EBP+28]	=	To check negative value
;	[EBP+32]	=	To increase index
;
; Return:
;	numsArray	= (SWORD) numeric value array 
;	
; --------------------------------------------------------------------------------------------
ReadVal PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDI
	PUSH	ESI

	MOV		EBX, 0
	MOV		ESI, [EBP+12]
	MOV		EDI, [EBP+20]
	MOV		EBX, [EBP+32]
	ADD		EDI, EBX

_getNumber:
	MOV		EAX, 0
	MOV		[ESI], EAX

	mGetString	[EBP+8], [EBP+12], maxBuffer, [EBP+24]

	MOV		ECX, [EBP+24]
	MOV		EBX, 0
	MOV		[EBP+28], EBX			; Reset negative Checker

_check_sign:
	LODSB
	CMP		AL, ASCII_pos
	JE		_posSign
	CMP		AL, ASCII_neg
	JE		_negSign
	JMP		_checkValid

_negSign:
	PUSH	EBX
	MOV		EBX, 1
	MOV		[EBP+28], EBX
	POP		EBX
	DEC		ECX
	JMP		_forward

_posSign:
	DEC		ECX

_forward:
	CLD
	LODSB
	JMP		_checkValid

_checkValid:
	CMP		AL, ASCII_enter
	JE		_invalid
	CMP		AL, ASCII_space
	JE		_invalid
	CMP		AL, ASCII_0
	JL		_invalid
	CMP		AL, ASCII_9
	JG		_invalid
	JMP		_accumulate

_invalid:
	mDisplayString	[EBP+16]
	CALL	Crlf
	POP		ECX
	MOV		EBX, 0
	MOV		[EDI], EBX
	JMP		_getNumber

_accumulate:
	MOV		EBX, [EDI]

	PUSH	EAX
	PUSH	EBX
	MOV		EAX, EBX
	MOV		EBX, 10
	MUL		EBX
	MOV		[EDI], EAX
	POP		EBX
	POP		EAX

	SUB		AL, ASCII_0
	ADD		[EDI], AL

	LOOP	_forward

	PUSH	EAX
	MOV		EAX, [EBP+28]
	CMP		EAX, 1
	JE		_negate
	JMP		_end

_negate:
	MOV		EAX, [EDI]
	NEG		EAX
	MOV		[EDI], EAX

_end:
	POP		EAX
	POP		ESI
	POP		EDI
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		28

ReadVal ENDP

;---------------------------------------------------------------------------------------------
; name: WriteVal 
;
; Displays previous string values ( numeric integers -> string integers )
;
; Postconditions:	outString will be modified
;
; Receives: 		
;	[EBP+8]		=	numsArray	
;	[EBP+12]	=	outString address
;
;----------------------------------------------------------------------------------------------
WriteVal PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDI
	PUSH	EDX

	MOV		EDI, [EBP + 12]			; outString address
	MOV		EAX, [EBP + 8]			; number to write to outString

_checkSign:
	CMP		EAX, 0
	JL		_negate
	JMP		_pushNullBit
	CLD

_negate:
	PUSH	EAX
	MOV		AL, 45
	STOSB	
	mDisplayString	[EBP + 12]

	DEC		EDI					; Move back to beginning of string (address)
		
	POP		EAX
	NEG		EAX					; convert to positive int

_pushNullBit:
	PUSH	0

_asciiConversion:

	MOV		EDX, 0
	MOV		EBX, 10
	DIV		EBX
		
	MOV		ECX, EDX
	ADD		ECX, 48
	PUSH	ECX
	CMP		EAX, 0
	JE		_popAndPrint
	JMP		_asciiConversion

_popAndPrint:
	POP		EAX

	STOSB
	mDisplayString	[EBP + 12]
	DEC		EDI				; Move back to display again

	CMP		EAX, 0
	JE		_exitAsciiConversion
	JMP		_popAndPrint

_exitAsciiConversion:
	MOV		AL, ASCII_space
	STOSB
	mDisplayString	[EBP + 12]
	DEC		EDI				; Move back to reset for next use 
	
	POP		EDX
	POP		EDI
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP

	RET		8

WriteVal ENDP

;---------------------------------------------------------------------------------------------
; name: DisplayNumbers
;
; By using loops, Find SDWORD numbers array and Call WriteVal to display these numbers
;
; Precondition:		SDWORD array should be filled.
;
; Receives: 		
;	[EBP+8]		=	numsArray	
;	[EBP+12]	=	outString address
;
;----------------------------------------------------------------------------------------------
DisplayNumbers PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	ESI
	PUSH	EDI
	PUSH	ECX

	MOV		ESI, [EBP + 8]			; numeric array
	MOV		EDI, [EBP + 12]			; outString
	MOV		ECX, maxNumLength

_printNumber:
	PUSH	EDI
	PUSH	[ESI]
	CALL	WriteVal
	ADD		ESI, 4
	LOOP	_printNumber

_end:
	POP		ECX
	POP		EDI
	POP		ESI
	POP		EBP	
	RET		8

DisplayNumbers ENDP

;---------------------------------------------------------------------------------------------
; name: CalculateSum
;
; For the calculation of sum
;
; Precondition:		SDWORD array should be filled.
;
; Receives: 		
;	[EBP+8]		=	numsArray	
;	[EBP+12]	=	sum
;
; Returns:
;	sum			=	the result of sum
;
;----------------------------------------------------------------------------------------------
CalculateSum PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	ESI
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX

	MOV		ESI, [EBP + 8]			; numeric array
	MOV		ECX, maxNumLength

	MOV		EAX, 0

_sumNumbers:
	ADD		EAX, [ESI]
	ADD		ESI, 4
	LOOP	_sumNumbers

	MOV		EBX, [EBP + 12]
	MOV		[EBX], EAX

_end:
	POP		ECX
	POP		EBX
	POP		EAX
	POP		ESI
	POP		EBP
	
	RET		8

CalculateSum ENDP

;---------------------------------------------------------------------------------------------
; name: CalculateAverage
;
; For the calculation of average
;
; Precondition:		sum should have a value
;
; Receives: 		
;	[EBP+8]		=	sum	
;	[EBP+12]	=	avg
;
; Returns:
;	avg			=	the result of average
;
;----------------------------------------------------------------------------------------------
CalculateAverage PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	ECX
	PUSH	EAX
	PUSH	EBX

	MOV		ECX, maxNumLength
	MOV		EAX, [EBP + 8]					
	
_divide:
	MOV		EBX, maxNumLength
	MOV		EDX, 0
	CDQ
	IDIV	EBX

	MOV		EBX, [EBP + 12]					
	MOV		[EBX], EAX

_end:
	POP		EBX
	POP		EAX
	POP		ECX
	POP		EBP

	RET		8

CalculateAverage ENDP


END main

