TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

MIN_VAL = 30
MAX_VAL = 200


.data

rangeVals  BYTE "Enter an integer between ",MIN_VAL," and ",MAX_VAL,".", 0
myGreeting  BYTE "This may be an exceptionally "
            BYTE "long statement that you may have "
            BYTE "to know the length of...",0
MYGREETING_LEN = ($ - myGreeting)

myArray       DWORD   14, 42, 19, 33, 190
MYARRAY_SIZE = ($ - myArray) ; Size of myArray (in bytes)

.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
