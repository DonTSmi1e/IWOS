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
    ; Catch error at start
    jc .error

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

    mov si, cmd_dir
    call string__compare
    jnc dir
    clc

    mov si, cmd_cls
    call string__compare
    jnc cls
    clc

    ; No-no-no, we can't load kernel again.
    mov si, kernel_file
    call string__compare
    jnc .error_kernel
    clc

    ; If file is not kernel, try to load.
    mov si, di
    mov bx, 5000h
    mov cl, 1
    call fs__read                           ; btw i wanna check if file exist right in shell
    jc .error

    ret

.error_kernel:
    mov si, sh_kernel
    call screen__print

    jmp main

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

cmd_dir:                db 'dir', 0
dir:
    mov bx, 5000h
    call fs__dir
    jmp main

cmd_cls:                db 'cls', 0
cls:
    call screen__clear
    jmp main

    ; --- INCLUDE --- ;
%include 'src/common/string.inc'
%include 'src/drivers/screen.inc'
%include 'src/drivers/keyboard.inc'
%include 'src/drivers/disk.inc'
%include 'src/drivers/iwfs.inc'


    ; --- STRINGS --- ;
kernel_file:            db 'kernel.bin', 0
sh_prompt:              db '>', 0
sh_help:                db 'Commands: help dir cls', NEWLINE, 0
sh_error:               db 'Unknown command, type help to get list of all commands.', NEWLINE, 0
sh_kernel:              db "Nice try, but you can't load kernel.", NEWLINE, 0


    ; --- FOOTER --- ;
times 10240-($-$$) db 0

