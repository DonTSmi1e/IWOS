[org 0x7C00]
[bits 16]


    ; --- DEFINES --- ;
%define KERNEL 'kernel.bin'


    ; --- FUNCTIONS --- ;
; Main bootloader function
main:
	; Setup stack
    mov ax, 0
    mov ss, ax
    mov sp, 0x7C00

    ; Setup screen
    call screen__clear

    mov si, msg_bootloader
    call screen__print

    call screen__newline

    ; Setup registers to read disk
    mov ax, 0
    mov cl, 1
    mov bx, 0x7E00

.search:
    ; Read sector
    inc ax
    call disk__read
    mov si, bx

    ; Check if first byte is 0
    cmp byte [si], 0
    je .not_found

    ; Compare filename
    mov di, kernel_file
    call string__compare
    jc .search

    ; If strings same, get file size
    add si, 50
    mov cl, byte [si]
    inc ax

    mov bx, 0x1000
    mov es, bx
    mov bx, 0x0

.load_file:
    ; Read file to memory
    call disk__read

    ; Setup registers to jump into kernel
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ax, 0
    mov dl, 0

    ; And finally, jump!
    call screen__clear
    jmp 0x1000:0x0

.not_found:
    mov si, msg_kernel_not_found
    call screen__print
    jmp .halt

.found:
    jmp .halt

.halt:
    cli
    hlt


    ; --- INCLUDES --- ;
%include 'src/drivers/disk.inc'
%include 'src/drivers/screen.inc'
%include 'src/common/string.inc'


    ; --- STRINGS --- ;
; Config
build:                  db DATESTAMP, 0
kernel_file:            db KERNEL, 0

; Messages
msg_bootloader:         db '; --- IWOS BOOTLOADER --- ;', NEWLINE, '; Builded: ', DATESTAMP, 0
msg_kernel_not_found:   db '(ERROR) ', KERNEL, ' not found!', NEWLINE, 0


    ; --- FOOTER --- ;
times 510-($-$$) db 0
dw 0xAA55

