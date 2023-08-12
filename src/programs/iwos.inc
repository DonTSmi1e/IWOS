; IWOS Shell
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- FUNCTIONS --- ;
; Print character to screen
; Input:
;    AL - character
screen__printchar:
    mov ah, 00h
    int 20h
    ret


; Print string to screen
; Input:
;   SI - string
screen__print:
    mov ah, 01h
    int 20h
    ret


; Clear screen
screen__clear:
    mov ah, 02h
    int 20h
    ret


; Get string from user
; Input:
;   BL - string size
; Output:
;   DI - string
keyboard__get_string:
    mov ah, 01h
    int 21h
    ret


; Print root directory content
fs__dir:
    mov ah, 0
    int 22h
    jmp .return

.return:
    ret


; Load file start and size (no reading)
; Input:
;   SI - filename
; Output:
;   AX - file start (0 if file not found)
;   CL - file size
;   CF
fs__load:
    clc
    mov ah, 01h
    int 22h
    cmp ax, 0
    je .error
    jmp .return

.error:
    stc

.return:
    ret


; Read file to memory
; Input:
;   SI - filename
;   BX - memory offset
; Output:
;   CF
fs__read:
    clc
    mov ah, 02h
    int 22h
    cmp ax, 0
    je .error
    jmp .return

.error:
    stc

.return:
    ret

