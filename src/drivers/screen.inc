; Screen driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- DEFINES --- ;
%define NEWLINE 0x0A


    ; --- FUNCTIONS --- ;
; Print one character to screen
; Input:
;   AL - Character
screen__printchar:
    pusha
    mov ah, 0x0E

    %ifdef VESA
        mov bl, 0x7
    %endif

    int 10h

    popa
    ret


; Print string to screen
; Input:
;   SI - Null terminated string
screen__print:
    pusha                       ; Saving our registers
    mov ah, 0x0E                ; Switching to TTY mode

.loop:
    mov al, [si]                ; Take char from SI
    inc si                      ; Increase pointer to SI

    or al, al                   ; Is Null?
    je .end                     ; Yep, jump to end

    cmp al, 0x0A                ; Is newline character?
    je .newline                 ; Yes, handle it

    call screen__printchar      ; Print char
    
    jmp .loop                   ; And going back

.end:
    popa                        ; Restoring our registers
    ret                         ; And back to main code

.newline:
    call screen__newline
    jmp .loop


; Just a newline.
screen__newline:
    pusha                       ; Saving our registers
    mov ah, 0x0E                ; Switching to TTY mode

    mov al, 0x0D
    call screen__printchar

    mov al, 0xA
    call screen__printchar

    popa                        ; Restoring our registers
    ret                         ; And back to main code


; Clear screen
screen__clear:
    pusha

    ; Scroll screen
    mov ah, 0x06                ; Scroll up
    mov al, 0                   ; Clear screen
    mov bh, 0x7                 ; Gray text color

    %ifdef VESA
        mov bx, 0x70
    %endif
    
    mov ch, 0                   ; Y
    mov cl, 0                   ; X

    mov dh, 25                  ; Y
    mov dl, 80                  ; X

    int 10h                     ; Clear

    ; Move cursor
    mov ah, 0x02
    mov bh, 0

    mov dh, 0
    mov dl, 0

    int 10h

    popa
    ret

