TITLE Arrays, Addressing, & Stack-Passed Params    (Proj5_ohhyun.asm)

; Author: HyunTaek Oh
; Last Modified: Nov. 26
; OSU email address: ohhyun@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:       5          Due Date: Nov. 26, 2023
; Description:  1.Introduce the program and programmer name 
;				2. Generate an array holding random values
;               3. Display the array to show random values
;				4. Sort the array in non-decreasing order (smallest first)
;				5. Display the whole elements of sorted array 
;				6. Display the median value of sorted array
;				7. Generate an array for counting same values in previous array
;				8. Display the counts of the array
;				9. Show a closing comment (good bye) 

INCLUDE Irvine32.inc

ARRAYSIZE	=	200
LO			=	15
HI			=	50

.data
intro1			BYTE	"Generating, Sorting, and Counting Random integers!					 Programmed by HyunTaek Oh",0
intro2			BYTE	"This program generates 200 random integers between 15 and 50, inclusive.",13,10,
						"It then displays the original list, sorts the list, displays the median value of the list, ",13,10,
						"displays the list sorted in ascending order, and finally displays the number of instances",13,10,
						"of each generated value, starting with the number of lowest.",0
UnsortedTitle	BYTE	"Your unsorted random numbers: ",0
randArray		DWORD	ARRAYSIZE DUP(?)
arrayLength		DWORD	LENGTHOF randArray
MedianTitle		BYTE	"The median value of the array: ",0
SortedTitle		BYTE	"Your sorted random numbers: ",0
CountTitle		BYTE	"Your list of instances of each generated number, starting with the smallest value: ",0
countArray		DWORD	ARRAYSIZE DUP(?)
countLength		DWORD	LENGTHOF countArray
goodbye			BYTE	"Goodbye, and thanks for using my program! ",0


.code
main PROC

	CALL	Randomize				; Generate a random seed.

	PUSH	OFFSET intro1			
	PUSH	OFFSET intro2					
	CALL	introduction

	PUSH	OFFSET randArray		; address of an array being filled by random values
	CALL	fillArray				; Filling an array with random values within boundaries

	PUSH	arrayLength				
	PUSH	OFFSET randArray
	PUSH	OFFSET UnsortedTitle	
	CALL	displayList				; Display the array

	PUSH	OFFSET randArray
	CALL	sortList				; Sorting the array

	PUSH	arrayLength
	PUSH	OFFSET randArray
	PUSH	OFFSET SortedTitle
	CALL	displayList

	PUSH	OFFSET randArray
	PUSH	OFFSET MedianTitle	
	CALL	displayMedian			; Show the median value of the array

	PUSH	OFFSET countArray
	PUSH	OFFSET randArray
	CALL	countList				; Generate a new counter array 

	PUSH	countLength
	PUSH	OFFSET countArray
	PUSH	OFFSET CountTitle
	CALL	displayList

	MOV		EDX, OFFSET	goodbye		; Display closing comment (No requirement about goodbye message)
	CALL	WriteString
	CALL	Crlf

	Invoke ExitProcess,0	
main ENDP


; ---------------------------------------------------------------------------------
; Name: Introduction
;
; Display Title, Name, and Instruction
;
; Receives:
; 
;	[EBP+12]	=	Title & Name
;	[EBP+8]		=	Instruction message
;
; ---------------------------------------------------------------------------------
introduction PROC
	PUSH	EBP
	MOV		EBP, ESP
	
	MOV		EDX, [EBP+12]			; Title & Name
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf

	MOV		EDX, [EBP+8]			; Instruction
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf
_end:
	POP		EBP
	RET		8

introduction ENDP


; ---------------------------------------------------------------------------------
; Name: fillArray
;
; Fill 200 random values [15-50] into an array. 
;
; Receives:
;	[EBP+8]		=	address of array
;	
; returns: randArray	=	it has random positive values
; ---------------------------------------------------------------------------------
fillArray PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EBX
	PUSH	ECX
	PUSH	EDI

	MOV		EBX, 0
	MOV		ECX, ARRAYSIZE				; loop counts (200)
	MOV		EDI, [EBP+8]				; address of array

_fillLoop:
	MOV		EAX, HI
	CALL	RandomRange					; Generate random values into EAX register

	CMP		EAX, LO						; Check the value is not lower than the boundary
	JL		_fillLoop

	MOV		[EDI+EBX*4], EAX			; Put the data into array in every 4 bytes
	INC		EBX
	LOOP	_fillLoop

_end:
	POP		EDI
	POP		ECX
	POP		EBX
	POP		EBP
	RET		4

fillArray ENDP


; ---------------------------------------------------------------------------------
; Name: sortList
;
; By using bubble sort, the elements of the array will become in non-decreasing order 
;
; Preconditions: the array contains only positive values
;
; Postconditions: none.
;
; Receives:
;	[EBP+8]		=	address of array
;
; returns: randArray	=	Unlike previous one, it is sorted 
; ---------------------------------------------------------------------------------
sortList PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EBX
	PUSH	EDI

	MOV		ECX, ARRAYSIZE-1			; Loop counts should decrease 1 because of out of index

	MOV		EDI, [EBP+8]

_outLoop:
	PUSH	ECX							; Save loop counts for outer loop
	MOV		EBX, 0						; EBX will be used for moving every 4bytes address forward.
_innerLoop:
	MOV		EAX, [EDI+EBX*4]
	INC		EBX
	CMP		EAX, [EDI+EBX*4]			; Compare the two contiguous values 
	JG		_exchangeValue				; if the value violates non-decreasing order, exchange it

_afterChange:
	LOOP	_innerLoop

	POP		ECX
	LOOP	_outLoop
	JMP		_end

_exchangeValue:
	PUSH	EDI							; address of array
	PUSH	EBX							; Index heving the value to be changed 
	CALL	exchangeElements
	JMP		_afterChange

_end:
	POP		EDI
	POP		EBX
	POP		EBP
	RET		4

sortList ENDP


; ---------------------------------------------------------------------------------
; Name: exchangeElements
;
; Swap the contiguous elements of array		( randArray[i] <=> randArray[i+4] )
;	By using EAX and ECX register 
;
; Preconditions: the elements should violate the rule in non-decreasing order
;
; Receives:
;	[EBP+8]		=	index of the elements to be changed
;	[EBP+12]	=	address of array
; 
; returns: randArray = the array having exchanged elements
; ---------------------------------------------------------------------------------
exchangeElements PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	
	MOV		EBX, [EBP+8]			; Use index
	MOV		EDI, [EBP+12]			; Address of array

	MOV		EAX, [EDI+EBX*4]		
	DEC		EBX
	MOV		ECX, [EDI+EBX*4]

	INC		EBX
	MOV		[EDI+EBX*4], ECX
	DEC		EBX
	MOV		[EDI+EBX*4], EAX

_end:
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		8

exchangeElements ENDP

; ---------------------------------------------------------------------------------
; Name: displayMedian
;
; Display the median value of "sorted" array. 
;	if the length of array is odd, use half of it as an index
;	if even, find two middle elements and calculate by using round-half up.
;		e.g. 50 => (randArray[23] + randArray[24]) / 2  
;	Then, print the median value
;
; Preconditions: the array need to be sorted
;
; Receives:
;	[EBP+8]		=	Title of median value
;	[EBP+12]	=	address of array
;
; ---------------------------------------------------------------------------------
displayMedian PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EAX
	PUSH	EBX
	PUSH	EDX
	PUSH	ESI

	MOV		EAX, ARRAYSIZE
	MOV		EBX, 2					; Divisor (2)
	MOV		EDX, [EBP+8]			; Median value title
	CALL	WriteString

	MOV		ESI, [EBP+12]			; Address of array

	MOV		EDX, 0
	DIV		EBX

	CMP		EDX, 0					; If remainder is 0, it means the number is even.
	JE		_evenCal
	
	MOV		EAX, [ESI+EAX*4]		; The value is odd, use it as an index and print.
	JMP		_print

_evenCal:
	PUSH	EBX
	MOV		EDX, [ESI+EAX*4]		; Store the value which has the middle index
	DEC		EAX
	MOV		EBX, [ESI+EAX*4]		; Store the value which has the another middle index. 
	MOV		EAX, EDX
	ADD		EAX, EBX
	
	POP		EBX
	MOV		EDX,0
	DIV		EBX
	
	CMP		EDX, 1					; If remainder is 1, it will become round up
	JE		_roundUp
	JMP		_print

_roundUp:
	INC		EAX
	
_print:
	CALL	WriteDec
	CALL	Crlf

_end:
	CALL	Crlf
	POP		ESI
	POP		EDX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		8

displayMedian ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
;
; Calculate and Display the elements of the array 
;	(20 numbers per a line with one space between each values)
;	if the elements have '0' value, ignore loops, and end this procedure
;
; Receives:
;	[EBP+8]		=	Title
;	[EBP+12]	=	address of array
;	[EBP+16]	=	loop counters (Array length)
;
; ---------------------------------------------------------------------------------
displayList PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSH	EDX
	PUSH	EBX
	PUSH	ECX
	PUSH	ESI

	MOV		EDX, [EBP+8]				; Display Title 
	CALL	WriteString
	CALL	Crlf

	MOV		EBX, 0						; Initialize EBX to 0

	MOV		ECX, [EBP+16]				; the number of Loops for displaying (length)

	MOV		ESI, [EBP+12]				; address of the array


_columnLoop:
	MOV		EAX, [ESI+EBX*4]

	CMP		EAX, 0						; Check the value is '0'
	JE		_end

	CALL	WriteDec					
	MOV		AL, 32						; For one empty space
	CALL	WriteChar

	INC		EBX
	
	MOV		EAX, EBX
	PUSH	EBX
	MOV		EBX, 20						; Divide the number with 20 for checking remainder

	MOV		EDX, 0
	DIV		EBX

	POP		EBX

	CMP		ECX, 1						; If it is the last loop, end this procedure
	JLE		_end

	CMP		EDX, 0						; If remainder is 0, it means 20 numbers are displayed
	JE		_rowLoop		

	LOOP	_columnLoop

_rowLoop:
	CALL	Crlf						; Change a line if 20 numbers are displayed
	LOOP	_columnLoop
	
_end:
	CALL	Crlf
	CALL	Crlf
	POP		ESI
	POP		ECX
	POP		EBX
	POP		EDX
	POP		EBP
	RET		12

displayList ENDP

; ---------------------------------------------------------------------------------
; Name: countList
;
; Check every elements in target array (randArray),
;	Count how many same numbers are there, and store these values into countArray.
;	(Holding one value and move foward to check whether the next value is same or not)
;
; Preconditions: Target array is needed (randArray)
;
; Receives:
;	[EBP+8]		=	address of target array to check and count same numbers
;	[EBP+12]	=	address of array to store the counts of target array
;
; returns: countArray = an array consists of the counts of elements in target array
;
; ---------------------------------------------------------------------------------
countList PROC
	PUSH	EBP
	MOV		EBP, ESP

	PUSHAD

	MOV		EBX, 1
	MOV		ECX, ARRAYSIZE
	MOV		ESI, [EBP+8]			; Target Array having sorted random values 
	MOV		EDI, [EBP+12]			; Count Array to store the counts of the elements in Target Array

_countLoop:
	MOV		EAX, [ESI]
	ADD		ESI, 4
	CMP		EAX, [ESI]
	JNE		_storeCount				; If contiguous elements are different, store it into array
	INC		EBX
_continue:
	LOOP	_countLoop
	JMP		_end

_storeCount:
	MOV		[EDI], EBX
	ADD		EDI, 4	
	MOV		EBX, 1
	JMP		_continue
	
_end:
	POPAD
	POP		EBP
	RET		8

countList ENDP


END main
