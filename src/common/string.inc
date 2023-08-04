; String library
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- FUNCTIONS --- ;
; Compare two strings
; Input:
;   SI - String 1
;   DI - String 2
; Output:
;   CF - set, if not same.
string__compare:
    pusha

.try:
    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne .not_same
    
    cmp al, 0
    je .same

    inc si
    inc di
    
    jmp .try

.same:
    clc
    popa
    ret

.not_same:
    stc
    popa
    ret

