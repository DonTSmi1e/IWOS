; IWOS Kernel ; Keyboard driver
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
; Output:
;   DI - entered string
;   BL - character limit
; p.s. i take it from https://wiki.osdev.org/Real_mode_assembly_I
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

    mov ah, 0x0E
    int 0x10                ; Print char

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
    int 10h                 ; Moving cursor back

    mov al, 0x0
    int 10h                 ; Printing space

    mov al, 0x08
    int 10h                 ; Moving cursor back

    jmp .loop

.done:
    mov al, 0
    stosb

    mov ah, 0x0E

    mov al, 0x0D
    int 0x10

    mov al, 0x0A
    int 0x10

    popa
    ret
