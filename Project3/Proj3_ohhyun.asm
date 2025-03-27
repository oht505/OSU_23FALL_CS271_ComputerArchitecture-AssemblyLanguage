TITLE Program Template     (template.asm)

; Author: Hyun Taek, Oh
; Last Modified: Nov. 05, 2023
; OSU email address: ohhyun@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:       3         Due Date: Nov. 05, 2023
; Description: Get the valid number from user and Show the results of Maximum, Minimum,
;			   sum of valid numbers, and rounded average.
;					** Extra Credit included
;			   1. Display the program title and instruction.
;              2. Get the user's name, and greet the user.
;			   3. Display instructions for the user.
;			   4. Repeatedly prompt the user to enter a number.
;			   5. Calculate the (rounded integer) average of the valid numbers and store in a variable.
;			   6. Display various results and say good bye
;			   

INCLUDE Irvine32.inc

FirstLowerLimit	 = -200
FirstUpperLimit	 = -100
SecondLowerLimit = -50
SecondUpperLimit = -1
ExitNumber		 =	0

.data
Intro1			BYTE	"Welcome to the Integer Accumulator by General Kenobi",0
commentEC		BYTE	" ** EC: Number the lines during user input. Increment the line number only for valid number entries. (1pt)",0
Intro2			BYTE	"We will be accumulating user-input negative integers between the specified bounds, ",13,10,
						"then displaying statistics of the input values including minimum, maximum, ",13,10,
						"and average values, total sums, and total number of valid inputs. ",0
AskName			BYTE	"What is your name? ",0
UserName		BYTE	35 DUP(0)
greeting		BYTE	"Hello there, ",0
Instruction1	BYTE	"Please enter numbers in [-200, -100] or [-50, -1].",13,10,
						"Enter a non-negative number when you are finished, and input stats will be shown. ",0
numberCount		BYTE	". ",0
msgGetNumber	BYTE	"Enter number: ",0
InvalidInput	BYTE	"This is not a number we're looking for (Invalid Input)! ",0
userInput		DWORD	?
msgNoInput		BYTE	"No valid numbers. No calculation.",0
msgForCount1	BYTE	"You entered ",0
msgForCount2	BYTE	" valid numbers. ",0
msgForMax		BYTE	"The maximum vaild number is ",0
msgForMin		BYTE	"The minimum valid number is ",0
msgForSum		BYTE	"The sum of your valid numbers is ",0
msgForRAvg		BYTE	"The rounded average is ",0
maxNumber		DWORD	-200
minNumber		DWORD	-1
sumOfNumbers	DWORD	0
AvgQ			DWORD	?
AvgR			DWORD	?
checkRound		DWORD	-0.51
roundedAvg		DWORD	?
goodbye			BYTE	"We have to stop meeting like this. Farewell, ",0

.code
main PROC
; ----------------------------------------------------------
; 1. Display the program title and instruction.
;		In addition, Show the comment about Extra Credit 
;		
; ----------------------------------------------------------

_Intro:
; Welcome comment
	MOV		EDX, OFFSET Intro1
	CALL	WriteString
	CALL	Crlf
	MOV		EDX, OFFSET	commentEC
	CALL	WriteString
	CALL	Crlf

; Introduction
	MOV		EDX, OFFSET Intro2
	CALL	WriteString
	CALL	Crlf


; ----------------------------------------------------------
; 2. Get a user's name, and greet the user.
;		
; ----------------------------------------------------------

_GetUserName:
; Ask and Get User's Name
	MOV		EDX, OFFSET AskName
	CALL	WriteString
	MOV		EDX, OFFSET UserName			; store a Name from user into UserName
	MOV		ECX, 35
	CALL	ReadString

; Say greeting and Display User Name
	MOV		EDX, OFFSET	greeting
	CALL	WriteString
	MOV		EDX, OFFSET UserName
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf

; ----------------------------------------------------------
; 3. Display instructions for the user, and
;		initialize EBX = 0 as a counter of valid numbers
;		 
; ----------------------------------------------------------

; Instruction to follow
	MOV		EDX, OFFSET	Instruction1
	CALL	WriteString
	CALL	Crlf
	MOV		EBX, 0							; For counting valid numbers

; ----------------------------------------------------------
; 4. Repeatedly prompt the user to enter a number.
;		If the number from user is valid, the number of the
;		counter of valid numbers increase.
;		If not, the program try to show message about invalid 
;		number, get a number again, and decrease the counter.
;		If user type a positive number or zero, the program
;		will end.
;
;		-200 <= valid number <= -100
;		-50 <= valid number <= -1
;		0 <= Exit number
;
;		** EC: Number the lines during user input.
;			  Increment the line number only for valid number
;			   entries

; ----------------------------------------------------------

_enterNumber:
; Show the count of valid numbers Get number from user
	INC		EBX								; **EC : increase the counter 
	MOV		EAX, EBX
	CALL	WriteDec
	MOV		EDX, OFFSET numberCount
	CALL	WriteString
	MOV		EDX, OFFSET	msgGetNumber
	CALL	WriteString
	CALL	ReadInt
	MOV		userInput, EAX					; store data into userInput

; Check Exit number
	CMP		userInput, ExitNumber			; If 0 <= userInput, Show results and Exit Program
	JNS		_results

; Check valid number -200 < userInput <= -1
	CMP		userInput, FirstLowerLimit	
	JL		_Invalidmsg
	CMP		userInput, SecondUpperLimit	
	JG		_Invalidmsg

_FirstLimit:
; Check valid number : userInput <= -100
	CMP		userInput, FirstUpperLimit
	JG		_SecondLimit
	CMP		userInput, FirstUpperLimit
	JLE		_updateNumber

_SecondLimit:
; Check valid number :  -50 <= userInput 
	CMP		userInput, SecondLowerLimit
	JL		_Invalidmsg
	CMP		userInput, SecondLowerLimit
	JGE		_updateNumber

_Invalidmsg:
	MOV		EDX, OFFSET InvalidInput		; If invalid number, repeat
	CALL	WriteString
	CALL	Crlf
	DEC		EBX
	JMP		_enterNumber

; ----------------------------------------------------------
; 5. For calculation, update maximum, minimum numbers, and 
;		sum every valid inputs. Then calculate average by 
;		dividing into a section of quotient, remainder.
;		After that, examine remainder to add -1 or not.
;		Calculate the (rounded integer) average of the valid 
;		numbers and store in a variable.
;
; ----------------------------------------------------------

_updateNumber:
; Check and Update Maximum and Minmum Number
	CMP		EAX, maxNumber
	JG		_updateMax
	CMP		EAX, minNumber
	JL		_updateMin

_updateMax:
; Update Maximum value
	MOV		maxNumber, EAX
	JMP		_sum

_updateMin:
; Update Minimum value
	MOV		minNumber, EAX	
	JMP		_sum

_sum:
; Calculate sum of user inputs
	MOV		EAX, sumOfNumbers
	ADD		EAX, userInput
	MOV		sumOfNumbers, EAX
	
; Calculate division of sum and the number of userInput
; to get Quotient(AvgQ), Remainder(AvgR), and rounded average(roundedAvg)
	MOV		EAX, sumOfNumbers	
	MOV		EDX, 0
	CDQ
	IDIV	EBX
	MOV		AvgQ, EAX					; store quotient into AvgQ
	MOV		EAX, EDX
	MOV		AvgR, EAX					; store remainder into AvgR

; Check remainder and Calculate round
	MOV		EAX, AvgR
	MOV		EDX, 0
	IDIV	EBX
	CMP		EAX, checkRound				; Check if AvgR <= -0.51
	JGE		_roundUp
	MOV		EAX, AvgQ
	MOV		roundedAvg, EAX
	JMP		_enterNumber

_roundUp:
; if AvgR <= -0.51, add -1 for round
	MOV		EAX, AvgQ
	ADD		EAX, -1
	MOV		roundedAvg, EAX
	JMP		_enterNumber


; ----------------------------------------------------------
; 6. Display the results of counted number, updated numbers 
;			such as	maximum, minimum numbers, and  summation
;			of valid numbers.
;			Then, show the value of rounded average
;		
;			After displaying all the results, the program
;			leave a commnet for closing - say good bye.
;		
; ----------------------------------------------------------

_results:
	CMP		EBX, 0
	JE		_msgNoInput

; Display the counts of data and results of calculation
	MOV		EDX, OFFSET	msgForCount1
	CALL	WriteString
	MOV		EAX, EBX					; counts of valid numbers
	CALL	WriteDEC
	MOV		EDX, OFFSET msgForCount2
	CALL	WriteString
	CALL	Crlf

; Display maximum valid number
	MOV		EDX, OFFSET msgForMax
	CALL	WriteString
	MOV		EAX, maxNumber
	CALL	WriteInt
	CALL	Crlf

; Display minimum valid number
	MOV		EDX, OFFSET msgForMin
	CALL	WriteString
	MOV		EAX, minNumber
	CALL	WriteInt
	CALL	Crlf

; Display sum of valid numbers
	MOV		EDX, OFFSET msgForSum
	CALL	WriteString
	MOV		EAX, sumOfNumbers
	CALL	WriteInt
	CALL	Crlf

; Display rounded average
	MOV		EDX, OFFSET msgForRAvg
	CALl	WriteString
	MOV		EAX, roundedAvg
	CALL	WriteInt
	CALL	Crlf

	JMP		_sayGoodbye					; Jump over _msgNoInput

_msgNoInput:
; comment about No valid data 
	MOV		EDX, OFFSET	msgNoInput
	CALL	WriteString
	CALL	Crlf

_sayGoodbye:
; Closing comment
	CALL	Crlf
	MOV		EDX, OFFSET	goodbye		
	CALL	WriteString
	MOV		EDX, OFFSET UserName
	CALL	WriteString
	CALL	Crlf
	

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
