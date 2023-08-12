; Screen driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- DEFINES --- ;
%define NEWLINE 0x0A
%define COLOR_DARK          0x07
%define COLOR_LIGHT         0x70
%define COLOR_GREEN         0x0A
%define COLOR_PANIC         0x1F
%define COLOR_PANIC_GRAY    0x74


    ; --- FUNCTIONS --- ;
; Print one character to screen
; Input:
;   AL - Character
screen__printchar:
    pusha

    mov ah, 0x0E
    int 10h

    %ifdef DEBUG
        mov dx, 0xE9
        out dx, al
    %endif

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


; Print register value to screen
; Input:
;   AX - register
screen__printhex:
    pusha
    mov si, .hex
    call screen__print

    push ax
    mov al, ah
    call .print_byte
    pop ax
    call .print_byte

    call screen__newline
    popa
    ret

.print_byte:
    mov [.temp], al
    shr al, 4
    cmp al, 10
    sbb al, 69h
    das

    call screen__printchar

    mov al, [.temp]
    ror al, 4
    shr al, 4
    cmp al, 10
    sbb al, 69h
    das

    call screen__printchar
    ret

.temp:      db 0
.hex:       db '0x', 0


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
    mov bh, COLOR_DARK          ; Gray text color
    
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

