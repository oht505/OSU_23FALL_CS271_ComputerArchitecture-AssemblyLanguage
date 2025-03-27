 TITLE Simple Comparator     (Comparator.asm)

; Author: Redfield
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This program gets two unsigned values from the user,
;	and determines which is greater (or if they are equal), then
;	notifies the user of the conclusion.

;	Note: This program verifies that both user-entered integers
;   are nonzero and positive.
;   

; ReadDec
; receive: None
; returns: EAX = unsigned integer
; CF = 1 if value is zero or invalid, else 0

INCLUDE Irvine32.inc

.data
a           SDWORD   ?
b           SDWORD   ?
rules1      BYTE     "Enter two unsigned values, a and b. I will tell you which is greater.",13,10,0
prompt1     BYTE     "Enter value for a: ",0
prompt2     BYTE     "Enter value for b: ",0
error		BYTE	 "Please enter a positive value. ",0
isGreater   BYTE     " is greater than ",0
isEqual     BYTE     "The two values you entered are equal",0
seeya       BYTE     ". Thanks for playing!",13,10,0

.code
main PROC

  mov    EDX, OFFSET rules1
  call   WriteString

  ; Get value a
_getA:
  mov    EDX, OFFSET prompt1
  call   WriteString
  call   ReadInt
  cmp	 EAX, 0
  JL	 _error
  mov    a, EAX		; value is accpetable
  
  ; Get value b
  mov    EDX, OFFSET prompt2
  call   WriteString
  call   ReadInt
  cmp	 EAX, 0
  JL	 _error
  mov    b, EAX		; value is accpetable
  

  JMP	 _bothDataValidated

_error:
  MOV	 EDX, OFFSET error
  CALL	 WriteString
  JMP	 _getA

_bothDataValidated:
  
  ; Print which is greater
  mov    EAX, a
  cmp    EAX, b
  ja     _aGreater
  jb     _bGreater
  mov    EDX, OFFSET isEqual  ; They are equal
  call   WriteString
  jmp    _goodbye

_aGreater:     ; a is greater than b
  mov    EAX, a
  call   WriteDec
  mov    EDX, OFFSET isGreater
  call   WriteString
  mov    EAX, b
  call   WriteDec
  jmp    _goodbye

_bGreater:     ; b is greater than a
  mov    EAX, b
  call   WriteDec
  mov    EDX, OFFSET isGreater
  call   WriteString
  mov    EAX, a
  call   WriteDec

_goodbye:
  mov    EDX, OFFSET seeya
  call   WriteString

  Invoke ExitProcess,0	; exit to operating system
main ENDP


END main
