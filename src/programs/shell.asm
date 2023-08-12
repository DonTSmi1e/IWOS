; IWOS Shell
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


[org 0x100]
[bits 16]


    ; --- DEFINES --- ;
%define NEWLINE 0x0A

    ; --- FUNCTIONS --- ;
main:
    mov si, sh_welcome
    call screen__print


; Shell function
shell:
    ; Print prompt
    mov al, '>'
    call screen__printchar

    ; Get input
    mov bl, 78
    call keyboard__get_string

    cmp byte [di], 0
    je shell                                ; We should skip empty input

    ; Handle commands
    mov si, .cmd_help
    call string__compare
    jnc .help
    clc

    mov si, .cmd_dir
    call string__compare
    jnc .dir
    clc

    mov si, .cmd_dbg
    call string__compare
    jnc .dbg
    clc

    mov si, .cmd_exit
    call string__compare
    jnc .exit
    clc

    ; Try to find file
    mov si, di
    mov bx, 0x300
    call fs__load
    jc .error

    ; Load file
    int 80h
    jmp shell

;; Error function
.error:
    mov si, sh_error
    call screen__print
    jmp shell

;; Shell commands
.cmd_help:                  db 'help', 0
.help:
    mov si, sh_help
    call screen__print
    jmp shell

.cmd_dir:                   db 'dir', 0
.dir:
    call fs__dir
    jmp shell

.cmd_dbg:                   db 'dbg', 0
.dbg:
    int 0FFh
    jmp shell

.cmd_exit:                  db 'exit', 0
.exit:
    retf


    ; --- INCLUDES --- ;
%include 'src/programs/iwos.inc'
%include 'src/common/string.inc'


    ; --- STRINGS --- ;
; Shell messages
sh_welcome:                 db 'Type help to get list of all commands.', NEWLINE, 0
sh_prompt:                  db '>', 0
sh_error:                   db 'File or command not found, type help to get list of commands.', NEWLINE, 0
sh_help:                    db 'Commands: help dir dbg exit', NEWLINE, 0

