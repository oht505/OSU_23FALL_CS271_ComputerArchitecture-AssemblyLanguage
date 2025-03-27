TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

;INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

myGreeting  BYTE "This may be an exceptionally "
            BYTE "long statement that you may have "
            BYTE "to know the length of...",0
MYGREETING_LEN = ($ - myGreeting)

.code
main PROC

    MOV     EAX, MYGREETING_LEN
    CALL    WriteInt
    CALL    Crlf

    MOV     EDX, OFFSET myGreeting
    CALL    WriteString
    CALL    Crlf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
