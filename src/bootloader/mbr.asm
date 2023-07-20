; IWOS Bootloader ; Stage 1
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 7C00h
bits 16


    ; --- FUNCTIONS --- ;
main:
    call screen__clear

    mov si, msg_stage_1
    call screen__print

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
    mov si, msg_error
    call screen__print
    
    cli
    hlt


    ; --- INCLUDES --- ;
%include 'src/bootloader/include/screen.inc'
%include 'src/bootloader/include/disk.inc'


    ; --- STRINGS --- ;
msg_stage_1:                    db 'IWOS Bootloader -- Stage 1 loaded', NEWLINE, 0
msg_error:                      db 'Disk reading error, reboot your PC.', NEWLINE, 0


    ; --- FOOTER --- ;
times 510-($-$$) db 0
dw 0xAA55

