; IWOS Bootloader ;
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 7C00h
bits 16


    ; --- DEFINES --- ;
%define KERNEL 'kernel.bin'


    ; --- FUNCTIONS --- ;
main:
    mov si, msg_booting
    call print

    ; Trying to load kernel
    mov si, kernel_file                 ; Moving kernel filename to SI
    
    mov bx, 2000h                       ; ES = 2000h
    mov es, bx
    mov bx, 0h                          ; BX = 0h

    call fs__open                       ; Trying to open file
    jc .error                           ; Catch error

    ; Jumping to kernel
    mov ax, 2000h
    mov ds, ax
    mov es, ax

    jmp 2000h:0

.error:
    mov si, msg_error
    call print
    
    cli
    hlt


    ; --- INCLUDE --- ;
%include 'src/bootloader/screen.inc'
%include 'src/bootloader/disk.inc'
%include 'src/bootloader/iwfs.inc'


    ; --- STRINGS --- ;
kernel_file:            db KERNEL, 0

msg_booting:            db 'Loading ', KERNEL, NEWLINE, 0
msg_error:              db 'File not found', NEWLINE, 0


    ; --- FOOTER --- ;
times 510-($-$$) db 0
dw 0xAA55

