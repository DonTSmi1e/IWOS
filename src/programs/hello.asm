    ; --- HEADER --- ;
org 100h
bits 16


    ; --- FUNCTIONS --- ;
main:
    mov ah, 01h
    mov si, hello_world
    int 20h

    retf


    ; --- STRINGS --- ;
hello_world:            db 'Hello, World!', 0x0D, 0x0A, 0

