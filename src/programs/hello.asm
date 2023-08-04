    ; --- HEADER --- ;
org 3000h
bits 16

; IWOS valid program magic code
jmp iwosvpmv
dw 0xFDFF
iwosvpmv:


    ; --- FUNCTIONS --- ;
main:
    mov si, hello_world
    call screen__print
    ret


    ; --- INCLUDE --- ;
%include 'src/drivers/screen.inc'


    ; --- STRINGS --- ;
hello_world:            db 'Hello, World!', NEWLINE, 0

