; IWOS Kernel ;
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 0h
bits 16

jmp kernel__main
file_name:          db 'kernel16.bin', 0


    ; --- FUNCTIONS --- ;
kernel__main:
    mov si, msg_loaded
    call screen__print

    ; Setup stack
    mov ax, 0
    mov ss, ax
    mov sp, 5400h


kernel__loop:
    mov si, shell_file
    jmp kernel__load


kernel__load:
    mov bx, 2800h
    mov cl, 20
    call fs__read
    jc kernel__loop

    call 1000h:2800h

    jmp kernel__load


halt:
    cli
    hlt


    ; --- INCLUDE --- ;
%include 'src/common/string.inc'
%include 'src/drivers/screen.inc'
%include 'src/drivers/disk.inc'
%include 'src/drivers/iwfs.inc'
%include 'src/drivers/keyboard.inc'


    ; --- STRINGS --- ;
shell_file:            db 'shell.com', 0
msg_loaded:            db 'IWOS Kernel loaded, welcome back.', NEWLINE, 0


    ; --- FOOTER --- ;
times 10240-($-$$) db 0

