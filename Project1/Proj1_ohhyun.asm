TITLE Project1 Assignment

; Author: HyunTaek, Oh 
; Last Modified: Oct.22, 2023
; OSU email address: ohhyun@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:       1        Due Date: Oct.22, 2023
; Description: Display sums and differences of three numbers from user input
;				by calculating. 
;				** Extra Credit instructions included
;				1. Introduce the title of this program and my name
;				2. Get Three Input Values from user and Store these value into userInputA, userInputB, userinputC 
;				3. Calculate sums and differences of three values (e.g. A+B, A-B, B+C, B-C, ... , A+B+C)
;				4. Display these results by restating the process of sums and differences
;				5. Say goodbye
;				
;

INCLUDE Irvine32.inc

QuitNumber = 9999

.data
Intro_1			BYTE	"         Elementary Arithmetic     by HyunTaek, Oh",0
Intro_EC		BYTE	"**EC: Program repeats until the user chooses to quit",13,10,
						"**EC: Program checks if numbers are in strictly descending order.",13,10,
						"**EC: Program handles negative results and computes B-A, C-A, C-B, C-B-A",13,10,
						"**EC: Program calculate and display the quotients A/B, A/C, B/C, printing the quotient and remainder",0
Intro_2			BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences.",0
Intro_quit		BYTE	"Typing 9999 to quit",0
DisplayToGet1	BYTE	"First number: ",0
DisplayToGet2	BYTE	"Second number: ",0
DisplayToGet3	BYTE	"Third number: ",0
DisplayError	BYTE	"ERROR: The numbers are not in descending order! Try again", 0
userInputA		DWORD	?
userInputB		DWORD	?
userInputC		DWORD	?
DisplayPlus		BYTE	" + ",0
DisplayMinus	BYTE	" - ",0
DisplayEqual	BYTE	" = ",0
DisplayDiv		BYTE	" / ",0
DisplayDot		BYTE	" ... ",0
sumofAB			DWORD	?
diffofAB		DWORD	?
sumofAC			DWORD	?
diffofAC		DWORD	?
sumofBC			DWORD	?
diffofBC		DWORD	?
SumAllABC		DWORD	?
diffofBA		DWORD	?
diffofCA		DWORD	?
diffofCB		DWORD	?
DiffAllCBA		DWORD	?
divofABQ		DWORD	?
divofACQ		DWORD	?
divofBCQ		DWORD	?
divofABR		DWORD	?
divofACR		DWORD	?
divofBCR		DWORD	?
Goodbye			BYTE	"Thanks for using Elementary Arithmetic!  Goodbye!",0


.code
main PROC
; ----------------------------------------------------------
; 1. Display Program Title and my Name as a Introduction
;		,and show the contents of Extra Credit.
;		Then, Give a instruction to User to follow 
;		as well as display the Quit number to quit 
;
; ----------------------------------------------------------

; Title and My Name
	MOV		EDX, OFFSET Intro_1
	CALL	WriteString
	CALL	Crlf

; Information about Extra Credit 
	MOV		EDX, OFFSET Intro_EC
	CALL	WriteString
	CALL	Crlf

; A Instruction
	MOV		EDX, OFFSET Intro_2
	CALL	WriteString
	CALL	Crlf

; Display a message to quit
_DisplayQuit:
	CALL	Crlf
	MOV		EDX, OFFSET Intro_quit
	CALL	WriteString
	CALL	Crlf

; ----------------------------------------------------------
; 2. Get Three Numbers from user, and Check if these numbers
;		are in strictly descending order. If not, user have to
;		type the first number again. Then, Check if user input
;		is eqaul to Quit number(9999) to quit. If not, just 
;		continue the program. Then, Store these values 
;		into userInputA, userInputB, and userInputC 
;		for calculation
;
; ----------------------------------------------------------

; Get First number (userInput A)
	MOV		EDX, OFFSET DisplayToGet1
	CALL	WriteString
	CALL	ReadDec
	CMP		EAX, QuitNumber
	JE		_sayGoodbye
	MOV		userInputA, EAX

; Get Second number (userInput B)
	MOV		EDX, OFFSET DisplayToGet2
	CALL	WriteString
	CALL	ReadDec
	CMP		EAX, QuitNumber
	JE		_sayGoodbye
	CMP		EAX, userInputA
	JGE		_DisplayError
	MOV		userInputB, EAX

; Get Third number (userInput C)
	MOV		EDX, OFFSET DisplayToGet3
	CALL	WriteString
	CALL	ReadDec
	CMP		EAX, QuitNumber
	JE		_sayGoodbye
	CMP		EAX, userInputB
	JGE		_DisplayError
	MOV		userInputC, EAX
	CALL	Crlf


; ----------------------------------------------------------
; 3. Calculate the Sums and Differences in the order which is 
;		from the Program Description
;		(A+B, A-B, A+C, A-C, B+C, B-C, A+B+C).

;		and Store the results into named variables separately.
;		For example,
;		"sumofAB" variable stores the result of "A+B" 
;		"diffofAB" variable stores the result of "A-B" 
;		"SumAllABC" variable stores the result of "A+B+C" 
;
;		**EC: Calculate B-A, C-A, C-B, C-B-A to handle 
;			   negative results and computes.
;			   with the same order and style like above
;		
;		**EC: Calculate A/B, A/C, B/C and store the results of
;			  the quotients and remainders into each variable
;			  with the same order and style like above
;
; ----------------------------------------------------------

; Store A+B into sumofAB
	MOV		EAX, userInputA
	ADD		EAX, userInputB
	MOV		sumofAB, EAX

; Store A-B into diffofAB
	MOV		EAX, userInputA
	SUB		EAX, userInputB
	MOV		diffofAB, EAX

; Store A+C into sumofAC
	MOV		EAX, userInputA
	ADD		EAX, userInputC
	MOV		sumofAC, EAX

; Store A-C into diffofAC
	MOV		EAX, userInputA
	SUB		EAX, userInputC
	MOV		diffofAC, EAX

; Store B+C into sumofBC
	MOV		EAX, userInputB
	ADD		EAX, userInputC
	MOV		sumofBC, EAX

; Store B-C into diffofBC
	MOV		EAX, userInputB
	SUB		EAX, userInputC
	MOV		diffofBC, EAX

; Store A+B+C into SumAllABC
	MOV		EAX, userInputA
	ADD		EAX, userInputB
	ADD		EAX, userInputC
	MOV		SumAllABC, EAX

; **EC: Store B-A into diffofBA
	MOV		EAX, userInputB
	SUB		EAX, userInputA
	MOV		diffofBA, EAX

; **EC: Store C-A into diffofCA
	MOV		EAX, userInputC
	SUB		EAX, userInputA
	MOV		diffofCA, EAX

; **EC: Store C-B into diffofCB
	MOV		EAX, userInputC
	SUB		EAX, userInputB
	MOV		diffofCB, EAX

; **EC: Store C-B-A into diffofCBA
	MOV		EAX, userInputC
	SUB		EAX, userInputB
	SUB		EAX, userInputA
	MOV		DiffAllCBA, EAX

; **EC: Store A/B quotient into divofABQ
	MOV		EAX, userInputA
	MOV		EBX, userInputB
	MOV		EDX, 0
	DIV		EBX
	MOV		divofABQ, EAX

; **EC: Store A/B remainder into divofABR
	MOV		EAX, EDX
	MOV		divofABR, EAX

; **EC: Store A/C quotient into divofACQ
	MOV		EAX, userInputA
	MOV		EBX, userInputC
	MOV		EDX, 0
	DIV		EBX
	MOV		divofACQ, EAX

; **EC: Store A/C remainder into divofACR
	MOV		EAX, EDX
	MOV		divofACR, EAX

; **EC: Store B/C quotient into divofBCQ
	MOV		EAX, userInputB
	MOV		EBX, userInputC
	MOV		EDX, 0
	DIV		EBX
	MOV		divofBCQ, EAX

; **EC: Store B/C remainder into divofBCR
	MOV		EAX, EDX
	MOV		divofBCR, EAX

; ----------------------------------------------------------
; 4. Display the Addition and Subtraction process 
;		by using User Inputs, and Show the results of them.
;
;		According to Example Execution, 
;		this section should show the three numbers 
;		from User Inputs, the operators such as " + ", " = ",
;		and the results of calculation.
;		
;		this part follows the order from Example Execution.
;		For instance, 
;		20 + 10 = 30		( A + B )
;		20 - 10 = 10		( A - B )
;		20 + 5 = 25			( A + C )
;		20 - 5 = 15			( A - C )
;		10 + 5 = 15			( B + C )
;		10 - 5 = 5			( B - C )
;		20 + 10 + 5 = 35	( A + B + C )
;
;		**EC: Display B-A, C-A, C-B, C-B-A 
;		**EC: Display A/B, A/C, B/C
;				with the same order and style 
;				like Addtion and Subtraction
;			
; ----------------------------------------------------------

; Display "A + B = Sum of A and B"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayPlus
	CALL	WriteString
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, sumofAB
	CALL	WriteDEC
	CALL	Crlf

; Display "A - B = Difference of A and B"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, diffofAB
	CALL	WriteDEC
	CALL	Crlf

; Display "A + C = Sum of A and C"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayPlus
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, sumofAC
	CALL	WriteDEC
	CALL	Crlf

; Display "A - C = Difference of A and C"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, diffofAC
	CALL	WriteDEC
	CALL	Crlf

; Display "B + C = Sum of B and C"
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayPlus
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, sumofBC
	CALL	WriteDEC
	CALL	Crlf

; Display "B - C = Difference of B and C"
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, diffofBC
	CALL	WriteDEC
	CALL	Crlf

; Display "A + B + C = Sum of A,B,and C"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayPlus
	CALL	WriteString
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayPlus
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, SumAllABC
	CALL	WriteDEC
	CALL	Crlf
	CALL	Crlf

; **EC: Display "B - A = Difference of B and A"
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, diffofBA
	CALL	WriteInt
	CALL	Crlf

; **EC: Display "C - A = Difference of C and A"
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, diffofCA
	CALL	WriteInt
	CALL	Crlf

; **EC: Display "C - B = Difference of C and B"
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, diffofCB
	CALL	WriteInt
	CALL	Crlf

; **EC: Display "C - B - A = Difference of C,B, and A"
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayMinus
	CALL	WriteString
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, DiffAllCBA
	CALL	WriteInt
	CALL	Crlf
	CALL	Crlf

; Display "A / B = Division of A and B (Quotient ... Remainder)"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayDiv
	CALL	WriteString
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, divofABQ
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayDot
	CALL	WriteString
	MOV		EAX, divofABR
	CALL	WriteDEC
	CALL	Crlf

; Display "A / C = Division of A and C (Quotient ... Remainder)"
	MOV		EAX, userInputA
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayDiv
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, divofACQ
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayDot
	CALL	WriteString
	MOV		EAX, divofACR
	CALL	WriteDEC
	CALL	Crlf

; Display "B / C = Division of B and C (Quotient ... Remainder)"
	MOV		EAX, userInputB
	CALL	WriteDEC
	MOV		EDX, OFFSET DisplayDiv
	CALL	WriteString
	MOV		EAX, userInputC
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayEqual
	CALL	WriteString
	MOV		EAX, divofBCQ
	CALL	WriteDEC
	MOV		EDX, OFFSET	DisplayDot
	CALL	WriteString
	MOV		EAX, divofBCR
	CALL	WriteDEC
	CALL	Crlf
	CALL	Crlf

; Jump over Error message
	JMP		_sayGoodbye

; Display Error message 
_DisplayError:
	MOV		EDX, OFFSET DisplayError
	CALL	WriteString
	CALL	Crlf
	JMP		_DisplayQuit

; ----------------------------------------------------------
; 5. If user does type Quit number(9999), end the program
;		with goodbye by showing this following sentence,
;		"Thanks for using Elementary Arithmetic!  Goodbye!"
;		, and Close the program by pushing Enter button
;    If not, Repeat the program until typing Quit number
;
; ----------------------------------------------------------

_sayGoodbye:

; Check Quit number
	CMP		EAX, QuitNumber
	JNE		_DisplayQuit
	CALL	Crlf

; Display goodbye
	MOV		EDX, OFFSET Goodbye
	CALL	WriteString
	CALL	Crlf
	
	Invoke ExitProcess,0	; exit to operating system
main ENDP

END main
