; IWOS Kernel ;
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- HEADER --- ;
org 2800h
bits 16

jmp main
file_name:          db 'shell.com', 0


    ; --- FUNCTIONS --- ;
main:
    ; Printing prompt
    mov si, sh_prompt
    call screen__print

    ; Get input from user
    mov bl, 78
    call keyboard__get_string

    ; If input is null, go back.
    cmp byte [di], 0
    je main

    ; Handle commands
    mov si, cmd_help
    call string__compare
    jnc help
    clc


.error:
    mov si, sh_error
    call screen__print

    jmp main

    ; --- COMMANDS --- ;
cmd_help:               db 'help', 0
help:
    mov si, sh_help
    call screen__print
    jmp main


    ; --- INCLUDE --- ;
%include 'src/common/string.inc'
%include 'src/drivers/screen.inc'
%include 'src/drivers/keyboard.inc'


    ; --- STRINGS --- ;
sh_prompt:              db '>', 0
sh_help:                db 'Commands: help', NEWLINE, 0
sh_error:               db 'Unknown command, type help to get list of all commands.', NEWLINE, 0


    ; --- FOOTER --- ;
times 10240-($-$$) db 0

