    ; --- HEADER --- ;
org 2800h
bits 16

jmp main
file_name:          db 'hello.com', 0               ; Change to your filename


    ; --- FUNCTIONS --- ;
main:
    mov si, hello_world
    call screen__print
    ret


    ; --- INCLUDE --- ;
%include 'src/drivers/screen.inc'


    ; --- STRINGS --- ;
hello_world:            db 'Hello, World!', NEWLINE, 0


    ; --- FOOTER --- ;
times 10240-($-$$) db 0

