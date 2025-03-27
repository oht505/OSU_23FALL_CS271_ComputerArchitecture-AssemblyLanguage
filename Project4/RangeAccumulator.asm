TITLE Range Accumulator     (RangeAccumulator.asm)

; Author: Redfield
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This program gets two integers from the user,
;	and calculates the summation of the integers from the
;	first to the second.  For example, if the user enters
;	1 and 10, the program calculates 1+2+3+4+5+6+7+8+9+10.

;	Note: This program does not perform any data validation.
;   If the user gives invalid input, the output will be
;   meaningless.

;  Implementation notes:
;	This program is implemented using procedures.
;	All variables are global ... no parameter passing

INCLUDE Irvine32.inc

.data
a        SDWORD   ?
b        SDWORD   ?
sum      SDWORD   ?
rules1   BYTE     "Enter a lower limit and an upper limit, and I'll show",13,10
         BYTE     "the summation of integers from lower to upper.",13,10,13,10,0
prompt1  BYTE     "Lower limit: ",0
prompt2  BYTE     "Upper limit: ",0
out1     BYTE     13,10,"The summation of integers from ",0
out2     BYTE     " to ",0
out3     BYTE     " is: ",0

.code
main PROC

   call  introduction
   call  getData        ; Add data validation
   call  calculate
   call  showResults

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -- introduction --
; Procedure to introduce the program.
; preconditions: rules1 and rules2 are strings that describe the program and rules.
; postconditions: EDX changed
; receives: ???
; returns: ???
introduction PROC
  mov    EDX, OFFSET rules1
  call   WriteString
  ret
introduction ENDP

; -- getData --
; Gets two values from the user (a and b). Hopefully a is less than b.
; preconditions: prompt1 and prompt2 are strings, a and b exist
; postconditions: EAX, EDX changed
; receives: none
; returns: user input values for global variables a and b
getData PROC
  mov    EDX, OFFSET prompt1
  call   WriteString    ;"Lower limit: "
  call   ReadInt        ; Lower limit into EAX
  mov    a, EAX         ; Lower limit into a
  
  mov    EDX, OFFSET prompt2
  call   WriteString    ;"Upper limit: "
  call   ReadInt        ; Upper limit into EAX
  mov    b, EAX         ; Upper limit into b

  ret
getData ENDP

; -- calculate --
; Calculate the summation of integers from a to b
; preconditions: a <= b
; postconditions: EAX, EBX changed
; receives: a and b are global variables
; returns: global variable (sum) = a + (a+1) + ... + b
calculate PROC
  ; Initialize registers
  mov    EAX, 0
  mov    EBX, a

_sumLoop:
    add   EAX, EBX    ;sum = sum + new a
    inc   EBX         ; a = a + 1
    cmp   EBX, b
  jle   _sumLoop    ; if new value is > b, stop accumulating

  mov   sum, EAX
  ret
calculate ENDP

; -- showResults --
; Display results of summation (a + ... + b = sum)
; preconditions: sum has been calculated
; postconditions: EAX and EDX
; receives: a and b and sum are global variables
; returns: none
showResults PROC
  ; Identify the output
  mov    EDX, OFFSET out1
  call   WriteString          ;"The summation of integers from "
  mov    EAX, a
  call   WriteInt             ; display a
  mov    EDX, OFFSET out2  
  call   WriteString          ; " to "
  mov    EAX, b
  call   WriteInt             ; display b
  mov    EDX, OFFSET out3
  call   WriteString          ; " is:"
  mov    EAX, sum
  call   WriteInt             ; display sum
  call   CrLf
  ret
showResults ENDP

END main
