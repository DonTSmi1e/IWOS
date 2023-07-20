; IWOS Kernel ;
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 0h
bits 16

jmp main
file_name:          db 'empty.bin', 0


    ; --- FUNCTIONS --- ;
main:
    mov si, msg_ahaaaa
    call screen__print

    cli
    hlt


    ; --- INCLUDE --- ;
%include 'src/drivers/screen.inc'


    ; --- STRINGS --- ;
msg_ahaaaa:            db 'Ahaaa! Something wrong with your disk driver =)))))', NEWLINE, 0


    ; --- FOOTER --- ;
times 10240-($-$$) db 0

