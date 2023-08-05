; Kernel interrupts
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


;; Screen API (print, clear, printchar and so on.)
; Input:
;   AH - function
; Output:
;   Carry flag set if error
INT20:
    cmp ah, 00h
    je .ah00

    cmp ah, 01h
    je .ah01

    cmp ah, 02h
    je .ah02

    stc
    jmp .RETURN

.ah00:
    call screen__printchar
    jmp .RETURN

.ah01:
    call screen__print
    jmp .RETURN

.ah02:
    call screen__clear
    jmp .RETURN

.RETURN:
    iret


;; Keyboard API (get key, get string)
; Input:
;   AH - function
; Output:
;   Carry flag set if error
INT21:
    cmp ah, 00h
    je .ah00

    cmp ah, 01h
    je .ah01

    stc
    jmp .RETURN

.ah00:
    call keyboard__get_key
    jmp .RETURN

.ah01:
    call keyboard__get_string
    jmp .RETURN

.RETURN:
    iret


;; Filesystem API (read file, print list of root dir)
; Input:
;   AH - function
; Output:
;   Carry flag set if error
INT22:
    cmp ah, 00h
    je .ah00

    cmp ah, 01h
    je .ah01

    stc
    jmp .RETURN

.ah00:
    call fs__dir
    jmp .RETURN

.ah01:
    call fs__read
    jmp .RETURN

.RETURN:
    iret

