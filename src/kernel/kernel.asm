; IWOS.
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


[org 0x0]
[bits 16]

; Now kernel is zero-terminated string
jmp end
db 0x08, 0x08, 'IWOS Kernel, build time: ', DATESTAMP, 0xA, 'Thanks for reading.', 0xA, 0
end:

; Built-in protection
push ax
mov ax, es
cmp ax, 0x1000
pop ax

jne no_kernel
jmp kernel

no_kernel:
    push si
    mov si, .msg
    add si, 0x100
    call screen__print
    pop si
    retf

.msg: db 'Kernel must be loaded at 1000h:0h', 0xA, 0


    ; --- DEFINES --- ;
%define INIT               'shell.com'
%define KERNEL_SEGMENT      0x1000


    ; --- FUNCTIONS --- ;
; Main function
kernel:
    ; Initialization
    call .init

    ; Print kernel version
    mov si, ver
    call screen__print

    ; Jump to main loop
    jmp kernel_loop

;; Initialization (interrupts)
.init:
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

    ; Setup int 80h
    mov bx, 80h
    shl bx, 2
    mov word [bx], INT80
    mov [bx + 2], cs

    ; Setup int FFh
    mov bx, 0FFh
    shl bx, 2
    mov word [bx], INTFF
    mov [bx + 2], cs

    ; Restore data segment
    mov ax, KERNEL_SEGMENT
    mov ds, ax

    ; Try to change console font
    mov si, sys_font
    call change_font
    ret

;; Execute program from memory
; Input:
;   AX - memory segment
;   BX - memory offset
.exec:
    mov bx, [memory]
    cmp bx, 0x7000
    mov si, halt_memory
    jae .error

    add word [memory], 0x1000
    mov bx, [memory]

    mov es, bx
    mov bx, 0x100
    call disk__read

    mov ax, [memory]
    mov bx, 0x100

    pusha
    push ds

    ; Setup BX, DS, ES to memory segment
    mov ds, ax
    mov es, ax

    ; Push AX:BX to stack
    push ax
    push bx
    mov bp, sp              ; Save stack pointer to BP

    ; Clear registers
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0

    ; Make call
    call far [bp]
    add sp, 4

    pop ds
    popa
    sub word [memory], 0x1000
    ret

.halt:
    ; Disable cursor
    pusha
    mov dx, 0x3D4
    mov al, 0x0A
    out dx, al

    mov dx, 0x3D5
    mov al, 0x20
    out dx, al

    ; Print message
    push si
    push si
    mov si, pfx_halt
    call screen__print
    pop si
    call screen__print
    call screen__newline
    call screen__newline
    pop si
    popa

    ; Print useful information
    call debug.registers
    call screen__newline
    call debug.kernel

    ; Halt.
    cli
    hlt

.error:
    pusha
    push si
    call screen__print
    call screen__newline
    pop si
    popa

    ret


; Change VGA font
; Input:
;   SI - font filename
change_font:
    pusha
    push bp

    ; Read file
    mov bx, 0x3000
    call fs__read
    jc .return
    call disk__read

    ; Check if it will work
    cmp word [bx], 0x0436
    jne .return
    cmp word [bx + 2], 0x1002
    jne .return

    ; Set font
    mov ax, 1110h
    mov bp, 0x3004
    mov bh, 16
    mov bl, 0
    mov cx, 256
    mov dx, 0
    int 10h

.return:
    pop bp
    popa
    ret


; Main kernel loop after initialization
kernel_loop:
    mov si, sys_init
    call fs__read

    call kernel.exec

    mov si, halt_init
    jmp kernel.halt


; Debug features
debug:
    ret

.registers:
    push ax
    push si

    ; Print AX/BX/CX/DX registers
    mov si, reg_AX
    call screen__print
    call screen__printhex           ; AX

    mov si, reg_BX
    call screen__print
    mov ax, bx
    call screen__printhex           ; BX

    mov si, reg_CX
    call screen__print
    mov ax, cx
    call screen__printhex           ; CX

    mov si, reg_DX
    call screen__print
    mov ax, dx
    call screen__printhex           ; DX

    ; Print ES/DS registers
    mov si, reg_ES
    call screen__print
    mov ax, es
    call screen__printhex           ; ES

    mov si, reg_DS
    call screen__print
    mov ax, ds
    call screen__printhex           ; DS

    ; Print SI/DI registers
    push si
    mov si, reg_SI
    call screen__print
    pop si
    mov ax, si
    call screen__printhex           ; SI

    mov si, reg_DI
    call screen__print
    mov ax, di
    call screen__printhex           ; DI

    pop si
    pop ax
    ret

.kernel:
    push ax
    push si

    ; Print kernel info
    mov si, dbg_memory
    call screen__print
    mov ax, [memory]
    call screen__printhex

    mov si, dbg_init
    call screen__print
    mov si, sys_init
    call screen__print
    call screen__newline

    mov si, dbg_font
    call screen__print
    mov si, sys_font
    call screen__print
    call screen__newline

    pop si
    pop ax
    ret


    ; --- INCLUDES --- ;
; Common
%include 'src/common/string.inc'

; Drivers
%include 'src/drivers/screen.inc'
%include 'src/drivers/keyboard.inc'
%include 'src/drivers/disk.inc'
%include 'src/drivers/iwfs.inc'

; Interrupts
%include 'src/kernel/interrupts.inc'


    ; --- STRINGS --- ;
; System
build:                      db DATESTAMP, 0
sys_init:                   db INIT, 0
sys_font:                   db 'system.psf', 0
memory:                     dw 0x1000
ver:                        db 'Incredibly Wrong Operating System', NEWLINE, '    Copyright (c) 2023 DonTSmi1e', NEWLINE, '    Build date: ', DATESTAMP, NEWLINE, 0

; Prefixes
pfx_halt:                   db '(HALT) ', 0

; Halt messages
halt_init:                  db 'Init has exited.', 0
halt_memory:                db 'Not enough memory.', 0

; Registers
reg_AX:                     db 'AX: ', 0
reg_BX:                     db 'BX: ', 0
reg_CX:                     db 'CX: ', 0
reg_DX:                     db 'DX: ', 0
reg_ES:                     db 'ES: ', 0
reg_DS:                     db 'DS: ', 0
reg_SI:                     db 'SI: ', 0
reg_DI:                     db 'DI: ', 0

; Messages
dbg_memory:                 db 'Program memory position:    ', 0
dbg_init:                   db 'Init file:                  ', 0
dbg_font:                   db 'Default font:               ', 0

