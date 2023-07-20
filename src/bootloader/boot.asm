; IWOS Bootloader ; Stage 2
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.
;
; It must be loaded at 1000h:2800h (0x12800)


    ; --- HEADER --- ;
org 2800h
bits 16


    ; --- FUNCTIONS --- ;
main:
    ; Now we are at 0x12800, what we should to do?
    ; First of all: load kernel.

    mov si, msg_stage_2
    call screen__print

    ; Loading file from disk
    mov si, kernel_file
    mov bx, 0h
    call fs__read
    jc .error

    ; Jump to kernel
    jmp 1000h:0h

.error:
    mov si, msg_error
    call screen__print

    cli
    hlt


    ; --- INCLUDES --- ;
%include 'src/bootloader/include/string.inc'
%include 'src/bootloader/include/screen.inc'
%include 'src/bootloader/include/disk.inc'
%include 'src/bootloader/include/iwfs.inc'


    ; --- STRINGS --- ;
kernel_file:                    db 'kernel.bin', 0

msg_stage_2:                    db 'IWOS Bootloader -- Stage 2 loaded', NEWLINE, 0
msg_error:                      db 'File not found.', NEWLINE, 0


    ; --- FOOTER --- ;
times 512-($-$$) db 0

