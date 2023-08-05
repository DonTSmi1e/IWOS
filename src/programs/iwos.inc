; IWOS interrupt library
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- DEFINES --- ;
%define NEWLINE 0x0A


    ; --- FUNCTIONS --- ;
; Print one character to screen
; Input:
;   AL - Character
printchar:
    mov ah, 00h
    int 20h
    ret


; Print string to screen
; Input:
;   SI - Null terminated string
print:
    mov ah, 01h
    int 20h
    ret


; Clear screen
clear:
    mov ah, 02h
    int 20h
    ret


; Get pressed key
; Output:
;   AH - scan code
;   AL - ASCII char
waitkey:
    mov ah, 00h
    int 21h
    ret


; Input string
; Input:
;   BL - character limit
; Output:
;   DI - entered string
input:
    mov ah, 01h
    int 21h
    ret


; Print list of files
fs_dir:
    mov ah, 00h
    int 22h
    ret


; Load file to memory
; Input:
;   SI - filename
;   BX - memory location
fs_read:
    mov ah, 01h
    int 22h
    ret

