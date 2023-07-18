; IWOS Kernel ;
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 0h
bits 16

jmp kernel__main
file_name:          db 'kernel.bin', 0


    ; --- FUNCTIONS --- ;
kernel__main:
    mov si, msg_loaded
    call screen__print

    cli
    hlt

    ; --- INCLUDE --- ;
%include 'src/drivers/screen.inc'


    ; --- STRINGS --- ;
msg_loaded:            db 'Kernel loaded.', NEWLINE, 0


    ; --- FOOTER --- ;
times 10240-($-$$) db 0

