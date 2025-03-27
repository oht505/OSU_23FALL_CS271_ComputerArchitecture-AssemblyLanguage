TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data
x	DWORD	153461
y	BYTE	37
z	BYTE	90
List1	Byte	10,20
		Byte	30,40
str1 \
	 BYTE "This string",0

myChecker	byte 12h
			byte 34h
			byte 56h
			byte 78h
			byte 90h

one2?     BYTE     "step",0
One_two   BYTE     "three o-clock",0
myArray BYTE 10, 20, 30



.code
main PROC
	
	mov eax, 212
	mov ebx, 17
	mov edx, 0
	div ebx
	call writeDec


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
