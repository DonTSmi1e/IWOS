; IWOS.
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


[org 0x0]
[bits 16]


    ; --- DEFINES --- ;
%define AUTORUN 'autorun.com'

    ; --- FUNCTIONS --- ;
; Main function
kernel:
    ; Initialization
    mov si, msg_init
    call screen__print
    call .init

    ; Execute autorun
    mov si, msg_welcome
    call screen__print

    mov si, sys_autorun
    mov bx, 0x3000
    call fs__read                           ; Try to read file
    jnc .autorun
    
    mov si, msg_autorun
    call screen__print
    jmp shell

.init:
    ;; Setup interrupts
    mov ax, 0
    mov ds, ax

    ; Setup int 20h
    mov bx, 20h
    shl bx, 2
    mov word [bx], INT20
    mov [bx + 2], cs

    ; Setup int 21h
    mov bx, 21h
    shl bx, 2
    mov word [bx], INT21
    mov [bx + 2], cs

    ; Setup int 22h
    mov bx, 22h
    shl bx, 2
    mov word [bx], INT22
    mov [bx + 2], cs

    ; Restore data segment
    mov ax, 0x1000
    mov ds, ax
    ret

.exec:
    pusha
    push es
    push ds
    call 0x3000
    pop ds
    pop es
    popa
    ret

.autorun:
    call .exec
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
    
;; File handling
.handle_exe:
    call kernel.exec
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


    ; --- INTERRUPTS --- ;
%include 'src/kernel/interrupts.inc'


    ; --- STRINGS --- ;
; System
build:                      db DATESTAMP, 0
sys_autorun:                db AUTORUN, 0

; Startup messages
msg_loaded:                 db 'Kernel loaded', NEWLINE, 0
msg_welcome:                db 'Incredibly Wrong Operating System', NEWLINE, '    Copyright (c) 2023 DonTSmi1e', NEWLINE, '    Build date: ', DATESTAMP, NEWLINE, NEWLINE, 'Type help to get list of all commands.', NEWLINE, 0
msg_init:                   db 'Initialization...', NEWLINE, 0
msg_autorun:                db '-- You can put a file called ',  AUTORUN, ' it will run automatically every time you start the system.', NEWLINE, 0

; Shell messages
sh_prompt:                  db '>', 0
sh_error:                   db 'File or command not found, type help to get list of commands.', NEWLINE, 0
sh_help:                    db 'Commands: help dir', NEWLINE, 0

