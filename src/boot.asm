; IWOS Bootloader ;
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.

    ; --- HEADER --- ;
org 0x7C00
bits 16


    ; --- DEFINES --- ;
%define KERNEL 'kernel.bin'


    ; --- FUNCTIONS --- ;
main:
    mov si, msg_booting
    call print

    cli
    hlt


    ; --- INCLUDE --- ;
%include 'src/bootloader/screen.inc'


    ; --- STRINGS --- ;
msg_booting:            db 'Loading ', KERNEL, NEWLINE, 0


    ; --- FOOTER --- ;
times 510-($-$$) db 0
dw 0xAA55

