    ; --- HEADER --- ;
org 3000h
bits 16


    ; --- FUNCTIONS --- ;
main:
    ; Print list of files
    mov si, newline
    call print
    call fs_dir
    call print

    ; Print prompt
    mov si, prompt
    call print

    ; Get filename
    mov bx, 65
    call input

    ; Read this file
    mov si, di
    mov bx, 0x3400
    call fs_read

    ; Print out it content
    call clear

.print:
    mov si, bx
    mov di, 0

    cmp byte [si], 0
    je .exit

    push di
    mov cx, 80
    repe movsb
    mov byte [di], 0
    pop di

    mov si, di
    add bx, 80

    call print
    call waitkey
    jmp .print

.exit:
    ; Exit
    mov si, newline
    call print
    ret


    ; --- INCLUDES --- ;
%include 'src/programs/iwos.inc'


    ; --- STRINGS --- ;
prompt:             db 'File to read: ', 0
newline:            db NEWLINE, 0

