TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

DOG_FACTOR = 7

.data

userName	BYTE	33 DUP(0)
userAge		DWORD	?
intro_1		BYTE	"Hi, my name is ht, this program for DogYears! ",0
prompt_1	BYTE	"your Name? ",0
prompt_2	BYTE	"your Age? ",0
dogAge		DWORD	?
result_1	BYTE	"Wow, that's ",0
result_2	BYTE	" in dog years! ",0
goodbye		BYTE	"Bye!",0

.code
main PROC

; Introduce programer
	mov		EDX, OFFSET intro_1
	call	writeString
	call	crlf

; Get your name
	mov		EDX, OFFSET prompt_1
	call	writeString
	mov		EDX, OFFSET userName
	mov		ECX, 33
	call	ReadString

; Get your age
	mov		EDX, OFFSET prompt_2
	call	writeString
	call	ReadDec
	mov		userAge, EAX

; Calculate age in dog years
	mov		EAX, userAge
	mov		EBX, DOG_FACTOR
	mul		EBX
	mov		dogAge, eax


; Report the result
	mov		EDX, OFFSET result_1
	call	writeString
	mov		EAX, dogAge
	call	writeDec
	mov		EDX, OFFSET result_2
	call	writeString
	call	crlf



; Say goodbye
	mov		EDX, OFFSET goodbye
	call	writeString
	mov		EDX, OFFSET	userName
	call	writeString
	call	crlf


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
