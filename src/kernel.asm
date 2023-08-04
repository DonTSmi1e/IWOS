[org 0x0]
[bits 16]


    ; --- FUNCTIONS --- ;
; Main function
kernel:
    %ifdef VESA
        ; Setup VESA
        mov ax, 0x4F02
        mov bx, 117h
        int 0x10
    %endif

    mov si, msg_welcome
    call screen__print

    jmp shell

.halt:
    cli
    hlt

; Shell function
shell:
    ; Print prompt
    mov al, '>'
    call screen__printchar

    ; Get input
    mov bl, 78
    call keyboard__get_string               ; Get filename input from user

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

    ; Read file
    mov si, di

    mov bx, 0x3000
    call fs__read                           ; Try to read file
    jc .error

    mov ax, [bx + 2]
    cmp ax, 0xFDFF
    je .handle_exe
    jne .handle_txt

;; File handling
.handle_exe:
    pusha
    push es
    push ds
    call 0x3000
    pop ds
    pop es
    popa

    jmp shell

.handle_txt:
    mov si, bx
    call screen__print

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


    ; --- INCLUDES --- ;
%include 'src/common/string.inc'
%include 'src/drivers/screen.inc'
%include 'src/drivers/keyboard.inc'
%include 'src/drivers/disk.inc'
%include 'src/drivers/iwfs.inc'


    ; --- STRINGS --- ;
; System
build:                      db DATESTAMP, 0

; Startup messages
msg_loaded:                 db 'Kernel loaded', NEWLINE, 0
msg_welcome:                db 'Incredibly Wrong Operating System', NEWLINE, '    Copyright (c) 2023 DonTSmi1e', NEWLINE, '    Build date: ', DATESTAMP, NEWLINE, NEWLINE, 'Type help to get list of all commands', NEWLINE, 0

; Shell messages
sh_prompt:                  db '>', 0
sh_error:                   db 'File or command not found, type help to get list of commands.', NEWLINE, 0
sh_help:                    db 'Commands: help dir', NEWLINE, 0

