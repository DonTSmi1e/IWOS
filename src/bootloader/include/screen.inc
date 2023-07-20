; IWOS Bootloader ; Screen library
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- DEFINES --- ;
%define NEWLINE 0x0D, 0xA


    ; --- FUNCTIONS --- ;
; Print newline
screen__newline:
    pusha                       ; Saving our registers

    mov ah, 0x0E                ; Switching to TTY mode

    mov al, 0x0D
    int 10h

    mov al, 0xA
    int 10h

    popa                        ; Restoring our registers
    ret                         ; And back to main code


; Print string to screen
; Input:
;   SI - string to print  
screen__print:
    pusha                       ; Saving our registers
    mov ah, 0x0E                ; Switching to TTY mode

.loop:
    mov al, [si]                ; Take char from SI

    or al, al                   ; Is Null?
    je .end                     ; Yep, jump to end
    int 10h                     ; No, print char
    
    inc si                      ; Increase pointer to SI
    jmp .loop                   ; And going back

.end:
    popa                        ; Restoring our registers
    ret                         ; And back to main code


; Clear screen
screen__clear:
    pusha

    ; Scroll screen
    mov ah, 0x06                ; Scroll up
    mov al, 0                   ; Clear screen
    mov bh, 0x7                 ; Gray text color
    
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