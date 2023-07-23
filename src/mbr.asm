; IWOS Bootloader ; Stage 1
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 7C00h
bits 16


    ; --- FUNCTIONS --- ;
main:
    ; Setup ES:BX
    mov bx, 1000h                       ; ES = 1000h
    mov es, bx
    mov bx, 2800h                       ; ES:BX = 1000h:2800h

    ; Reading disk
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov cl, 2
    int 13h
    jc .error

    ; Jumping to kernel
    mov ax, 1000h
    mov ds, ax
    mov es, ax

    jmp 1000h:2800h

.error:
    mov ah, 0x0E
    mov al, '!'
    int 10h

    cli
    hlt


    ; --- FOOTER --- ;
times 510-($-$$) db 0
dw 0xAA55

