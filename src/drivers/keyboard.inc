; Keyboard driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- FUNCTIONS --- ;
; Get pressed key
; Output:
;   AH - scan code
;   AL - ASCII char
keyboard__get_key:
    mov ax, 0
    mov ah, 0
    int 16h

    ret


; Input string
; Input:
;   BL - character limit
; Output:
;   DI - entered string
; p.s. i took it from https://wiki.osdev.org/Real_mode_assembly_I
keyboard__get_string:
    pusha
    xor cl, cl

.loop:
    call keyboard__get_key

    cmp al, 0x08            ; Handle Backspace
    je .backspace

    cmp al, 0x0D            ; Handle Enter
    je .done

    cmp cl, bl              ; Character limit
    je .loop

    call screen__printchar  ; Print char

    stosb                   ; Put character in buffer
    inc cl
    jmp .loop

.backspace:
    cmp cl, 0
    je .loop

    dec di
    mov byte [di], 0	    ; Delete character
    dec cl		            ; Decrement counter

    mov al, 0x08
    call screen__printchar  ; Moving cursor back

    mov al, 0x0
    call screen__printchar  ; Printing space

    mov al, 0x08
    call screen__printchar  ; Moving cursor back

    jmp .loop

.done:
    mov al, 0
    stosb

    call screen__newline

    popa
    ret

