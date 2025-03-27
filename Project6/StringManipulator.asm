TITLE String Manipulator     (StringManipulator.asm)

; Author: Redfield
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This program asks the user to enter a string,
;					then duplicates the string, capitalizes all characters,
;					and finally reverses the string. The string is displayed
;					after each change, and string primitives are used
;					whenever appropriate.

INCLUDE Irvine32.inc

MAXSIZE = 101

.data

inString		BYTE		MAXSIZE DUP(?)		;User String
outString	BYTE		MAXSIZE DUP(?)		;User String
prompt		BYTE		"Enter a string (Max 100 characters): ",0
usrString   BYTE     "The starting string:    ",0
dupString   BYTE     "The duplicate string:   ",0
capString   BYTE     "The capitalized string: ",0
revString   BYTE     "The reversed string:    ",0
sLen			DWORD		?

.code
main PROC

  ; Get user Input:
  mov    EDX, OFFSET prompt
  call   WriteString
  mov    EDX, OFFSET inString
  mov    ECX, MAXSIZE
  call   ReadString
  mov    sLen, EAX
  call   CrLf

  ; Print the starting string
  mov    EDX, OFFSET usrString
  call   WriteString
  mov    EDX, OFFSET inString
  call   WriteString
  call   CrLf


  ; Duplicate the string
  ;   Set up loop counter and indexes (indices?)
  CLD
  mov    ECX, sLen
  mov    ESI, OFFSET inString
  mov    EDI, OFFSET outString
  
  ;   Duplicate string
  REP    MOVSB

  ;   Print the string
  mov    EDX, OFFSET dupString
  call   WriteString
  mov    EDX, OFFSET outString
  call   WriteString
  call   CrLf


  ; Capitalize the string
  ;   Set up loop counter and indexes (indices?)
  CLD
  mov    ECX, sLen
  mov    ESI, OFFSET inString
  mov    EDI, OFFSET outString
  
  ;   Capitalize string
_capLoop:
  LODSB     ; Puts byte in AL
    cmp    AL, 97
    JL     _alreadyCap
    cmp    AL, 122
    JG     _alreadyCap
    sub    AL, 32
  _alreadyCap:
    STOSB
  LOOP   _capLoop

  ;   Print the string
  mov    EDX, OFFSET capString
  call   WriteString
  mov    EDX, OFFSET outString
  call   WriteString
  call   CrLf


  ; Reverse the string
  ;   Set up loop counter and indexes (indices?)
  mov    ECX, sLen
  mov    ESI, OFFSET inString
  add    ESI, ECX
  dec    ESI
  mov    EDI, OFFSET outString
  
  ;   Reverse string
_revLoop:
    STD
    LODSB
    CLD
    STOSB
  LOOP   _revLoop

  ;   Print the string
  mov    EDX, OFFSET revString
  call   WriteString
  mov    EDX, OFFSET outString
  call   WriteString
  call   CrLf
  call   CrLf

  Invoke ExitProcess,0	; exit to operating system
main ENDP

END main
