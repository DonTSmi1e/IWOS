; IWOS Bootloader ; Stage 2
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.
;
; It must be loaded at 1000h:2800h (0x12800)


    ; --- HEADER --- ;
org 0h
bits 16


    ; --- FUNCTIONS --- ;
main:
    mov si, msg_stage_2
    call screen__print

    ; Loading file from disk
    mov si, kernel_file
    mov bx, 200h
    call fs__read
    jc .error

    ; Jump to kernel
    jmp 1000h:200h

.error:
    mov si, msg_error
    call screen__print

    cli
    hlt


    ; --- INCLUDES --- ;
%include 'src/common/string.inc'
%include 'src/drivers/screen.inc'
%include 'src/drivers/disk.inc'
%include 'src/drivers/iwfs.inc'


    ; --- STRINGS --- ;
kernel_file:                    db 'kernel.bin', 0

msg_stage_2:                    db 'IWOS Bootloader <3', NEWLINE, 0
msg_error:                      db 'File not found :c', NEWLINE, 0


    ; --- FOOTER --- ;
times 512-($-$$) db 0

