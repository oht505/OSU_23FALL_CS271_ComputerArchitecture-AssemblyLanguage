TITLE Guessing Game with Data Validation  (GuessingGameDataValidation.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: Program asks user to pick a value between 1 and 10.
;     If user gets the correct number (defined as constant), print congratulations!
;     If not, let user try again, and let them know if they're above or below.
;
; NOTE: Data Validation has been added to this program

INCLUDE Irvine32.inc

; (insert macro definitions here)

RIGHT_NUMBER   =     72
LOWER_LIMIT    =     15
UPPER_LIMIT    =     200

.data

greeting		BYTE	"Welcome to the number guessing game! Guess until you get it right!",13,10,0
prompt_1		BYTE	"Pick a number between ",0
prompt_2		BYTE	" and ",0
prompt_3		BYTE	": ",0
invalid_guess	BYTE	"Whoops! Your number is outside the range! ",0
userVal			DWORD	?		; User's guess
correct_string	BYTE	"Amazing! You got it right!",13,10,"You've won the game! Goodbye!",0
above_string	BYTE	"Too high! Try again. ",0
below_string	BYTE	"Too low! Try again. ",0

.code
main PROC

; Greet the user
mov	edx, OFFSET greeting
call	WriteString

; Get user guess, verifying guess is within limits
_startLoop:
  ; Prompt User (with range values based on constants)
  mov	edx, OFFSET prompt_1
  call	WriteString
  mov	eax, LOWER_LIMIT
  call	WriteDec
  mov	edx, OFFSET prompt_2
  call	WriteString
  mov	eax, UPPER_LIMIT
  call	WriteDec
  mov	edx, OFFSET prompt_3
  call	WriteString

; Verify guess is within limits. If not, print error and jump above to ask again.
  call	ReadDec
  cmp	EAX, LOWER_LIMIT
  JL	_BadValue
  cmp	EAX, UPPER_LIMIT
  JLE	_GoodValue
_BadValue:
  mov	EDX, OFFSET invalid_guess
  call	WriteString
  jmp	_startLoop

_GoodValue:
  mov	userVal, EAX

; Evaluate user guess and print appropriate reponse
  cmp	userVal, RIGHT_NUMBER

; if equal, jump to correct
  je	_correct
; if less than, print "below" string and jump to user guess
  jb	_below
; if greater than, print "above" string and jump to user guess
  ;THIS POINT means guess is ABOVE correct value
  mov	edx, OFFSET above_string
  call	WriteString
  jmp	_startLoop

_below:     ; guess is BELOW correct value
  mov	edx, OFFSET below_string
  call	WriteString
  jmp	_startLoop

_correct:
  mov	edx, OFFSET correct_string
  call	WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
